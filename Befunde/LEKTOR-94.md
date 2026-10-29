# <a id="lektor-94"></a>LEKTOR-94 — Datenschutz nach PR #184 und #185, Release-Vorbereitung 7.2.1, 29.10.2026

**Auftrag.** Nach den beiden Bereinigungen (PR #184 `eb0ad40b`, PR #185
`94217d88`, Merge `1ba04dbc`) prüfen, ob im ganzen Repo noch etwas aus
Gregors Postfach steht; ob die Ersetzungen Sätze sinnlos gemacht oder Belege
verfälscht haben; ob CHANGELOG, FAQ, README „Bekannte Fehler“, TESTPLAN und
WEITERMACHEN für das Release 7.2.1 zusammenpassen; was aus den Funden von
[LEKTOR-93](LEKTOR-93.md#lektor-93) wurde. Gemessen im Arbeitsbaum
`Eudora7.2-wt-lektor` auf `wt/lektor-20261029d` (= `1ba04dbc` = `origin/main`).
Nichts gebaut, nichts gestartet.

**Wie gesucht wurde** (gemessen): (a) die Muster aus der lokalen, von Git
ignorierten Suchliste (ohne Gregors Vornamen) über jede verfolgte Datei, über
die ausgepackten ZIPs unter `Releases/`, über alle Commit-Nachrichten seit
`750eb814`, über die 22 Release-Texte auf GitHub und über jeden Zweig auf
GitHub; (b) jede seit dem Originalimport `567a5d87` hinzugekommene Zeile
(271 257 Zeilen, ohne `OpenSSL*`) auf Mailadressen, Betreffmuster
(`Fw:`/`Fwd:`/`Re:`/`WG:`/`AW:`/`Subject:`/`Betreff`), Message-IDs,
Postfach- und IMAP-Ordnernamen, Anhang-Dateinamen und Adressen im Netz;
(c) Stichwortsuche nach den Absendern, die in den Ersetzungen von `94217d88`
vorkommen. **Ausgenommen** wie beauftragt: OpenSSL, zlib, STL, Apple, die
Junk-Datenbank unter `InstallersForEudora`; dazu die Testdateien unter
`Documents/WinTestFiles` aus dem Originalimport (ein Treffer der Suchliste
dort ist Qualcomm-Testmaterial von 2006, nicht Gregors Post — belegt:
`git log` nennt nur `567a5d87`).

**In diesem Bericht steht kein Name, keine Adresse, kein Betreff und kein
Dateiname aus Gregors Postfach.** Jeder Fund ist nur mit Datei:Zeile und
Kategorie genannt.

**Ergebnis vorweg.** **18 Funde: 8 zum Datenschutz, 4 zu verfälschten oder
zerbrochenen Sätzen, 6 zur Release-Vorbereitung und Buchführung.** Die
Muster der lokalen Suchliste kommen im aktuellen Stand **nicht mehr vor**
(gemessen: 0 Zeilen auf `main`, gegen 67 auf `fc3ac107` vor den beiden PRs).
**Aber:** die Bereinigung hat nur nach den Mustern der Liste und nach
bekannten Betreffzeilen gesucht. **Was nicht in der Liste stand, ist
geblieben** — darunter Anhang-Dateinamen aus einer beruflichen Mail
([L-94.1](#l-94.1)), der Name des Unterzeichners eines Rundbriefs mit
Absenderdomain und Bildnamen ([L-94.2](#l-94.2)), die Betreffzeile einer
privaten Anzeigen-Unterhaltung samt Gegenstand ([L-94.3](#l-94.3)) und
die Firmennamen mehrerer Absender, obwohl der Commit `94217d88` *„Absender-
und Firmennamen“* als ersetzt meldet ([L-94.4](#l-94.4)). Die öffentliche
Git-Geschichte, sechs Zweige auf GitHub und die Diff-Ansichten der PRs #184
und #185 zeigen alles Entfernte weiter ([L-94.7](#l-94.7), Gregors
Entscheidung). Für das Release passt der Stand im Wesentlichen zusammen; die
Funde aus [LEKTOR-93](LEKTOR-93.md#lektor-93) sind 4 von 6 erledigt, 2
teilweise.

---

## Funde aus LEKTOR-93

| Fund | Was es war | Heute | Beleg |
|---|---|---|---|
| [L-93.1](LEKTOR-93.md#l-93.1) | [E-169](../Intern/BEFUNDE.md#e-169) (Druckvorschau ohne Bilder) nannte die widerlegte Vermutung zuerst | **erledigt** | `Intern/BEFUNDE.md:386` die Vermutung ist durchgestrichen, *„(widerlegt am Quelltext, siehe *Was noch fehlt*)“*; Klartext *„nach dem Release wird am Prüfstand gemessen“* (belegt) |
| [L-93.2](LEKTOR-93.md#l-93.2) | [E-170](../Intern/BEFUNDE.md#e-170) (Label geht beim Verschieben im IMAP-Konto verloren) stufte still Verlorenes als *wichtig* | **teilweise** — Stufe jetzt *kritisch*; die um zwei Zeilen verrutschte Angabe steht weiter | `Intern/BEFUNDE.md:385` *„**Stufe: kritisch** (eine gesetzte Markierung geht still verloren …)“*; ebenda weiter *„`ImapToc.cpp:1453`“*, der Aufruf `pCopySum->Copy(pSum)` steht in `:1455` (gemessen in [LEKTOR-93](LEKTOR-93.md#l-93.2)) |
| [L-93.3](LEKTOR-93.md#l-93.3) | [E-172](../Intern/BEFUNDE.md#e-172) (Mail als rohes Base64) stufte ohne Wissen mit „nichts geht verloren“ | **teilweise** — Stufe jetzt vorläufig *kritisch*; der Satz zu [E-145](../Intern/BEFUNDE.md#e-145) (Base64-Dekodieren verfälscht einzelne Bytes) ist nicht abgeschwächt | `Intern/BEFUNDE.md:383` *„**Stufe: kritisch** (vorläufig, bis gemessen …)“*; ebenda *„möglich ist ein Zusammenhang mit [[E-145](../Intern/BEFUNDE.md#e-145)] (Base64-Dekodieren), nicht geprüft“* (belegt) |
| [L-93.4](LEKTOR-93.md#l-93.4) | [E-171](../Intern/BEFUNDE.md#e-171) (Suche ohne Auswahl meldet internen Fehler): belegter Weg als Vermutung, Zeile verrutscht, „nie gemessen“ | **erledigt** | `Intern/BEFUNDE.md:384` *„alle drei Menüpunkte rufen dieselbe Funktion (`TridentView.cpp:1159`, `:1172`, `:1185` …)“*, *„`SearchView.cpp:2590-2593`“*, *„**Zuletzt gemessen: 29.10.2026 an 7.2.0.127**“*; `offene-befunde.pl` zählt jetzt *„aktuell gemessen 6“* (gemessen, unten) |
| [L-93.5](LEKTOR-93.md#l-93.5) | FAQ empfahl *Make Label* mit *Transfer To* ohne [E-170](../Intern/BEFUNDE.md#e-170) | **erledigt** | `Doku/FAQ.md:55-58` *„**Bekannte Einschränkung:** wird eine Mail mit Label später zwischen zwei Ordnern **desselben IMAP-Kontos** verschoben, ist das Label danach weg“* |
| [L-93.6](LEKTOR-93.md#l-93.6) | WEITERMACHEN-Einstieg kannte nur [E-169](../Intern/BEFUNDE.md#e-169); Gregors „nach dem Release“ fehlte bei den Entscheidungen | **erledigt** | `Intern/WEITERMACHEN.md:7` nennt [E-169](../Intern/BEFUNDE.md#e-169) bis [E-172](../Intern/BEFUNDE.md#e-172) *„alle erst nach dem Release (Entscheidung 16)“*; `:137` Entscheidung 16 |

**Reste aus [LEKTOR-92](LEKTOR-92.md#lektor-92) und [LEKTOR-91](LEKTOR-91.md#lektor-91):**

| Fund | Heute | Beleg |
|---|---|---|
| [L-92.2](LEKTOR-92.md#l-92.2) (FILTER.md nennt verrutschte Zeilen) | **teilweise** — die FAQ ist berichtigt, FILTER.md nicht | `Doku/FAQ.md:61` *„`EudoraRes.rc:6089`, ausgeführt in `filtersd.cpp:1222-1226`“* (gemessen: `:1222` `case ID_FLT_LABEL:`); `Intern/FILTER.md:228` weiter *„`filtersd.cpp:1151-1155`“* — dort steht ein Kommentar über Spurmarken (gemessen); `:220` weiter *„`EudoraRes.rc:6063-6093`“* |
| [L-91.3](LEKTOR-91.md#l-91.3) (tote Links in drei veröffentlichten Release-Texten) | **erledigt** für die drei — aber drei ältere haben je einen weiteren → [L-94.14](#l-94.14) | gemessen mit `gh release view`: `v1.0.113` 2, `v1.0.117` 2, `v1.0.120` 3 Links auf `blob/main/Intern/BEFUNDE.md`; Entscheidung 17, `Intern/WEITERMACHEN.md:138` |
| [L-91.4](LEKTOR-91.md#l-91.4) (E-166-Prüfschritt am Release) | **teilweise**, unverändert | `Intern/TESTPLAN.md:30` *„Kommt sie wieder, ist [E-166](../Intern/BEFUNDE.md#e-166) nicht behoben — bitte melden.“* — dass `README.md:162` dann ihr *„Behoben ab dem Release 7.2.1“* verlöre, steht weiter nicht da |
| [L-91.7](LEKTOR-91.md#l-91.7) („Punktzahl 0“ ohne Bedingung) | **teilweise**, unverändert | `Intern/FILTER.md:530-533` *„Einer Einstufung, die auf einem nicht geladenen Modul beruht, darf man keine Post zum Löschen anvertrauen.“* — der Fall des **geladenen** Moduls fehlt weiter |

## Mechanisch zuerst (gemessen, nicht als Urteil übernommen)

| Werkzeug | Ausgabe | Bewertung |
|---|---|---|
| `perl tools/doku-pruefen.pl` | *„gepruefte Dateien 48 … Kennungen im Verzeichnis 161 … Kein Widerspruch gefunden.“*, dazu *„Zur Kenntnis“* 15 Dateien, die 7.2.0.127 nicht nennen (`Doku/HINTERGRUND.md` … `tools/pruefdaten/LIESMICH.md`) | dieselbe Rauschliste wie in [LEKTOR-93](LEKTOR-93.md#lektor-93). Datenschutz prüft es nicht |
| `perl tools/offene-befunde.pl` | *„offen laut Intern/BEFUNDE.md 45 … davon aktuell gemessen 6 … davon veraltet gemessen 25 … davon NIE gemessen 14 … in Intern/WEITERMACHEN.md 45 … 45 offene Befunde, in beiden Listen gleich.“* | gegen [LEKTOR-93](LEKTOR-93.md#lektor-93) (5/25/15) ist [E-171](../Intern/BEFUNDE.md#e-171) von *nie* zu *aktuell* gewandert — das war [L-93.4](LEKTOR-93.md#l-93.4) |
| `perl tools/pruefe-regressionstest.pl` | *„Befunde insgesamt 218 … davon mit Testfall 74 … behoben und OHNE Testfall 68 … kritisch 73 … OHNE jede Pruefung 24 … [S-1](../Intern/BEFUNDE.md#s-1) [S-8](../Intern/BEFUNDE.md#s-8) [V-1](../Intern/BEFUNDE.md#v-1) [AN-1](../Intern/BEFUNDE.md#an-1) [E-2](../Intern/BEFUNDE.md#e-2) [E-3](../Intern/BEFUNDE.md#e-3) [E-23](../Intern/BEFUNDE.md#e-23) [E-32](../Intern/BEFUNDE.md#e-32) [E-60](../Intern/BEFUNDE.md#e-60) [E-64](../Intern/BEFUNDE.md#e-64) [E-72](../Intern/BEFUNDE.md#e-72) [E-82](../Intern/BEFUNDE.md#e-82) [E-120](../Intern/BEFUNDE.md#e-120) [E-122](../Intern/BEFUNDE.md#e-122) [E-123](../Intern/BEFUNDE.md#e-123) [E-124](../Intern/BEFUNDE.md#e-124) [E-126](../Intern/BEFUNDE.md#e-126) [E-129](../Intern/BEFUNDE.md#e-129) [E-172](../Intern/BEFUNDE.md#e-172) [E-170](../Intern/BEFUNDE.md#e-170) [E-156](../Intern/BEFUNDE.md#e-156) [E-136](../Intern/BEFUNDE.md#e-136) [E-133](../Intern/BEFUNDE.md#e-133) [E-39](../Intern/BEFUNDE.md#e-39) … Kein neues "behoben" ohne Regressionstest.“* | [E-170](../Intern/BEFUNDE.md#e-170) und [E-172](../Intern/BEFUNDE.md#e-172) stehen jetzt als *kritisch ohne Prüfung* in der Liste — die angekündigte Folge von [L-93.2](LEKTOR-93.md#l-93.2); nach Gregors Entscheidung vom 23.10. hält das 7.2.1 nicht auf |
| `perl tools/ziel-stand.pl` | *„ziel-stand: 27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“* | — |
| `perl tools/pruefe-testdaten-anonym.pl` (zusätzlich) | *„GRUEN: 15 Datei(en) geprueft, nichts beanstandet. … keines der 9 Ausschlussmuster kommt vor.“* | prüft nur `Testdaten/`; die Funde in [L-94.3](#l-94.3) liegen auch dort und fallen durch kein Muster → [L-94.17](#l-94.17) |

---

## Datenschutz

### <a id="l-94.1"></a>L-94.1 — Datenschutz: Anhang-Dateinamen aus einer beruflichen Mail

**Was passiert:** im CHANGELOG stehen die vollständigen Dateinamen dreier
Anhänge, die Gregor über IMAP empfangen hat. Sie nennen ein Fachthema, eine
Einrichtung, ein Projekt, ein Datum und einen Namensbestandteil — sie lassen
auf Gregors Arbeitsumfeld schließen. Die Suchliste kannte keinen dieser
Begriffe, deshalb blieb es stehen.

* **Gemessen**, Kategorie *Anhang-Dateinamen einer beruflichen Mail*:
  `CHANGELOG.md:1663`, `:1664`, `:1665` (Tabelle *„vom Server
  (BODYSTRUCTURE) | gespeichert als“*), `:1668` (Stammteil eines dieser
  Namen).
* **Gemessen**, dieselbe Kategorie in gekürzter Form:
  `Befunde/LEKTOR-19.md:21` (zwei umbenannte Kopien desselben Anhangs).

**Was zu tun wäre:** die Namen durch Muster ersetzen, die nur die gemessene
Eigenschaft tragen (Länge, Endung), etwa *„ein `.docx`-Name mit 42
Zeichen“*, *„ein `.zip`-Name mit 229 Zeichen“*. Die Messung bleibt gültig,
denn sie hängt nur an der Länge.

### <a id="l-94.2"></a>L-94.2 — Datenschutz: Rundbrief einer Organisation — Unterzeichner, Absenderdomain, Bildnamen, Textstücke

**Was passiert:** zu den Bild-Befunden aus dem September steht ein Rundbrief,
den Gregor bekommt, so genau im Repo, dass Absender und Abonnement erkennbar
sind: der Name des Unterzeichners in Anführungszeichen, die echte
Absenderdomain mit Bildpfad (in Quelltextkommentar und Unit-Tests), die
Dateinamen der Bilder (mit Initialen und Organisationskürzel) und Stücke des
Rundbrief-Texts.

* **Gemessen**, *Personenname* (Unterzeichner): `CHANGELOG.md:2071`.
* **Gemessen**, *Bild-Dateinamen des Rundbriefs*: `CHANGELOG.md:2072`,
  `:2107`; `Eudora71/Eudora/HTMLUtils.cpp:73`; `Intern/BEFUNDE.md:356`;
  `Eudora71/Tests/TestE112.cpp:41`, `:44` (Bildbezeichnung im Prüftext).
* **Gemessen**, *echte Absenderdomain mit Pfad*:
  `Eudora71/Eudora/PGHTMIMP.CPP:2603`; `Eudora71/Tests/TestResolveURL.cpp:47`,
  `:51`, `:57`, `:68`, `:72`, `:75`, `:110`, `:138`;
  `Eudora71/Tests/UnderTestResolveURL.cpp:18`; `Intern/BEFUNDE.md:356`.
* **Gemessen**, *Textstücke des Rundbriefs*: `Intern/BEFUNDE.md:356` (die
  Aufzählung *„alle **zehn** abgewiesenen Adressen tragen Leerzeichen
  (…)“*).

**Was zu tun wäre:** Domain durch `https://absender.invalid/…`, Bildnamen
durch erfundene Namen mit derselben Eigenschaft (Leerzeichen, `%20`,
Klammern), den Personennamen streichen. In den Tests ändert das nur die
Zeichenkette, nicht den Prüffall — vorher und nachher den Testlauf zählen
(der Bau gehört nicht zu diesem Auftrag).

### <a id="l-94.3"></a>L-94.3 — Datenschutz: Betreffzeile einer privaten Anzeigen-Unterhaltung, mit Gegenstand und Dateiname

**Was passiert:** die Betreffzeile einer weitergeleiteten Antwort auf eine
Anzeige Gregors steht wörtlich da, mit dem Gegenstand, den er angeboten
hat; an einer Stelle zusätzlich der Dateiname, unter dem er die Mail
gespeichert hat. Die Kopfzeilen derselben Stelle sind schon anonymisiert
(`konto-…@gregor.invalid`), der Betreff nicht.

* **Gemessen**, *Betreffzeile einer Fremdmail mit Gegenstand*:
  `Eudora71/Eudora/compmsgd.cpp:3449`; `CHANGELOG.md:2599-2600`;
  `Testdaten/e106-bild-groesser-als-angegeben.eml:32-33`, `:306`, `:605`.
* **Gemessen**, *Dateiname einer gespeicherten Mail mit diesem Betreff*:
  `Intern/BEFUNDE.md:348`.
* **Gemessen**, nur der allgemeine Anfang ohne Gegenstand:
  `Eudora71/Tests/TestE101.cpp:594`, `:600` — unbedenklich.

**Was zu tun wäre:** Gegenstand durch `<Gegenstand>` ersetzen; in der
`.eml` durch ein erfundenes Wort **gleicher Bytelänge mit denselben
Umlauten**, weil die Faltung und die Kodierung dort der Prüfgegenstand sind.

### <a id="l-94.4"></a>L-94.4 — Datenschutz: Firmennamen von Absendern und zwei Newsletter-Betreffe stehen weiter, obwohl der Commit sie als ersetzt meldet

**Was passiert:** der Commit `94217d88` sagt *„Betreffzeilen, Absender- und
Firmennamen … durch Platzhalter ersetzt“*. Ersetzt wurden die Firmennamen,
die in der Suchliste standen. Drei weitere Absender stehen mit Namen da —
ein Software-Hersteller (21 Stellen), ein Anzeigenportal (21
Stellen außerhalb der `.eml`, dazu das ganze HTML in `Testdaten/e106…`) und
ein Mailanbieter als Absender eines Newsletters —, dazu zwei
Newsletter-Betreffe in einem Protokollauszug.

* **Gemessen**, *Firmenname eines Absenders (Software-Hersteller)*:
  `Befunde/LEKTOR-35.md:8`, `:28`, `:39`, `:41`, `:123`;
  `Befunde/PRUEFER-7.md:228`; `CHANGELOG.md:1527`;
  `Eudora71/EuImap/src/ImapAppend.cpp:733`, `:1337`;
  `Eudora71/Tests/TestE118.cpp:112`, `:115`, `:120`, `:121`;
  `Intern/BEFUNDE.md:364`, `:367`; `Intern/TESTPLAN.md:686`;
  `Intern/WEITERMACHEN.md:29`; `Releases/1.0.90/TESTEN.txt:10`, `:11`;
  `Releases/PAKETE.md:694`, `:703`.
* **Gemessen**, *Name eines Anzeigenportals als Absender*:
  u. a. `Intern/BEFUNDE.md:348`, `:349`, `:352`, `:358`;
  `CHANGELOG.md:1553`, `:2282`, `:2431`, `:2437`;
  `Eudora71/Eudora/PgEmbeddedImage.cpp:813`; `Intern/AUFGABEN.md:47`;
  `Intern/TESTPLAN.md:670`; `Intern/WEITERMACHEN.md:33`, `:34`;
  `Intern/LEKTORAT.md:1311`; `Befunde/LEKTOR-14.md:366`,
  `LEKTOR-15.md:97`, `LEKTOR-33.md:49`, `PRUEFER-16.md:118`;
  `Releases/1.0.87/TESTEN.txt:11`; `Eudora71/Tests/TestE101.cpp:599`; `tools/pruefe-testdaten-anonym.pl:147` (Domain auf `.invalid`, Name erkennbar).
* **Gemessen**, *Betreff zweier Newsletter und Absender-Anbieter*:
  `CHANGELOG.md:4339-4340`; dazu `Befunde/PRUEFER-7.md:66`, `:73` (Absender
  eines Newsletters, Domain auf `.invalid` umgestellt, Anbietername
  erkennbar).
* **Gemessen**, *Betreff einer Bestätigungscode-Mail* (allgemein gehalten,
  ohne Absender): `Eudora71/Eudora/msgutils.cpp:3848`;
  `Eudora71/Tests/TestE101.cpp:36`, `:50` — für sich unbedenklich, aber
  zusammen mit [L-94.8](#l-94.8) zu lesen.

**Was zu tun wäre:** wie in `94217d88`: Software-Hersteller →
`Werbemail-C` (oder *„eine Mail mit eingebetteten Bildern“*),
Anzeigenportal → *„Portal-Nachricht“*; die beiden Newsletter-Betreffe
durch `<Betreff eines Newsletters>`. Ob Firmen, die nur als Absender von
Werbung vorkommen, überhaupt schutzwürdig sind, entscheidet Gregor — sein
*„solche daten“* und der Commit-Text sprechen dafür.

### <a id="l-94.5"></a>L-94.5 — Datenschutz: zwei Mailadressen ohne `.invalid` in einem Unit-Test

**Was passiert:** ein Unit-Test baut eine Empfängerzeile mit einer Adresse,
die aus Gregors Vornamen und der Domain eines echten Mailanbieters besteht.
Ob es Gregors Adresse ist, weiß ich nicht (**Vermutung**: eher erfunden, sein
Konto heißt im Repo `konto-…@gregor.invalid`); zustellbar wäre sie in jedem
Fall.

* **Gemessen**, *Mailadresse mit echter Domain*:
  `Eudora71/Tests/TestPopEmpfang.cpp:556`, `:564`.
* Unbedenklich (gemessen): `postmaster@…` desselben Anbieters
  (`:388-389`, eine Funktionsadresse), `juergen@example.org` (reservierte
  Domain), `a@b.de` in `Befunde/PRUEFER-14.md:99`, `newsletter@beispiel.de`
  in `Intern/FILTER.md:379`, `:386` (erfundene Beispiele, aber echte
  Domains — `.invalid` wäre sauberer).

**Was zu tun wäre:** `empfaenger@example.invalid`.

### <a id="l-94.6"></a>L-94.6 — Datenschutz: zwei veröffentlichte Release-Texte enthalten ein Wort aus einer Werbe-Betreffzeile, das im Repo ersetzt ist

**Was passiert:** im Repo wurde das Produktwort aus der Betreffzeile zu
[E-94](../Intern/BEFUNDE.md#e-94) (Betreff mitten im Wort umbrochen) durch
`Ware` ersetzt. Auf GitHub steht es in zwei veröffentlichten Release-Texten
weiter, dort im zitierten Bruchstück.

* **Gemessen** (`gh release view <tag> --json body`), *Wort aus der
  Betreffzeile einer Werbemail*: `v1.0.72`, Absatz *„**[E-94](../Intern/BEFUNDE.md#e-94)** — die
  Betreffzeile wird beim Weiterleiten mitten im Wort umbrochen“*; `v1.0.84`,
  erster Absatz (*„Vorher zeigte Eudora …“*).
* **Gemessen**, sonst sauber: alle 22 Release-Texte gegen die Suchliste
  (0 Treffer), Mailadressen (0 außer `.invalid`/`example`).

**Was zu tun wäre:** in beiden Texten das Wort durch `Ware` ersetzen —
eine Änderung nach außen, also nur mit Gregors Ja.

### <a id="l-94.7"></a>L-94.7 — Datenschutz: Git-Geschichte, sechs Zweige auf GitHub und die PR-Seiten zeigen alles Entfernte weiter

**Was passiert:** die Bereinigung wirkt nur auf den aktuellen Stand; der
Commit sagt das selbst (*„Git-Geschichte unveraendert“*). Alles Entfernte ist
im öffentlichen Repo weiter lesbar — über jeden älteren Commit, über die
Diff-Ansicht von PR #184 und #185 (die gelöschten Zeilen stehen dort rot),
und über sechs Zweige auf GitHub, deren **aktueller** Stand die Daten noch
trägt.

* **Gemessen** (`git grep -c` mit den Mustern der lokalen Liste, ohne
  Vornamen, ohne fremden Code): `origin/main` 0; `fc3ac107` (vor #184) 67;
  `origin/datenschutz-bereinigen` 63, `origin/release-7.2.1-vorbereiten` 66,
  `origin/wt/lektor-20261028` 63, `origin/wt/lektor-20261029` 63,
  `origin/wt/lektor-20261029b` 64, `origin/wt/pruefer-20261028` 63.
* **Gemessen**: alle sechs Zweige sind in `main` enthalten
  (`git merge-base --is-ancestor`); keiner hat einen offenen PR
  (`gh pr list --state open`: leer).
* **Gemessen**: die Commit-Nachrichten seit `750eb814` (20 Commits) sind
  frei von Mustern, Adressen und Betreffzeilen.

**Was zu tun wäre** (Gregors Entscheidung, [unten](#gregor)): die sechs
Zweige löschen kostet nichts und nimmt die Daten aus der Zweigansicht — aus
der Geschichte nicht. Ganz weg wären sie nur durch Umschreiben der
Geschichte (z. B. `git filter-repo`), erzwungenes Schieben aller Zweige und
Marken, und eine Anfrage an GitHub, die zwischengespeicherten Ansichten und
PR-Diffs zu entfernen. Jeder Klon, der bereits existiert, behält sie.

### <a id="l-94.8"></a>L-94.8 — Datenschutz, Hinweis: die Lehre zur Bereinigung beschreibt das Entfernte so genau, dass sie selbst etwas verrät

**Was passiert:** der Nachtrag vom 29.10. in der Lehre
`gedaechtnis-ist-oeffentlich` zählt auf, was gefunden wurde, und nennt dabei
für eine Betreffzeile und für einen Absender die **Art** so genau, dass sie
für sich eine persönliche Auskunft über Gregor ist. Zusammen mit dem
Platzhalter `Werbemail-A` für eben diese Mail ([L-94.11](#l-94.11)) und mit
der unveränderten Geschichte ([L-94.7](#l-94.7)) führt der Satz genau zur
empfindlichsten der entfernten Zeilen.

* **Belegt**, `Arbeitsweise/gedaechtnis-ist-oeffentlich.md:47` (die beiden
  Klammerzusätze nach *„Betreffzeilen“* und nach *„Absender- und
  Firmennamen“*). Die Datei ist ein Spiegel des Gedächtnisses (gemessen:
  byte-gleich mit dem Gedächtnisordner).

**Was zu tun wäre:** die beiden Klammerzusätze streichen — im
**Gedächtnis**, sonst bringt der nächste Spiegellauf sie zurück.

## Verfälschte oder zerbrochene Sätze

### <a id="l-94.9"></a>L-94.9 — zerbrochen: Ersetzungen ohne angepasste Grammatik

**Was passiert:** ein Platzhalter mit anderem Geschlecht oder ohne
Pluralendung hinterlässt falsches Deutsch.

* **Gemessen**, `Befunde/LEKTOR-33.md:79` *„mit den Werbemail-A- und
  Werbemail-Ben.“* (die Pluralendung des alten Namens klebt am Platzhalter).
* **Gemessen**, *„die Produktbild“* (Artikel des ersetzten Wortes stehen
  geblieben): `Intern/BEFUNDE.md:336`, `:342`; `CHANGELOG.md:2881`
  (*„seinem Bild die Produktbild:“*), `:3131` (*„liegt die Produktbild
  über“*); `Eudora71/Eudora/msgutils.cpp:3614`.

**Was zu tun wäre:** *„mit den Mails Werbemail-A und Werbemail-B“*; *„das
Produktbild“*. Für `msgutils.cpp` byte-erhaltend.

### <a id="l-94.10"></a>L-94.10 — Beleg verfälscht: E-94-Messung zitiert „Ware“, das Prüfwerkzeug erzeugt „Waren“, und die gemessene Abschneidestelle passt nur zu einem

**Was passiert:** zu [E-94](../Intern/BEFUNDE.md#e-94) (Betreff mitten im
Wort umbrochen) ist gemessen, wo die Postfachliste den Betreff der
Prüfnachricht 06 abschneidet (*„die übliche Feldlänge“*). Bei der
Bereinigung bekam das Werkzeug das Ersatzwort `Waren`, die Berichte das
Ersatzwort `Ware` — ein Zeichen Unterschied. Die zitierte Abschneidestelle
war mit dem ursprünglichen Wort gemessen; mit `Ware` statt `Waren` endete das
Feld ein Zeichen später. Wer die Messung mit dem heutigen Werkzeug
wiederholt, bekommt ein anderes Bild als im Bericht.

* **Gemessen**, Werkzeug: `tools/anhang-pruefdaten.pl:173` (kodiertes Wort
  mit `Waren`), `:185` (Soll-Betreff mit `Waren`).
* **Gemessen**, Berichte mit `Ware`: `CHANGELOG.md:1585`, `:1586` (die
  abgeschnittene Listenzeile mit dem Zusatz *„(die übliche Feldlänge)“*),
  `:1619`; `Befunde/LEKTOR-23.md:7`, `:8`; `Intern/AUFGABEN.md:801`.
* **Belegt**, ebenso: die Zitate aus Gregors Bildschirmfoto zu [E-94](../Intern/BEFUNDE.md#e-94)
  (`CHANGELOG.md:1597`, `:1604`; `Befunde/LEKTOR-24.md:16`, das sogar die
  Wörtlichkeit bis auf doppelte Leerzeichen prüft) stehen als wörtliche
  Zitate in Codespannen, enthalten aber einen Platzhalter — ohne Hinweis.

**Was zu tun wäre:** ein Ersatzwort für alle (das gleich lange `Waren`
erhält die Messung); an den Bildschirmfoto-Zitaten einmal *„(Produktwort
ersetzt)“*.

### <a id="l-94.11"></a>L-94.11 — Beleg verfälscht: „Werbemail-A“ ist keine Werbemail

**Was passiert:** der Platzhalter `Werbemail-A` ersetzt durchgehend einen
einzigen Absender (gemessen: in `94217d88` alle Ersetzungen zu
`Werbemail-A` aus demselben Namen). Diese Mail war aber keine Werbung — das
zeigt die Betreffzeile wenige Zeilen daneben im selben Test. Wer die
Befunde liest, hält [E-95](../Intern/BEFUNDE.md#e-95) und
[E-96](../Intern/BEFUNDE.md#e-96) (Bilder im Verfassenfenster zerschnitten
bzw. falsch hoch) für einen Fall aus Werbung.

* **Gemessen**, `Eudora71/Tests/TestE101.cpp:29` *„nach Gregors Datei "Fw
  Werbemail-A.eml" (5716 Byte)“* gegen die Betreffzeile in `:36`; ebenso
  `Eudora71/Eudora/msgutils.cpp:3844` gegen `:3848`.

**Was zu tun wäre:** `Mail-A`/`Mail-B` statt `Werbemail-A`/`-B`, oder
*„eine Mail mit Logo und eingebetteten Bildern“*. Den Hinweis in
[L-94.8](#l-94.8) mitdenken: je weniger der Platzhalter über die Art der
Mail sagt, desto besser.

### <a id="l-94.12"></a>L-94.12 — ungenau: die Tabelle „gemessen an echten Kopfzeilen“ zeigt `<Ort>`, der Test prüft `Musterstadt`

**Was passiert:** [BEFUNDE.md](../Intern/BEFUNDE.md) gibt an, die Tabelle
zeige die Eingaben von `TestPopEmpfang.cpp`. Im Test steht nach der
Bereinigung `Musterstadt`, in der Tabelle `<Ort>`; und *„echt“* sind die
Kopfzeilen seitdem nicht mehr.

* **Gemessen**, `Intern/BEFUNDE.md:3510` *„Gemessen an echten Kopfzeilen
  (`TestPopEmpfang.cpp`, neun Tests)“*, `:3520` *„`Re:
  =?utf-8?Q?Gr=C3=BC=C3=9Fe?= aus <Ort>`“* gegen
  `Eudora71/Tests/TestPopEmpfang.cpp:297` *„"Re: =?utf-8?Q?Gr=C3=BC=C3=9Fe?=
  aus Musterstadt"“*.

**Was zu tun wäre:** in der Tabelle `Musterstadt`, im Satz *„an
nachgebauten Kopfzeilen“*.

## Release-Vorbereitung und Buchführung

### <a id="l-94.13"></a>L-94.13 — Hinweis: die README empfiehlt bei E-172 „Rechtsklick → View Source“ — nie angeklickt, und im Nur-Text-Fenster womöglich gesperrt

**Was passiert:** in „Bekannte Fehler“ steht als Hilfe gegen die
Base64-Anzeige ([E-172](../Intern/BEFUNDE.md#e-172)) der Kontextmenüpunkt
*View Source*. Den Menüpunkt gibt es im Kontextmenü empfangener Mails. Für
die Nur-Text-Anzeige gibt ihn der Quelltext aber nur frei, wenn die Mail
formatierten Text enthält — eine als Base64-Brei angezeigte Mail hat das
vermutlich nicht.

* **Belegt**, `README.md:166` *„Rechtsklick → *View Source* zeigt den
  Rohtext“*.
* **Belegt am Quelltext**, `EudoraRes.rc:5884` `POPUP "Received Msgs"`,
  `:5900` `MENUITEM "&View Source", ID_VIEW_SOURCE`;
  `PgMsgView.cpp:734-735` *„Only enable the View Source command if the
  message contains styled text.“*, `:751-752`
  `if (PgHasStyledText(…)) pCmdUI->Enable(TRUE);`. Im HTML-Fenster
  (`TridentView.cpp:105`) gibt es diese Bedingung nicht.
* **Vermutung**, nicht gemessen: ob Gregors Mail im HTML- oder im
  Nur-Text-Fenster stand.
* Geprüft ohne Fund: die Hilfe zu [E-171](../Intern/BEFUNDE.md#e-171)
  *„*Edit → Find → Find Messages*“* (`README.md:165`) gibt es
  (`EudoraRes.rc:5520` `POPUP "&Edit"`, `:5606` `POPUP "F&ind"`, `:5612`
  `"Find &Messages\tCtrl+F"`).

**Was zu tun wäre:** *„*Message → … View Source*“* nur nennen, wenn
geprüft; sonst *„die Mail als Datei speichern und in einem Texteditor
ansehen“* oder die Spalte auf *„–“* setzen.

### <a id="l-94.14"></a>L-94.14 — ungenau: drei weitere veröffentlichte Release-Texte zeigen ins Leere

**Was passiert:** Entscheidung 17 und das CHANGELOG melden die toten Links
der Release-Texte als berichtigt. Das stimmt für die drei genannten. Drei
ältere Release-Texte enthalten je einen Link auf `blob/main/BEFUNDE.md`,
die es auf `main` nicht mehr gibt.

* **Gemessen** (`gh release view <tag> --json body`): `v1.0.2`, `v1.0.10`,
  `v1.0.43` je 1 × `blob/main/BEFUNDE.md`; `git ls-tree origin/main` kennt
  im Wurzelverzeichnis keine `BEFUNDE.md` (0 Treffer).
* **Belegt**, `CHANGELOG.md:125` *„mit sieben Links ins Leere … am
  29.10.2026 berichtigt“*; `Intern/WEITERMACHEN.md:138` *„2 + 2 + 3 Links
  … mit `gh release view` nachgezählt“*.

**Was zu tun wäre:** die drei Links ebenfalls umstellen (Gregors Ja aus
Entscheidung 17 galt *„die release-texte“* — ob es diese drei einschließt,
fragt [unten](#gregor) mit), oder im CHANGELOG *„in den drei jüngsten“*.

### <a id="l-94.15"></a>L-94.15 — ungenau: WEITERMACHEN und CHANGELOG stehen auf dem Zweig vor #183, ein alter Block widerspricht Entscheidung 16

**Was passiert:** der Einstieg nennt als Arbeitszweig
`release-7.2.1-vorbereiten`, der mit #183 gemergt ist; die Bereinigungen
#184/#185 fehlen. Der Block darunter (*„Stand 29.10.2026 — hier weiter“*)
ist nicht als überholt markiert und nennt als nächsten Schritt [E-169](../Intern/BEFUNDE.md#e-169) am
Prüfstand — Entscheidung 16 legt [E-169](../Intern/BEFUNDE.md#e-169) bis [E-172](../Intern/BEFUNDE.md#e-172) hinter das Release.

* **Belegt**, `Intern/WEITERMACHEN.md:7` *„(Stand 29.10.2026, Zweig
  `release-7.2.1-vorbereiten`)“*; `:140` *„**Stand 29.10.2026 — hier
  weiter:** Zweig `e166-junk_message_fix`“* … *„**Als Nächstes:** PR →
  `main`; danach [[E-169](../Intern/BEFUNDE.md#e-169)] am Prüfstand“* gegen `:137` *„werden **erst nach
  dem Release 7.2.1** behandelt“*.
* **Belegt**, `Intern/WEITERMACHEN.md:11` *„Zweig `e166-junk_message_fix`
  (auf `main` seit PR #180 …)“* — [E-166](../Intern/BEFUNDE.md#e-166) kam mit #182.
* **Belegt**, `CHANGELOG.md:106` *„weiter auf `release-7.2.1-vorbereiten`“*.
* **Gemessen**, `git log`: `1ba04dbc` Merge #185, `0047f5d1` Merge #184,
  `fc3ac107` Merge #183.

**Was zu tun wäre:** `:7` auf *„`main` nach #185; als Nächstes das Release
7.2.1 schnüren“*, `:140` als *„überholt durch den Block darüber“*
kennzeichnen, `:11` und `CHANGELOG.md:106` nachziehen.

### <a id="l-94.16"></a>L-94.16 — Hinweis: auf `main` liegt ein Commit mit Terminal-Steuerzeichen als Nachricht und vier doppelte Commits

**Was passiert:** der Merge, der den Zweig `release-7.2.1-vorbereiten` vor
#183 zusammenführte, trägt statt einer Nachricht die Antwort eines Terminals
auf eine Farbabfrage. Er führt zwei Linien mit jeweils denselben Commits
zusammen (gleiche Nachricht, gleiche Minute, verschiedene Kennung).

* **Gemessen**, `git log --graph`: `80f340d5` Nachricht
  *„;rgb:bfbf/bfbf/bfbfrgb:0000/0000/0000“*, Eltern `6eae4a32` und
  `d4fa94e3`; Paare gleicher Nachricht `6eae4a32`/`d4fa94e3`,
  `659bce90`/`f7ca0753`, `cde17fd4`/`e291dbf7`, `6410cff7`/`aef8f880`.
* **Vermutung**: die Nachricht entstand, als ein Commit-Befehl ohne `-m` in
  einem Terminal lief, das auf eine OSC-Farbabfrage antwortete.

**Was zu tun wäre:** nichts an der Geschichte (sie ist gemergt); falls sie
ohnehin für [L-94.7](#l-94.7) umgeschrieben wird, die Nachricht mit.

### <a id="l-94.17"></a>L-94.17 — ungenau: WERKZEUGE nennt 17 Ausschlussmuster, das Werkzeug meldet 9 — und es prüft nur `Testdaten/`

**Was passiert:** die Schranke für Testdaten zählt heute 9 Muster;
WERKZEUGE spricht von 17. Die Schranke sieht nur `Testdaten/` — der Rest
des Repos (wo [L-94.1](#l-94.1) bis [L-94.5](#l-94.5) liegen) hat keine
Schranke, nur den Merksatz in der Lehre.

* **Gemessen**, `perl tools/pruefe-testdaten-anonym.pl` *„keines der 9
  Ausschlussmuster kommt vor“* gegen `tools/WERKZEUGE.md:98` *„keines von 17
  Ausschlussmustern“*.
* **Belegt**, `Arbeitsweise/gedaechtnis-ist-oeffentlich.md:50`
  *„`perl tools/pruefe-testdaten-anonym.pl` prüft nur `Testdaten/`; für
  alles andere die Begriffe … über `git diff --cached` suchen“* — von Hand.

**Was zu tun wäre:** WERKZEUGE berichtigen; die Suche über
`git diff --cached` mit der lokalen Liste in den `pre-commit` nehmen
([schranke-gehoert-in-den-haken](../Arbeitsweise/schranke-gehoert-in-den-haken.md)).
Gegen [L-94.1](#l-94.1) bis [L-94.4](#l-94.4) hilft das allein nicht — die
Begriffe standen in keiner Liste.

### <a id="l-94.18"></a>L-94.18 — Hinweis: das CHANGELOG erwähnt die Bereinigung nicht

**Was passiert:** #184/#185 haben Quelltextkommentare, Unit-Tests und ein
Werkzeug geändert (Testlauf 314/314, laut Commit). Der Abschnitt *„Im
Quellstand, noch in keinem Paket“* nennt das nicht. Für Anwender ohne
Wirkung; wer den Quellstand mit 1.0.127 vergleicht, findet Änderungen ohne
Eintrag.

* **Belegt**, `CHANGELOG.md:104-132` (kein Eintrag); `git show --stat
  94217d88` 43 Dateien, darunter `Eudora71/Tests/TestPopEmpfang.cpp`,
  `TestE101.cpp`, `msgutils.cpp`, `PGHTMIMP.CPP`.

**Was zu tun wäre:** eine Zeile unter *Werkzeuge* oder *Dokumentation*:
*„Persönliche Daten aus Testfällen, Kommentaren und Dokumentation durch
Platzhalter ersetzt; kein Einfluss auf das Programm.“* — oder bewusst nicht,
wenn Gregor keine Aufmerksamkeit darauf lenken will.

---

## Release-Vorbereitung: geprüft ohne Fund

* **CHANGELOG ↔ README ↔ BEFUNDE zu [E-169](../Intern/BEFUNDE.md#e-169) bis [E-172](../Intern/BEFUNDE.md#e-172)** (belegt):
  `CHANGELOG.md:114-117` nennt alle vier mit *„behandelt nach dem Release“*;
  `README.md:163-166` hat je eine Zeile; die Stufen in
  `Intern/BEFUNDE.md:383-386` ([E-172](../Intern/BEFUNDE.md#e-172) *kritisch* vorläufig, [E-171](../Intern/BEFUNDE.md#e-171)
  *unkritisch*, [E-170](../Intern/BEFUNDE.md#e-170) *kritisch*, [E-169](../Intern/BEFUNDE.md#e-169) *wichtig*) passen zu den Spalten
  *„Was kann verlorengehen“* ([E-170](../Intern/BEFUNDE.md#e-170) *„das **Label**“*, [E-172](../Intern/BEFUNDE.md#e-172) *„offen, ob die
  Mail richtig gespeichert ist“*, [E-169](../Intern/BEFUNDE.md#e-169) und [E-171](../Intern/BEFUNDE.md#e-171) *„nichts“*).
* **[E-166](../Intern/BEFUNDE.md#e-166)** (belegt): `CHANGELOG.md:110` *„**Kommt mit dem Release
  7.2.1**“* mit Verweis auf `TESTPLAN.md#e-166-am-release`; der Anker steht
  in `Intern/TESTPLAN.md:13`; `ZIEL.md:46` verweist dorthin; `README.md:162`
  *„**Behoben ab dem Release 7.2.1**“*; Entscheidung 15
  (`Intern/WEITERMACHEN.md:136`) *„In der README steht [E-166](../Intern/BEFUNDE.md#e-166) unter
  „Bekannte Fehler““* — stimmt.
* **Entscheidungen 15 bis 17** (belegt, `Intern/WEITERMACHEN.md:136-138`):
  jede mit Datum und Zitat; 16 deckt [E-169](../Intern/BEFUNDE.md#e-169) bis [E-172](../Intern/BEFUNDE.md#e-172), 17 die drei
  Release-Texte (gemessen berichtigt, bis auf [L-94.14](#l-94.14)).
* **FAQ** (belegt): drei Antworten, jede mit Herkunft (*am Quelltext* /
  *am Programm*); die E-170-Einschränkung (`Doku/FAQ.md:55-58`) sagt
  dasselbe wie `README.md:163` und `Intern/BEFUNDE.md:385`.
  `README.md:48` verlinkt die FAQ.
* **Release-Abschriften im Repo** (gemessen):
  `Releases/1.0.113`, `1.0.114`, `1.0.117`, `1.0.120` verweisen nur noch
  auf `blob/main/Intern/BEFUNDE.md`.

## Datenschutz: geprüft ohne Fund

* Muster der lokalen Suchliste (ohne Vornamen) im aktuellen Stand: 0 Zeilen
  außerhalb fremden Codes und der Original-Testdateien (gemessen); der eine
  Treffer in `Eudora71/PNG/zlib/ChangeLog` ist fremder Code.
* Die beiden ZIPs unter `Releases/` (ausgepackt im Scratchpad, nur gelesen):
  keine Treffer der Liste; Adressen nur aus dem Original (Qualcomm,
  Zertifizierungsstellen, `myfirm.com`-Beispiele).
* Postfach- und IMAP-Ordnernamen in den hinzugekommenen Zeilen: nur
  Eudora-eigene (`In`, `Out`, `Trash`, `Junk`, `INBOX`) und erfundene
  Prüfnamen; `Imap\Dominant\INBOX` ist Eudoras Hauptpersönlichkeit.
* Message-IDs: nur `@127.0.0.1`, `@localhost` und `.invalid` (gemessen).
* Das Gedächtnis und sein Spiegel `Arbeitsweise/`: byte-gleich, keine
  Treffer der Liste (gemessen) — der nächste Spiegellauf bringt nichts
  zurück, außer was in [L-94.8](#l-94.8) steht.
* `Testdaten/*.eml`: Adressen auf `.invalid`, Kennungen in Adressen des
  Portals durch Füllwerte ersetzt, Anrede ohne Namen (gemessen, `e106:567`);
  offen nur [L-94.3](#l-94.3) und der Portalname ([L-94.4](#l-94.4)).

## Nicht geprüft

* Ob ein Text **sinngemäß** auf Gregor zurückführt, außerhalb der oben
  genannten Suchwege — etwa Gesprächsinhalte in Gregors Zitaten. Die
  Suche nach Personennamen ist heuristisch (zitierte Zweiwort-Namen,
  Kopfzeilen mit Anzeigenamen); ein Name ohne Anführungszeichen in
  Fließtext kann durchgerutscht sein.
* Binärdateien außer den beiden ZIPs (DLLs, `.lib`, `.tlb`), die
  Release-**Anhänge** auf GitHub (22 ZIPs, nicht heruntergeladen) und die
  Texte der PR-Seiten und Issues.
* Nichts am laufenden Programm.

## <a id="gregor"></a>Was nur Gregor entscheiden kann

* **Die Geschichte umschreiben oder nicht** ([L-94.7](#l-94.7)). Alles, was
  #184/#185 entfernt haben, ist im öffentlichen Repo über ältere Commits und
  die Diff-Ansicht der beiden PRs lesbar. Ganz weg nur mit `git filter-repo`
  über alle Zweige und Marken, erzwungenem Schieben und einer Anfrage an
  GitHub; bestehende Klone behalten es. Mindestens: sollen die sechs schon
  gemergten Zweige auf GitHub gelöscht werden, die die Daten noch im
  aktuellen Stand tragen?
* **Sollen die Firmennamen von Werbe-Absendern auch weg** ([L-94.4](#l-94.4))
  — der Commit-Text sagt, sie seien es schon?
* **Zwei veröffentlichte Release-Texte** (`v1.0.72`, `v1.0.84`) enthalten
  ein Wort aus einer Werbe-Betreffzeile ([L-94.6](#l-94.6)); drei ältere
  (`v1.0.2`, `v1.0.10`, `v1.0.43`) haben je einen toten Link
  ([L-94.14](#l-94.14)). Beides berichtigen?
* Unverändert offen: was vor der Marke `v7.2.1.N` getestet sein muss
  ([L-74.10](LEKTOR-74.md#l-74.10)) und Kriterium 0 ohne Visual Studio
  ([L-77.3](LEKTOR-77.md#l-77.3)).
