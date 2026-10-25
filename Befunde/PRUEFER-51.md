# <a id="pruefer-51"></a>PRUEFER-51 — E-119 K5, E-148, der neue Prüfbericht und die verschärften Schranken gegen die Quelle nachgerechnet, 25.10.2026

**Auftrag.** `git log 4ee02768..HEAD -- Eudora71 tools Releases/1.0` (Stand
`58113d66`, Zweig `wt/pruefer-20261025`): die Behebung von
[PRUEFER-49 K5](PRUEFER-49.md#k5) zu [E-119](../Intern/BEFUNDE.md#e-119)
(geteilte Bilddatei), [E-148](../Intern/BEFUNDE.md#e-148) (eMudhra-Wurzeln),
der neue Prüfbericht (`tools/pruefbericht.pl`, `tools/pruefstand-lauf.ps1`,
`tools/pruefstaende-auffrischen.ps1`, Einhängen in `tools/paket-bauen.ps1`)
und die heute nach [PRUEFER-50](PRUEFER-50.md#pruefer-50) verschärften
Schranken.

**Ergebnis vorweg.**

* **Die Behebung der geteilten Bilddatei hält.** Wer dieselbe Nachricht mit
  einem eingebetteten `data:`-Bild zweimal weiterleitet oder beantwortet,
  bekommt je Entwurf eine eigene Bilddatei. Löscht man einen Entwurf
  endgültig, behält der andere sein Bild. Die Erkennung der Datei stimmt: sie
  wird mit genau derselben Formel gebildet, mit der sie angelegt wurde. Auch
  das zweite Speichern desselben Entwurfs ist sicher. **Nur wenn das Kopieren
  scheitert** (etwa bei voller Platte), fällt Eudora auf den alten, geteilten
  Weg zurück, und dann kann das Löschen wieder ein fremdes Bild mitnehmen
  ([K8](#k8)).
* **Die eMudhra-Wurzeln sind aus der ausgelieferten Liste heraus.** Gemessen:
  117 Zertifikate, keines von eMudhra. Der Paketbau legt die neue Datei über
  die alte. **Eine Einschränkung:** Eudora liest `rootcerts.p7b` zuerst aus
  dem **Mailverzeichnis** und erst dann aus dem Programmverzeichnis. Liegt im
  Mailverzeichnis eine alte Datei, gilt die alte Liste. Die README nennt nur
  das Programmverzeichnis ([K6](#k6)). Im Paket selbst liegt im
  Mailverzeichnis keine solche Datei, der Normalfall ist also geschützt.
* **Der neue Prüfbericht kann „BESTANDEN“ melden, ohne dass alles gemessen
  wurde.** Drei Wege, alle drei gemessen:
  * Ein Oberflächentest zählt als grün, wenn er an **irgendeinem** Bau mit
    derselben Fassungsnummer lief. Ich habe im Ergebnisbuch den Bau von
    E-119d auf einen Stand **vor** der Behebung gesetzt. Der Bericht meldete
    trotzdem BESTANDEN ([K1](#k1)).
  * Bricht die Testsammlung mitten im Lauf ab, zählt der Bericht nur die
    Tests bis dahin. Gemessen: 240 von 295 Tests gelaufen, Urteil
    BESTANDEN. Auch der Vergleich vorher/nachher meldete „nichts neu rot“
    ([K2](#k2)).
  * Der Vergleich vorher/nachher fasst gleichnamige Schrankenproben zusammen:
    18 Proben werden 14 Einträge. Ich habe eine der vier E-35-Proben rot
    gemacht, der Vergleich meldete „NEU ROT 0“ und Rückgabe 0 ([K3](#k3)).
* **Die verschärften Schranken lassen weiter Rückfälle durch.** Auch das ist
  gemessen:
  * Hat eine Funktion zwei Warteschleifen und verliert die erste das
    Zurückstellen von `WM_QUIT`, bleibt die Schranke grün. Die zweite
    Schleife deckt sie mit ([K4](#k4)).
  * Die GetButton-Schranke erkennt den Zugriff `(*p).` nicht. Und sie nimmt
    eine NULL-Prüfung an, die den Zugriff gar nicht schützt ([K5](#k5)).
* **Die Testsuite ist grün: 295 Tests, 295 bestanden** (gemessen, vor und
  nach allen Rückfallproben).

**Hält ein Fund das Paket 7.2.0.123 auf?** **Nein.** Ein Programmfehler, der
vorher nicht da war, ist nicht dabei. **Vor dem Schnüren gehört aber ein
Handgriff dazu, den der Bericht heute nicht selbst prüft:** Die Baukennung
der Prüfstände (Commit) muss mit dem Bau in `Eudora71\Bin\Release`
übereinstimmen, aus dem das Paket entsteht. Sonst bescheinigt der Bericht
einen Bau, an dem kein Oberflächentest gelaufen ist ([K1](#k1)). Die anderen
Funde betreffen Prüfungen und Werkzeuge. Sie gehören vor **7.2.1.0**, für das
alle Regressionstests laufen und bestehen müssen.

**Neue E-Kennungen: keine. E-147 und E-149 bleiben frei.** [K6](#k6) gehört zu
[E-148](../Intern/BEFUNDE.md#e-148), [K8](#k8) zu
[E-119](../Intern/BEFUNDE.md#e-119). Eingetragen in `Intern/BEFUNDE.md` ist
nichts. Vorher gelaufen: `perl tools/befund-suchen.pl` zu
`ChooseCertFileDirectory` (kein Befund), `QCSSLContext.cpp`
([E-148](../Intern/BEFUNDE.md#e-148), [NP2-3](../Intern/BEFUNDE.md#np2-3)),
`E119KopieAlsTeil` ([E-119](../Intern/BEFUNDE.md#e-119)) und
`pruefbericht.pl` (kein Befund).

Gekennzeichnet ist jede Aussage: **gemessen** (Testlauf, Rückfallprobe,
Werkzeuglauf), **am Quelltext belegt** (Datei:Zeile, Stand `58113d66`),
**Vermutung**.

---

## 1. E-119 K5: jede Nachricht bekommt ihre eigene Bilddatei

**Was die Behebung tut** (am Quelltext belegt). `PgSaveUrlImage` ruft für
eine `file://`-Adresse jetzt `E119IstDataDatei`
(`PgEmbeddedImage.cpp:1220`). Liegt die Datei unter
`<EudoraDir><Embedded>\` und heißt sie `data-*`, kopiert
`E119KopieAlsTeil` sie über `NewPart` in einen neuen Teil der Nachricht
(`:1109-1159`). Sonst bleibt es bei `make_new_part_from_file`.

**Erkennung des Verzeichnisses: stimmt** (am Quelltext belegt). Angelegt wird
die Datei mit `"%s%s\\data-%08lx.%s"` aus `EudoraDir` und
`CRString(IDS_EMBEDDED_FOLDER)` (`PGHTMIMP.CPP:3673`). Erkannt wird sie mit
`"%s%s\\"` aus denselben zwei Werten (`PgEmbeddedImage.cpp:1098`), danach
`strnicmp` und kein weiterer `\` im Namen. Beide Seiten entstehen in derselben
Sitzung aus derselben Variablen, die Schreibweise (lang/8.3, Groß/klein) kann
nicht auseinanderlaufen. Die Kopien bekommen über `NewPart` einen Namen aus
`GetTmpFile` (`MimeStorage.cpp:225-245`), heißen also nicht `data-*` und
werden beim nächsten Speichern nicht noch einmal als geteilte Datei erkannt.

**Zweites Speichern derselben Nachricht (Adresse ist dann `cid:`):
unbedenklich** (am Quelltext belegt). Nach dem ersten Speichern steht die
`cid` in der Adresse (`PgEmbeddedImage.cpp:1243`). Beim zweiten Speichern
läuft der Zweig `make_it_schmookie` (`:1240`): er findet den Teil über
`IsRealCID` und kopiert ihn in einen neuen Teil (`:1462` ff.). Das war bei
QUALCOMM für `cid:`-Bilder schon immer so. Die erste Kopie bleibt in der
Teileliste der Nachricht und wird mit ihr gelöscht. Es gehen keine Daten
verloren, es entsteht nur je Speichern eine Datei mehr (Original, kein
Rückschritt durch K5).

**Antwort statt Weiterleitung: derselbe Weg** (am Quelltext belegt).
`E119IstDataDatei` fragt nicht nach der Art der Antwort, nur nach der Adresse.
Gemessen ist am Prüfstand aber nur die Weiterleitung
(`messen-e119-geteilt.ps1:225`, `ID_MESSAGE_FORWARD`); siehe [K9](#k9).

**Fehlschlag mitten in der Kopie:** siehe [K8](#k8).

### <a id="k8"></a>K8 — Scheitert die Kopie, kehrt die geteilte Datei zurück; eine an der letzten Pufferleerung gescheiterte Kopie gilt als gelungen

**Was passiert.** Drei Fehlerwege, alle selten (volle Platte, gesperrte
Datei), alle am Quelltext belegt:

1. `pNeu->Close()` (`PgEmbeddedImage.cpp:1139`) wird nicht ausgewertet.
   `QCMimePart::Write` schreibt über `JJFileMT::Put` in einen Puffer. Den
   letzten Rest schreibt erst `Close` → `Flush`, und ein Fehler dort kommt nur
   als Rückgabe von `Close` (`QCUtils/src/jjfile.cpp:173-200`). Ist die
   Platte beim letzten Stück voll, steht `kopiert=1`, und die Nachricht
   verweist auf ein abgeschnittenes Bild.
2. Scheitert die Kopie erkannt, nimmt `E119KopieAlsTeil` den alten Weg
   `make_new_part_from_file` (`:1158`). Der Kommentar sagt es selbst: „die
   Datei wird geteilt“. Damit ist genau der Datenverlust aus
   [PRUEFER-49 K5](PRUEFER-49.md#k5) wieder offen. Löscht man diese Nachricht
   endgültig, löscht `DeleteEmbeddedObjects` die gemeinsame `data-*`-Datei
   auch für alle anderen Entwürfe (`tocdoc.cpp:2929-2932`, `:4839-4851`).
3. `RemovePart` (`:1146`) löscht über `QCMimePart::Delete`. Scheitert das
   Löschen (Datei gesperrt), bleibt der Eintrag in der Teileliste stehen
   (`MimeStorage.cpp:207-220`). Die Nachricht trägt dann neben der geteilten
   Datei auch die halbe Kopie in `X-EmbeddedContent`.

Dazu kommt ein Rest aus [E-119](../Intern/BEFUNDE.md#e-119) selbst, den K5
weiterträgt: `E119DataNachDatei` prüft weder `fwrite` noch `fclose`
(`PGHTMIMP.CPP:3694-3695`). Eine abgeschnittene `data-*`-Datei wird wegen
`FileExistsMT` nie neu geschrieben (`:3679`), und jede Kopie erbt sie.

**Schwere:** gering. Es braucht einen Schreibfehler. Der Rückfall auf den
geteilten Weg ist aber eine bewusste Entscheidung für „Bild sichtbar, dafür
später verlierbar“. Bei vollem Datenträger wäre „Speichern scheitert
sichtbar“ die Alternative. **Gregor entscheidet.**

### <a id="k9"></a>K9 — E-119d prüft nicht, ob überhaupt gelöscht wurde, und misst nur die Weiterleitung

**Was passiert** (am Quelltext belegt). `messen-e119-geteilt.ps1` verlangt
`vollstaendig=1 probe=ok` (`pruefstand-faelle.txt:206`). `probe=ok` heißt nur,
dass vorher zwei Entwürfe mit Bildverweisen da waren (`:295`). Ob der
Papierkorb wirklich geleert wurde, prüft das Skript nicht. Es zählt weder,
ob eine Bilddatei verschwand, noch ob `out=1` erreicht wurde (`:296` gibt
`out` aus, die Fallzeile verlangt es nicht).

**Kann der Fall grün werden, ohne gemessen zu haben?** Am alten Bau würde ein
nicht geleerter Papierkorb nichts löschen. Beide Entwürfe hätten dann alle
Bilder, also `vollstaendig=2`, und der Fall wäre rot. Das gilt, solange die
Bytes des verschobenen Entwurfs noch in `Out.mbx` stehen, wie am 24.10.
gemessen (Kommentar `:276-281`). **Vermutung:** Verdichtet Eudora `Out.mbx`
zwischen Verschieben und Auswerten, steht nur noch ein Entwurf darin. Dann
ergibt auch der alte Bau `vollstaendig=1`, und der Fall ist grün, ohne dass
gelöscht wurde. Ob die Verdichtung dort greift (`tocdoc.cpp:1397`,
`IDS_INI_COMPACT_MAILBOX_PERCENT`), habe ich nicht gemessen.

**Vorschlag:** zusätzlich `out=1` verlangen, und dass mindestens eine
Bilddatei unter `Embedded` verschwunden ist. Einen zweiten Durchgang mit
`ID_MESSAGE_REPLY` aufnehmen, falls die Antwort Bilder übernimmt.

**Schwere:** gering.

### <a id="k10"></a>K10 — Hinweis: Entwürfe aus 1.0.110 bis 1.0.122 tragen die geteilte Datei weiter

**Vermutung**, nicht gemessen. Ein Entwurf, den ein Paket vor 7.2.0.123
gespeichert hat, nennt die geteilte `data-*`-Datei in seinem
`X-EmbeddedContent`. Beim Löschen liest `DeleteEmbeddedObjects` diese Liste,
nicht die Adresse im Text (`tocdoc.cpp:2929-2932`). Solange so ein alter
Entwurf existiert, kann sein Löschen das Bild anderer Nachrichten mitnehmen.
Das ist keine Schwäche der Behebung, aber eine Zeile in der README wert („alte
Entwürfe mit eingebetteten Bildern einmal öffnen und neu speichern“). Ob das
neue Speichern den alten Eintrag wirklich ersetzt, wäre vorher zu messen.

---

## 2. E-148: eMudhra-Wurzeln

**Gemessen** (`openssl pkcs7 -print_certs`):

| Datei | Zertifikate | davon eMudhra |
|---|---|---|
| `Releases/1.0/rootcerts.p7b` (neu, SHA256 `07fea9d2…`, stimmt mit `.sha256`) | 117 | 0 |
| `rootcerts.p7b` in `Releases/Eudora72-1.0.2-lauffaehig.zip` (Grundlage) | 121 | 4 (emSign Root CA – C1, – G1, ECC – C3, ECC – G3) |
| `Eudora71/Bin/Release/rootcerts.p7b` und `Bin/Debug/…` (im Repo, SHA256 `7e681db4…`) | 19 | 0 |
| `InstallersForEudora/Eudora7.1/Data/win32/rootcerts.p7b` | 30 | 0 |

**Landet die neue Datei im Paket?** Ja (am Quelltext belegt).
`paket-bauen.ps1:491` legt sie nach dem Auspacken der Grundlage (`:469`) und
vor jeder weiteren Kopie ab. Kein späterer Schritt im Skript berührt
`rootcerts.p7b`, und die Liste `$eigene` aus dem Bauverzeichnis (`:520-524`)
enthält sie nicht. `paket-bauen.ps1` ist das einzige Werkzeug, das ein Paket
packt (gemessen: `ExtractToDirectory` und `CreateFromDirectory` stehen nur
dort). Die Prüfstände bekommen die neue Datei über
`pruefstaende-auffrischen.ps1:60`.

**Ausschluss** (am Quelltext belegt). `rootcerts-erzeugen.ps1` vergleicht
`$cert.Subject -match 'O=eMudhra'`. Das trifft beide Organisationsnamen
(„eMudhra Inc“, „eMudhra Technologies Limited“). `usercerts.p7b` in der
Grundlage enthält drei alte QUALCOMM-Testzertifikate, kein eMudhra
(gemessen).

### <a id="k6"></a>K6 — Eudora liest rootcerts.p7b zuerst aus dem Mailverzeichnis; die README nennt nur das Programmverzeichnis

**Was passiert** (am Quelltext belegt). `CSSLSettings` setzt
`m_InputCertsDir = EudoraDir + "\r\n" + ExecutableDir` (`SSLSettings.cpp:87`).
`ChooseCertFileDirectory` nimmt das **erste** Verzeichnis, in dem die Datei
existiert, und `EudoraDir` steht vorn (`QCSSL/src/QCSSLContext.cpp:410-440`,
geladen in `:486`). Liegt im Mailverzeichnis eine `rootcerts.p7b`, wird die
Datei im Programmverzeichnis gar nicht gelesen.

**Was das für [E-148](../Intern/BEFUNDE.md#e-148) heißt.** Im Paket liegt im `Mailverzeichnis` keine
`rootcerts.p7b` (gemessen, Inhaltsliste der Grundlage: nur
`Mailverzeichnis\Eudora.ini`). Der Normalfall ist also geschützt. Wer aber
eine Datei mit eMudhra (Pakete 1.0.110 bis 1.0.122) ins Mailverzeichnis
kopiert hat, behält sie, auch mit Paket 7.2.0.123. Dasselbe gilt für ein
fremdes 7.1-Mailverzeichnis, falls dort eine liegt. Dann gilt die alte
QUALCOMM-Liste mit 30 Zertifikaten, ohne eMudhra, aber auch ohne die
heutigen Wurzeln. Wie oft so eine Datei im Mailverzeichnis liegt, ist
**Vermutung**. Ob der 7.1-Installer sie dorthin legt, habe ich nicht geprüft.

Die README sagt „gegen die Datei `rootcerts.p7b` im Programmverzeichnis“
(`README.md:223`, ebenso die Tabellenzeile `:147`) und rät für ältere Pakete, sie **dort** zu ersetzen
(`:241-244`). Für den Fall oben hilft das nicht.

**Vorschlag:** In der README den Satz ergänzen: „liegt auch im
Mailverzeichnis eine `rootcerts.p7b`, gilt diese; dort ebenfalls ersetzen
oder löschen“. Optional eine Protokollzeile, aus welchem Verzeichnis die
Liste geladen wurde. **Schwere:** mittel (Sicherheit, aber nur in einer
seltenen Lage). Gehört zu [E-148](../Intern/BEFUNDE.md#e-148).

### <a id="k7"></a>K7 — TestE148 prüft den Text des Paketskripts, nicht das Paket

**Gemessen.** Rückfall: direkt hinter die neue Zeile in `paket-bauen.ps1`
eine zweite `Nimm (Join-Path $binRel 'rootcerts.p7b') 'rootcerts.p7b'`
gesetzt. Das Paket bekäme damit die 19 alten Zertifikate aus `Bin\Release`.
`EudoraTests.exe`: **295 von 295**, beide E-148-Tests `[ok]`. Danach
byte-genau zurück (`cmp` gleich).

Der Test sucht nur, ob die Zeile im Skript steht (`TestE148.cpp:66-72`). Was
danach mit der Datei geschieht, prüft niemand. Auch `paket-pruefen.ps1`
kennt `rootcerts.p7b` nicht (am Quelltext belegt: kein Treffer für `p7b`).
Die Grundlage behält die alte Datei mit vier eMudhra-Wurzeln. Jede
Umstellung, die nach `Nimm` noch einmal auspackt oder aus der Grundlage
kopiert, holt sie zurück, ohne dass ein Test rot wird.

**Vorschlag:** `paket-pruefen.ps1` liest `rootcerts.p7b` **im fertigen Paket**
wie TestE148 (≥ 100 Zertifikate, kein eMudhra). **Schwere:** gering (heute
richtig, nur nicht bewacht).

---

## 3. Der neue Prüfbericht

Gefahren mit `perl tools/pruefbericht.pl --zeigen --ohne-bau` bzw.
`--vergleich --ohne-bau`, es wurde nichts geschrieben. Ohne Änderung:
**BESTANDEN**, 295 Unit-Tests, 18 Schrankenproben, 29 Prüfstandsfälle
(gemessen).

### <a id="k1"></a>K1 — Ein Oberflächentest zählt als grün, wenn nur die Fassungsnummer stimmt

**Gemessen.** In `Intern/pruefstand-buch.tsv` den Bau von E-119d von
`Paket 1.0.122+9402f257` auf `Paket 1.0.122+054b6e66*` gesetzt. Das ist ein
Stand **vor** der Behebung `00c1c3d6`, mit Sternchen, also mit
uncommitteten Änderungen gebaut. Ergebnis: **Gesamturteil BESTANDEN**,
„Prüfstand 29 / 29 / 0, 0 an anderem Bau“, und in der Zeile E-119d steht
`ok` mit genau diesem Bau. Danach byte-genau zurück.

**Am Quelltext belegt.** `pruefbericht.pl:166-167` zieht aus der Baukennung
nur `Eudora (\d+\.\d+\.\d+\.\d+)` und vergleicht mit `Version.h`. Commit und
Sternchen werden gelesen, aber nicht verglichen. Die Fassungsnummer steigt
aber erst beim Schnüren ([Arbeitsweise/nummer-erst-beim-schnueren.md](../Arbeitsweise/nummer-erst-beim-schnueren.md)).
Zwischen zwei Paketen tragen **alle** Bauten dieselbe Nummer. Genau das hat
`pruefstaende-auffrischen.ps1` am 25.10. gemessen: „die sieben Prüfstände
trugen sieben verschiedene Bauten, alle mit derselben Fassung 7.2.0.122“
(`:8-12`). Der Bericht schließt diese Lage nicht aus.

Dazu prüft `paket-bauen.ps1` nicht, ob der Bau in `Bin\<Bauart>`, der ins
Paket kommt, derselbe ist, an dem die Prüfstände liefen. Das Skript kennt
keine Baukennung (am Quelltext belegt: kein Treffer für
`Kennung`/`rev-parse` außer der Link-Schranke `:333`). Wird nach dem
Prüfstandslauf noch einmal gebaut, bescheinigt der Bericht einen Bau, an dem
kein Oberflächentest lief.

**Vorschlag:** Als „dieser Bau“ zählt ein Fall nur, wenn Commit **und**
Sternchen der Baukennung zu `git rev-parse --short HEAD` und sauberem Baum
passen, und `paket-bauen.ps1` vergleicht die Kennung aus `Bin\<Bauart>\Eudora.exe`
mit der im Buch. **Schwere:** wichtig (Prüfstand). Für 7.2.0.123 von Hand
abzugleichen (siehe oben).

### <a id="k2"></a>K2 — Bricht die Testsammlung ab, meldet der Bericht BESTANDEN

**Gemessen.** In `TestMain.cpp` hinter `RunE105Tests();` ein `exit(0);`
eingesetzt, gebaut, gefahren: 240 Tests liefen, 55 nicht.

* `pruefbericht.pl --zeigen --ohne-bau`: **Gesamturteil BESTANDEN**,
  „Unit-Tests 240 / 240 / 0“.
* `pruefbericht.pl --vergleich --ohne-bau`: **NEU ROT 0, weggefallen 55,
  Rückgabe 0.**

Danach `TestMain.cpp` byte-genau zurück (`cmp` gleich), neu gebaut: 295 von
295.

**Am Quelltext belegt.** Drei Lücken derselben Art:

1. `pruefbericht.pl:104-120` liest nur die `[ok]`/`[FEHL]`-Zeilen. Rückgabe
   (`$?`) und die Zeile `Ergebnis: N Tests, …` werden nicht ausgewertet.
   Bei einem echten Absturz käme dasselbe Urteil heraus. Das Schwesterwerkzeug
   `pruefe-tests-gruen.pl` macht es richtig (`:72-95`, keine Ergebniszeile =
   MANGEL, Rückgabe ≠ 0 = MANGEL). Sein Urteil verwirft der Bericht
   ausdrücklich (`pruefbericht.pl:99-101`: „Das Urteil zaehlt hier nicht“).
2. Scheitert dort der **Bau**, läuft danach die **alte**
   `EudoraTests.exe` (`:103-104` prüft nur, ob die Datei da ist). Der Bericht
   schreibt trotzdem „gegen den Quelltext von Commit …“ (`:266`).
3. Schranken: liefert `schranken-gegenprobe.pl` keine Zeile (Absturz,
   Aufruffehler), gibt es 0 Schranken und 0 rote (`:127-133`, Rückgabe
   unbeachtet), und das Urteil (`:229`) verlangt keine Mindestzahl.

`--vergleich` macht aus „weggefallen“ nie Rückgabe 1 (`:218`). Ein Test, der
nicht mehr läuft, gilt dort als unauffällig.

**Vorschlag:** Ergebniszeile und Rückgabe auswerten wie `pruefe-tests-gruen.pl`.
Die Zahl der Unit-Tests und Schranken muss der Ergebniszeile bzw. der Zahl
der Proben in `regression-schranken.txt` entsprechen. „weggefallen“ ist im
Vergleich rot. **Schwere:** wichtig (Prüfstand).

### <a id="k3"></a>K3 — Der Vergleich übersieht eine rote Schrankenprobe neben grünen Geschwistern

**Gemessen.** In `tools/regression-schranken.txt` die Probe [E-35](../Intern/BEFUNDE.md#e-35) R1
harmlos gemacht: ihr Rückfall ändert nichts mehr, die Probe muss also
durchfallen. `schranken-gegenprobe.pl`: Rückgabe 1, die Zeile
`[FEHL] E-35 … rueckfall=0`, die drei anderen E-35-Proben `[ ok ]`.
`pruefbericht.pl --vergleich --ohne-bau`: **NEU ROT 0, unverändert 338,
Rückgabe 0.** Danach byte-genau zurück.

**Am Quelltext belegt.** Der Schlüssel einer Schrankenzeile ist
`Kennung (Schranke)` (`pruefbericht.pl:180`). [E-35](../Intern/BEFUNDE.md#e-35) hat seit heute vier
Proben, [E-62](../Intern/BEFUNDE.md#e-62) zwei. In `%neu` und `%alt` (`:189-190`) überschreibt jede Zeile
die vorige mit gleichem Schlüssel. Aus 18 Proben werden 14 Schlüssel
(gemessen: 240 + 29 + 14 = 283 „unverändert“ in der Probe zu [K2](#k2)).
Weil `@buchzeilen` sortiert ist (`:182`) und `FEHL` vor `ok` steht, gewinnt
**immer** die grüne Zeile, sobald eine Schwester grün ist.

Der normale Bericht (ohne `--vergleich`) sieht die rote Probe: er zählt je
Zeile (`:133`). Auch `pruefe-regressionstest.pl` sieht sie (K12 aus
[PRUEFER-50](PRUEFER-50.md#pruefer-50) zählt „keine rote“, `pruefe-regressionstest.pl:125-138`). Blind
ist nur der Vergleich vorher/nachher, also genau der Weg, den Gregor für
jemanden verlangt hat, der das Repo klont und nach einer Änderung prüft.

**Vorschlag:** Den Schlüssel um eine laufende Nummer der Probe oder den
Rückfalltext erweitern. **Schwere:** wichtig (Prüfstand).

### <a id="k11"></a>K11 — „Wann lief welcher Test“: alle Fälle eines Laufs tragen dieselbe Uhrzeit

**Gemessen:** alle 29 Zeilen in `Intern/pruefstand-buch.tsv` tragen
`2026-10-25 09:37:12`. **Am Quelltext belegt:** `pruefstand-lauf.ps1:331`
nimmt die Zeit einmal am Ende des ganzen Laufs. Ebenso liest `BauKennung`
(`:315-321`) die `Eudora.exe` erst nach dem Lauf. Wird sie während eines
langen Laufs ausgetauscht, steht der neue Bau an alten Ergebnissen. Für
Gregors Frage „welcher Test ist wann mit welchem build gelaufen“ ist die Zeit
also die Zeit des Laufs, nicht des Falls. **Schwere:** gering.

---

## 4. Die verschärften Schranken

Grundstand (gemessen): `schranken-gegenprobe.pl` 18 von 18,
`pruefe-nachrichtenschleife.pl` 8 Schleifen, alle mit Zurückstellen,
`pruefe-fensterbau.pl` 10 GetButton-Aufrufe, 0 ungeprüft,
`pruefe-regressionstest.pl --hinweis` 39 von 68 kritischen gedeckt, 27 ohne
Prüfung, darunter jetzt richtig [E-108](../Intern/BEFUNDE.md#e-108).

### <a id="k4"></a>K4 — Nachrichtenschleife: zwei Schleifen in einer Funktion decken einander

**Gemessen**, beide Rückfälle in `CTridentView::DoFindFirst`
(`TridentView.cpp:1710`), die zwei `PeekMessage`-Schleifen hat:

| Rückfall | Schranke |
|---|---|
| `::PostQuitMessage` aus der **ersten** Schleife entfernt (`:1736`), die Abfrage bleibt | **grün** (Rückgabe 0) |
| in der zweiten Schleife das `return FALSE;` hinter `::PostQuitMessage` entfernt (`:1755`) | **grün** (Rückgabe 0) |

Beide Male danach byte-genau zurück (`cmp` gleich).

**Am Quelltext belegt.** Die Regel sucht je **Funktion** die erste Erwähnung
von `WM_QUIT` und danach irgendein `PostQuitMessage`
(`pruefe-nachrichtenschleife.pl:144-146`). Im ersten Rückfall steht das
`PostQuitMessage` der zweiten Schleife hinter dem `WM_QUIT` der ersten, also
grün. Die erste Schleife verschluckt das Beenden, wie in
[E-62](../Intern/BEFUNDE.md#e-62).

Im zweiten Rückfall bleibt die Schleife nach dem Zurückstellen in Betrieb.
**Vermutung** (Verhalten von `PeekMessage` nach `PostQuitMessage` laut
Windows-Dokumentation, nicht gemessen): die nächste Runde holt `WM_QUIT`
gleich wieder heraus. Die Schleife dreht dann, bis `IsReady()` wahr wird.
Wird es das nie, hängt Eudora beim Beenden, die Klasse aus
[E-51](../Intern/BEFUNDE.md#e-51).

**Vorschlag:** je Fundstelle von `WM_QUIT` prüfen, und zwar im Block der
Abfrage: `PostQuitMessage` **und** ein Verlassen (`return`/`break`) vor der
schließenden Klammer. Die Probe aus Zeile 1 als dritte E-62-Zeile in
`regression-schranken.txt`. **Schwere:** wichtig (Prüfstand).

### <a id="k5"></a>K5 — GetButton-Schranke: Zugriff über `(*p).` unsichtbar, nicht schützende Prüfung zählt

**Gemessen**, beide in `CompMessageFrame.cpp:1728-1736`:

| Rückfall | Schranke |
|---|---|
| NULL-Prüfung entfernt, Zugriff als `(*pSendeKnopf).IsBPWarning()` / `.SetBPWarning(...)` | **grün**, „10 Aufrufe, 0 ohne NULL-Prüfung“ |
| `if (!pSendeKnopf) TRACE("kein Sendeknopf\n");` vor dem ungeschützten Block, der Zugriff bleibt | **grün** |

Beide Male danach byte-genau zurück.

**Am Quelltext belegt.** Als Zugriff zählt nur `name->`
(`pruefe-fensterbau.pl:201`). Wird keiner gefunden, gilt der Aufruf als „nie
benutzt: harmlos“ (`:211`). Als Prüfung zählt jedes `if (` mit dem Namen vor
dem Zugriff (`:202-209`), gleich, ob der Zugriff im geschützten Zweig steht.

**Gegenprobe auf Fehlalarm** (gemessen): `if (p != NULL ? p->X() : false)`
und `if (p == NULL) return;` vor dem Zugriff bleiben richtig grün.

**Vorschlag:** `(*name)` und `name[` als Zugriff zählen. Als Prüfung nur
`if (name)` / `if (name != NULL …)` gelten lassen, deren Block den Zugriff
enthält, oder `if (!name) return/continue/break`. **Schwere:** mittel. Der
erste Rückfall ist eine ungewöhnliche Schreibweise, der zweite braucht eine
Prüfung, die nichts schützt.

### Ohne Fund

* **`schranken-gegenprobe.pl`, nur Rückgabe 1** (am Quelltext belegt,
  `:98`): ein Absturz der Schranke (Perl `die` = 255) oder ein Aufruffehler
  (2) zählt jetzt als FEHL. Stimmt.
* **`pruefe-regressionstest.pl` ohne Kommentare (K4)**: Zeichenketten zählen
  weiter. Gemessen: sechs Kennungen stehen in den Tests nur in Zeichenketten,
  die kein Testname sind ([E-33](../Intern/BEFUNDE.md#e-33), [E-76](../Intern/BEFUNDE.md#e-76), [E-85](../Intern/BEFUNDE.md#e-85), [E-96](../Intern/BEFUNDE.md#e-96), [P-1](../Intern/BEFUNDE.md#p-1), [R-1](../Intern/BEFUNDE.md#r-1)). Bei [E-33](../Intern/BEFUNDE.md#e-33), [E-76](../Intern/BEFUNDE.md#e-76)
  und [E-96](../Intern/BEFUNDE.md#e-96) sind es Prüfmeldungen echter Prüfungen. Bei
  [E-85](../Intern/BEFUNDE.md#e-85) (kritisch) ist es nur die Beschriftung
  `"roher Index (wie IMAP bis E-85)"` eines Gegenbeispiels
  (`TestPopEmpfang.cpp:218`). Gedeckt ist [E-85](../Intern/BEFUNDE.md#e-85) trotzdem, über den Test
  „[NP3-8](../Intern/BEFUNDE.md#np3-8): ImapDownload.cpp rechnet mit der Skala von FindMIMECharset“
  (`TestZeichenWege.cpp:242`). Heute also keine falsche Zahl, aber die
  Deckung hängt am Wortlaut einer Beschriftung.
* **`pruefe-regressionstest.pl`, Schranken nur mit grünem Testbuch (K12)**:
  liest das **eingecheckte** `Releases/pruefbericht-tests.tsv`. Eine Schranke,
  die seit dem letzten Bericht ihren Rückfall nicht mehr abweist, zählt bis
  zum nächsten Bericht weiter. So beschrieben („zuletzt gemessen“), also kein
  Fund, aber kein Tagesstand.

---

## Was gelaufen ist

* `Eudora71/Tests/RunTests.cmd` im Arbeitsbaum `Eudora7.2-wt-pruefer`:
  **295 Tests, 295 bestanden**, Rückgabe 0, vor den Proben und nach der
  Wiederherstellung von `TestMain.cpp` (neu gebaut).
* Rückfallproben, je Probe die Datei mit Perl `:raw` geändert, gefahren,
  zurückgeschrieben und mit `cmp` gegen eine Kopie geprüft:
  `TridentView.cpp` (2), `CompMessageFrame.cpp` (4, davon 2 auf Fehlalarm),
  `paket-bauen.ps1` (1), `TestMain.cpp` (1, mit Bau),
  `Intern/pruefstand-buch.tsv` (1), `tools/regression-schranken.txt` (1).
  `git status` danach leer.
* `pruefbericht.pl` nur mit `--zeigen` bzw. `--vergleich`, also ohne zu
  schreiben.
* `openssl pkcs7 -print_certs` über vier `rootcerts.p7b` und `usercerts.p7b`
  der Grundlage, `sha256sum` über alle Fassungen im Repo.
* Zählprogramm „Kennung nur in Zeichenketten“ über `Eudora71/Tests/*.cpp`.
* Die Hilfsskripte liegen im Scratch-Verzeichnis, nichts davon im Repo.
* Kein Eudora gebaut oder gestartet, kein Fenster,
  `pruefstand-lauf.ps1` nicht gestartet, nichts unter `C:\Temp` angefasst.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| [K1](#k1) | Prüfbericht zählt einen Oberflächentest als grün, wenn nur die Fassungsnummer stimmt; gemessen BESTANDEN mit E-119d an einem Bau vor der Behebung | wichtig (Prüfstand) | nein, aber vor 7.2.0.123 Baukennung der Prüfstände gegen `Bin\Release` von Hand abgleichen |
| [K2](#k2) | Testsammlung bricht nach 240 von 295 ab, Bericht BESTANDEN, Vergleich „nichts neu rot“; gescheiterter Bau fährt die alte EXE | wichtig (Prüfstand) | nein; vor 7.2.1.0 beheben |
| [K3](#k3) | `--vergleich` fasst gleichnamige Schrankenproben zusammen; eine rote E-35-Probe bleibt unsichtbar, Rückgabe 0 | wichtig (Prüfstand) | nein; vor 7.2.1.0 beheben |
| [K4](#k4) | Nachrichtenschleifen-Schranke grün, wenn eine von zwei Schleifen einer Funktion `WM_QUIT` verschluckt oder nach dem Zurückstellen weiterläuft | wichtig (Prüfstand) | nein |
| [K5](#k5) | GetButton-Schranke grün bei `(*p).` und bei einer Prüfung, die nicht schützt | mittel | nein |
| [K6](#k6) | [E-148](../Intern/BEFUNDE.md#e-148): `rootcerts.p7b` im Mailverzeichnis hat Vorrang; README nennt nur das Programmverzeichnis | mittel | nein (README-Satz ergänzen) |
| [K7](#k7) | TestE148 prüft nur den Text von `paket-bauen.ps1`; ein späteres Überschreiben bleibt 295/295; `paket-pruefen.ps1` kennt die Datei nicht | gering | nein |
| [K8](#k8) | [E-119](../Intern/BEFUNDE.md#e-119) K5: scheitert die Kopie, wird wieder geteilt; ein Fehler beim letzten Schreiben gilt als gelungen | gering | nein |
| [K9](#k9) | E-119d prüft nicht, ob gelöscht wurde; nur Weiterleitung gemessen | gering | nein |
| [K11](#k11) | Ergebnisbuch: alle Fälle eines Laufs tragen die Endzeit des Laufs | gering | nein |
| [K10](#k10) | Entwürfe aus 1.0.110–1.0.122 tragen die geteilte Datei weiter (Vermutung) | Hinweis | nein |

**Vergeben: keine. Frei: E-147, E-149.** Eingetragen in `Intern/BEFUNDE.md`
ist nichts.
