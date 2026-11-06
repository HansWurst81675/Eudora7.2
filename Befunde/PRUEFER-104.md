# <a id="pruefer-104"></a>PRUEFER-104

Geprüft habe ich den Stand `af53e155` des Zweigs `e151_pruefstand_klon`. Mein Zweig ist wt/pruefer-20261106b. Geprüft ist alles, was seit `0dfce844` unter `Eudora71/`, `tools/` und `Releases/1.0` dazukam (`git log 0dfce844..HEAD -- Eudora71 tools Releases/1.0`). Der Schwerpunkt liegt auf [E-151](../Intern/BEFUNDE.md#e-151), also auf den sieben Commits `b1db2b13..9bb080b8` und dem Merge `af53e155`: Einrichter, Starter, Vorlagen-Erfasser, Prüfserver-Aufräumer, `pruefstand-lauf.ps1` mit wählbarer Wurzel, die Schranke `pruefe-feste-pfade.pl`, die Vorlagen unter `Testdaten/pruefstand/` und die Pfadschranken der Messskripte. Auf Wunsch des Koordinators habe ich mit Vorrang geprüft, ob die Werkzeuge echte Eudora-Instanzen unter `C:\Temp` treffen können (§4, K2).

Eudora habe ich weder gebaut noch gestartet und kein Fenster geöffnet. Keinen Prüfstand unter `C:\Temp` habe ich angefasst, `pruefstand-lauf.ps1`, Einrichter und Starter habe ich nicht gefahren. Die Testsuite habe ich in meinem Baum gebaut und gefahren. Alle anderen Messungen liefen im Scratchpad der Sitzung: reine Zeichenkettenproben der Pfadschranken und ein Start von `perl.exe` mit einem Hilfsskript, das nur seine Argumente ausgibt. Die lokale Namensliste `tools/anonym-begriffe.lokal` des Hauptbaums habe ich gelesen, um Treffer zu zählen. Ihren Inhalt gebe ich hier nicht wieder.

## Ergebnis vorweg

**Ein Fund hält den PR auf (K1).** `tools/pruefstand-vorlage-erfassen.ps1:55` enthält zwei Familiennamen im Klartext. Sie stehen dort als Suchmuster des Privatfilters. Beide Muster stammen aus der lokalen Ausschlussliste, die laut `.gitignore` *„nie ins öffentliche Repo“* soll (gemessen: Muster 4 und 6 der Liste treffen in `tools/` nur diese eine Datei). Die Abhilfe ist eine Zeile: Die Namen aus `tools/anonym-begriffe.lokal` laden, so wie `pruefe-testdaten-anonym.pl` es schon tut. Ob die Namen auch aus der Geschichte des schon gepushten Zweigs verschwinden sollen, muss Gregor entscheiden.

**Echte Eudora-Instanzen unter `C:\Temp` sind nur auf dem Weg über den Starter geschützt (K2, hoch, neu als [E-243](../Intern/BEFUNDE.md#e-243)).** Die Marke `.eudora72-pruefstand` prüft allein der Einrichter. Der Starter-Weg (`Pruefstand starten.cmd`) fasst deshalb kein fremdes Verzeichnis an. Seine Fälle gelten als übersprungen (belegt). Alle anderen Werkzeuge kennen die Marke nicht: `pruefstand-lauf.ps1` ohne `-OhneBuch` (der Weg der Agenten), `testlauf.ps1`, `pruefstaende-auffrischen.ps1` und rund 40 Messskripte. Ihre Pfadschranke lässt `C:\Temp\Eudora72-<Fassung>-release` durch (gemessen). Dann löscht `messen-e13.ps1 -Vorbereiten` dort In/Out/Trash samt `.toc`. `testlauf.ps1` startet Eudora darin, also mit echtem Konto und Kennwort. Die Rücksetzung der Registry hält jeden Wert unter `C:\Temp\` für einen Prüfstandswert. Heute schützt nur, dass die Fallliste ausschließlich Namen wie `E239` nennt. Abhilfe in §4.

**Das Versprechen „aus jedem Klon“ gilt zweimal nicht ganz.** K3: Liegt der Klon in einem Pfad mit Leerzeichen (etwa `C:\Users\Max Muster\…`), startet kein einziger Prüfserver. Das ist gemessen: `perl` endet mit 2, das Skript wird nicht gefunden. Die Gegenprobe ohne Leerzeichen läuft. K4: Für `E169`, `E169B` und `E239` liegen keine Vorlagen im Repo. Sechs Fälle (`E-169p/r/b/h/s`, `E-239p`), darunter beide Befunde des letzten Release, werden in jedem Klon still übersprungen (gemessen: Fallliste gegen `Testdaten/pruefstand/`).

**Die Vorlagen selbst sind sauber (gemessen).** In 356 Dateien (nicht 400) stehen nur Adressen auf `127.0.0.1` oder `.invalid` und nur Pfade unter `C:\Temp\`. Es gibt keine fremden Laufwerke, UNC-Pfade, URLs oder fremden IP-Adressen. Keines der neun Muster der lokalen Namensliste trifft.

**Die Nacharbeit zu PRÜFER-103 K1/K2 ist angekommen (gemessen).** Die Testsuite meldet an `af53e155` 428 Tests, 428 bestanden. Die Gegenproben G6 und G3 an `mainfrm.cpp` machen `TestE239` jetzt rot (427/428). Vorher blieb er grün. `E-239p` läuft über `hinweis-exit-close`.

Dazu kommen fünf geringe Funde (K5 bis K9). **Neue Kennungen:** [E-243](../Intern/BEFUNDE.md#e-243) für K2, [E-244](../Intern/BEFUNDE.md#e-244) für K3. Beide stehen noch nicht in `Intern/BEFUNDE.md`. Zum Ort von K2 nennt `befund-suchen.pl testlauf.ps1` nur [E-157](../Intern/BEFUNDE.md#e-157) (Registry) und keinen Befund zu fremden Verzeichnissen. Zu `Start-Process` nennt es nur [X-6](../Intern/BEFUNDE.md#x-6)/[X-7](../Intern/BEFUNDE.md#x-7) (Bau). **Den PR hält K1 auf.** K2 hält ihn nicht auf, weil der neue Weg geschützt ist. Vor dem nächsten Prüfstandslauf eines Agenten auf einem Rechner mit eigenen Eudora-Ordnern sollte K2 aber geschlossen sein.

## 1. E-151 am Quelltext

**Einrichter** (`pruefstand-einrichten.ps1`, belegt):
* Die Wurzel wird normalisiert und muss `^C:\\Temp(\\[^\\]+)*$` treffen (:66-67). Gemessen: `C:\Temp\..\Windows` und `C:\Users\Beispiel` werden abgewiesen, `C:\Temp\Mein Ordner` wird angenommen (siehe K3).
* Ein Verzeichnis wird nur gelöscht und neu angelegt, wenn es die Marke `.eudora72-pruefstand` trägt, `-Erneuern` gesetzt ist und dort keine Eudora läuft (:147-160). Ohne Marke bleibt es unberührt, und seine Fälle kommen in die Liste `Eudora72-Pruefstand-nicht-einrichtbar.txt` (:148-152).
* Die heruntergeladene Grundlage wird nur geschrieben, wenn sie fehlt (:107). Eine Prüfsumme prüft der Einrichter nicht (Hinweis T4).
* Mit `-Nur` richtet der Starter trotzdem alle Verzeichnisse ein. Er reicht `-Nur` nicht an den Einrichter weiter (`pruefstand-starten.ps1:128-131`). Das kostet nur Zeit.

**Starter** (`pruefstand-starten.ps1`, belegt): Er fragt jeden Anwender mit `j/n` (:115-121). `-Ja` beantwortet die Frage ohne Tastatur (K9). Selbst schreibt er nichts in die Registry. Das tun Eudora und die Rücksetzung in `pruefstand-sperre.ps1` innerhalb des Laufs. Gregors Verzeichnisse unter `C:\Users\…` erreicht er nicht, weil Einrichter und Lauf die Wurzel auf `C:\Temp` beschränken (:67 bzw. `pruefstand-lauf.ps1:63`). Echte Instanzen **unter** `C:\Temp` behandelt §4.

**Lauf** (`pruefstand-lauf.ps1`, belegt): `$PsWurzel` wird vor `$wurzel = Split-Path …` (:67) berechnet. Die Verwechslung aus `9fb89e33` ist damit behoben, und keine spätere Zeile benutzt `$Wurzel` noch im Sinn der Prüfstandswurzel. Die Liste der nicht einrichtbaren Fälle wirkt nur mit `-OhneBuch` (:137). Ein Rest dieser Liste dünnt also die Läufe der Agenten nicht aus. Port- und Server-Aufräumen geschehen nach `Sperre-Nehmen`, innerhalb von `try` (:236-243), und noch einmal in `finally` (:448).

**Andere Wurzel als `C:\Temp`:** Erlaubt ist nur `C:\Temp\…`. Die Sperrdatei und der gesicherte Registry-Stand liegen fest in `C:\Temp` (`pruefstand-sperre.ps1:53-54`). Das ist richtig, denn die Sperre gilt rechnerweit. Rot werden `E-133p/q` (die Muss-Zeilen nennen `C:\Temp\E133`, `pruefstand-faelle.txt:591-592`) und `E-216l`. So steht es auch in `Doku/PRUEFSTAND.md:184`. Weitere feste `C:\Temp`-Pfade gibt es im Code der Skripte im Umfang nicht (gemessen mit eigenem Muster über 59 Messskripte und die Kernwerkzeuge, nur Code-Zeilen). In den Vorlagen stehen feste Pfade nur in Dateien, deren Pfad Eudora nicht liest oder die `-Vorbereiten` neu schreibt:
* 46 `.inf`-Dateien tragen `C:\Temp\<Name>\…`, in `E146` sogar Pfade nach `E77` und `E118`. `CImapMailbox::ReadImapInfo` liest dieses Feld und verwirft es (`EuImap/src/ImapMailbox.cpp:470-473`, `// m_Dirname = buf;`). Belegt, unschädlich.
* `E177/Filters.pce:3` ruft `C:\Temp\E177\e177-kopieren.vbs` auf. `messen-e177.ps1 -Vorbereiten` schreibt `Filters.pce` mit `$vbs` aus dem eigenen Verzeichnis neu (:55, :98-103). Belegt.
* `E207/Eudora.ini:345` nennt eine zuletzt geöffnete Datei. Das ist harmlos.

**Prüfserver-Aufräumer** (`pruefserver-aufraeumen.ps1`, belegt): Er beendet nur `perl.exe`, deren Befehlszeile `<repo>\tools\anhang-pruefdaten.pl`, `imap-pruefserver.pl` oder `smtp-pruefserver.pl` enthält (:41-55). Die Messskripte starten genau so (`"$repo\tools\…pl"`, `$repo = Split-Path -Parent $PSScriptRoot`). Server anderer Arbeitsbäume trifft er nicht, denn `…\Eudora7.2\tools\` steckt nicht in `…\Eudora7.2\.wt\x\tools\`. **Im schlimmsten Fall** beendet er einen Prüfserver desselben Repos, den gerade jemand anderes braucht: ein laufender Prüfstand oder ein von Hand gestartetes Messskript. Innerhalb des Laufs schützt davor die Sperre. Im Starter läuft der Aufräumer aber vor der Frage und ohne Sperre (K5). Erreicht ein Pfad die Befehlszeile in anderer Schreibweise (8.3-Kurzname, `subst`), findet er nichts. Das ist harmlos, er bleibt dann nur blind (Vermutung).

**Vorlagen-Erfasser** (`pruefstand-vorlage-erfassen.ps1`, belegt): Er entfernt Fensterpfade und Ablageverzeichnisse aus der INI (:52) und lässt `E222\e222-quelle.ems` und `E193f\privat\` aus. Er prüft jede erfasste Datei, aber erst **nach** dem Schreiben ins Repo (:94-100). Bei einem Treffer bleibt die Datei im Arbeitsbaum liegen. Das Muster sucht nur `.de/.com/.net/.org` und ist zugleich Fund K1.

**Schranke** `pruefe-feste-pfade.pl`: Gemessen meldet sie 75 Skripte sauber, Selbsttest 4/4. Sie sieht nur `C:\Users\` und die alte Schranke in einfachen Anführungszeichen (:54, :59). Feste `C:\Temp\<Name>`-Pfade, `StartsWith('C:\Temp')` oder `-like` sieht sie nicht. Heute fehlt nichts davon (gemessen, siehe oben). Die Grenze gehört aber in den Kopf des Werkzeugs (Hinweis T3).

## 2. Vorlagen auf persönliche Daten (gemessen)

`git ls-files Testdaten/pruefstand` ergibt 356 Dateien in 46 Verzeichnissen. Der Auftrag nannte „400“. Geprüft habe ich mit eigenen Mustern im Scratchpad:
* **Adressen:** alle auf `@127.0.0.1` oder `@….invalid`.
* **Pfade:** nur `C:\Temp\…` (46 `.inf`, 1 `.pce`, 1 `.ini`) und `C:\Windows\System32\wscript.exe`. Es gibt kein anderes Laufwerk, kein `\\server`, kein `Users`, `Documents` oder `AppData` und keine URL.
* **IP-Adressen:** nur `127.0.0.1`.
* **Kennwörter:** `SavePasswordText` ist `eA==` (`x`) und einmal das Prüfkennwort von [E-223](../Intern/BEFUNDE.md#e-223).
* **Namen:** `RealName` heißt nur „Pruefstand …“ oder „E125 Pruefstand“. Die neun Muster der lokalen Liste treffen 0 von 356 Dateien.
* **Grenze:** `pruefe-testdaten-anonym.pl` liest nur die Dateien direkt unter `Testdaten/` (:240-247). Die 356 Vorlagen liegen außerhalb seiner Schranke (K8).

## 3. Testsuite und Gegenproben (gemessen)

Ich habe `RunTests.cmd` in meinem Baum gebaut und gefahren. Die Gegenproben liefen so: `mainfrm.cpp` vorübergehend per Perl (`:raw`, genau 1 Treffer) geändert, `EudoraTests.exe` gefahren, die Datei aus der Sicherung zurückgeschrieben und den Hash mit der Sicherung verglichen. Am Ende war `git status` leer.

| Probe | Änderung | Ergebnis |
|---|---|---|
| ohne | `af53e155` | 428 Tests, 428 bestanden |
| G6 | `return;` hinter *„weiteres Schliessen ignoriert“* gestrichen | **427 bestanden, 1 rot** ([E-239](../Intern/BEFUNDE.md#e-239)) |
| G3 | `return;` des Aufschubs gestrichen | **427 bestanden, 1 rot** ([E-239](../Intern/BEFUNDE.md#e-239)) |

Damit ist [PRUEFER-103](PRUEFER-103.md#pruefer-103) K1 an diesem Stand geschlossen. Dort blieben G3 und G6 grün. Nach jeder Probe war die Datei byte-gleich zur Sicherung.

## 4. Echte Eudora-Instanzen unter `C:\Temp` (Vorrang)

Unter `C:\Temp` können Eudora-Instanzen mit echten Mails liegen (etwa ein entpacktes Release `C:\Temp\Eudora72-<Fassung>-release`).

**(1) Was wird unter der Wurzel angelegt, überschrieben, geleert oder gelöscht?** (belegt)

| Werkzeug | Was | Stelle |
|---|---|---|
| Einrichter | legt `<Wurzel>\<Fallname>` an. **Löscht** es ganz (`Remove-Item -Recurse`), aber nur mit Marke und `-Erneuern` | `pruefstand-einrichten.ps1:147-160` |
| Einrichter | schreibt `<Wurzel>\Eudora72-Pruefstand-nicht-einrichtbar.txt` (überschreibt) und lädt `<Wurzel>\Eudora72-*-release.zip`, nur wenn es fehlt | :196, :106-108 |
| Starter/Lauf | `<Wurzel>\pruefstand-ergebnis.txt` (überschreibt) | `pruefstand-starten.ps1:136`, `pruefstand-lauf.ps1:473` |
| Sperre | `C:\Temp\Eudora72-Pruefstand.lock`, `…reg.xml` | `pruefstand-sperre.ps1:53-54` |
| Auffrischer | **überschreibt** `Eudora.exe`, die DLLs und `rootcerts.p7b` in jedem Fallverzeichnis, ohne Marke | `pruefstaende-auffrischen.ps1:56-60` |
| Messskripte `-Vorbereiten` | **löschen/überschreiben** Postfächer und Hilfsdateien im Fallverzeichnis, zum Beispiel: In/Out/Trash `.mbx/.toc`, `lmos.dat*`, `spool\`, `Embedded\` (`messen-e13.ps1:57-62`); `In.mbx` neu geschrieben (15 Skripte, etwa `messen-e125.ps1:62`, `messen-e97.ps1:60`); `In.mbx`/`In.toc` gelöscht (`messen-e239.ps1:127`); IMAP-Ordner bis auf eine Liste gelöscht (`messen-e122.ps1:81-92`, `messen-e141.ps1:69-80`, `messen-e184.ps1:114-118`); `Filters.pce` und `Eudora.ini` umgeschrieben (`messen-e177.ps1:103`, `messen-e166-konto.ps1:48`) | 127 Lösch- und Beendestellen in 59 Skripten (gezählt) |
| Lauf, Fall `ohne-argument` | **liest** das neueste `eudora.log` bis Tiefe 2 unter der Wurzel, auch aus einem fremden Verzeichnis | `pruefstand-lauf.ps1:344-351` |
| Registry-Rücksetzung | setzt jeden Wert zurück, der auf `X:\Temp\` zeigt, und löscht neue Unterschlüssel unter `…\Eudora\C:\Temp\` | `pruefstand-sperre.ps1:151-153`, :247-251 |

**(2) Kann ein vorhandenes, nicht vom Einrichter angelegtes Verzeichnis getroffen werden?**
* **Über den Starter: nein** (belegt). Der Einrichter lässt es liegen und führt seine Fälle als nicht einrichtbar (`pruefstand-einrichten.ps1:148-152`). Der Lauf mit `-OhneBuch` überspringt sie (`pruefstand-lauf.ps1:137-151`). Eine Instanz mit einem Namen, der nicht in der Fallliste steht (`Eudora72-*`), kommt in keiner Liste vor.
* **Über `pruefstand-lauf.ps1` ohne `-OhneBuch`, also den Weg der Agenten: ja**, sobald ein Verzeichnis wie ein Fall heißt (`C:\Temp\E239` usw.). Es gibt keine Prüfung auf die Marke (`grep eudora72-pruefstand tools/`: nur der Einrichter). Hätte Gregor eine echte Instanz nach `C:\Temp\E239` kopiert, löschte `messen-e239.ps1:127` dort `In.mbx` und `In.toc`.
* **Über einen direkten Aufruf: ja**, mit jedem Namen. Die Schranke `-notmatch ('^' + [regex]::Escape(<Wurzel>) + '\\[^\\]+')` lässt `C:\Temp\Eudora72-<Fassung>-release` durch. Gemessen am Ausdruck aus `messen-e13.ps1:54`, ebenso `testlauf.ps1:137` (`StartsWith('C:\Temp')` → `True`). Nur fünf Skripte binden ihre Schranke an den Fallnamen (`E133`, `E204`, `E222`, `E223`, `E239`). `testlauf.ps1 -Verzeichnis C:\Temp\Eudora72-…` startete Eudora mit dem echten Mailverzeichnis. Hat das Konto „Check mail every …“ an, holt es Post vom echten Server (Vermutung über den Ablauf, belegt ist nur, dass die Schranke durchlässt).
* **Prozesse:** Der Einrichter, der Auffrischer und `testlauf.ps1` schießen Eudora nur ab, wenn sie aus dem eigenen Verzeichnis läuft (`testlauf.ps1:416-418`, Pfad aus `MainModule`). Eine echte Instanz, die Gregor gerade benutzt, wird also nicht beendet (belegt).
* **Registry:** `Ist-Pruefstandswert` gilt für **jeden** Pfad unter `X:\Temp\` (`pruefstand-sperre.ps1:151-153`). Startet Gregor während eines Laufs seine Instanz unter `C:\Temp` zum ersten Mal oder macht er sie zur Vorgabe, setzt `Registry-Zurueck` danach `CommandLine\Current` auf den alten Wert zurück und löscht ihren neuen Unterschlüssel (Vermutung über den Ablauf, belegt an den Zeilen). Mails gehen dabei nicht verloren, wohl aber die Zuordnung für Doppelklick und `mailto:`. Das gehört zu [E-157](../Intern/BEFUNDE.md#e-157).
* **Lesen:** Im Fall `ohne-argument` (`E-133p/q`) kann der Lauf das Protokoll einer gleichzeitig laufenden echten Instanz als Messung nehmen (`pruefstand-lauf.ps1:345-350`). Dann wird der Fall falsch beurteilt, beschädigt wird nichts.

**(3) Gibt es eine Marke?** Es gibt `.eudora72-pruefstand`, geschrieben vom Einrichter (:182). Geprüft wird sie nur von ihm selbst. Lauf, `testlauf.ps1`, Auffrischer und Messskripte prüfen sie nicht. Die gewachsenen Prüfstände der Entwicklermaschine haben die Marke auch nicht. Würde man sie heute verlangen, liefe dort kein Fall mehr.

**Abhilfe (Vorschlag, nicht umgesetzt):**
1. **Marke oder Ausweis an einer Stelle prüfen:** in `testlauf.ps1` nach der Pfadprüfung (:134-145). Abweisen, wenn das Verzeichnis weder `.eudora72-pruefstand` trägt noch in der Fallliste steht. Damit sind alle Messskripte gedeckt, denn sie laufen unter `testlauf.ps1`. Für die gewachsenen Prüfstände einmal die Marke setzen (ein Werkzeug, Liste aus `pruefstand-faelle.txt`).
2. **Fremdes Mailverzeichnis abweisen:** In jeder `Eudora.ini` einer Vorlage stehen nur Server `127.0.0.1` oder `localhost` (gemessen, §2). `testlauf.ps1` sollte abweisen, wenn `PopServer`, `SMTPServer` oder ein IMAP-Server dort etwas anderes nennt. Das fängt auch die Instanz, die jemand nach `C:\Temp\E239` kopiert hat.
3. **Vorgabe-Wurzel als eigener Unterordner**, etwa `C:\Temp\Eudora72-Pruefstand\`. Dann ist `Ist-Pruefstandswert` auf diesen Ordner zu verengen. Messbar rot werden dabei `E-133p/q` und `E-216l` (Doku :184). Ihre Muss-Zeilen müssten die Wurzel einsetzen. Das ist der größere Schritt. 1 und 2 schließen den Datenverlust schon allein.
4. Die Schranken der Messskripte mit `$` abschließen und `EUDORA72_PRUEFSTAND` selbst auf `^C:\\Temp(\\[^\\]+)*$` prüfen (K7).

## Funde

### <a id="k1"></a>K1 (hoch, gemessen): Zwei Familiennamen im öffentlichen Code

`tools/pruefstand-vorlage-erfassen.ps1:55` (`$privat = …`) nennt neben „gregor“ zwei Familiennamen als Suchmuster. Gemessen: Von den neun Mustern in `tools/anonym-begriffe.lokal` treffen Muster 4 und 6 in `tools/` nur diese Datei. Im ganzen Repo stehen die beiden Wörter nur hier (`git grep -i`), eingeführt mit einem inzwischen umgeschriebenen Commit vom 05.11.2026. Der Zweig ist gepusht. Gregors Regel vom 29.10.2026 steht in `pruefe-testdaten-anonym.pl:45-50`: Echte Namen kommen nur aus der lokalen, ignorierten Liste. **Vorschlag:** Die Muster aus `tools/anonym-begriffe.lokal` laden (dasselbe Format wie `pruefe-testdaten-anonym.pl:81-90`). Fehlt die Datei, bricht der Erfasser ab. Erst prüfen, dann schreiben (:94-100). Ob die Namen auch aus der Geschichte des Zweigs entfernt werden, entscheidet Gregor.

### <a id="k2"></a>K2 (hoch, belegt; Schranke gemessen): Prüfwerkzeuge können echte Instanzen unter `C:\Temp` treffen (neu: E-243)

Siehe §4. Nur der Starter-Weg ist durch die Marke geschützt. Der Agentenweg und direkte Aufrufe schützen nur über die Namen der Fallliste. Die Pfadschranke der Messskripte und `testlauf.ps1` lassen jedes `C:\Temp\<x>` durch. Die Folge im schlimmsten Fall: Postfächer einer echten Instanz werden gelöscht oder überschrieben (`messen-e13.ps1:57-62`, `messen-e239.ps1:127`), oder Eudora wird darin gestartet. Diese Lage bestand schon vor [E-151](../Intern/BEFUNDE.md#e-151). [E-151](../Intern/BEFUNDE.md#e-151) hat sie nicht erweitert, aber erst jetzt ist bekannt, dass unter `C:\Temp` echte Daten liegen. **Vorschlag:** Abhilfe 1 und 2 aus §4 vor dem nächsten Prüfstandslauf.

### <a id="k3"></a>K3 (mittel, gemessen): Mit einem Leerzeichen im Repo-Pfad startet kein Prüfserver (neu: E-244)

21 Skripte starten die Prüfserver mit `Start-Process $perl -ArgumentList @("$repo\tools\….pl", …)`. Windows PowerShell 5.1 fügt die Elemente ohne Anführungszeichen zusammen. Gemessen im Scratchpad mit demselben Aufrufmuster: Mit dem Ordner `mit leer` endet `perl` mit **2**, ohne dass das Skript läuft. Mit `ohneleer` endet es mit 0 und meldet die richtigen Argumente. Ein Klon unter einem Benutzernamen mit Leerzeichen bekommt also alle POP-, IMAP- und SMTP-Fälle rot, ohne dass am Programm etwas kaputt ist. Dasselbe gilt für eine Wurzel wie `C:\Temp\Mein Ordner`. Sie wird angenommen (gemessen), danach brechen `--eml`, `--protokoll` und `--ablage` auseinander. `Doku/PRUEFSTAND.md` erwähnt Leerzeichen nicht. **Vorschlag:** sofort in die Voraussetzungen schreiben und in Starter und Einrichter abweisen (`$repo` oder Wurzel mit Leerzeichen). Später die Argumente einzeln in Anführungszeichen setzen.

### <a id="k4"></a>K4 (mittel, gemessen): Sechs Fälle haben im Klon keine Vorlage

Die Fallliste nennt 49 Verzeichnisse, `Testdaten/pruefstand/` hat 46. Es fehlen `E169`, `E169B` und `E239`. Sie kamen mit dem Merge von 7.2.2.136. Der Einrichter meldet sie als *„KEINE VORLAGE“* (:143-145), der Starter zählt sie als übersprungen. Betroffen sind `E-169p`, `E-169r`, `E-169b`, `E-169h`, `E-169s` und `E-239p`, also beide Behebungen des letzten Release. Eine Schranke „jedes Fallverzeichnis hat eine Vorlage“ gibt es nicht. Die Zahl der Klonprobe (95/102) stammt von vor dem Merge. **Vorschlag:** `pruefstand-vorlage-erfassen.ps1` erneut fahren (nach K1) und den Vergleich Fallliste ↔ Vorlagen als Schranke in `pruefe-feste-pfade.pl` aufnehmen.

### <a id="k5"></a>K5 (gering, belegt): Der Starter räumt auf, bevor er fragt, und ohne Sperre

`pruefstand-starten.ps1:80` ruft `Pruefserver-Aufraeumen` vor der Frage (:115-121) und vor jeder Sperre. Wer den Starter öffnet, während ein Prüfstand desselben Repos läuft, beendet dessen Prüfserver. Der laufende Fall wird dann rot. Das gilt auch, wenn er danach mit `n` antwortet. Die Meldung *„Abgebrochen – nichts gestartet“* stimmt dann nicht ganz. **Vorschlag:** Das Aufräumen nach der Frage machen und nur, wenn die Sperre frei ist (`Sperre-Halter`). Sonst *„es läuft schon ein Prüfstand“* melden.

### <a id="k6"></a>K6 (gering, belegt): Der Starter deutet den Abbruch des Laufs als „2 Fälle fehlgeschlagen“

`pruefstand-lauf.ps1` endet bei jedem Abbruch mit `exit 2` (:63, :71-127, :152, :229, :242): Sperre nicht bekommen, Ports belegt, alle Fälle übersprungen. Bei einer unbehandelten Ausnahme endet es mit 1. Der Starter liest 1 bis 199 als Zahl roter Fälle (`pruefstand-starten.ps1:149`) und meldet *„2 Fall/Faelle fehlgeschlagen – Liste oben ([FEHL])“*, obwohl es keine solche Liste gibt. **Vorschlag:** Für Abbrüche einen eigenen Code ab 200 nehmen oder das Ergebnis aus `-ErgebnisDatei` lesen.

### <a id="k7"></a>K7 (gering, gemessen): Die Pfadschranke vertraut der Umgebungsvariable ungeprüft

Die rund 40 Schranken und `testlauf.ps1:78` übernehmen `EUDORA72_PRUEFSTAND`, ohne sie zu prüfen. Gemessen: Mit `EUDORA72_PRUEFSTAND=C:\Users\Beispiel` lässt die Schranke `C:\Users\Beispiel\Eudora72-x` durch. Vor [E-151](../Intern/BEFUNDE.md#e-151) hieß sie fest `C:\Temp`. Lauf und Einrichter prüfen die Variable, bevor sie sie setzen (:63, :67). Gefährlich ist sie also nur, wenn jemand ein Messskript oder `testlauf.ps1` direkt aufruft, während eine fremd gesetzte Variable in der Umgebung steht. 33 der Schranken haben außerdem kein `$` am Ende. Das ist unschädlich, weil der Pfad vorher normalisiert wird. **Vorschlag:** eine gemeinsame Funktion `Pruefstand-Wurzel`, die `^C:\\Temp(\\[^\\]+)*$` verlangt, mit derselben Schranke wie §4 Abhilfe 1.

### <a id="k8"></a>K8 (gering, belegt): Die Anonym-Schranke sieht die Vorlagen nicht

`pruefe-testdaten-anonym.pl` liest nur die Dateien direkt unter `Testdaten/` (:240-247). Die 356 Vorlagen prüft allein der Erfasser, mit einem eigenen, schwächeren Muster (K1, nur vier Endungen) und erst nach dem Schreiben. Heute sind die Vorlagen sauber (§2). **Vorschlag:** `Testdaten/pruefstand/**` in die Schranke aufnehmen. Adressen auf `@127.0.0.1` sind dort ausdrücklich zu erlauben.

### <a id="k9"></a>K9 (gering, belegt): `-Ja` ist eine Freigabe ohne Mensch

Mit `-Ja` schreibt der Starter *„Anwender <Windows-Konto> am <Datum> per Pruefstand starten: 'j' (-Ja)“* als Freigabe (:122-123). Auf der Entwicklermaschine ist das Gregors Kontoname. Ein Agent, der `pruefstand-starten.ps1 -Ja` ruft, bekommt also eine Freigabe, die nach Gregor klingt. Der Haken `haken-eudora-start.pl` lässt diesen Weg zu. Das Kennzeichen `(-Ja)` steht im Protokoll. **Vorschlag:** `-Ja` abweisen, wenn `CLAUDE_PROJECT_DIR` oder eine Agentenvariable gesetzt ist, oder den Text in *„ohne Rückfrage (-Ja)“* ändern.

## Hinweise (keine Funde)

* **T1:** [PRUEFER-103](PRUEFER-103.md#pruefer-103) K1 ist geschlossen (§3). K2 ist geschlossen: Der Fall `E-239p` läuft über `messen-e239-exit-close.ps1` mit `hinweis-exit-close` und verlangt `E239 URTEIL gruen`.
* **T2:** Die `.inf`-Pfade der IMAP-Vorlagen sind unschädlich (`ImapMailbox.cpp:470-473`).
* **T3:** Die Grenzen von `pruefe-feste-pfade.pl` (§1) gehören in seinen Kopf.
* **T4:** Die Grundlage von GitHub wird ohne Prüfsumme ausgepackt und ihre `Eudora.exe` später gestartet. Die Übertragung läuft über TLS, für einen Fork ist das vertretbar.
* **T5:** Perl wird fest unter `C:\Program Files\Git\usr\bin\perl.exe` erwartet (`pruefstand-starten.ps1:69`). Eine Git-Installation nur für den Benutzer (`%LOCALAPPDATA%\Programs\Git`) wird abgewiesen. Die Doku nennt den Pfad.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| [K1](#k1) | Zwei Familiennamen aus der lokalen Namensliste stehen als Muster in `pruefstand-vorlage-erfassen.ps1:55`, öffentlich gepusht | hoch | **ja**: vor dem Merge aus der lokalen Liste laden; Geschichte entscheidet Gregor |
| [K2](#k2) ([E-243](../Intern/BEFUNDE.md#e-243)) | Echte Instanzen unter `C:\Temp`: Marke nur im Einrichter; Agentenlauf, `testlauf.ps1`, Auffrischer und Messskripte lassen jedes `C:\Temp\<x>` durch und löschen dort Postfächer; Registry-Rücksetzung hält jedes `C:\Temp` für Prüfstand | hoch | nein für den PR (Starter-Weg geschützt); ja vor dem nächsten Prüfstandslauf eines Agenten auf einem Rechner mit eigenen Eudora-Ordnern |
| [K3](#k3) ([E-244](../Intern/BEFUNDE.md#e-244)) | Leerzeichen im Repo- oder Wurzelpfad: kein Prüfserver startet, alle Abruffälle rot | mittel | nein, wenn die Voraussetzung in `PRUEFSTAND.md` steht und der Starter abweist |
| [K4](#k4) | Keine Vorlagen für `E169`, `E169B`, `E239`: 6 Fälle ([E-169](../Intern/BEFUNDE.md#e-169), [E-239](../Intern/BEFUNDE.md#e-239)) im Klon still übersprungen | mittel | nein; Vorlagen erfassen (nach K1), Schranke Fallliste ↔ Vorlagen |
| [K5](#k5) | Starter beendet Prüfserver vor der Frage und ohne Sperre | gering | nein |
| [K6](#k6) | Abbruch des Laufs (`exit 2`) wird als „2 Fälle fehlgeschlagen“ gemeldet | gering | nein |
| [K7](#k7) | `EUDORA72_PRUEFSTAND` ungeprüft in rund 40 Schranken und `testlauf.ps1` | gering | nein |
| [K8](#k8) | `pruefe-testdaten-anonym.pl` sieht `Testdaten/pruefstand/` nicht | gering | nein |
| [K9](#k9) | `-Ja` erzeugt eine Freigabe mit Gregors Kontonamen ohne Menschen | gering | nein |
