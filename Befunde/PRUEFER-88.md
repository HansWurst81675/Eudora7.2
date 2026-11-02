# <a id="pruefer-88"></a>PRUEFER-88

Lauf nach [PRUEFER-87](PRUEFER-87.md). Geprüft wurde `ee7b5400..HEAD -- Eudora71 tools` auf Zweig wt/pruefer-20261102h, vorher mit `tools/arbeitsbaum-angleichen.sh` auf `origin/e203_e204_persona_kennwort` gebracht (Stand 21029ad6). Im Bereich liegen drei Commits: f96f8797 (neu `tools/startzeilen-sammeln.pl`), 47093e2f (Behebung von [E-203](../Intern/BEFUNDE.md#e-203) und [E-204](../Intern/BEFUNDE.md#e-204), `TestE203E204.cpp`, `messen-e204.ps1`, `anhang-pruefdaten.pl --protokoll`, Fall `E-39p` umbenannt in `E-203p`) und 21029ad6 (übernommene Prüfstandssperre). Die Sperre selbst hat [PRUEFER-87](PRUEFER-87.md) schon geprüft. Hier wurde nur nachgesehen, ob sie unverändert übernommen ist. Eudora habe ich weder gebaut noch gestartet. Keinen Prüfstand habe ich angefasst, nichts in der Registry gelesen oder geschrieben. Unter `C:\Temp` habe ich nur nachgesehen, welche Verzeichnisse es gibt.

## Ergebnis vorweg

Beide Behebungen stimmen. Löscht man eine Persönlichkeit, vergisst Eudora jetzt ihr Kennwort im Speicher immer, nicht nur dann, wenn sie gerade die aktuelle war. Die Stelle steht richtig hinter dem Umschalten auf `<Dominant>`, denn das Umschalten legt das Kennwort vorher noch einmal ab. Der Vergleich ohne Rücksicht auf Groß- und Kleinschreibung nimmt jede Schreibweise des Namens mit. Die MFC-Tabelle selbst vergleicht mit Rücksicht darauf, das habe ich in der MFC-Quelle nachgelesen. *Change Password* schaltet jetzt auf allen vier Ausgängen zurück. Andere Wege, auf denen das Kennwort einer gelöschten Persönlichkeit überlebt, habe ich nicht gefunden: *Shift+New*, Klonen, IMAP, Konto ändern. Die Testsuite läuft mit 369/369. Die übernommene Sperre ist Byte für Byte die aus ff49d438.

Gefunden habe ich vor allem Lücken im Prüfstand und im Test, nicht im Programm. Der neue Prüfstandsfall `E-203p` läuft in einem eigenen Verzeichnis ohne Positivprobe. Er wäre also auch grün, wenn der Vorlauf gar nicht wirkt (K1). Der Regressionstest bleibt bei drei von sechs Gegenproben grün (K2). Neu ist ein alter Stapelüberlauf in *Change Password* (K5, Vorschlag [E-210](../Intern/BEFUNDE.md#e-210)). Er ist Originalbestand und ab Werk kaum erreichbar. `startzeilen-sammeln.pl` verliert keine Zeilen. Es übernimmt aber auch Zeilen, die anderswo später berichtigt werden, und hängt sie unsortiert an (K6).

Für das Paket: **Keiner der Funde hält 7.2.2.132 auf.** K1 sollte vor dem nächsten Prüfstandslauf behoben werden, sonst sagt `E-203p` nichts.

## 1. E-204: `CPersonality::Remove` am Quelltext

- **Wo das Kennwort liegt.** `SetCurrent` ruft beim Wechsel `SavePassInfo` auf, und zwar *vor* `m_Current = PersonaID` (persona.cpp:188-201). `SavePassInfo` legt das globale `POPPassword` unter `m_Passwords[m_Current]` ab, für `<Dominant>` unter `m_Dominant` (:1134-1137). `RestorePassInfo` holt es mit `Lookup` und setzt sonst `""` (:1183-1184). Belegt.
- **Reihenfolge.** Der E-204-Block (:608-619) steht hinter dem E-39-Block. Ist die gelöschte Persönlichkeit die aktuelle, legt `SetCurrent( NULL )` (:593) ihr Kennwort noch einmal unter ihrem Schlüssel ab. Erst danach wird gelöscht. Stünde der Block davor, bliebe das Kennwort stehen. Belegt.
- **MFC.** `CMapStringToString::Lookup` und `RemoveKey` vergleichen mit `pAssoc->key == key`, also `CString::operator==` mit Rücksicht auf die Schreibung (VS 2022 14.38, `atlmfc/src/mfc/map_ss.cpp:196`, `:288`). `RemoveKey` gibt den Eintrag sofort frei (`FreeAssoc`, :291). Deshalb ist es richtig, die Schlüssel zuerst in `listVergessen` zu sammeln und erst nach dem Durchlauf zu löschen. Belegt.
- **Groß- und Kleinschreibung.** Der Schlüssel trägt die Schreibung des Aufrufers von `SetCurrent`. Das ist meist die aus `List()`, bei `headervw.cpp:323` und `summary.cpp:1327` aber die aus der Zusammenfassung einer Nachricht. `Remove` findet die Persönlichkeit mit `strcmpi` (:543). `CompareNoCase` nimmt deshalb jede Schreibweise mit. Für den Fall mit gleicher Schreibung genügt das, und für andere Schreibweisen löscht es eher zu viel als zu wenig. Belegt.
- **Nicht aktuelle Persönlichkeit.** Hier ändert sich am globalen `POPPassword` nichts. Es gehört der aktuellen. Belegt.

### Weitere Wege, auf denen das Kennwort überleben könnte

| Weg | Ergebnis | Belegt |
|---|---|---|
| Neu anlegen über den Assistenten (*New*) | war das Leck, jetzt zu | gemessen vom BEHEBER (`E-204p`), Quelltext |
| *Shift+New* (`CModifyAcctSheet`, PersonalityView.cpp:872-875) | schon vorher kein Leck: `LoginName` ist leer, das eingetragene Konto weicht davon ab, also `ClearPasswordFor(neuer Name)` (ModifyAcctDlgs.cpp:325-334). Dasselbe gilt für den Server (:519-522). Nur wenn beide Felder leer bleiben, wird nichts gelöscht, und dann gibt es kein Konto. | Quelltext, nicht gemessen |
| Klonen (`Clone`, persona.cpp:491-524) | kopiert nur `GetParams`, kein Kennwort | Quelltext |
| Import aus anderen Programmen (`MAPIImport.cpp:1976`, `:2049`) | ruft `Add`. Seit der Behebung findet ein gleichnamiger Import nichts mehr. | Quelltext |
| Umbenennen | gibt es nicht. `Modify` behält den Namen (ModifyAcctSheet.cpp:117-127). | Quelltext |
| IMAP-Persönlichkeit | das Konto mitsamt seinem Kennwortobjekt wird gelöscht (`WillDeletePersona`, QCImapMailboxDirector.cpp:331-357, persona.cpp:552) | Quelltext |
| Kennwort auf der Platte | der Abschnitt wird gelöscht (:573). In den Abschnitt der aktuellen Persönlichkeit schreibt `FlushINIFile` nur `SavePassword` und `SavePasswordText` (TestE39 prüft das in `rs.cpp`). Diese beiden nimmt [E-39](../Intern/BEFUNDE.md#e-39) aus dem Zwischenspeicher. | Quelltext |
| `SetCurrent` später mit dem Namen der gelöschten Persönlichkeit (aus einer Zusammenfassung) | legt nur einen *leeren* Eintrag an, denn `RestorePassInfo` setzt `""` | Quelltext |
| laufende Abrufaufgabe | `Remove` verweigert das Löschen, solange es Aufgaben gibt (:533-537) | Quelltext |

Nicht durchgesehen: ob die SMTP-Anmeldung irgendwo ein eigenes Kennwort zwischenspeichert. Vermutung: nein, sie nimmt `POPPassword`.

## 2. E-203: `ChangePassword` am Quelltext

- Umgeschaltet wird nur bei mehreren Persönlichkeiten und nur, wenn die gewählte eine andere ist (password.cpp:451-452). Zurückgeschaltet wird jetzt auf allen vier Ausgängen hinter dem Umschalten (:464-465, :474-475, :530-531, :540-541). Der Ausgang :448 liegt vor dem Umschalten. Ist `OrgPersona` gleich `NewPersona`, tut `SetCurrent( OrgPersona )` nichts (persona.cpp:188). Belegt.
- `OrgPersona` ist für `<Dominant>` leer (`GetCurrent`, :171-172), und `SetCurrent("")` schaltet auf `<Dominant>`. Belegt.
- Beim Zurückschalten legt `SavePassInfo` das Kennwort der gewählten Persönlichkeit unter ihrem Schlüssel ab. Auf den frühen Ausgängen ist das unverändert ihr eigenes. Belegt.
- Zum Rest der Funktion siehe K5.

## 3. Testsuite und Gegenproben (in meinem Baum)

Gemessen. Die Basis lief über `cmd /c Eudora71\Tests\RunTests.cmd`: 369 Tests, 369 bestanden. `TestE203E204` liest die Quelle zur Laufzeit. Die Gegenproben haben deshalb die Quelle mit Perl `:raw` geändert, Anker mit genau einem Treffer, und `EudoraTests.exe` ohne neuen Bau neu gestartet. Danach habe ich die Datei byte-genau zurückgeschrieben. Der Vergleich meldete jedes Mal *byte-gleich*, und `git status` war am Ende leer.

| Lauf | Änderung (vorübergehend) | Ergebnis |
|---|---|---|
| 0 | keine | 369/369 |
| G1 | `CompareNoCase( PersonaID ) == 0` → `!= 0`: löscht alle *anderen* Kennwörter | 368/369, rot [E-204](../Intern/BEFUNDE.md#e-204) |
| G2 | `if (0)` vor den E-204-Block | 368/369, rot [E-204](../Intern/BEFUNDE.md#e-204) |
| G3 | `if (0)` vor dem ersten `if ( bMultiple ) … SetCurrent( OrgPersona )` | **369/369, grün** (K2) |
| G4 | `OrgPersona = NewPersonaName;` vor dem zweiten Zurückschalten | **369/369, grün** (K2) |
| G5 | `if ( Name[0] == 'E' ) return TRUE;` vor dem E-39-Block in `Remove` | **369/369, grün**, auch TestE39 (K2) |

Dazu kommen die drei Gegenproben des BEHEBERS (Block unter `bWarAktuell`, `Compare`, je eine Zeile `SetCurrent( OrgPersona )` entfernt). Sie sind laut Commit-Nachricht rot. Nachgefahren habe ich sie nicht.

**Deckt TestE39 die E-39-Behebung noch allein?** Ja, am Quelltext. `Test_E39_Remove` verlangt den ganzen Block in seiner Reihenfolge unter der unveränderten Bedingung. `Test_E39_FlushSchreibtInAktuelle` sichert die Annahme über `rs.cpp`. Am Programm misst [E-39](../Intern/BEFUNDE.md#e-39) kein Fall mehr. Das ist so gewollt (siehe K4). G5 zeigt dieselbe Grenze wie bei [E-204](../Intern/BEFUNDE.md#e-204): Ein früher Ausstieg vor dem Block bleibt grün.

## 4. Messskript und Prüfstandsfälle

- **`messen-e204.ps1` trifft den Weg.** `-Vorbereiten` legt `[Persona-E204Zwei]` mit `SavePassword=0` an und schaltet für `<Dominant>` den Abruf ab (:114-120). *Check Mail* prüft also nur E204Zwei. Nach dem Abruf schaltet Eudora zurück, und `SavePassInfo` legt das Kennwort ab. Abruf 2 ohne Frage belegt, dass es im Speicher steht (:323). Gelöscht wird über *Personalities → Delete* (`33038`), während `<Dominant>` die aktuelle ist. Neu angelegt wird über den Assistenten. Danach liest das Skript am Prüfserver mit, welches `PASS` ankommt. Das Ergebnis unterscheidet die Fälle: `pass=alt` ohne Frage gegen `pass=neu` mit Frage. Nur Botschaften an gemessene Handles, kein Tastendruck. Belegt.
- **Was es nicht misst:** die Spurzeile `war-aktuell`, siehe K3, und eine andere Schreibung des neuen Namens. Die sichert nur der Test.
- **`anhang-pruefdaten.pl --protokoll`.** Der Server öffnet die Datei selbst zum Anhängen (`>>`) und leitet STDERR dorthin um. `$| = 1` gilt danach für STDOUT. Das Skript löscht die Datei in `-Vorbereiten` vorher (:134). Folgt auf `--protokoll` kein Name, bleibt `$protokoll` undefiniert, und die Option wirkt stillschweigend nicht. Für den Aufruf aus dem Skript ist das gleichgültig. Belegt. Der Server schreibt `PASS` im Klartext ins Protokoll. Hier sind das nur die erfundenen Testkennwörter.
- **`E-203p`**: siehe K1.

## 5. Übernommene Sperre (21029ad6)

Gemessen: `git rev-parse` liefert für `tools/pruefstand-sperre.ps1`, `tools/testlauf.ps1` und `tools/pruefstand-lauf.ps1` in ff49d438, 21029ad6 und HEAD dieselben Blobs (`11796659…`, `4e8893da…`, `4e0fad3d…`). Die Übernahme ist also unverändert. Beim Zusammenführen mit `e133_mailverzeichnis_fehlt` gibt es an diesen drei Dateien keinen Konflikt.

Zwei Dinge fallen dabei auf. `pruefstand-lauf.ps1` aus ff49d438 bringt auch den E-133-Teil aus c473e7f7 mit (Schalter `ohne-argument,messen=…`). Das ist harmlos, denn hier nutzt ihn kein Fall. Nicht übernommen sind aus ff49d438 die Stilllegung von `tools/strg-n-pruefen.ps1` und der Gegentest `tools/pruefstand-sperre-test.ps1`. Das ist K7.

## 6. `tools/startzeilen-sammeln.pl`

- **Kann es Zeilen verlieren?** Nein. Es öffnet die Zieldatei nur zum Anhängen (`>>:raw`, :55). Fehlt am Ende der Zeilenumbruch, ergänzt es ihn vorher (:54). Es entfernt und sortiert nichts. Belegt. Gemessen: Ein Lauf mit `--nur-zeigen` in meinem Baum meldete `0 Zeile(n) fehlen hier`, mit 7 Arbeitsbäumen aus `git worktree list` und 35 Zweigen. Das eigentliche Sammeln war deshalb nicht nötig, und `TESTLAEUFE.md` ist unverändert.
- **Liest es die Zweige wirklich?** Ja. `perl` ist hier Cygwin-Perl (`$^O = cygwin`), die Backticks laufen also über `sh`, und `2>/dev/null` stimmt. Gemessen: `git show origin/main:tools/TESTLAEUFE.md` lieferte 223771 Byte. Unter einem Windows-Perl (`cmd.exe`) würde `2>/dev/null` den Befehl scheitern lassen, und der Zweigteil wäre blind. Das ist eine Vermutung, weil hier kein solches Perl im Pfad ist.
- **Kann es falsche Zeilen übernehmen?** Ja, siehe K6.

## 7. Funde

### <a id="k1"></a>K1: `E-203p` läuft in einem eigenen Prüfstand ohne Positivprobe und kann blind grün werden

(am Quelltext belegt)

`pruefstand-lauf.ps1` fasst die Fälle nach Verzeichnis, Nachricht und Schalter zu einem Lauf zusammen (:185). `E-203p` steht auf `C:\Temp\E203`. Die beiden Positivproben `E-39v` (*„Vorlauf: kennwort-meldung,vergessen“*) und `E-39w` (*„PROBE ok“*) stehen auf `C:\Temp\E39` (pruefstand-faelle.txt:374-376) und laufen also in einem anderen Start. Verlangt wird in `E-203p` `war-aktuell=0 abschnitt-wieder=0`. Genau das kommt auch heraus, wenn der Vorlauf nicht wirkt, zum Beispiel wenn *Change Password* nicht auf E39Zwei umschaltet oder die Meldung ausbleibt. Dann ist die gelöschte Persönlichkeit ohnehin nicht die aktuelle. Laut [E-203](../Intern/BEFUNDE.md#e-203) hat der BEHEBER `E39 PROBE ok` im selben Lauf gesehen. Die Messung von heute gilt also. Spätere Läufe des Falls sichern das aber nicht mehr ab (`Arbeitsweise/pruefstand-kann-blind-sein.md`). **Abhilfe:** `E-203v` und `E-203w` auf `C:\Temp\E203` mit denselben erwarteten Zeilen wie `E-39v`/`E-39w` ergänzen, oder `E-203p` zurück auf `C:\Temp\E39` legen. **Schwere: gering bis mittel.** In [E-203](../Intern/BEFUNDE.md#e-203) fortschreiben. **Hält das Paket nicht auf**, sollte aber vor dem nächsten Prüfstandslauf behoben sein.

### <a id="k2"></a>K2: `TestE203E204` prüft nur den Text direkt vor jedem `return`

(gemessen, Abschnitt 3)

G3 und G4 bleiben grün. Der Test vergleicht nur die Zeichen unmittelbar vor `return`. Eine Bedingung davor (`if (0)`) oder ein überschriebenes `OrgPersona` sieht er nicht. G5 zeigt, dass weder TestE39 noch der E-204-Test einen frühen Ausstieg vor dem E-39-Block erkennt. Das ist dieselbe Art Lücke wie in [PRUEFER-85](PRUEFER-85.md#pruefer-85) K1. Die Gegenproben sind gebaut, wirklich vorkommen werden solche Änderungen kaum. **Abhilfe:** für [E-203](../Intern/BEFUNDE.md#e-203) den Abschnitt von `ErrorDialog(IDS_ERR_NO_POP_ACCT)` bis zum ersten `return` als ganzen Block vergleichen, wie bei [E-204](../Intern/BEFUNDE.md#e-204), und verlangen, dass `OrgPersona` nach `GetCurrent()` nicht mehr zugewiesen wird. Für `Remove` verlangen, dass vor dem E-39-Block genau die beiden bekannten `return FALSE` stehen (:536, :546). **Schwere: gering.**

### <a id="k3"></a>K3: `messen-e204.ps1` liest die Spurzeile `war-aktuell` nicht

(am Quelltext belegt)

Wäre E204Zwei beim Löschen die aktuelle, nähme schon der E-39-Block das Kennwort weg, und `E-204p` wäre auch ohne die E-204-Behebung grün. Im alten Bau kam `pass=alt` an, dort war sie also nicht die aktuelle. Der Weg zum Löschen ist im neuen Bau derselbe, und [E-203](../Intern/BEFUNDE.md#e-203) berührt ihn nicht. Dass `E-204p` die eigene Behebung misst, ist deshalb sehr wahrscheinlich, aber im Lauf selbst nicht belegt. [PRUEFER-85](PRUEFER-85.md#pruefer-85) K5 hat für `E-39p` genau diese Spurzeile verlangt. **Abhilfe:** die Zeile `E-39 Remove E204Zwei: war-aktuell=` aus der `eudora.log` lesen und in `E204 PROBE` `war-aktuell=0` verlangen (wie `messen-e39.ps1`:337-343). **Schwere: gering.**

### <a id="k4"></a>K4: „Kein Weg über die Oberfläche führt mehr zur gelöschten aktuellen Persönlichkeit“ ist nicht belegt

(am Quelltext belegt bzw. Vermutung)

[E-203](../Intern/BEFUNDE.md#e-203), `messen-e39.ps1`:37-38 und `pruefstand-faelle.txt` sagen das so. Durchgesehen ist nur *Change Password*. Es gibt rund 100 Aufrufe von `SetCurrent`. Mindestens einer kehrt zurück, ohne zurückzuschalten: `NewCompDocument` schaltet bei `compmsgd.cpp:2241` um und gibt bei `:2251` zurück, wenn `NewChildDocument` scheitert. Das ist selten. Stichproben in `summary.cpp`, `msgdoc.cpp`, `TocFrame.cpp` und `headervw.cpp` haben keinen Ausgang zwischen Umschalten und Zurückschalten gezeigt. **Abhilfe:** „kein *bekannter* Weg“ schreiben. TestE39 bleibt nötig. **Schwere: gering.**

### <a id="k5"></a>K5: `ChangePassword` kopiert das POP-Konto ungeprüft in 128 Byte (Vorschlag: E-210)

(am Quelltext belegt, nicht gemessen)

`char Username[128]` (password.cpp:430). Dahinein schreibt `strcpy(Username, POPAccount)` (:469). `POPAccount` kommt aus `GetIniString`, und dessen Puffer ist 512 Byte groß (`INI_NORMAL_BUF_SIZE`, rs.cpp:48). Ein Konto mit mehr als 127 Zeichen läuft über den Stapel hinaus. Das ist Originalbestand, `befund-suchen.pl ChangePassword` meldet nur [E-203](../Intern/BEFUNDE.md#e-203) und [E-39](../Intern/BEFUNDE.md#e-39). Erreichbar ist es nur über *Change Password*, und das steht ab Werk nicht im Menü (`RemoveChangePassword`, siehe [E-203](../Intern/BEFUNDE.md#e-203)). Außerdem muss der Anwender ein so langes Konto selbst eingetragen haben. Ob das Feld im Kontodialog eine Längengrenze hat, habe ich nicht nachgesehen. Ob ein Einstellungslink (`x-eudora-setting:`) `POPAccount` setzen kann, ist eine Vermutung. **Abhilfe:** `strncpy` mit Abschluss bzw. `strcpy_s`, und bei zu langem Konto `IDS_ERR_BAD_POP_ACCT`. Das ist eine Zeile in derselben Funktion. **Schwere: gering bis mittel** (Speicherfehler, aber ab Werk kaum erreichbar). **Hält das Paket nicht auf**, Entscheidung Gregor.

### <a id="k6"></a>K6: `startzeilen-sammeln.pl` übernimmt ungeprüft und hängt unsortiert an

(am Quelltext belegt; der Kopfteil ist gemessen)

1. **Berichtigte Zeilen kommen wieder.** Gelesen wird auch der *ungesicherte* Stand fremder Arbeitsbäume (:36-42). Steht dort eine Zeile mit falscher Zeit, die ihr Agent später berichtigt, haben alle Bäume, die vorher gesammelt haben, beide Fassungen. Doppelte Zeilen mit leicht anderem Text sind keine Gleichen (:24, :31) und werden beide übernommen.
2. **Unsortiert ans Ende.** Die Datei wird sonst nach Zeit geordnet geführt. f31dbff9 hat drei Zeilen an ihren Platz verschoben (gemessen mit `git log -p`). Werkzeuge hängen davon nicht ab: `pruefe-startwege.pl` vergleicht nur Zeiten (:185-212). Aber jeder Zweig hängt einen anderen Block ans Ende. Beim Zusammenführen in `main` gibt es dann Konflikte am Dateiende, und nach dem Auflösen stehen Zeilen doppelt da.
3. **Die Abdeckung wird breiter.** `pruefe-startwege.pl` deckt einen Start mit *irgendeiner* Zeile im Fenster von ±600 s (:100, :201-212), ohne auf das Verzeichnis zu schauen. Mit allen fremden Zeilen im eigenen Protokoll deckt die Zeile eines anderen Agenten auch einen eigenen Start ohne Zeile, wenn beide in dieselben zehn Minuten fallen. Das war schon beim Abschreiben von Hand so. Das Werkzeug macht es zur Regel.
4. **Kleinigkeiten.** `refname:short` liefert für `origin/HEAD` den Namen `origin`, der Ausschluss auf :46 greift also nie (gemessen). `git show origin:…` zeigt dann `main` ein zweites Mal, und das ist harmlos. Zweige, deren letzter Commit älter als zwei Tage ist, werden übersprungen. Ihre Starts meldet `pruefe-startwege.pl` weiter, dagegen hilft `--tage`. Das Werkzeug muss aus dem Wurzelverzeichnis laufen (`tools/TESTLAEUFE.md` relativ, :21).

**Abhilfe:** nur committete Stände lesen (`git show <Zweig>:…`, auch für die Arbeitsbäume), die übernommenen Zeilen zusammen mit den eigenen nach Zeit einsortieren, und bei gleicher Zeit mit anderem Text nicht übernehmen, sondern melden. **Schwere: gering.**

### <a id="k7"></a>K7: Auf diesem Zweig startet `strg-n-pruefen.ps1` Eudora weiter ohne Sperre

(gemessen: Datei fehlt bzw. Stilllegung fehlt)

21029ad6 hat drei Dateien aus ff49d438 übernommen. Die Stilllegung von `tools/strg-n-pruefen.ps1` und `tools/pruefstand-sperre-test.ps1` sind nicht dabei. Wer von diesem Zweig aus `strg-n-pruefen.ps1` startet, schreibt `CommandLine\Current` ohne Sperre und ohne Protokollzeile, also genau das, was [E-157](../Intern/BEFUNDE.md#e-157) abstellen soll. Nach dem Zusammenführen beider Zweige ist das erledigt. **Abhilfe:** auch die Stilllegung übernehmen, oder diesen Zweig erst nach `e133_mailverzeichnis_fehlt` zusammenführen. **Schwere: gering.**

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| K1 | `E-203p` auf `C:\Temp\E203` hat keine Positivprobe im selben Lauf; wirkt der Vorlauf nicht, ist der Fall trotzdem grün | gering bis mittel | nein; vor dem nächsten Prüfstandslauf `E-203v`/`E-203w` ergänzen |
| K2 | `TestE203E204` und TestE39 bleiben grün bei `if (0)` vor dem Zurückschalten, überschriebenem `OrgPersona` und frühem Ausstieg in `Remove` | gering | nein |
| K3 | `messen-e204.ps1` belegt nicht, dass die gelöschte Persönlichkeit nicht die aktuelle war (`war-aktuell` ungelesen) | gering | nein |
| K4 | „kein Weg über die Oberfläche mehr“ zu [E-39](../Intern/BEFUNDE.md#e-39) ist nicht belegt (z. B. `compmsgd.cpp:2241/2251`) | gering | nein |
| K5 | `strcpy` des POP-Kontos (bis 511 Zeichen) in `Username[128]` in `ChangePassword`, Originalbestand (Vorschlag [E-210](../Intern/BEFUNDE.md#e-210)) | gering bis mittel | nein; Entscheidung Gregor |
| K6 | `startzeilen-sammeln.pl` übernimmt ungesicherte fremde Zeilen, hängt unsortiert an (Konflikte beim Zusammenführen), verbreitert die Zeitabdeckung; verliert aber nichts | gering | nein |
| K7 | Stilllegung von `strg-n-pruefen.ps1` aus ff49d438 nicht übernommen | gering | nein |

## <a id="nachtrag-1"></a>Nachtrag 02.11.2026

Geprüft wurde `git diff 4182961e..origin/e203_e204_persona_kennwort -- Eudora71 tools`, nach `arbeitsbaum-angleichen.sh` auf 78b47ebe. Der größte Teil des Bereichs kommt mit dem Merge von `main` (#209/#210, [E-194](../Intern/BEFUNDE.md#e-194)/[E-196](../Intern/BEFUNDE.md#e-196)/[E-205](../Intern/BEFUNDE.md#e-205) und Messskripte anderer Befunde). Diese Teile habe ich nicht geprüft. Inhaltlich neu für diesen Bericht ist 78b47ebe: Behebungen zu K1 bis K7, neu [E-210](../Intern/BEFUNDE.md#e-210) und [E-211](../Intern/BEFUNDE.md#e-211). Eudora habe ich wieder weder gebaut noch gestartet.

### Ergebnis vorweg

Alle sieben Funde sind behoben, und die Behebungen stimmen. Die Längenprüfung von [E-210](../Intern/BEFUNDE.md#e-210) liegt genau an der richtigen Grenze. Das Zurückschalten von [E-211](../Intern/BEFUNDE.md#e-211) steht an der richtigen Stelle und schaltet nicht doppelt. Die neuen Tests werden bei allen fünf Gegenproben rot, die vorher grün blieben oder neu sind. Die Testsuite läuft mit 389/389. `startzeilen-sammeln.pl` verschiebt keine vorhandene Zeile mehr und hat in meinem Baum drei Zeilen richtig eingeordnet. Es kann aber eine Zeile verlieren, wenn im selben Baum gleichzeitig ein Testlauf schreibt (K8). Dazu kommen zwei kleine Funde (K9, K10). **Keiner hält 7.2.2.132 auf.**

### E-210: Längenprüfung (password.cpp:469-480)

- **Grenze.** `if (strlen(POPAccount) >= sizeof(Username))` mit `char Username[128]` weist ab 128 Zeichen ab. 127 Zeichen plus Nullbyte sind genau 128 Byte, die passen. 128 Zeichen bräuchten 129 Byte und werden abgewiesen. Richtig. Belegt.
- **Nullbyte.** `GetIniString` liefert immer einen abgeschlossenen Puffer von höchstens 511 Zeichen (rs.cpp:48). `strlen` liest also nicht über das Ende hinaus. `NULL` und die leere Zeichenkette fängt vorher :461 ab. Belegt.
- **Meldung.** `ErrorDialog` formatiert mit `_vsnprintf(buf, 1023, …)` in `char buf[1024]` (guiutils.cpp:939-952). Der Text von `IDS_ERR_BAD_POP_ACCT` (EudoraRes.rc:9160) hat etwa 65 Zeichen, mit einem Konto von 511 Zeichen sind das knapp 580 Zeichen. Abgeschnitten wird nichts, und die Ausgabe ist abgeschlossen. Belegt. Ein unabgeschlossener Puffer entstünde erst ab 1023 Zeichen. Das ist Altbestand von `ErrorDialog` und hier nicht erreichbar. Die Meldung *„can't tell where the machine name is“* passt nur halb zu einem zu langen Konto. Das ist eine Kleinigkeit und Absicht des BEHEBERS.
- **Zurückschalten** wie bei [E-203](../Intern/BEFUNDE.md#e-203). Der Test zählt jetzt fünf Ausgänge. Belegt.

### E-211: `NewCompDocument` (compmsgd.cpp:2260-2270)

- `csCurPersona` wird am Anfang festgehalten, vor jedem Umschalten (:2190). Umgeschaltet wird nur bei gültigem `csPersona` (:2250-2251). Im Fehlerzweig schaltet die Funktion jetzt vor dem `return` zurück (:2267). War nicht umgeschaltet worden, tut `SetCurrent` nichts (persona.cpp:188). Auf dem Fehlerweg gibt es also genau ein Umschalten und genau ein Zurückschalten. Auf dem Erfolgsweg bleibt alles wie vorher (:2341, :2350). Belegt.
- `#ifdef COMMERCIAL` um das Zurückschalten passt zur Deklaration von `csCurPersona` (:2195-2253). Ohne `COMMERCIAL` würde der Bau sonst nicht übersetzt. Belegt.
- **MFC.** `NewChildDocument` liefert bei einem Fehler `NULL` (das ist der Zweig hier). Ob es auf einem anderen Weg eine Ausnahme werfen kann, an der das Zurückschalten vorbeiläuft, habe ich nicht nachgesehen. Vermutung: `CDocTemplate::OpenDocumentFile` fängt seine Ausnahmen selbst.

### Die neuen Tests (in meinem Baum)

Gemessen, so gefahren wie in Abschnitt 3. Danach war jede Datei byte-gleich zurückgeschrieben, und `git status` war leer.

| Lauf | Änderung (vorübergehend) | Ergebnis |
|---|---|---|
| 0 | keine | 389/389 |
| N1 | `if (0)` vor dem ersten Zurückschalten (vorher G3) | 388/389, rot [E-203](../Intern/BEFUNDE.md#e-203) |
| N2 | `if ( Name[0] == 'E' ) return TRUE;` vor dem E-39-Block (vorher G5) | 388/389, rot [E-204](../Intern/BEFUNDE.md#e-204) |
| N3 | `>=` → `>` in der Längenprüfung: 128 Zeichen liefen wieder über | 388/389, rot [E-210](../Intern/BEFUNDE.md#e-210) |
| N4 | `if (bMultiple) OrgPersona.Empty();` direkt vor `strcpy` | 388/389, rot [E-210](../Intern/BEFUNDE.md#e-210) (nur, weil der Block nicht mehr direkt vor `strcpy` steht; die Zählung `OrgPersona =` sieht `.Empty()` nicht) |
| N5 | `if (0)` vor das Zurückschalten in `NewCompDocument` | 388/389, rot [E-211](../Intern/BEFUNDE.md#e-211) |
| N6 | `throw 1;` am Anfang von `Remove` | **389/389, grün** (konstruiert; kein Fund) |

`QT_LiesNurCode` wirft `#if 0`-Blöcke weg (Quelltext.cpp:205). Das `return` in `#if 0` bei compmsgd.cpp:2225 zählt deshalb nicht, und die Erwartung *zwei Ausgänge* stimmt. Belegt. Blind ist keiner der neuen Tests. Grenzen bleiben: eine Zuweisung ohne Leerzeichen (`OrgPersona=`) oder über `.Empty()` zählt die Prüfung „genau einmal belegt“ nicht mit (N4 zeigt das).

### `messen-e204.ps1` liest die Spurzeile (K3)

Das Skript wartet bis zu 10 s auf `E-39 Remove E204Zwei: war-aktuell=` in der `eudora.log` und verlangt `0`. Es nimmt den *letzten* Treffer der ganzen Datei. Siehe K9.

### `startzeilen-sammeln.pl`: Einsortieren

- **Verschiebt es vorhandene Zeilen?** Nein. Jede neue Zeile wird vor die erste vorhandene Datenzeile mit späterer Zeit gesetzt, sonst hinter die letzte Datenzeile (:94-102). Vor dem Schreiben prüft das Werkzeug, ob die alten Zeilen in alter Reihenfolge vollständig sind (:105-108). Gemessen: In meinem Baum kamen drei Zeilen aus `.wt/e170` dazu. Die ersten 933 Zeilen waren danach byte-gleich mit der Sicherung (`cmp`), und die drei neuen standen hinter der letzten, früheren Zeile. Die Datei hat 0 CR, das Zurückschreiben mit LF ändert also nichts.
- **Sortierte Lage.** Die Datei ist selbst nicht sortiert. Gemessen: 13 Rücksprünge bei 925 Datenzeilen, zum Beispiel Zeile 851. Eine neue Zeile landet dann vor dem ersten späteren Eintrag, nicht unbedingt neben ihren zeitlichen Nachbarn. Das ist harmlos und kein Fund.
- **Verlieren:** siehe K8. **Zeile ohne Sekunden:** siehe K10.

### Funde

#### <a id="k8"></a>K8: `startzeilen-sammeln.pl` kann eine gleichzeitig geschriebene Zeile verlieren

(am Quelltext belegt)

Vorher hängte das Werkzeug nur an (`>>`). Jetzt liest es die Datei (:41-42), holt dann bis zu 35 Zweige über `git show` (:72-78, das dauert Sekunden) und schreibt die Datei danach ganz neu (`>:raw`, :109). Hängt `testlauf.ps1` im *selben* Arbeitsbaum dazwischen eine Zeile an, wird sie überschrieben. Danach fehlt die Protokollzeile eines echten Starts, und `pruefe-startwege.pl` weist genau diesen Start ab, oder ein fremder Start im selben Zehnminutenfenster deckt ihn zu. Die Prüfung auf :105-108 vergleicht nur mit dem eigenen, früheren Lesestand und sieht das nicht. Das Werkzeug nimmt die Prüfstandssperre nicht. **Abhilfe:** direkt vor dem Schreiben die Datei noch einmal lesen und abbrechen, wenn sie sich seit :42 verändert hat, oder über eine Hilfsdatei und `rename` schreiben. **Schwere: gering** (nur bei gleichzeitigem Lauf im selben Baum). **Hält das Paket nicht auf.**

#### <a id="k9"></a>K9: `messen-e204.ps1` und `messen-e39.ps1` lesen die Spurzeile aus der ganzen `eudora.log`

(am Quelltext belegt)

Beide nehmen den letzten Treffer der ganzen Datei (messen-e204.ps1:360-372, messen-e39.ps1:337-346). `-Vorbereiten` leert die `eudora.log` nicht. Kommt die Zeile des aktuellen Laufs nicht oder zu spät an, gilt die eines früheren Laufs, und der stand mit dem behobenen Bau auf `war-aktuell=0`. `geloescht=1` belegt zwar, dass `Remove` lief, aber nicht, dass seine Spurzeile in den zehn Sekunden in der Datei steht. **Abhilfe:** die Länge der `eudora.log` vor *Delete* merken und nur dahinter suchen. **Schwere: gering.**

#### <a id="k10"></a>K10: Eine fremde Zeile ohne Sekunden wird an den Anfang der Tabelle sortiert

(am Quelltext belegt)

`aufnehmen` lässt jede Zeile `| JJJJ-MM-TT …` durch (:52). `zeit()` verlangt aber `hh:mm:ss` (:90). Solche Zeilen gibt es: Zeile 671 hat nur `17:23`. Kommt so eine Zeile als neu dazu, ist ihre Zeit `undef`. Unter `use warnings` gibt das Warnungen beim Sortieren (:94), und `$ti gt $t` ist für die erste Datenzeile wahr (:99). Die Zeile landet ganz oben in der Tabelle. Verloren geht nichts. **Abhilfe:** auf :52 dasselbe Muster wie in `zeit()` verlangen, oder solche Zeilen hinter die letzte Datenzeile setzen. **Schwere: gering.**

### Übersicht zum Nachtrag

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| K1 bis K7 | behoben in 78b47ebe ([E-210](../Intern/BEFUNDE.md#e-210), [E-211](../Intern/BEFUNDE.md#e-211) neu und behoben) | – | nein |
| K8 | `startzeilen-sammeln.pl` schreibt die Datei ganz neu; eine gleichzeitig von `testlauf.ps1` angehängte Zeile geht verloren | gering | nein |
| K9 | Spurzeile `war-aktuell` wird aus der ganzen `eudora.log` gelesen, auch aus früheren Läufen | gering | nein |
| K10 | fremde Zeile ohne Sekunden landet am Tabellenanfang | gering | nein |
