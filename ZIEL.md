# Was „lauffähig" heißt

Von Gregor am 30.08.2026 festgelegt, nachdem eine Fassung als „lauffähig"
ausgeliefert wurde, die zwar startete, aber nicht bedienbar war.

> * es genügt nicht, daß das programm startet
> * die darstellung sollte korrekt sein
> * ich möchte damit einen mail server verbinden und mails abrufen.

## Maßstab für die Fassung 7.2.1.0

Von Gregor am 14.10.2026 bestätigt (*„hört sich vernünftig an für die 7.2.1.0
version."*), auf seine Frage, welche Fehler behoben und welche Funktionen
eingebaut sein müssen. **7.2.1.0 ist die erste Fassung ohne Vorbehalt für den
täglichen Gebrauch.** Neue Funktionen gehören nicht dazu. Maßstab sind alle
neun Kriterien unten, und zwar **erfüllt**, nicht „fast“.

<!-- ziel-stand: Anfang -->

**Stand: 11 von 17 erfüllt, 6 offen.** Diese Übersicht wird aus den
Urteilen in [Intern/BEFUNDE.md](Intern/BEFUNDE.md) **erzeugt** — `tools/ziel-stand.pl`
setzt sie und weist im `pre-commit` ab, wenn sie nicht stimmt. Die Reihenfolge ist
die der Gruppen unten: was Post verfälscht oder eine fremde Installation
beschädigt, steht oben.

| | wer | Was noch fehlt | Wie zu prüfen |
|---|---|---|---|
| **[E-101](Intern/BEFUNDE.md#e-101)** | ich | allein **F2** — `StripTabooHeaders` entfernt die `Content-Type`-Zeile, bevor der Kern sie setzen kann; auf dem einzigen Aufrufweg ist er damit tot (… | Testsuite plus eine echte Nachricht: HTML-Mail über *File → Save As* sichern und die Datei in einem Browser öffnen. Rot: Umlaute als Ersatzzeichen, weil die `Content-Type`-Zeile fehlt. G… |
| **[E-77](Intern/BEFUNDE.md#e-77)** | ich | die Behebung — eine Dekodierung von modifiziertem UTF-7 gibt es in `Eudora71/` nirgends; der rohe Name geht aus der `LIST`-Antwort in `ImapMailbox::… | am eigenen IMAP-Prüfserver (`tools/imap-pruefserver.pl`). Einen Ordner `Entwürfe` anlegen, abrufen, in der Postfachliste nachsehen. Rot: `Entw&APw-rfe`. Grün: `Entwürfe`. **Stufe: wichti… |
| **[E-113](Intern/BEFUNDE.md#e-113)** | ich | alles — von Gregor angeordnet; die Vorbedingung [E-112](Intern/BEFUNDE.md#e-112) ist seit 7.2.0.85 behoben, der Befund ist damit an der Reihe. Billig wäre ein Deckel beim Umb… | eine Nachricht mit einem Bild, das breiter ist als das Fenster. Rot: das Bild läuft rechts hinaus. Grün: es ist auf die Fensterbreite eingepasst. Danach Fenstergröße ändern und noch ein… |
| **[E-119](Intern/BEFUNDE.md#e-119)** | ich | der Einbau — die Base64-Daten müssen **vor** `PGHTMIMP.CPP:3317` (beim Zerlegen des `<img>`-Tags) in eine Datei unter `Embedded` dekodiert und `src… | `Testdaten/` um eine Nachricht mit `data:`-Bild ergänzen, darauf antworten. Rot: grauer Kasten im Verfassenfenster. Grün: das Bild. **Stufe: wichtig** (Darstellung: eingebettete Bilder als… |
| **[E-116](Intern/BEFUNDE.md#e-116)** | ich | Einbau und Messung — der Vorschlag des PRÜFERS vor `PGHTMIMP.CPP:3694` (auf eine folgende Ziffer prüfen und sonst abbrechen) ist nicht eingebaut, … | Testsuite: `width="35px"` muss 35 ergeben, nicht 3508; `width="35.5"` 35, nicht 3645. Dazu eine Prüfnachricht, auf der das Bild vorher zu breit war. **Stufe: wichtig** (Darstellung: Groesse… |
| **[E-14](Intern/BEFUNDE.md#e-14)** | ich | die eine Messung, die entscheidet — Eudora zweimal hintereinander auf **demselben gewachsenen** Mailverzeichnis starten und beim zweiten Mal auf `Se… | eine Messung, kein Einbau. Schritte: ein Testverzeichnis mit gewachsenem Postfach nehmen, Eudora starten, beenden, **sofort wieder starten**. Beim zweiten Start auf die Zusicherung `SearchMa… |

<!-- ziel-stand: Ende -->

| Gruppe | Befund | Worum es geht |
|---|---|---|
| Fremde Installation | **Anforderung — ERLEDIGT durch Entscheidung** | **Wir bauen nichts für Hermes nach.** Von Gregor am 22.10.2026 entschieden: *„wir fixen nichts für hermes, der hinweis, daß man es separieren soll, reicht."* Damit ist diese Zeile **keine Voraussetzung für 7.2.1.0** mehr. Was bleibt und schon steht: die Warnung ganz oben in [README.md](README.md) (vor dem ersten Start sichern, getrennte Verzeichnisse benutzen, Parallelbetrieb auf eigene Gefahr) und der Abschnitt *What we do not take on* in [MELDUNGEN-VON-AUSSEN.md](MELDUNGEN-VON-AUSSEN.md). Was **nicht** entfällt, weil es etwas anderes ist: dass **vorsichtige Benutzung nichts zerstört** — genau das war [Issue #102](https://github.com/HansWurst81675/Eudora7.2/issues/102)-1, und dafür sind [E-131](Intern/BEFUNDE.md#e-131) (Schreibweg, 7.2.0.113) und [E-132](Intern/BEFUNDE.md#e-132) (fremdes Mailverzeichnis, 7.2.0.117/.118) behoben. **Offen bleibt allein der Leseweg von [E-131](Intern/BEFUNDE.md#e-131)** — eine INI, die den kaputten Wert schon trägt, wird erst beim nächsten Speichern berichtigt. Die vorher hier verlangte Bestandsaufnahme *„welche Schlüssel schreiben wir, die 7.1 nicht kennt"* ist mit dieser Entscheidung **gestrichen** |
| Fremde Installation | [E-131](Intern/BEFUNDE.md#e-131) | unsere Fassung schrieb eine ungültige Fensterposition in die gemeinsam benutzte `Eudora.ini`; danach startete eine **daneben installierte** Eudora/Hermes 7.1 nicht mehr (**behoben in 7.2.0.113**, nachgestellt und gemessen; der Leseweg bleibt offen). **Von Gregor am 20.10.2026 in den Maßstab aufgenommen** — der erste Fehlerbericht von außen ([Issue #102](https://github.com/HansWurst81675/Eudora7.2/issues/102)), und der einzige Befund, der etwas **außerhalb** von Eudora unbrauchbar macht |
| Adressbuch benutzbar | **Anforderung — ERFÜLLT, Doku fehlt** | **Nach *Strg+Umschalt+,* steht im `To:`-Feld die Mailadresse, nicht der eingetippte Kurzname.** Von Gregor am 21.10.2026 gesetzt und am 22.10.2026 entschieden: *„wenn es mit ctrl-shif-, geht, dann ist es auch erfüllt, muß nur dokumentiert werden."* **Am Quelltext belegt (22.10.2026), nicht am laufenden Programm gemessen:** `EudoraRes.rc:267-268` legt **beide** Tasten auf `ID_EDIT_FINISHNICKNAME` — `Strg+,` und `Strg+Umschalt+,`. In `FinishNickname` (`nickdoc.cpp:4103`) entscheidet `BOOL DoExpand = ShiftDown();`: **ohne** Umschalt wird der Kurzname nur **vervollständigt**, **mit** Umschalt durch `ExpandAliases` ersetzt (`:4213-4228`). **Ein gemessener Vorbehalt:** `:4208` setzt `DoExpand = DoExpand && (NumFound == 1)` — passen **mehrere** Kurznamen auf das Getippte, wird nicht expandiert, sondern vervollständigt. **Was noch zu tun ist:** die Taste in [README.md](README.md) aufschreiben und einmal am laufenden Programm nachmessen. *Tab* bleibt davon unberührt und ist **nicht** mehr verlangt |
| Eingaben gehen verloren | [E-135](Intern/BEFUNDE.md#e-135) | die Auswahlbox im `To:`-Feld wurde bei jedem Cursor-Schritt kleiner und war nach fünf Schritten nicht mehr zu sehen — `ReCalcACListBoxPos` las das Innenmaß und setzte daraus das Außenmaß (**behoben in 7.2.0.120**, rot und grün am laufenden Programm gemessen: 100×62 bis 20×14 gegen konstant 108×70). **Quelltext original, Verhalten in Hermes nicht gemessen** |
| Eingaben gehen verloren | [E-134](Intern/BEFUNDE.md#e-134) | ein neuer Adressbucheintrag nahm den eingetippten Kurznamen nicht an — das Formular zeigte ihn, der Baum behielt `Untitled`, und auf der Platte stand `alias Untitled` (**behoben in 7.2.0.119**, dreimal gegengemessen). `SelectItem()` setzt in diesem Bau die Karette, aber nicht `TVIS_SELECTED`; **der Quelltext ist original, das Verhalten nicht** |
| Post wird verfälscht | [E-121](Intern/BEFUNDE.md#e-121) | Nachricht beim Verschieben in einen IMAP-Ordner spurlos weg (**eingebaut in 7.2.0.90; gegen die Doppelanzeige danach sechs Anläufe bis 7.2.0.96, der letzte an 1.0.96 von Gregor bestätigt; in 7.2.0.97 gesendete Post und N1, an 1.0.99 von Gregor bestätigt; N2/N3 abgetrennt als [E-123](Intern/BEFUNDE.md#e-123) (offen); in 7.2.0.100 mehrere gesendete Mails in einer Übertragung ([PRÜFER-31](Befunde/PRUEFER-31.md) F1), an 1.0.100 von Gregor getestet; in 7.2.0.101 eigene Kennung für gesendete Post ([PRÜFER-32](Befunde/PRUEFER-32.md)), an 1.0.101 von Gregor bestätigt, veröffentlicht als `v1.0.101`; **behoben, von Gregor am 17.10.2026 bestätigt**; vermuteter Rest abgetrennt als [E-126](Intern/BEFUNDE.md#e-126) (offen)**) |
| Post wird verfälscht | [E-118](Intern/BEFUNDE.md#e-118) | HTML-Mail im IMAP-Ordner als Quelltext, lokale Kopie weg (**Teil 2 – eingebettete Bilder – von Gregor am 14.10.2026 an 1.0.90 bestätigt; eingebaut in 7.2.0.89, von Gregor am 14.10.2026 an 1.0.89 bestätigt**) |
| Post wird verfälscht | [E-69](Intern/BEFUNDE.md#e-69) | Filterlauf bricht im Release lautlos ab, meldet Erfolg (**behoben in 7.2.0.106, nachgebessert in 7.2.0.109 und 7.2.0.110 – ein Sammeleintrag statt einer Meldung je Nachricht, [PRÜFER-36](Befunde/PRUEFER-36.md) P3 und [PRÜFER-38](Befunde/PRUEFER-38.md) R1–R3; am Prüfstand gemessen, von Gregor noch nicht bestätigt**) |
| Post wird verfälscht | [E-101](Intern/BEFUNDE.md#e-101) | gespeicherte Datei in anderen Programmen unbrauchbar (**offen.** Dritter Teil eingebaut in 7.2.0.107, nie geschnürt; nach [PRÜFER-37](Befunde/PRUEFER-37.md) ist der Kern auf dem einzigen Aufrufweg **tot** – F2 –, **F1, F3 und F4 sind in 7.2.0.110 behoben**, offen bleibt allein F2) |
| Kriterium 2 | [E-105](Intern/BEFUNDE.md#e-105) | versteckte Abschnitte doppelt (eingebaut in 7.2.0.88) |
| Kriterium 2 | [E-77](Intern/BEFUNDE.md#e-77) | IMAP-Ordnernamen mit Umlauten roh |
| Kriterium 2 | [E-113](Intern/BEFUNDE.md#e-113) | breite Bilder laufen rechts hinaus |
| Kriterium 2 | [E-119](Intern/BEFUNDE.md#e-119) | `data:`-Bilder als grauer Kasten |
| Kriterium 2 | [E-116](Intern/BEFUNDE.md#e-116) | `35px` falsch gelesen |
| Kriterium 2 | [E-95](Intern/BEFUNDE.md#e-95), [E-96](Intern/BEFUNDE.md#e-96) | zerschnittene/gequetschte Bilder beim Antworten — Gregors Test an der Doctolib- und FairToner-Nachricht — **am 14.10.2026 an 1.0.87 bestätigt** |
| Kriterium 4 | [E-111](Intern/BEFUNDE.md#e-111) | `resolve_URL` schreibt ein Byte hinter das Feld |
| Kriterium 4 | [E-14](Intern/BEFUNDE.md#e-14) | Zusicherung beim Start auf frischem Mailverzeichnis — klären |

**Ausdrücklich nicht Voraussetzung:** [E-114](Intern/BEFUNDE.md#e-114), [E-78](Intern/BEFUNDE.md#e-78), [E-47](Intern/BEFUNDE.md#e-47), [E-67](Intern/BEFUNDE.md#e-67) (Korrektur seit 7.2.0.43, am 17.10.2026 gemessen), [E-98](Intern/BEFUNDE.md#e-98), [E-39](Intern/BEFUNDE.md#e-39), die
zurückgestellte [E-71](Intern/BEFUNDE.md#e-71), die NP-Punkte und [R-1](Intern/BEFUNDE.md#r-1).

**Vor dem Release:** die Tabelle der Kriterien neu messen (ihre Urteile
stammen von 7.2.0.55), dann Gregors Test aller neun Kriterien an einem frischen
Paket, erst danach Marke `v7.2.1.0`.


## Regressionstests — Anordnung vom 22.10.2026

> *„das zauberwort heißt regression tests … jetzt ordne ich es an: wir führen
> vor jedem release alle regression tests aus, soll alles PASSED sein. und zu
> jedem befund brauchen wir ein regression test, damit wir sehen, daß eine
> neue änderung nichts altes kaputt macht."*
>
> *„vermutlich kann man nicht alle findings per automatisierten tests prüfen.
> manche muß man wohl manuell testen, diese werden dann als solche markiert
> und vor 7.2.1.0 release ausgeführt. dazu wie immer eine liste / tabelle mit
> schritten und zu erwarteten ergebnissen (= testplan)."*

**Zwei Regeln, beide ab sofort:**

1. **Vor jedem Release laufen alle Regressionstests, und alle müssen bestehen.**
   Kein Paket, solange einer rot ist.
2. **Jeder Befund braucht eine Prüfung** — entweder einen **automatischen**
   Testfall, der seine Kennung nennt, oder die Marke **`Prüfung: manuell`** im
   Urteil **und** einen Eintrag mit Schritten und erwartetem Ergebnis in
   [Intern/TESTPLAN.md](Intern/TESTPLAN.md). Die Marke allein reicht nicht:
   ohne Schritte ist *manuell* nur ein Wort, das die Schranke abschaltet.

**Stand am 22.10.2026, gemessen mit `tools/pruefe-regressionstest.pl`:**

| | |
|---|---|
| Befunde insgesamt | **186** |
| davon mit automatischem Testfall | **29** |
| davon manuell im Testplan | **0** |
| als *behoben* geführt und **ohne jede Prüfung** | **97** |

Darunter [E-121](Intern/BEFUNDE.md#e-121) (eine Nachricht verschwand beim
Verschieben in einen IMAP-Ordner), [E-83](Intern/BEFUNDE.md#e-83),
[E-97](Intern/BEFUNDE.md#e-97), [E-104](Intern/BEFUNDE.md#e-104),
[E-115](Intern/BEFUNDE.md#e-115), [E-134](Intern/BEFUNDE.md#e-134) und
[E-135](Intern/BEFUNDE.md#e-135). Nichts hindert eine neue Änderung daran,
sie wieder kaputtzumachen.

**Die Schranke verlangt den Rückstand nicht auf einmal** — eine Prüfung, die
vom ersten Tag an jeden Commit abweist, wird am zweiten Tag ausgebaut. Sie
weist ab, sobald ein Befund **neu** auf *behoben* geht, ohne geprüft zu sein;
die 97 werden gezählt und können dadurch nur sinken.

**Dritte Regel, angeordnet am selben Tag:**

> *„unit tests beim bauen sind auch sehr hilfreich. das bedeutet, die baust du
> jetzt auch — erst für die aktuellen fixes, später für die alten befunde."*

3. **Jeder Bau fährt die Tests gleich mit.** `tools/bauen.ps1` ruft am Ende
   `pruefe-tests-gruen.pl` — wer baut, sieht sofort, ob er etwas Altes
   kaputtgemacht hat, und nicht erst beim Push. Der Bau gilt dabei weiter als
   **Erfolg**, wenn ein Test rot ist: die Übersetzung *ist* gelungen, und zwei
   verschiedene Aussagen gehören nicht in einen Rückgabewert. Abgewiesen wird
   im `pre-push`. `-OhneTests` überspringt den Schritt für einen Wegwerfbau.

**Die Reihenfolge, in der der Rückstand abgearbeitet wird** — ebenfalls seine
Vorgabe, hier festgehalten, damit sie nicht an jemandes Gedächtnis hängt:

| | |
|---|---|
| **zuerst** | die Befunde, die **gerade** behoben werden — jede neue Behebung bringt ihren Test im selben Commit mit, das erzwingt `pruefe-regressionstest.pl` |
| **danach** | die Altlasten: 97 Befunde stehen als *behoben* ohne jede Prüfung. Davon sind viele **Werkzeug**-Befunde ([NP3-4](Intern/BEFUNDE.md#np3-4)…7, [W-1](Intern/BEFUNDE.md#w-1), [X-1](Intern/BEFUNDE.md#x-1)…8), die nicht in die C++-Sammlung gehören, sondern eigene `--selbsttest` haben — die werden getrennt gezählt, damit die Rückstandszahl ehrlich bleibt |
| **nicht automatisierbar** | bekommt die Marke `Prüfung: manuell` **und** einen Eintrag mit Schritten und erwartetem Ergebnis in [Intern/TESTPLAN.md](Intern/TESTPLAN.md) |

## Die Kriterien

> **Diese Tabelle ist die Quelle.** `README.md`, `AUFGABEN.md`,
> `WEITERMACHEN.md`, `CHANGELOG.md`, `PORTIERUNG.md` und `Releases/PAKETE.md`
> verweisen hierher, statt sie zu wiederholen. Wer den Stand ändert, ändert ihn
> **hier**.

**Stand 22.10.2026.** Quellstand **7.2.0.120** / `VERSION` **1.0.120**, veröffentlicht als [`v1.0.120`](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.120). **Was zur Fassung 7.2.1.0 noch fehlt, steht im erzeugten Block oben** — nicht hier. Die Fassungsgeschichte steht in [CHANGELOG.md](CHANGELOG.md), die Messung zu jedem Befund in [Intern/BEFUNDE.md](Intern/BEFUNDE.md).

> **Hier stand bis zum 22.10.2026 ein Absatz mit 9356 Zeichen** — eine vollständige Fassungsgeschichte von 7.2.0.120 rückwärts bis 7.2.0.85, unter einer Überschrift, die eine Tabelle ankündigt. Gregor dazu: *„ist das eine tabelle?"* Gemessen wurden an dem Tag **17 Absätze über 1200 Zeichen** in den führenden Dokumenten. Kein Inhalt ist verloren: jede genannte Fassung hat ihren Abschnitt in [CHANGELOG.md](CHANGELOG.md).

> **Berichtigt am 18.09.2026 (LEKTOR, [L-15.2](Befunde/LEKTOR-15.md#l-15.2)).** Hier stand *„Als Paket
> geschnürt ist **1.0.70** … das erste, das alles enthält; bei Gregor liegen
> 1.0.65, 1.0.67, 1.0.68 und 1.0.69, **1.0.70 noch nicht**"* — und [**E-106**](Intern/BEFUNDE.md#e-106)
> galt als *„ausdrücklich nicht nachgewiesen"*. Beides ist überholt: das
> Release `v1.0.72` war zu diesem Zeitpunkt schon draußen (`gh release list`),
> und [E-106](Intern/BEFUNDE.md#e-106) hat Gregor an 1.0.69 bestätigt. Vom Release stand in dieser Zeile
> kein Wort.

**Neun Kriterien.** 0 bis 3 hat Gregor am 30.08.2026 festgelegt — sie messen, ob
Eudora *läuft*. 4 bis 6 kamen am 06.09.2026 dazu, **Kriterium 7** (sauberes
Beenden) am 07.09.2026 aus seinem Urteil zu 1.0.18 (*„beenden kann ich es auch
nicht"*), **Kriterium 8** (die offenen Fenster sichtbar und auswählbar) am
07.09.2026 nach dem ersten geglückten Verfassen-Fenster. Sie messen, ob man
**damit arbeiten** kann. Ein Mailprogramm, das keine Mail schreiben kann, ist
kein Mailprogramm.

| # | Kriterium | Stand |
|---|---|---|
| 0 | Das Paket läuft ohne Nachinstallieren | **erfüllt** — Gregor hat `Eudora72-1.0.10-release.zip` am 06.09.2026 auf einem Rechner **ohne Visual Studio** ausgepackt und gestartet: *„test bestanden: eudora läuft ohne VS2022 installiert."* |
| 1 | Eudora startet und zeigt sein Hauptfenster | **erfüllt** — mehrfach gestartet und bedient |
| 2 | Die Darstellung ist korrekt | **fast.** Erfüllt sind: Fenster, Menüs und Werkzeugleiste ([E-1](Intern/BEFUNDE.md#e-1), [E-2](Intern/BEFUNDE.md#e-2)), Bau-Kennung im Titel ([E-7](Intern/BEFUNDE.md#e-7)), Fortschritt beim Abruf ([E-13](Intern/BEFUNDE.md#e-13)), Umlaute im lokal geschriebenen Text ([Z-2](Intern/BEFUNDE.md#z-2), [Z-2b](Intern/BEFUNDE.md#z-2b)), „In" nur noch einmal unter *Recent* ([E-24](Intern/BEFUNDE.md#e-24)), gesperrte Knöpfe zeigen ihr Symbol ([E-30](Intern/BEFUNDE.md#e-30)), Doppelklick und Suchtreffer öffnen die Nachricht ([E-28](Intern/BEFUNDE.md#e-28)). **Umlaute in per IMAP abgerufenen Nachrichten** sind seit 7.2.0.52 in Ordnung: [**E-85**](Intern/BEFUNDE.md#e-85) war eine Kette aus vier Mängeln — der Zeichensatz wurde aus dem Top-Level-Header statt aus dem MIME-Teil gelesen, der Suchbereich endete vor `IDS_MIME_UTF_8`, der Rückgabewert von `ISOTranslate` wurde verworfen, und der Übertrag über die Stückgrenze fehlte; die Behebung führte zudem eine Regression ein, die PRÜFER vor der Auslieferung fand. **Am laufenden Programm belegt:** `uebersetzt=ja` im Protokoll, null unübersetzte UTF-8-Folgen in der Mailboxdatei. **Was diesem Kriterium noch fehlt, steht in der Zeile darunter.** |
| 2a | *offen zu Kriterium 2* | [**E-77**](Intern/BEFUNDE.md#e-77): IMAP-Postfachnamen mit Umlauten stehen roh da, `Entw&APw-rfe` statt *Entwürfe* — modifiziertes UTF-7, ein anderer Weg als [E-85](Intern/BEFUNDE.md#e-85). Dazu die Meldung „Encountered an improper argument" beim Anzeigen mancher Nachrichten. **Berichtigung vom 22.10.2026:** hier stand bis heute auch [E-86](Intern/BEFUNDE.md#e-86) (HTML-Nachrichten falsch dargestellt) — der ist seit **7.2.0.55 behoben und am laufenden Programm gemessen**. Gefunden hat den Widerspruch Gregor. Die Schranke `pruefe-befundurteile.pl` schwieg, weil ihre Wortliste das Wort *offen* nicht kannte; seit dem 22.10.2026 kommt der Stand dieser Zeile aus dem erzeugten Block oben |
| 3 | Ein Mailkonto lässt sich einrichten, verbinden und Mail abrufen | **erfüllt** — POP3 über **Port 995 mit TLSv1.3**, `Negotiation Status: Succeeded`, von Gregor bestätigt. **Seit 10.09.2026 auch IMAP:** *„imap: funktioniert“*, `imap.gmx.net:993`, TLSv1.3, `TLS_AES_256_GCM_SHA384` (256 Bit) |
| 4 | **Keine Abstürze** | **fast** — Strg-N stürzt nicht mehr ab (fünfmal nachgemessen an 7.2.0.21, danach 20 s offen: kein `Exception.log`). Drei Fehler lagen hintereinander: [**E-34**](Intern/BEFUNDE.md#e-34), [**E-35**](Intern/BEFUNDE.md#e-35), [**E-36**](Intern/BEFUNDE.md#e-36). Das Beenden ist erledigt (Kriterium 7), und mit [**E-43**](Intern/BEFUNDE.md#e-43) sind auch [**E-37**](Intern/BEFUNDE.md#e-37) und [**E-38**](Intern/BEFUNDE.md#e-38) weggefallen. **Offen bleibt eine Stelle:** die Meldung „Encountered an improper argument" beim **Anzeigen** mancher Nachrichten |
| 5 | **Eine neue Mail lässt sich schreiben und abschicken** | **erfüllt** — Gregor hat am 07.09.2026 mit 7.2.0.21 eine Mail geschrieben und abgeschickt: *„mail können jetzt abgeschickt werden."* Belegt durch sein Bildschirmfoto: *Out* enthält „test von freenet nach GMX", 10:01 Uhr |
| 6 | **Eine Mail lässt sich weiterleiten** | **erfüllt** — dasselbe Bildschirmfoto zeigt die **Antwort** darauf im Postfach *In*: „Re: test von freenet nach GMX — ja, ist da.", 10:02 Uhr. Verfassen, Senden, Zitieren und Empfangen laufen damit im Kreis |
| 7 | *File → Exit* beendet Eudora sauber | **erfüllt** — Gregor am 08.09.2026 an Paket 1.0.22: *„schließen klappt jetzt."* Alle drei Wege beenden: Menü, Alt-F4 und das Kreuz. Behoben durch [**E-40**](Intern/BEFUNDE.md#e-40), [**E-41**](Intern/BEFUNDE.md#e-41) und [**E-42**](Intern/BEFUNDE.md#e-42): ein Fehler beim *Aufräumen* verhindert das Beenden nicht mehr, nur eine bewusste Entscheidung des Anwenders. Der Fehler dahinter, [**E-43**](Intern/BEFUNDE.md#e-43), ist in 7.2.0.24 an der Wurzel behoben und ebenfalls bestätigt: die Protokollzeile `E-42 Beenden: Schritt 'SaveBarState(ToolBar)' hat eine Ausnahme ausgelöst` kommt nicht mehr |
| 8 | **Die offenen Fenster sind sichtbar und auswählbar** | **erfüllt** — von Gregor am 09.09.2026 bestätigt: das Menü *Window* listet sie auf („1 In", „2 Out"), und die **Registerkartenleiste am unteren Fensterrand** ist da (Anforderung **A-3**, Befund [**E-48**](Intern/BEFUNDE.md#e-48), umgesetzt in 7.2.0.25) — der Klick auf eine Karte holt ihr Fenster nach vorn, die Beschriftungen stimmen mit dem Menü *Window*. Drei Mängel an der Leiste sind in 7.2.0.26 behoben ([**E-50**](Intern/BEFUNDE.md#e-50)) und von Gregor an 1.0.84 bestätigt (13.10.2026) |

**Neun Kriterien: sieben sind belegt (0, 1, 3, 5, 6, 7, 8), zwei sind fast
erfüllt (2, 4).** Was Kriterium 2 noch fehlt, steht vollständig in der Zeile
**2a**: [**E-77**](Intern/BEFUNDE.md#e-77) (IMAP-Postfachnamen mit Umlauten)
und die Meldung „Encountered an improper argument" beim **Anzeigen** mancher
Nachrichten — diese Meldung fehlt auch Kriterium 4.

> **Berichtigt am 22.10.2026.** Hier stand bis heute auch
> [E-86](Intern/BEFUNDE.md#e-86) (HTML-Nachrichten falsch dargestellt) — der
> ist seit **7.2.0.55** behoben und am laufenden Programm gemessen. Es war
> die **dritte** Stelle derselben veralteten Aussage: `ZIEL.md:75` (Zeile 2a
> der Tabelle), diese hier, und `Intern/PORTIERUNG.md` in der Kurzfassung.
> Gefunden hat alle drei Gregor, nicht die Schranken — `pruefe-befundurteile.pl`
> kannte das Wort *offen* nicht (behoben am selben Tag), und eine Aufzählung
> ohne Statuswort erkennt sie bis heute nicht.

Die Umlaute in per IMAP abgerufenen Nachrichten sind mit [**E-85**](Intern/BEFUNDE.md#e-85)
in **7.2.0.52** behoben und **am laufenden Programm belegt** (`uebersetzt=ja`
im Protokoll, null unübersetzte UTF-8-Folgen in der Mailboxdatei); 7.2.0.51
hatte nur den Suchbereich repariert, nicht die Quelle.

> **Aus Anwendersicht hat sich am 06.09.2026 nichts verbessert.** Gregors Urteil
> zu 1.0.18: *„es crasht nicht, aber es passiert auch nichts. beenden kann ich
> es auch nicht. nichts statt crash ist auch keine verbesserung!"* Das ist der
> Maßstab — nicht, wie weit die Spur im Protokoll kommt.
>
> Was sich verbessert hat, ist die **Ausgangslage**, nicht das Programm: bis
> 06.09.2026 entstand in dieser Portierung kein einziges Paige-Fenster, und die
> Ursache war unbekannt. Jetzt ist sie gefunden und behoben ([E-31](Intern/BEFUNDE.md#e-31)). Ob daraus für
> den Anwender ein sichtbares Verfassen-Fenster wird, entscheidet der nächste
> Lauf auf Gregors Rechner — nicht diese Datei.

## Kriterium 0: das Paket muss ohne Nachinstallieren laufen

Von Gregor am 31.08.2026 festgelegt, nachdem Paket 1.0.2 mit `0xc000007b`
scheiterte, weil vier Debug-DLLs von Visual Studio fehlten:

> *„ziel: möglichst einfach: zip runterladen, entpacken, starten - läuft. keine
> fehlenden DLLs, keine fehlermeldungen, daß etwas nicht gefunden werden kann
> oder nachinstalliert werden muß"*

Und auf die Frage nach dem Weg dorthin:

> *„sonst ja, statisch linken, ist mir auch egal."*

Kriterium 0 steht vor allen anderen, weil ohne lauffähiges Paket niemand die
übrigen prüfen kann.

### Der Weg dorthin

| Weg | Ergebnis |
|---|---|
| **Debug-Bau** | vier nicht verteilbare DLLs nötig (`mfc140d`, `msvcp140d`, `vcruntime140d`, `ucrtbased` — Microsoft nimmt die Debug-Laufzeit ausdrücklich vom Weiterverteilen aus), dazu SUPERASSERT-Dialoge beim Start. **Ungeeignet fürs Ausliefern.** |
| **Release-Bau, dynamisch** | `mfc140.dll`, `msvcp140.dll`, `vcruntime140.dll` sind verteilbar und dürfen beiliegen. Keine Dialoge mehr. **Das ist der heutige Zustand.** |
| **Release-Bau, statisch (`/MT` + MFC statisch)** | keine Laufzeit-DLL nötig; Gregors bevorzugter Weg. **Ausgeschlossen** — Eudora hat sechs MFC-Erweiterungs-DLLs (Befund F-1.1) |

Die vorgebauten Fremd-DLLs von 2006 (Paige32, EuMemMgr und die übrigen) bleiben
davon unberührt — sie sind eigene Module mit eigener Laufzeit und brauchen
weiterhin `MSVCR71.dll`. Dafür gibt es seit Befund [B-1](Intern/BEFUNDE.md#b-1) einen **eigenen Nachbau**
(`Eudora71/VC71Bruecke`), der auf die von Windows selbst mitgelieferte
`msvcrt.dll` weiterleitet. Der darf mit ins Paket, er ist unser eigener Code.

### Woran sich Kriterium 0 misst

**Das ZIP auf einem Rechner ohne Visual Studio auspacken und starten** — kein
`0xc000007b`, keine Meldung über eine fehlende DLL, kein Nachinstallieren.
**Erbracht am 06.09.2026** von Gregor selbst, mit dem **Release**-Paket
`Eudora72-1.0.10-release.zip`: *„test bestanden: eudora läuft ohne VS2022
installiert."*

> **`tools/paket-pruefen.ps1` war einmal kein Nachweis, ist es heute aber.** Am
> 31.08.2026 war Kriterium 0 mit diesem Werkzeug als „gemessen erfüllt" gemeldet
> worden; die Gegenprobe hat es widerlegt: aus einer ausgepackten Kopie wurden
> `EudoraRes.dll`, `QCSSL.dll`, `SPELL32.DLL`, `EuGraph.ocx` und der ganze
> `Plugins`-Ordner gelöscht — das Ergebnis blieb **„keine Fehler, EXIT=0"**. Das
> Werkzeug prüfte die Maschine, nicht das Paket, und seine feste
> Debug-Laufzeitliste erzeugte bei einem Release-Paket vier Falschwarnungen, die
> zum Lizenzverstoß anleiteten. **Das ist am 06.09.2026 behoben** ([PR-2.0](Befunde/PAKET.md#pr-2.0),
> Commit `dfc8b40`): es rechnet die Startkette aus den PE-Import- und
> Verzögerungstabellen aus, zählt einen Treffer in `SysWOW64`/`System32`
> ausdrücklich **nicht** als vorhanden und weist den Weg über
> `laufzeit-holen.ps1` selbst ab — mit drei Gegenproben belegt
> (`Befunde/PAKET.md`). Es ersetzt trotzdem keinen Startversuch auf einem
> fremden Rechner: es sagt, ob der Lader alles findet, nicht ob Eudora läuft.

## Anforderungen neben den Kriterien

Die neun Kriterien oben sagen, wann eine Fassung **abnahmefähig** ist. Daneben
stellt Gregor einzelne Anforderungen, die kein Kriterium sind, aber genauso
verbindlich — sie bekommen eine Kennung `A-n` und stehen hier, damit sie
nachprüfbar sind und nicht nur in einer Werkzeugdatei behauptet werden.

### A-1 — Vorgaben für ein **neu angelegtes** Konto

Gestellt am 07.09.2026, mit zwei Bildschirmfotos der Kontoeinstellungen:

> *„die zwei markierte dinge möchte ich als default bei jedem konto. zum testen
> ist es wichtig, sonst werden die mails abgerufen und gelöscht, wenn ich nicht
> dran denke."*

und, nach der Klärung, dass ein bestehendes Konto damit nicht erreichbar ist:

> *„für neue konten. bestehendes kann ich selbst korrigieren."*
>
> *„anforderung an neues konto: beide optionen so setzen, wenn ich per wizard
> ein neues konto anlege."*

**Verbindlich sind diese vier Werte.** Ein per Assistent oder über *New…* neu
angelegtes Konto muss sie tragen:

| Schlüssel | Wert | im Dialog | markiert am |
|---|---|---|---|
| `SSLSendUse` | `2` | *Secure Sockets when Sending* → **Required, Alternate Port** | 07.09.2026, Bild 1 |
| `CheckMailByDefault` | `1` | *Check Mail* angehakt | 07.09.2026, Bild 1 |
| `SSLReceiveUse` | `2` | *Secure Sockets when Receiving* → **Required, Alternate Port** | 07.09.2026, Bild 2 |
| `LeaveMailOnServer` | `1` | *Leave mail on server* angehakt | 07.09.2026, Bild 2 |

Die Zahlen der beiden SSL-Werte sind die Reihenfolge im Auswahlfeld
(`SSLSettings::SSLUsage`, `Eudora71/Eudora/SSLSettings.h:30-36`): `0` Never,
`1` If Available STARTTLS, `2` Required Alternate Port, `3` Required STARTTLS.

**Begründung, die den Umfang festlegt:** Gregor nennt als Grund, dass Testmails
sonst abgerufen **und auf dem Server gelöscht** werden. Das leisten die zwei von
ihm markierten Häkchen **nicht** — *Check Mail* schaltet den Abruf ein, die
SSL-Wahl betrifft nur die Verbindung. Erforderlich dafür ist
`LeaveMailOnServer`; deshalb gehört es zur Anforderung, obwohl er es nicht
markiert hat. Dazu `LeaveOnServerDays=0` und `ServerDelete=0`, die das Löschen
auf anderen Wegen wieder einschalten würden.

**Erfüllt** seit dem 07.09.2026 durch `tools/DEudora.ini`, die
`tools/paket-bauen.ps1` neben `Eudora.exe` ins Paket legt. Eudora liest sie in
`GetDefaultIniSetting` (`Eudora71/Eudora/rs.cpp:357-385`) **vor** den in
`EudoraRes.rc` eingebauten Vorgaben. Belegt ist die Kette bis in die
`Eudora.ini` hinein: `AccountWizard/Src/WizardPropSheet.cpp:137` →
`CPersParams::GetDefaultParams` (`PersParams.cpp:195`, liest die Datei bei
`:215` und `:236-237`) → der Assistent überschreibt die vier Werte nirgends
(kein Treffer in ganz `Eudora71/AccountWizard`) → `WizardPropSheet.cpp:193`
`g_Personalities.Add` → geschrieben in `persona.cpp:988` (`LeaveMailOnServer`)
und `:1051` (`SSLReceiveUse`). **Am laufenden Programm bestätigt**: Gregor am
08.09.2026 an Paket 1.0.22, nach dem Anlegen eines neuen Kontos: *„default
werte beim neuen persona konto für ‚leave message on server' greifen."*

`tools/paket-pruefen.ps1` warnt, wenn die Datei im Paket fehlt oder einen der
vier Werte nicht trägt, und `tools/doku-pruefen.pl` hält die Datei gegen diese
Tabelle — eine Anforderung ohne Schranke ist ein Versprechen.

**Was [A-1](Intern/BEFUNDE.md#a-1) ausdrücklich nicht verlangt:** ein **bestehendes** Konto zu ändern.
`CPersonality::GetIniDefaultValue` (`persona.cpp:606-620`) liest beim Laden
eines vorhandenen Kontos ausschließlich die Ressource, nie die `DEudora.ini`.
Gregors Wort dazu: *„bestehendes kann ich selbst korrigieren."* Von Hand geht es
in der `Eudora.ini` des Mailverzeichnisses — `<Dominant>` im Abschnitt
`[Settings]`, jedes weitere in `[Persona-<Name>]` (`persona.cpp:897-898`,
Präfix `:52`).

**Warum `tools/DEudora.ini` die Originaldatei ist und keine kurze Eigenbau-Fassung.**
Sie ist die **Originaldatei von QUALCOMM** mit vier Zusatzzeilen: ihr Abschnitt
`[Mappings]` mit 124 Dateizuordnungen ist unverändert übernommen. Eine Fassung
mit nur `[Settings]` hätte beim Auspacken über eine bestehende Installation
genau diese Zuordnungen gelöscht. `tools/doku-pruefen.pl` zählt sie deshalb
gegen `InstallersForEudora/Eudora7.1/Data/INIfiles/deudora.ini` nach und weist
ab, sobald es weniger werden.

Zweiter Aufrufer neben dem Assistenten ist `ModifyAcctSheet.cpp:46` (*New…* im
Kontodialog) — auch dieser Weg geht über `CPersParams::GetDefaultParams` und
trägt die vier Werte damit ebenfalls.


### A-2 — *Task Status* und *Task Errors* waagrecht unten

Gestellt am 08.09.2026, nachdem Gregor die Leisten im Prüfstand gesehen hatte:

> *„task errors und task status wären waagrecht unten besser als senkrecht —
> nach dem exit-fix korrigieren."*

Beide Bereiche lagen **senkrecht** als schmale Spalten links neben dem
MDI-Bereich. Verlangt ist eine **waagrechte** Anordnung am unteren Fensterrand.
Die Reihenfolge, die Gregor selbst gesetzt hat, gilt: **erst** Kriterium 7 (das
Beenden), dann das.

Zusammenhang mit Kriterium 8: dort geht es um die **Registerkartenleiste** für
die offenen Fenster am unteren Rand. A-2 betrifft dieselbe Gegend des Fensters
und dieselbe Ersatzschicht `OTShim` — und genau so ist es gekommen: die
Registerkarten sind als **A-3** unmittelbar danach umgesetzt worden
(siehe unten), in derselben Schicht.

**Woran A-2 sich messen lässt.** Nach dem Start muss `tools/leisten-messen.ps1`
für die Leiste mit der Kennung **320** melden: Andockseite **unten**,
**Sichtbar = True**, Höhe **80**, Breite = Breite des Hauptfensters minus
Rahmen. Und zwar **sowohl** beim ersten Start (frisches Profil, kein
`[WazooBars]`-Abschnitt) **als auch** bei jedem weiteren Start mit vorhandener
`Eudora.ini` — das sind zwei verschiedene Programmwege, und nur der zweite ist
der, den Gregor gesehen hat.

**Umgesetzt in 7.2.0.23** (Befund [**E-44**](Intern/BEFUNDE.md#e-44)), von Gregor am 08.09.2026 am
ausgelieferten Paket bestätigt: *„leiste unten paßt."*
Zwei Ursachen, beide gemessen, beide behoben:

1. Beim frischen Profil lag die Leiste schon richtig (unten, 1712×80) und wurde
   nur durch `ID_SEC_HIDE` in `WazooBarMgr.cpp`, `SetDefaultWazooBarState`
   Fall 2, sofort wieder **versteckt**. Diese Zeile ist entfallen.
2. Ab dem zweiten Start läuft ein anderer Zweig, der die Andockseite
   **überhaupt nicht** setzt: `LoadWazooConfigFromIni` (`WazooBar.cpp:552`)
   stellt nur wieder her, welche Fenster in einer Leiste sitzen. Die Lage käme
   aus MFCs `LoadBarState` und damit aus dem INI-Abschnitt `[ToolBar...]` —
   den es nicht gibt, weil `SaveBarState` beim Beenden abbricht ([**E-43**](Intern/BEFUNDE.md#e-43)).
   Jetzt wird die Standardanordnung nachgezogen, wenn eine Leiste an keiner
   Andockleiste hängt.

Fundstellen: `Eudora71/Eudora/WazooBarMgr.cpp` (`SetDefaultWazooBarState`,
`LoadWazooBarConfigFromIni`), `Eudora71/Eudora/WazooBar.cpp:552`, Abschnitt
`[WazooBars]` in der `Eudora.ini` (Schlüssel `WazooBarIds`, `WazooBar%d`,
`WazooMDI%d`, Namen in `EudoraRes.rc:10637-10640`), und die Andockseite in
`Eudora71/OTShim/OTShim.cpp:293` (`SECMDIFrameWnd::DockControlBarEx`).

### A-3 — Offene Fenster als Registerkarten direkt auswählen

Gestellt am 09.09.2026, nachdem Gregor 1.0.24 geprüft hatte:

> *„es ist nur übers menü zu sehen, welches fenster gerade offen ist, ich möchte
> noch eine möglichkeit haben, ähnlich wie im web browser (tabs) die einzelnen
> fenster direkt auszuwählen."*

Das ist der noch fehlende Teil von **Kriterium 8**. Mit A-3 ist es ganz erfüllt.

**Der Befund dazu ist [E-48](Intern/BEFUNDE.md#e-48).** Und die Lage ist besser als gedacht: die Leiste
ist nicht *nicht vorhanden*, sondern **abgeschaltet**. Nachgemessen am
09.09.2026:

| Stück | wo | Zustand |
|---|---|---|
| Ein-/Ausschalter | `mainfrm.cpp:1042` `ShowMDITaskBar(GetIniShort(IDS_INI_MDI_TASKBAR))` | **da** |
| INI-Schlüssel und Vorgabe | `EudoraRes.rc:7959` `ShowMDITaskbar\n1` | **da, Vorgabe „an"** |
| Einstellungsseite | `settings.cpp:1060`, Ankreuzfeld *„Show MDI task bar"* (`EudoraRes.rc:2704`) | **da** |
| Zeichnen | `QCWorkbook::OnDrawTab`, `OnDrawTabIconAndLabel`, `OnDrawBorder`, `GetTabPts` (`workbook.cpp:1254ff`) | **da** |
| Geometrie | `QCGetTabRect`, `QCGetTaskBarRect`, `recalcTabWidth`, `CountVisibleTabs` | **da** |
| Maus | `OnLButtonDown`, `TabHitTest`, `OnContextMenu`, `OnSetCursor` | **da** |
| Kurzhinweise | `InitMDITaskBarTooltips`, `RecalcToolTipRects`, `OnNotify` | **da** |
| Blattliste | `AddSheet`/`RemoveSheet` → `ResetTaskBar`; die Liste führt `SECWorkbook` (`OTShim.cpp:923/936`) | **da** |
| **`SECWorkbook::SetWorkbookMode`** | `OTShim.cpp:1120` | **Attrappe** — meldet „nicht umgesetzt", setzt `m_bWorkbookMode` **nicht** und reserviert keinen Rand |
| **Wer `OnDrawTab` ruft** | — | **fehlt** — der Streifen wird nie gezeichnet |

Es fehlten also nur Anschlüsse in der Ersatzschicht, nicht die Funktion selbst.

**Umgesetzt in 7.2.0.25**, am laufenden Programm gemessen und fotografiert
(zwei offene Fenster, zwei beschriftete Karten: `In` und
`No Recipient, No S…`, die aktive hervorgehoben). **Von Gregor am 09.09.2026
bestätigt:** der Klick auf eine Karte holt das Fenster nach vorn, und die
Beschriftungen stimmen mit dem Menü *Window*. Damit ist **Kriterium 8** ganz
erfüllt. Drei Mängel, die er dabei an 1.0.25 gefunden hat, sind als [**E-50**](Intern/BEFUNDE.md#e-50) in
7.2.0.26 behoben und noch nicht nachgesehen; ein **Nebenbefund ohne Nummer**
bleibt offen — nach einem Neustart stehen die Fenster nicht im Vollbild,
obwohl sie beim Beenden so waren. Der gehört nicht zu A-3, sondern zum
Fensterzustand (`SaveOpenWindows`), und ist getrennt zu messen.

Vier Ursachen lagen dazwischen, jede einzeln gemessen:

| | war | ist |
|---|---|---|
| `SECWorkbook::SetWorkbookMode` | Attrappe, meldete „nicht umgesetzt" und setzte `m_bWorkbookMode` nicht | setzt den Betrieb und reserviert den Streifen |
| `SECWorkbook::GetTabPts` | lieferte **sechs Nullpunkte** → jede Karte an Punkt (0,0) mit Größe null | echte Kartenform; gezählt werden nur **sichtbare** Blätter, wie in `CountVisibleTabs` |
| `recalcTabWidth()` | **liefert** die Breite nur zurück, setzt `m_cxTab` nicht — der Rückgabewert war weggeworfen | `m_cxTab = recalcTabWidth()` |
| Streifenlage | begann bei `rectClient.left` = 0 und lag damit **unter der linken Leiste** (Client-x 6…186); nur der Rand von Karte 1 war zu sehen | beginnt am **MDI-Bereich**. Bewusste Abweichung von `QCGetTaskBarRect` (`workbook.cpp:930`), das dort ebenfalls `rectClient.left` nimmt |
| Beschriftung | `OnDrawTab` zeichnet nur den **Rahmen** | `OnDrawTabIconAndLabel` wird mitgerufen — sie ist virtuell und wurde von niemandem aufgerufen |

**Woran A-3 sich messen lässt.** Bei laufendem Eudora mit mindestens zwei
offenen Fenstern:

1. Am unteren Fensterrand steht ein Streifen mit **einer Registerkarte je
   offenem Fenster**, beschriftet wie im Menü *Window* (dort nachzuzählen).
2. **Ein Klick** auf eine Karte holt das zugehörige Fenster nach vorn.
3. Die aktive Karte ist von den übrigen unterscheidbar.
4. Öffnet oder schließt man ein Fenster, ändert sich der Streifen sofort.
5. Das Ankreuzfeld *„Show MDI task bar"* in den Einstellungen schaltet ihn
   aus und wieder ein, und der Zustand überlebt einen Neustart.
6. `tools/leisten-messen.ps1` muss den Streifen als Messwert ausgeben können —
   ein Bildschirmfoto ist kein Beleg.

**Nicht verlangt:** Karten verschieben, schließen per Mittelklick oder ein
Kontextmenü über das hinaus, was `OnContextMenu` schon mitbringt.

### A-4 — Das linke Fenster breiter ziehen können

Gestellt am 09.09.2026, unmittelbar nach A-3:

> *„ich noch das fenster links (mailverzeichnis, persona, …) möchte vergrößern
> können. also den trennbalken nach rechts, damit ich mehr sehe."*

Gemeint ist die Wazoo-Leiste **318** (Postfächer, Dateien, Signaturen,
Briefpapier, Persönlichkeiten). Sie ist heute auf **180 Pixel** festgenagelt —
gesetzt in `WazooBarMgr.cpp`, `SetDefaultWazooBarState` Fall 0
(`DockControlBarEx(pWazooBar, AFX_IDW_DOCKBAR_LEFT, 0, 0, 1.00, 180)`) — und
lässt sich mit der Maus nicht verändern.

**Der Befund dazu ist [E-49](Intern/BEFUNDE.md#e-49).** Wie bei A-3 ist die Mechanik vorhanden und nur
nicht angeschlossen. Nachgemessen am 09.09.2026:

| Stück | wo | Zustand |
|---|---|---|
| Klasse `SECDockBar::Splitter` mit Lage, Art, Ausrichtung, Grenzen | `OTShim.h:753` | **da** |
| `AddSplitter` | `OTShim.cpp:3683`, 17 Anweisungen | **umgesetzt** |
| `HitTest` (findet den Balken unter dem Zeiger) | `OTShim.cpp:3808` (erklärt in `OTShim.h:865`), 7 Anweisungen | **umgesetzt** |
| `StartTracking` (Ziehen beginnen) | `OTShim.cpp:3974`, 7 Anweisungen | **umgesetzt** |
| `CalcTrackingLimits` (wie weit man ziehen darf) | `OTShim.cpp:3835`, 11 Anweisungen | **umgesetzt** |
| `Splitter::DrawTrackerRect` (der Ziehbalken) | `OTShim.cpp:4249`, 14 Anweisungen | **umgesetzt** |
| `DeleteAllSplitters` | `OTShim.cpp:3711` | **umgesetzt** |

> **Alle sieben Zeilenangaben am 17.09.2026 vom LEKTOR neu gemessen ([L-13.3](Befunde/LEKTOR-13.md#l-13.3)).**
> Sie waren um 500 bis 1000 Zeilen abgewandert und zeigten ins Leere:
> `OTShim.h:724ff`, `OTShim.cpp:3038`, `:3159`, `:3199`, `:3178`, `:3255`,
> `:3066`. An keiner dieser Stellen steht heute noch, was hier behauptet wurde.
> **Die Sache selbst stimmt** — jede der sieben Stellen ist umgesetzt und
> wurde einzeln nachgeschlagen; falsch war nur, wo sie zu finden sind.
| Eudoras eigene Überschreibung `QCDockBar::CalcTrackingLimits` | `DockBar.cpp:149` | **da** — sorgt dafür, dass die Reklameleiste nicht überfahren wird |
| Eudoras `QCDockBar::NormalizeRow` | `DockBar.cpp:223` | **da** |
| **Der Aufruf von `AddSplitter`** | — | **fehlt** — `m_arrSplitters` bleibt leer, `HitTest` liefert immer NULL, und damit kommt es nie zum Ziehen |

Der Kommentar im Kopf sagt es selbst (`OTShim.h:702`): *„STUFE 2 OFFEN: die
Splitter selbst. AddSplitter wird nie aufgerufen …"*

**Woran A-4 sich messen lässt.** Bei laufendem Eudora:

1. Fährt man mit der Maus auf die Kante zwischen linkem Bereich und
   Nachrichtenliste, wird der Zeiger zum **Größenzeiger**.
2. Ziehen nach rechts **verbreitert** den linken Bereich, ziehen nach links
   verschmälert ihn; der Nachrichtenbereich gibt entsprechend nach.
3. Die Breite lässt sich über **180 Pixel hinaus** vergrößern — das ist
   Gregors eigentliche Bitte.
4. Die eingestellte Breite **überlebt einen Neustart** (sie landet im
   `[ToolBar…]`-Abschnitt der `Eudora.ini`, der seit [**E-43**](Intern/BEFUNDE.md#e-43) überhaupt
   erst geschrieben wird).
5. `tools/leisten-messen.ps1` gibt die geänderte Breite als Zahl aus — vorher
   180, hinterher der neue Wert.

**Zusammenhang mit A-3:** beides sitzt in derselben Ersatzschicht und
derselben Fensterebene, und beides ist „Mechanik da, Anschluss fehlt".
Deshalb zusammen umzusetzen, nicht nacheinander.

**Umgesetzt in 7.2.0.26, nachgebessert in 7.2.0.27 ([E-52](Intern/BEFUNDE.md#e-52)) und in 7.2.0.29
([E-54](Intern/BEFUNDE.md#e-54): der Ziehrahmen war nach rechts unsichtbar; [E-55](Intern/BEFUNDE.md#e-55): acht Pixel leerer
Streifen unter der Werkzeugleiste), von Gregor an 1.0.84 bestätigt am 13.10.2026** (Testplan Teil A: *„nach neustart immer noch gleiche größe“*). Bis dahin war nur der **Gegenfall** bestätigt: am 09.09.2026
*„verschieben rauf / runter — bug gefixt, die anzeige ist korrekt."*, also die
Höhenänderung des unteren Bereichs samt Auffrischen; das seitliche Ziehen
beurteilte er erst am 13.10.2026. Drei Anläufe, zwei davon am laufenden Programm
widerlegt:

| Anlauf | Messung | Urteil |
|---|---|---|
| über `SetBorders` | Andockleiste Client **176**, Leiste 318 **180** | verworfen — der Rand verkleinert den Innenbereich und vergrößert die Andockleiste **nicht** |
| Zuschlag in `CalcFixedLayout`, Bedingung über `m_arrBars` | Andockleiste blieb **180** | verworfen — keine Wirkung |
| Messversuch: Zuschlag **11**, bedingungslos | **187**, freier Streifen **7** | belegt: der Weg stimmt, MFC verbraucht **4 Pixel** des Zuschlags selbst |
| Bedingung am Ergebnis, Balken nach nachgemessenem Platz | **188**, freier Streifen **8** | steht |

**Was ich nicht selbst prüfen kann:** das Ziehen. `Splitter::Track` bricht ab,
sobald die **physische** Maustaste los ist — das muss so sein, weil der erste
Entwurf mit `while(::GetMessage(...))` die Prüfinstanz **zweimal eingefroren**
hat, wenn kein `WM_LBUTTONUP` kam. Ein künstlicher Zug über Fensterbotschaften
ist damit nicht mehr möglich. Nachweisbar ist nur die Voraussetzung: 8 Pixel
freier Streifen, an dem der Balken sitzt.

## Woran sich Kriterium 2 misst

Gregor hat als Vergleich ein Bildschirmfoto der Originalfassung geliefert
(Eudora 7 unter Windows XP). Maßgeblich sind daraus:

- Werkzeugleiste mit **allen** Symbolen, keine leeren grauen Felder
- Postfachbaum links, sauber abgegrenzt
- Nachrichtenfenster mit Kopfzeilenbereich und Textbereich untereinander
- Registerkarten am unteren Rand des Nachrichtenbereichs
- keine sich überlagernden Bereiche

Dazu kommt: **was man anklickt, muss auch aufgehen.** Ein Fenster, das erscheint,
aber nicht benutzbar ist, erfüllt kein Kriterium — das war Gregors Maßstab schon
am 30.08.2026 (*„das hauptfenster ist ja kaputt!"*). Deshalb zählen Strg-N, der
Doppelklick auf eine Nachricht und die Suchtreffer zu Kriterium 2 und nicht zu
den Kleinigkeiten.

Bekannte Abweichungen im Erscheinungsbild sind in `BEFUNDE.md` unter [S-6](Intern/BEFUNDE.md#s-6)
gesammelt.

## Woran sich Kriterium 3 misst

Nachweis ist ein tatsächlicher Abruf gegen einen echten Server, mit Beleg:
Protokollversion und Verfahren aus *Tools → Last SSL Info*, und mindestens eine
empfangene Nachricht, die lesbar dargestellt wird.

> **Erbracht.** Am 31.08.2026, 08:09:43 (Befund [E-3](Intern/BEFUNDE.md#e-3)): `mx.freenet.de` auf
> **Port 110 mit STARTTLS**, `TLSv1.3`, `TLS_AES_256_GCM_SHA384` (256 Bit),
> Status *Succeeded*, danach 159 abgerufene und lesbar dargestellte Nachrichten.
> Am 06.09.2026 zusätzlich über **Port 995** mit `TLSv1.3`,
> `Negotiation Status: Succeeded` — damit gilt auch der Weg mit implizitem TLS
> als belegt, und die frühere Einschränkung „nur über Port 110" ist überholt.

## Was daraus für die Benennung folgt

Der Dateiname `Eudora72-1.0.2-lauffaehig.zip` behauptet mehr, als die Fassung
kann. Künftige Pakete heißen nach ihrem tatsächlichen Stand. Siehe
`Releases/PAKETE.md`.
