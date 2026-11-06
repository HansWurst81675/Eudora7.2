# <a id="pruefer-105"></a>PRUEFER-105

Geprüft habe ich den Stand `be3d8b93` des Zweigs `e151_pruefstand_klon`. Mein Zweig ist wt/pruefer-20261106c. Geprüft ist alles, was seit `fdf6ce45` (Abgabe von [PRUEFER-104](PRUEFER-104.md#pruefer-104)) unter `Eudora71/`, `tools/` und `Releases/1.0` dazukam, dazu `.claude/settings.json` und die neuen Vorlagen. Das ist eine kurze Runde vor dem PR `e151_pruefstand_klon` → `main`. Schwerpunkte: das Umschreiben der Geschichte, die Namensschranke `pruefe-namen-gestaget.pl`, der Haken `haken-backslash.pl`, die Marke `.eudora72-pruefstand` in allen Werkzeugen, die neue Vorgabe-Wurzel `C:\Temp\Eudora72-Pruefstand` samt freier `-Wurzel`, `E-133r`, die Umrechnung der Muss-Texte, die Vorlagen `E169`/`E169B`/`E239` und der Bildserver im Aufräumer.

Eudora habe ich weder gebaut noch gestartet und kein Fenster geöffnet. Keinen Prüfstand unter `C:\Temp` habe ich angefasst, keine Registry geändert (nur `reg query` gelesen). Alle Proben liefen im Scratchpad oder in einem Wegwerf-Ordner meines Baums, der danach wieder gelöscht war: reine Zeichenkettenproben, ein Wegwerf-Repo mit einem erfundenen Namensmuster und `perl.exe` mit einem Hilfsskript, das nur seine Argumente ausgibt. Die lokale Namensliste habe ich gelesen, um Treffer zu zählen. Ihren Inhalt gebe ich nicht wieder. Die Testsuite habe ich nicht gefahren: Seit `fdf6ce45` hat sich unter `Eudora71/` nichts geändert (gemessen, `git diff --stat` leer).

## Ergebnis vorweg

**Die Geschichte ist sauber (gemessen).** In allen Commits zwischen `main` und dem Zweig trifft keines der acht Namensmuster, weder in Zeilen noch in Commit-Nachrichten noch in Dateinamen. Dasselbe gilt für alle fünf Serverzweige jenseits von `main`. Die Gegenprobe am alten Commit vom 05.11.2026 trifft zweimal. Der umgeschriebene Merge unterscheidet sich vom alten Stand `af53e155` in genau einer Zeile, der des Privatfilters.

**Ein Fund hält den PR auf (K1, klein).** Der neue Fall `E-133r` ist blind. Er prüft, ob der Registry-Eintrag nach dem Lauf auf die `Eudora.exe` dieses Prüfstands zeigt. Genau so steht der Eintrag aber schon vorher da, denn `-Vorbereiten` schreibt ihn selbst so hinein. Gemessen: Mit dem vorbereiteten, nie berichtigten Wert meldet die Auswertung `zeigt-hierher=1`. Bis gestern prüfte `E-133p` den berichtigten Teil (`…\MAILVE~1`) mit. Diese Prüfung ist mit dem PR weggefallen. Die Abhilfe sind zwei Zeilen: das **zweite** Stück des Werts auflösen und mit `<Prüfstand>\Mailverzeichnis` vergleichen.

**Eine Wurzel mit Leerzeichen schickt Eudora in ein falsches Mailverzeichnis (K2, mittel).** Die Doku verspricht *„jeder Ordner außer einem Laufwerksstamm“*. `testlauf.ps1:364` übergibt das Mailverzeichnis aber ohne Anführungszeichen. Gemessen: Aus `…\Mein Ordner\E133\Mailverzeichnis` werden zwei Argumente. Eudora trennt an der ersten Leerstelle (`fileutil.cpp:480`, belegt). Das Mailverzeichnis wäre dann `…\Mein`, also ein Ordner **ohne** Marke. Dasselbe gilt für die Protokoll- und Ablagepfade von sechs Prüfservern. Abhilfe: eine Zeile in jeder der zwei Wurzelschranken, die Leerraum abweist, und ein Halbsatz in der Doku. Den PR hält das nicht auf, weil die Vorgabe-Wurzel kein Leerzeichen hat.

**Die Marke lässt sich an einer Stelle umgehen (K3, mittel).** Ruft man ein Messskript direkt auf, etwa `messen-e13.ps1 -Vorbereiten`, prüft niemand die Marke. Gezählt: 62 Messskripte haben `-Vorbereiten`, keines prüft die Marke, 39 fallen ohne Umgebungsvariable noch auf `C:\Temp` zurück. Über `pruefstand-lauf.ps1` und `testlauf.ps1` ist die Marke dicht (belegt: beide prüfen vor jedem Löschen und Start).

**Der alte Commit mit den Namen ist auf GitHub noch abrufbar (K4, mittel, neu als [E-246](../Intern/BEFUNDE.md#e-246)).** Gemessen mit `gh api …/commits/<Kennung>`: Er kommt zurück, obwohl kein Zweig ihn mehr enthält. Seine Kennung steht an fünf Stellen im Baum und in drei Commit-Nachrichten, also gleich mit Wegweiser. Ganz entfernen kann ihn nur eine Anfrage beim GitHub-Support. Ob das gewollt ist, entscheidet Gregor. Den PR hält das nicht auf, denn der PR bringt den Commit nicht zurück.

**Die neue Namensschranke sieht drei Wege nicht (K5, mittel, neu als [E-245](../Intern/BEFUNDE.md#e-245)).** Gemessen in einem Wegwerf-Repo mit einem erfundenen Muster: Ein Name im **Dateinamen**, in der **Commit-Nachricht** oder in einer **Binärdatei** geht durch. Ein Name im Inhalt wird abgewiesen.

Dazu kommen vier geringe Funde (K6 bis K9). **Neue Kennungen:** [E-245](../Intern/BEFUNDE.md#e-245) für K5, [E-246](../Intern/BEFUNDE.md#e-246) für K4. Beide stehen noch nicht in `Intern/BEFUNDE.md`. Für K1 empfehle ich [E-151](../Intern/BEFUNDE.md#e-151) fortzuschreiben, für K2 [E-244](../Intern/BEFUNDE.md#e-244) und für K3 [E-243](../Intern/BEFUNDE.md#e-243). `befund-suchen.pl pruefe-namen-gestaget` meldet keinen Befund zu diesem Ort.

## 1. Geschichte und Namensschranke

**Umschreiben (gemessen).** Ich habe `git log -p -m -U0` über `origin/main..origin/e151_pruefstand_klon` mit Nachrichten gelesen (48 803 Zeilen) und mit einem eigenen Zähler im Scratchpad durchsucht. Der Zähler gibt nur die Nummer des Musters aus, nie den Treffer. Ergebnis: 0 Treffer in hinzugefügten und entfernten Zeilen, in Dateinamen und in Nachrichten. Über `--remotes --tags --not origin/main` (fünf Serverzweige) ebenfalls 0. Positivprobe: Der alte Commit vom 05.11.2026 trifft mit zwei Mustern. `git branch -r --contains` und `git branch --contains` nennen für ihn keinen Zweig, auch kein Stash enthält ihn. `git diff af53e155 49914ab7` zeigt eine Datei mit einer Zeile, nämlich den Privatfilter.

**`pruefe-namen-gestaget.pl` (belegt und gemessen).**
* Selbsttest 10/10. `--seit-main` an `be3d8b93`: frei, 8 Muster. `--commit <alter Commit>`: rot, Rückgabe 1. Die Schranke funktioniert also für Inhalte.
* Die Liste findet sie auch aus einem verschachtelten Arbeitsbaum (`.wt/e151/.wt/pruefer`) über `--git-common-dir` (:222-223, gemessen).
* Sie liest nur die Zeilen nach `+` (:249-252). Kopfzeilen `+++ b/<Pfad>` verbraucht sie als Dateinamen, die Nachricht unterdrückt sie mit `--format=tformat:COMMIT` (:293-294). Binärdateien liefert `git diff` gar nicht als Zeilen. Daraus folgt K5.
* Im `pre-push` prüft sie `origin/main..HEAD` (`hooks-einrichten.sh:676`), nicht die Referenzen, die tatsächlich gepusht werden. Ein `git push origin <anderer Zweig>` aus einem Baum, der auf einem dritten Zweig steht, prüft den falschen Bereich (belegt, gering). Merge-Commits zeigt `git log -p` ohne `-m` nicht. Ein Name, der erst in einer Konfliktauflösung entsteht, bliebe unbemerkt (belegt, gering).

**`haken-backslash.pl` (gemessen).** Selbsttest 13/13. Den Befehlstext habe ich als JSON durch den Haken geschickt, mit zwölf eigenen Varianten. Abgewiesen wird nur `perl -i.bak -pe 's/…/…\\…/'`. Durch gehen `sed -i`, `perl -pie`, `s#…#…#` und `s|…|…|` mit `-i`, `-e` in doppelten Anführungszeichen, `printf … > Datei`, `<<<`, `Set-Content` und eine Heredoc-Marke mit Bindestrich. Das ist K8. Der Haken ist eine Erinnerung, keine Schranke. Die vier Fälle vom 06.11.2026 fängt er.

## 2. Marke und Wurzel

**Wo die Marke greift (belegt).**

| Werkzeug | Prüfung | vor welchem Eingriff |
|---|---|---|
| `pruefstand-lauf.ps1:282-288` | Marke im Fallverzeichnis | vor dem Löschen der `eudora.log` (:293), vor `-Vorbereiten` und Start |
| `testlauf.ps1:151-155` | Marke in `$voll` | `Melde-Mangel` bricht bei :205 ab, also vor `-MitVorbereiten` (:290) und Start (:364) |
| `pruefstaende-auffrischen.ps1:56` | Marke im Fallverzeichnis | vor dem Überschreiben von `Eudora.exe` und DLLs |
| `pruefstand-sperre.ps1:151-171` | Wert zählt als eigener nur mit Marke im Pfad oder darüber | vor dem Zurücksetzen von Werten |
| `pruefstand-einrichten.ps1` | wie bisher: Löschen nur mit Marke und `-Erneuern` | — |
| `messen-*.ps1` (62 mit `-Vorbereiten`) | **keine** | K3 |
| `pruefstand-sperre.ps1:265-268` (Unterschlüssel `<Basis>\C:\Temp\…`) | **keine** | K6 |

**`Ist-Pruefstandswert` (gemessen).** Die Funktion habe ich aus der Datei herausgelöst und mit Pfaden mit Leerzeichen gefahren, in einem Wegwerf-Ordner meines Baums (nicht im Scratchpad, denn Scratchpad-Pfade zählen dort immer als eigen). Fünf von fünf richtig: eigener Wert ohne und mit Anführungszeichen → eigen, fremder Wert → fremd, erst fremd, dann eigen → eigen, Text ohne Pfad → fremd. Die 8.3-Kurznamen habe ich nicht nachgemessen. Die Klonprobe in [E-243](../Intern/BEFUNDE.md#e-243) nennt *„11 eigene Wert(e)“* zurückgesetzt.

**Wurzelschranke (gemessen, `pruefstand-lauf.ps1:65`, `pruefstand-einrichten.ps1:67`).**

| `-Wurzel` | nach `GetFullPath` | Ergebnis |
|---|---|---|
| `C:\Temp\Mein Ordner` | gleich | angenommen (K2) |
| `\\server\share\pf` | gleich | abgewiesen |
| `Z:\pf` (verbundenes Laufwerk) | gleich | angenommen |
| `C:\`, `C:\Temp\..` | `C:` | abgewiesen |
| `C:\Users\Beispiel`, `C:\Windows` | gleich | angenommen (K7) |
| `C:pf` | `<Arbeitsverzeichnis des Prozesses>\pf` | angenommen (K7) |
| `\\?\C:\Temp\x` | gleich | abgewiesen |

**Netzlaufwerk:** Ein UNC-Pfad wird abgewiesen. Ein verbundenes Laufwerk wird angenommen. Dort gelten Marke und Registry-Prüfung wie lokal, solange der Buchstabe in der Sitzung verbunden ist. Ob Eudora auf einem Netzlaufwerk Kurznamen schreibt und ob `GetLongPathName` sie dort auflöst, habe ich nicht gemessen (Vermutung: `E-133r` könnte dort rot werden, ohne dass etwas kaputt ist). Die Sperre und ihr Registry-Stand liegen fest in `C:\Temp` (`pruefstand-sperre.ps1:53-54`). Fehlt `C:\Temp` auf einem Rechner, der nur `-Wurzel D:\…` benutzt, schreibt `Export-Clixml` nichts und meldet *„Stand nicht abgelegt“* (:193). Nach einem Absturz fehlt dann die Rücksetzung (belegt, gering).

**Muss-Umrechnung (gemessen und belegt).** `.Replace('C:\Temp\', …)` (`pruefstand-lauf.ps1:96-97`) unterscheidet Groß- und Kleinschreibung. In der Fallliste nennt nur ein einziger Muss-Text einen Pfad, nämlich `E-133q` (gezählt über Feld 4 und 5 aller Fälle). Dafür ist die Umrechnung richtig.

**Vorlagen, Schalterdateien, Bildserver (gemessen und belegt).**
* `pruefe-feste-pfade.pl`: 75 Skripte, 49 Fallverzeichnisse, jedes mit Vorlage, grün. Gegenprobe: Nimmt man `E169B/Mailverzeichnis/Eudora.ini` vorübergehend weg, wird sie rot (Rückgabe 1) und nennt den Befehl zum Erfassen. Danach war `git status` leer. 363 Dateien unter `Testdaten/pruefstand/` liegen auf der Platte, 363 sind getrackt, keine fehlt im Klon.
* Die 363 Vorlagen habe ich neu mit den Mustern der lokalen Liste, auf fremde Adressen, Laufwerkspfade außerhalb `C:\Temp\`, UNC und URLs durchsucht. Gefunden habe ich nur den bekannten `wscript.exe`-Pfad aus [PRUEFER-104](PRUEFER-104.md#pruefer-104) §2.
* `E169B/e169-schalter.txt` ist getrackt. Der Einrichter kopiert jede Datei neben dem Mailverzeichnis (`pruefstand-einrichten.ps1:181-182`). `messen-e169.ps1:82` liest sie.
* Der Bildserver startet als `"$repo\tools\e169-bildserver.pl"` (`messen-e169.ps1:100`). Genau diesen Text sucht der Aufräumer (`pruefserver-aufraeumen.ps1:36`, :44-51), Port 18169 steht in beiden.

## Funde

### <a id="k1"></a>K1 (mittel, gemessen): `E-133r` ist grün, ohne dass Eudora etwas berichtigt hat

`messen-e133.ps1 -Vorbereiten` schreibt `Current = <dieser Prüfstand>\Eudora.exe <Wurzel>\E133-gibt-es-nicht …` (:82-86). `E-133r` vergleicht nach dem Lauf nur das **erste** Stück mit `<dieser Prüfstand>\Eudora.exe` (:193-196). Das stimmt schon vor dem Start. Gemessen: Die herausgelöste Auswertung meldet mit dem vorbereiteten Wert `zeigt-hierher=1`, mit leerem Wert 0. Bis `fdf6ce45` verlangte `E-133p` wörtlich `…\E133\Eudora.exe C:\Temp\E133\MAILVE~1` und damit den **berichtigten** Mailverzeichnis-Teil. Jetzt verlangt `E-133p` nur noch `registry-danach=` (`pruefstand-faelle.txt:595`). Ob die Registry berichtigt wird, misst damit kein Fall mehr. Es bleibt nur `E-133q`, also Eudoras eigene Protokollzeile, die eine Behauptung ist und kein gemessener Zustand. **Abhilfe:** das zweite Stück (`-split …)[1]`) mit `GetLongPathName` auflösen und mit `Join-Path $voll 'Mailverzeichnis'` vergleichen. Gegenprobe: der vorbereitete Wert muss 0 ergeben. **Hält den PR auf:** ja. Der PR selbst ersetzt eine wirksame Prüfung durch eine blinde, und die Abhilfe ist klein.

### <a id="k2"></a>K2 (mittel, gemessen und belegt): Mit Leerzeichen in der Wurzel öffnet Eudora ein fremdes Mailverzeichnis

`testlauf.ps1:364` startet `Start-Process -FilePath $exe -ArgumentList $daten`. Die Zeile davor (:363) zeigt den Pfad in Anführungszeichen an, übergibt ihn aber ohne. Gemessen mit `perl.exe` als Ziel: `…\Mein Ordner\E133\Mailverzeichnis` kommt als zwei Argumente an. Eudora trennt die Befehlszeile an der ersten Leerstelle, wenn sie nicht mit `"` endet (`fileutil.cpp:480`), und prüft dann das erste Stück als Mailverzeichnis (:508). Damit läuft Eudora in `…\Mein`, außerhalb der Marke. Dasselbe Muster haben die Protokoll- und Ablagepfade unter `$voll` für die Prüfserver in `messen-e122.ps1:205`, `messen-e169.ps1:100`, `messen-e179.ps1:152`, `messen-e204.ps1:142`, `messen-e221.ps1:206` und `messen-e223.ps1:121` (belegt). Die Doku (`Doku/PRUEFSTAND.md:205`) verspricht *„jeder Ordner außer einem Laufwerksstamm“*, und die Schranke nimmt `C:\Temp\Mein Ordner` an (gemessen). Das ist dieselbe Fehlerklasse wie [E-244](../Intern/BEFUNDE.md#e-244), nur über die Wurzel statt über den Klon-Pfad. **Abhilfe:** In beiden Wurzelschranken Leerraum abweisen (`-match '\s'`) und die Doku-Zeile ergänzen. Oder `$daten` in `testlauf.ps1:364` in Anführungszeichen setzen. Dann bleiben die Prüfserver aber rot. **Hält den PR auf:** nein, die Vorgabe-Wurzel hat kein Leerzeichen. Empfohlen ist trotzdem die eine Zeile vor dem Merge.

### <a id="k3"></a>K3 (mittel, belegt und gezählt): Messskripte direkt aufgerufen prüfen keine Marke

Von 73 `messen-*.ps1` haben 62 `-Vorbereiten`, keines prüft `.eudora72-pruefstand`. 39 fallen ohne `EUDORA72_PRUEFSTAND` auf `C:\Temp` zurück, nicht auf die neue Vorgabe. Beispiel: `messen-e13.ps1 -Vorbereiten -Pfadfilter C:\Temp\<irgendwas>` besteht die Pfadschranke (:54) und löscht dann In, Out und Trash samt `.toc` (:58-60). Über Lauf und `testlauf.ps1` geht das nicht mehr (§2). [E-243](../Intern/BEFUNDE.md#e-243) sagt aber *„jedes dieser Werkzeuge fasst nur noch Verzeichnisse mit Marke an“* und zählt `messen-e13.ps1` unter den Ursachen auf. Für den direkten Aufruf stimmt das nicht. **Abhilfe:** eine gemeinsame Zeile `if (-not (Test-Path (Join-Path $voll '.eudora72-pruefstand'))) { exit 2 }` im `-Vorbereiten`-Zweig und eine Schranke, die sie in jedem Messskript verlangt. **Hält den PR auf:** nein, der Weg der Agenten ist geschützt. Den Satz in [E-243](../Intern/BEFUNDE.md#e-243) aber auf „über Lauf und testlauf“ einschränken.

### <a id="k4"></a>K4 (mittel, gemessen): Der alte Commit mit den Namen ist auf GitHub weiter abrufbar (neu: E-246)

`gh api repos/{owner}/{repo}/commits/<Kennung>` liefert den Commit vom 05.11.2026, 20:13, mit vollem Inhalt. Kein Zweig enthält ihn mehr, GitHub hält ihn aber über die Kennung vor. Die Kennung steht in `tools/pruefe-namen-gestaget.pl:12`, `tools/hooks-einrichten.sh:589` und `:677`, `tools/WERKZEUGE.md:103` und `Arbeitsweise/gedaechtnis-ist-oeffentlich.md:124` sowie in drei Commit-Nachrichten des Zweigs. Wer den Kommentar liest, findet den Namen also mit einem Klick. **Abhilfe:** Gregor entscheidet, ob er beim GitHub-Support die Entfernung beantragt. Bis dahin die Kennung in den fünf Dateien durch „Commit vom 05.11.2026“ ersetzen. Die drei Nachrichten bleiben, solange der Zweig nicht noch einmal umgeschrieben wird. **Hält den PR auf:** nein.

### <a id="k5"></a>K5 (mittel, gemessen): Die Namensschranke ist blind für Dateinamen, Commit-Nachrichten und Binärdateien (neu: E-245)

Gemessen in einem Wegwerf-Repo im Scratchpad mit einem erfundenen Muster in `tools/anonym-begriffe.lokal`:

| Probe | gestagt | `--commit HEAD` |
|---|---|---|
| Name im Dateinamen, Inhalt harmlos | frei (0) | frei (0) |
| Name nur in der Commit-Nachricht | — | frei (0) |
| Name in einer Datei mit Nullbyte | frei (0) | — |
| Name im Inhalt (Positivprobe) | **rot (1)** | — |

Gerade die Commit-Nachricht ist der Weg, auf dem schon einmal ein Pfad von Gregor öffentlich wurde (Lehre *„Gregors Pfade gar nicht erst schreiben, auch nicht in die Commit-Nachricht“*). **Abhilfe:** ein `commit-msg`-Haken, der dieselben Muster gegen `$1` prüft. Im `--seit-main`-Zweig die Nachricht mitlesen (`%B`) und die Kopfzeilen `+++ b/` gegen die Muster halten. Binärdateien über `git diff --cached --text` oder durch Verbot der Endung. **Hält den PR auf:** nein, die Geschichte ist gemessen sauber.

### <a id="k6"></a>K6 (gering, belegt): Unterschlüssel unter `C:\Temp` werden ohne Marke gelöscht

`Registry-Zurueck` löscht jeden Unterschlüssel `HKCU\Software\Qualcomm\Eudora\C:\Temp\<x>`, der vor dem Lauf nicht da war (`pruefstand-sperre.ps1:265-268`), ohne nach der Marke zu fragen. Eudora legt dort je Verzeichnis einen Schlüssel an (gelesen mit `reg query`, nur die Namen). Startet Gregor während eines Laufs zum ersten Mal eine neue echte Instanz unter `C:\Temp`, verschwindet ihr Schlüssel. Bei einer Wurzel außerhalb von `C:\Temp` (`D:\…`) räumt umgekehrt niemand ihre Schlüssel auf. **Abhilfe:** aus dem Schlüsselnamen den Pfad bilden und die Marke prüfen wie bei den Werten. Die Basis aus der Wurzel ableiten statt fest `C:\Temp` (:176).

### <a id="k7"></a>K7 (gering, gemessen): Die Wurzelschranke nimmt fast alles an

Seit `916d9dec` gilt nur noch „kein Laufwerksstamm“. Angenommen werden `C:\Windows`, `C:\Users\<Name>` und das laufwerksbezogene `C:pf`, das gegen das Arbeitsverzeichnis des **Prozesses** aufgelöst wird, nicht gegen das von PowerShell (§2). Die Fallverzeichnisse schützt die Marke. Ohne Marke schreibt der Ablauf aber in die Wurzel selbst: `pruefstand-ergebnis.txt` und `Eudora72-Pruefstand-nicht-einrichtbar.txt` werden überschrieben. Der Fall `ohne-argument` liest das neueste `eudora.log` bis Tiefe 2 unter der Wurzel (`pruefstand-lauf.ps1:361-363`). Bei `-Wurzel C:\Users\<Name>` wäre das auch Gregors eigenes Protokoll. Das ist keine Gefahr für Daten, aber ein Leck in die Ergebnisdatei. **Abhilfe:** eine nicht leere Wurzel nur annehmen, wenn sie schon Prüfverzeichnisse mit Marke enthält.

### <a id="k8"></a>K8 (gering, gemessen): `haken-backslash.pl` fängt nur zwei Formen

Siehe §1: 11 von 12 eigenen Varianten gehen durch, darunter `sed -i` und `perl -pie`. Der Kopf des Werkzeugs nennt nur, was abgewiesen wird, nicht, was durchgeht. **Abhilfe:** mindestens `sed -i` und `-pie`/`-pi -e` aufnehmen und die Grenze in den Kopf schreiben.

### <a id="k9"></a>K9 (gering, belegt): Veraltete Kommentare und eine ungeglättete Wurzel im Starter

`pruefstand-lauf.ps1:57` (*„Nur C:\Temp oder darunter“*), `pruefstand-einrichten.ps1:59` (*„C:\Temp oder ein Ordner darunter“*), `pruefstand-starten.ps1:30` und :35 (`[-Wurzel C:\Temp]`) sowie die Meldung in `messen-e133.ps1:58` (*„nicht unter C:\Temp\E133*“*) beschreiben noch die alte Schranke. Der Starter normalisiert `$Wurzel` nicht. `-Wurzel C:\Temp\X\` mit Schrägstrich am Ende macht die Prüfung auf offene Eudora-Fenster (:78, `StartsWith($Wurzel + '\')`) blind.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| [K1](#k1) | `E-133r` ist mit dem selbst vorbereiteten Registry-Wert grün, die Berichtigung misst kein Fall mehr | mittel | **ja, den PR** (zwei Zeilen); kein Programmpaket |
| [K2](#k2) | Wurzel mit Leerzeichen: Eudora öffnet `…\Mein` statt des Prüfstands, Prüfserver schreiben daneben | mittel | nein (eine Zeile empfohlen) |
| [K3](#k3) | Messskripte direkt aufgerufen löschen ohne Marke | mittel | nein |
| [K4](#k4) | alter Commit mit Namen auf GitHub per Kennung abrufbar, Kennung fünfmal im Baum ([E-246](../Intern/BEFUNDE.md#e-246)) | mittel | nein, Gregor entscheidet |
| [K5](#k5) | Namensschranke blind für Dateiname, Commit-Nachricht, Binärdatei ([E-245](../Intern/BEFUNDE.md#e-245)) | mittel | nein |
| [K6](#k6) | Registry-Unterschlüssel unter `C:\Temp` ohne Marke gelöscht | gering | nein |
| [K7](#k7) | Wurzelschranke nimmt `C:\Windows`, `C:\Users\…`, `C:pf` an | gering | nein |
| [K8](#k8) | Backslash-Haken lässt `sed -i`, `-pie` u. a. durch | gering | nein |
| [K9](#k9) | veraltete Kommentare, Starter-Wurzel nicht geglättet | gering | nein |
