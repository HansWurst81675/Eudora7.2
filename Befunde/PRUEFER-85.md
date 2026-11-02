# <a id="pruefer-85"></a>PRUEFER-85

Lauf nach PRUEFER-84 (liegt auf `wt/pruefer-20261102d`, noch nicht auf `main`). Geprüft wurde `253a8a40..HEAD -- Eudora71 tools Releases/1.0` auf Zweig wt/pruefer-20261102e (von `origin/e39_persona_loeschen`). Inhaltlich sind das 7e38b87b (ZWEIGE), fd216aa2 (Messskript), 6e7d3252 (Behebung und Test) und cf126b0d (Prüfstandsfälle, Doku). Schwerpunkt ist [E-39](../Intern/BEFUNDE.md#e-39): `CPersonality::Remove` in `persona.cpp`, der Auslöser `ChangePassword` in `password.cpp`, `TestE39.cpp`, `tools/messen-e39.ps1` und die Fälle `E-39p`/`E-39v`/`E-39w`. Eudora habe ich weder gebaut noch gestartet. `C:\Temp\E39` und `C:\Temp\E39-alt` habe ich nur gelesen.

## Ergebnis vorweg

Die Behebung selbst ist richtig. War die gelöschte Persönlichkeit die aktuelle, nimmt `Remove` ihre beiden Kennwortschlüssel ungeschrieben aus dem Zwischenspeicher, schaltet auf `<Dominant>` und vergisst danach ihr Kennwort im Speicher. Die Reihenfolge stimmt in beiden Punkten: erst aus dem Zwischenspeicher, dann umschalten; erst umschalten, dann vergessen (weil `SetCurrent` das Kennwort beim Umschalten noch einmal ablegt). Das Programm am Prüfstand zeigt es: In `C:\Temp\E39` steht die Spurzeile `war-aktuell=1 aktuell=<Dominant>` und kein `[Persona-E39Zwei]` mehr, in `C:\Temp\E39-alt` steht der Abschnitt mit `SavePasswordText=` wieder da. Die Testsuite läuft mit 364/364.

Drei Dinge halte ich für wichtiger als die Behebung selbst. Erstens bleibt der neue Test grün, wenn man die Behebung über ihre Bedingung abschaltet oder das Vergessen des Kennworts vor das Umschalten zieht (K1, gemessen). Zweitens ist `ChangePassword` ein eigener Fehler: Es lässt bei einem Konto ohne „@“ die gewählte Persönlichkeit für den Rest der Sitzung als aktuelle stehen, und das wirkt auf jede Einstellung, nicht nur aufs Löschen (K2). Drittens bleibt das Kennwort einer gelöschten Persönlichkeit, die **nicht** die aktuelle war, im Speicher. Legt man in derselben Sitzung eine neue mit demselben Namen an, bekommt sie das alte Kennwort (K3, am Quelltext belegt).

Die Stufe *kritisch* für [E-39](../Intern/BEFUNDE.md#e-39) halte ich nicht für haltbar (K4). Was zurückkommt, ist ein verwaister Abschnitt mit einer leeren Zeile, den Eudora nicht liest. Der Auslöser liegt hinter einem Befehl, der ab Werk ausgeblendet ist. Der Prüfstand erreicht ihn mit einer Botschaft, die ein Anwender so nicht schicken kann. Ein Anwender kommt nur über einen selbst eingerichteten Knopf auf der Werkzeugleiste oder über `RemoveChangePassword=0` dorthin. Dazu kommen drei kleine Funde zum Prüfstandsfall, zur Doku und zu Resten nach dem Löschen (K5–K7).

Für das Paket: Keiner der Funde hält das nächste Paket auf. K1 sollte vor dem Merge nachgeschärft werden. K2 und K3 schlage ich als eigene Befunde vor ([E-203](../Intern/BEFUNDE.md#e-203), [E-204](../Intern/BEFUNDE.md#e-204)), K4 ist eine Entscheidung für Gregor.

## 1. Die Behebung am Quelltext

- **Ort.** Der neue Block steht in `persona.cpp:575-600`. Er liegt hinter dem Löschen des Abschnitts (`WritePrivateProfileString(PersonaID, NULL, NULL, INIPath)`, :573) und vor `g_thePersonalityDirector.DeleteCommand` (:606). Belegt.
- **Vergleich.** `m_Current` hält die Form `Persona-<Name>` (`SetCurrent`, persona.cpp:183-184, `csPersonaPreface = "Persona-"` :52). `PersonaID` in `Remove` hat dieselbe Form (:531). Der Vergleich `CompareNoCase` ist richtig. Belegt.
- **Zwischenspeicher.** `FlushINIFile` schreibt nur `SavePassword` und `SavePasswordText` in den Abschnitt von `g_Personalities.GetCurrent()` (rs.cpp:1239-1251), alle anderen Schlüssel nach `[Settings]` (rs.cpp:1253-1257). `RemoveIniFromCache` löscht den Eintrag samt Schmutz-Kennzeichen (rs.cpp:1439-1450). Danach schreibt das `FlushINIFile` in `SetCurrent( NULL )` (persona.cpp:192) nichts mehr in den gelöschten Abschnitt. Belegt.
- **Kennwort im Speicher.** `SetCurrent` ruft vor dem Umschalten `SavePassInfo` auf. Das legt `POPPassword` unter `m_Passwords[m_Current]` ab (persona.cpp:1107-1113). Erst danach kann `m_Passwords.RemoveKey( PersonaID )` (:594) den Eintrag wirklich entfernen. `RestorePassInfo` lädt dann das Kennwort von `<Dominant>` (:1150-1160). Die Reihenfolge im Code ist richtig. Der Test schützt sie nicht (K1, G3).
- **Übrige Schlüssel.** Schmutzige Nicht-Kennwort-Einträge aus der Zeit, in der die gelöschte Persönlichkeit aktuell war, schreibt `SetCurrent( NULL )` nach `[Settings]`. Das tat vorher das nächste Umschalten oder Beenden genauso. Die Behebung ändert daran nichts. Belegt.
- **Spurzeile.** `PutDebugLog(DEBUG_MASK_MISC, …)` in beiden Fällen, auch bei `war-aktuell=0`. Gemessen in `C:\Temp\E39\Mailverzeichnis\eudora.log`, Zeile 56: `E-39 Remove E39Zwei: war-aktuell=1 aktuell=<Dominant>`. In `E39-alt` fehlt die Zeile, wie erwartet.
- **Bytes.** `persona.cpp` hat vorher und nachher 18 CRLF (Zeilen 3–20, der Kopf) und 0 Bytes >127. Die 27 neuen Zeilen enden auf LF wie ihre Umgebung. `TestE39.cpp` hat 0 CRLF und 0 Bytes >127. Gemessen.

## 2. Nebenwirkungen des Löschens

Gefragt war nach offenen Fenstern, Hintergrundaufgaben, IMAP-Konten und Filtern mit dieser Persönlichkeit.

- **Hintergrundaufgaben.** `Remove` lehnt ab, solange `GetTaskCount(Name) != 0` (persona.cpp:533). Belegt.
- **IMAP.** `g_theMailboxDirector.WillDeletePersona` (persona.cpp:552) löscht den lokalen Zwischenspeicher und das Kontoobjekt (QCImapMailboxDirector.cpp:331-356). Das geschieht vor dem neuen Block und schaltet nicht um. Belegt.
- **Nachrichten, Fenster, Filter.** Eine Zusammenfassung speichert die Persönlichkeit nur als Hash (summary.cpp:2864-2876). `GetPersona` sucht ihn in `List()` und liefert `""`, wenn es keinen Treffer gibt (summary.cpp:2878-2881, persona.cpp:108-127). `Remove` setzt `m_bListStale` (:608), die Liste wird also neu gelesen. Nachrichten in *Out*, offene Fenster und Filter mit *Change Personality → <gelöschte>* (filtersd.cpp:1367-1369) landen damit bei `<Dominant>`. Den gelöschten Abschnitt rufen sie über `SetCurrent` nicht mehr auf. Meine Gegenvermutung „die Nachrichten bleiben ewig in Out hängen“ ist damit am Quelltext widerlegt. Wohl gehen sie dann mit den Einstellungen von `<Dominant>` hinaus. Das steht so im übernommenen Quelltext und ist durch [E-39](../Intern/BEFUNDE.md#e-39) nicht verändert. Ob die Absenderzeile dabei wechselt, habe ich nicht gemessen (Vermutung).
- **Spool-Verzeichnis.** Gemessen an beiden Prüfständen: `Mailverzeichnis\spool\E39Zwei\` steht nach dem Löschen noch da (K7).

## 3. Andere Wege zur „aktuellen“ gelöschten Persönlichkeit

Ich habe alle 97 `SetCurrent`-Aufrufe außerhalb von `Tests/` mit einem Skript nach Funktionen gruppiert. Gesucht habe ich `return`, `break`, `goto` und `throw` zwischen dem ersten und dem letzten Aufruf einer Funktion. 16 Funktionen meldet das Skript, alle habe ich gelesen. Am Quelltext belegt:

| Stelle | Was | Bleibt umgeschaltet? |
|---|---|---|
| password.cpp:457-459, :465-467 | `ChangePassword`, `IDS_ERR_NO_POP_ACCT` / `IDS_ERR_BAD_POP_ACCT` | **ja, bis Programmende** (K2) |
| compmsgd.cpp:2240-2251 | `NewCompDocument`: `NewChildDocument` misslingt, `return` vor `SetCurrent( csCurPersona )` (:2331) | ja, nur wenn das Dokument nicht angelegt werden kann |
| ImapDownload.cpp:789, :1032-1033 | `DownloadSingleMessage`: Postfach lässt sich nicht wieder öffnen, `return E_FAIL` vor :1098 | ja, nur in diesem Fehlerfall |
| sendmail.cpp:3847-3848, :3921-3922 | `SendMail`: nichts gespoolt, `return` ohne `SetCurrent( homie )` | nein, beide Aufrufer stellen danach selbst zurück (sendmail.cpp:3752, GetMail.cpp:245) |
| headervw, pophost, RegInfoReader, TocFrame, Trnslate, PersonalityView, SelectPersonalityDlg, QCImapMailboxDirector | `break` in inneren Schleifen oder `return` mit vorigem Zurückstellen | nein |

Über die Oberfläche bleibt also nur `ChangePassword`. Die zwei anderen Wege sind Fehlerfälle, die ich nicht nachstellen kann. Die Aussage in [E-39](../Intern/BEFUNDE.md#e-39) *„alle übrigen `SetCurrent`-Paare im Quelltext stellen die vorige Persönlichkeit wieder her“* stimmt so nicht (K6).

**Erreichbarkeit von Change Password.** Der Menüeintrag wird beim Start entfernt (`RemoveChangePassword`, eingebaut `1`, EudoraRes.rc:11283, mainfrm.cpp:8372-8373). Der Befehl selbst bleibt aber verdrahtet (`ON_COMMAND`, mainfrm.cpp:480), ohne `ON_UPDATE_COMMAND_UI`, das ihn sperren würde. Außerdem steht er in der Knopfgruppe *Special* des Dialogs *Customize Toolbar* (QCToolBarManager.cpp:185-197, :1078). Den Dialog erreicht man über das Kontextmenü der Werkzeugleiste, *Customize …* (EudoraRes.rc:6144). Ein Anwender kann sich den Knopf also auf die Leiste ziehen und damit `ChangePassword` aufrufen, auch wenn der Menüeintrag fehlt. Am Quelltext belegt, nicht gemessen. Der Prüfstand schickt `WM_COMMAND 32824` direkt an das Hauptfenster (messen-e39.ps1:218), und in `C:\Temp\E39\Mailverzeichnis\Eudora.ini` steht kein `RemoveChangePassword` (gemessen). Er trifft den Befehl also, aber nicht über einen Weg, den ein Anwender ab Werk hat.

## 4. Testsuite und Gegenproben (in meinem Baum)

Gemessen. Die Basis lief über `cmd /c Eudora71\Tests\RunTests.cmd`. Die Gegenproben liefen gegen das gebaute `EudoraTests.exe`, das `persona.cpp` zur Laufzeit liest. Ersetzt habe ich mit Perl `:raw`, Such- und Ersatztext kamen aus Dateien, die Trefferzahl war jeweils 1. Nach jedem Lauf habe ich die Sicherung zurückkopiert. `cmp` meldete keinen Unterschied, `git status` war leer.

| Lauf | Änderung in `persona.cpp` (vorübergehend) | Folge im Programm | Ergebnis |
|---|---|---|---|
| 0 | keine | – | 364/364 |
| G1 | `if ( bWarAktuell )` → `if ( FALSE && bWarAktuell )` | Behebung ganz abgeschaltet, [E-39](../Intern/BEFUNDE.md#e-39) wie vorher | **364/364, grün** (K1) |
| G2 | `RemoveIniFromCache( IDS_INI_SAVE_PASSWORD );` entfernt | `SavePassword` kommt in den gelöschten Abschnitt | 363/364, rot *„Remove nimmt SavePassword/SavePasswordText nicht aus dem Zwischenspeicher …“*. Positivprobe |
| G3 | `m_Passwords.RemoveKey` vor `SetCurrent( NULL )` gezogen | `SavePassInfo` legt das Kennwort gleich wieder ab, es wird nicht vergessen | **364/364, grün** (K1) |
| G4 | `SetCurrent( NULL );` entfernt (die Gegenprobe aus 6e7d3252) | kein Umschalten | 363/364, rot. Die Angabe im Commit stimmt |

`Test_E39_FlushSchreibtInAktuelle` prüft nur, dass die Bedingung aus rs.cpp:1239 irgendwo in `rs.cpp` steht, nicht in `FlushINIFile`. Das reicht für die Annahme, die er schützt. Kein Fund.

## 5. Messskript und Prüfstandsfälle

- **Trifft es den Weg?** Teilweise. Vorlauf, Löschen und Beenden laufen über echte Fenster und Befehle des Programms. Die Rückfrage wird am Text erkannt (messen-e39.ps1:285), die INI wird vor dem Löschen, direkt nach *Yes* und nach dem Ende gelesen. Das ist sauber. Den Befehl *Change Password* erreicht das Skript aber über eine Botschaft, die der ab Werk ausgeblendete Menüeintrag nicht hergibt (Abschnitt 3). Belegt.
- **Gegenprobe haltbar?** Für den alten Bau ja. `E39-alt` hat den Abschnitt `[Persona-E39Zwei]` mit `SavePasswordText=` (Eudora.ini:341-342, gemessen). Die „umgedrehte Gegenprobe“ ohne Vorlauf aus fd216aa2 ist im Skript kein Schalter. Sie ist also nicht als Fall nachfahrbar, nur aus der Commit-Nachricht belegt.
- **Was die Fälle nicht prüfen:** siehe K5.

## 6. Funde

### K1: TestE39 bleibt grün, wenn die Behebung abgeschaltet oder falsch geordnet ist

Gemessen (G1, G3). Der Test prüft, ob die fünf Zeilen vorhanden sind und ob `RemoveIniFromCache` vor `SetCurrent` steht. Er prüft nicht, dass sie unter `if ( bWarAktuell )` stehen und dass diese Bedingung unverändert aus dem Vergleich kommt. Mit `FALSE &&` ist [E-39](../Intern/BEFUNDE.md#e-39) wieder da, und die Suite bleibt grün. Er prüft auch nicht, dass `m_Passwords.RemoveKey` **nach** `SetCurrent( NULL )` steht. Vorher ist es wirkungslos, weil `SavePassInfo` (persona.cpp:1107-1113) das Kennwort beim Umschalten wieder ablegt. Der Kommentar im Test sagt selbst, dass die Reihenfolge zählt, prüft aber nur die eine Hälfte.

Vorschlag: nach `QT_LeerraumZusammen` die Folge `if ( bWarAktuell ) { RemoveIniFromCache( IDS_INI_SAVE_PASSWORD ); RemoveIniFromCache( IDS_INI_SAVE_PASSWORD_TEXT ); SetCurrent( NULL ); m_Passwords.RemoveKey( PersonaID ); }` als Ganzes verlangen, dazu `const BOOL bWarAktuell = ( m_Current.CompareNoCase( PersonaID ) == 0 );`. **Schwere: mittel** (die Suite schützt die Behebung nur gegen das Löschen einzelner Zeilen).

### K2: ChangePassword lässt die gewählte Persönlichkeit als aktuelle stehen (Vorschlag: eigener Befund E-203)

Am Quelltext belegt. `ChangePassword` schaltet bei mehreren Persönlichkeiten auf die im Dialog gewählte um (password.cpp:451-452). Fehlt das POP-Konto oder hat es kein „@“, kehrt es nach `ErrorDialog` mit `return (FALSE)` zurück (:457-459, :465-467). Das `SetCurrent( OrgPersona )` der beiden anderen Ausgänge (:521-522, :531-532) erreicht es nicht. Am Prüfstand gemessen ist, dass genau diese Meldung kommt (eudora.log Zeile 50: *„I can't tell where the machine name is in this POP Account“*) und dass die Persönlichkeit danach die aktuelle ist (Spurzeile `war-aktuell=1`).

[E-39](../Intern/BEFUNDE.md#e-39) führt das als „nur der Weg hierher, nicht behoben“. Die Folgen reichen aber weiter als das Löschen. Bis zum nächsten Umschalten auf eine *andere* Persönlichkeit liest jedes `GetIniString` ohne eigenes Umschalten zuerst ihren Abschnitt (rs.cpp:441-451). Was in dieser Zeit geändert wird, schreibt `FlushINIFile` aber nach `[Settings]` (rs.cpp:1253-1257). Die Mailprüfung über alle Persönlichkeiten stellt am Ende auf die *vorige* zurück (GetMail.cpp:245), und das ist eben diese. Der Zustand hält also bis zum Programmende. Belegt. Was der Anwender konkret sieht, habe ich nicht gemessen. Denkbar ist, dass *Tools → Options* Werte der Persönlichkeit zeigt und beim Speichern in die Hauptpersönlichkeit schreibt (Vermutung).

`befund-suchen.pl ChangePassword` findet nur [E-39](../Intern/BEFUNDE.md#e-39). Vorschlag: Behebung mit `if ( bMultiple ) g_Personalities.SetCurrent( OrgPersona );` vor beiden frühen `return`. Erreichbar ist der Weg ab Werk nur über einen selbst angelegten Werkzeugleisten-Knopf (Abschnitt 3). **Schwere: mittel**, nach der Legende in BEFUNDE.md wohl *wichtig*, *kritisch* nur, wenn die Options-Vermutung gemessen wird.

### K3: Das Kennwort einer gelöschten, nicht aktuellen Persönlichkeit bleibt im Speicher (Vorschlag: eigener Befund E-204)

Am Quelltext belegt. `m_Passwords.RemoveKey( PersonaID )` steht nur im Zweig `bWarAktuell` (persona.cpp:594). Jedes Umschalten weg von einer Persönlichkeit legt ihr `POPPassword` unter `m_Passwords["Persona-<Name>"]` ab (`SavePassInfo`, :1107-1113), also auch die Mailprüfung über alle Persönlichkeiten. Nach dem Löschen einer nicht aktuellen Persönlichkeit bleibt der Eintrag stehen. `Add` räumt `m_Passwords` nicht auf (persona.cpp:235-276). Legt der Anwender in derselben Sitzung eine neue Persönlichkeit mit demselben Namen an, findet `RestorePassInfo` beim ersten Umschalten das alte Kennwort (:1159). Dass Eudora es dann ohne Rückfrage an den Server der neuen Persönlichkeit schickt, ist eine Vermutung und nicht gemessen. `CMapStringToString::RemoveKey` vergleicht außerdem mit Groß- und Kleinschreibung, `bWarAktuell` ohne. Weicht die Schreibung ab, bleibt das Kennwort auch im aktuellen Fall stehen. Das ist ein Randfall, weil beide Namen aus `List()` kommen.

`befund-suchen.pl SavePassInfo`: kein Befund. Vorschlag: `m_Passwords.RemoveKey( PersonaID )` vor das `if`, und zwar unbedingt. Im aktuellen Fall muss es zusätzlich nach `SetCurrent( NULL )` stehen bleiben. **Schwere: mittel** (selten, aber nach der Legende *Sicherheit*, falls das Senden gemessen wird).

### K4: Die Stufe *kritisch* für E-39 ist mit der gemessenen Folge nicht haltbar

Gemessen ist ein Abschnitt `[Persona-E39Zwei]` mit der einzigen Zeile `SavePasswordText=` (E39-alt/Eudora.ini:341-342). `List()` liest Persönlichkeiten nur aus `[Personalities] PersonaN` (persona.cpp:660-682). Der verwaiste Abschnitt wird also nicht gelesen, und keine Einstellung geht verloren. Er wirkt erst, wenn eine neue Persönlichkeit desselben Namens entsteht. `Add` schreibt dann nur `SavePasswordText` (persona.cpp:1095-1099), ein zurückgekehrtes `SavePassword=` würde sie also erben. Belegt. Nach der Legende in BEFUNDE.md:147-149 ist das ein *Rest*, also *unkritisch*. Dazu kommt, dass der Auslöser ab Werk nur über einen selbst angelegten Knopf erreichbar ist (Abschnitt 3).

*Kritisch* wäre es, wenn in den Geisterabschnitt ein echtes, kodiertes Kennwort zurückkehren kann. Etwa so: Eine Mailprüfung endet bei der festsitzenden Persönlichkeit, nachdem dort ein Kennwort mit *Remember* eingegeben wurde, und danach wird gelöscht. Das ist eine Vermutung, nicht gemessen. Die Behebung deckt diesen Fall mit ab. **Schwere: gering** (Einstufung, Entscheidung Gregor).

### K5: Der Prüfstandsfall prüft nicht, ob die gelöschte wirklich die aktuelle war

Belegt an tools/pruefstand-faelle.txt (`E-39p`/`E-39v`/`E-39w`) und messen-e39.ps1. `E-39p` erwartet `aktuell-danach=<Dominant>`. Den Wert hat die Spurzeile aber auch bei `war-aktuell=0`. `E-39v` erwartet `kennwort-meldung`, und das setzt das Skript bei **jedem** neuen Dialog nach *OK* (:225-231). Den Text gibt es aus, prüft ihn aber nicht. Wird K2 behoben oder ändert sich der Dialog, bleiben alle drei Fälle grün, und der Prüfstand fährt das Löschen einer *nicht* aktuellen Persönlichkeit. Das ist der Fall, den [E-39](../Intern/BEFUNDE.md#e-39) gerade nicht betrifft. Vorschlag: `war-aktuell=` in die ERGEBNIS-Zeile übernehmen und in `E-39p` `war-aktuell=1` verlangen. Außerdem `kennwort-meldung` nur setzen, wenn der Text `machine name` enthält. **Schwere: gering.**

### K6: Doku nennt einen Menüweg, den es ab Werk nicht gibt, und behauptet zu viel über die SetCurrent-Paare

- README (*Bekannte Fehler*), CHANGELOG und [E-39](../Intern/BEFUNDE.md#e-39) nennen *Special → Change Password* als Weg. Der Eintrag ist ab Werk ausgeblendet (Doku/FUNKTIONEN.md:214, mainfrm.cpp:8372-8373). Der Anwender findet ihn nicht. Erreichbar ist der Befehl über *Customize Toolbar* oder `RemoveChangePassword=0`. Belegt.
- [E-39](../Intern/BEFUNDE.md#e-39) sagt *„alle übrigen `SetCurrent`-Paare im Quelltext stellen die vorige Persönlichkeit wieder her“*. compmsgd.cpp:2251 und ImapDownload.cpp:1033 tun es in Fehlerfällen nicht (Abschnitt 3). Belegt.

**Schwere: gering.**

### K7: Nach dem Löschen bleibt das Spool-Verzeichnis der Persönlichkeit stehen

Gemessen: `C:\Temp\E39\Mailverzeichnis\spool\E39Zwei\` und `C:\Temp\E39-alt\Mailverzeichnis\spool\E39Zwei\` stehen nach dem Lauf noch da. Der Abschnitt ist im neuen Bau weg. `Add` legt den Spool-Verwalter an (`QCSpoolMgrMT::CreateSpoolMgr`, persona.cpp:262), `Remove` räumt ihn nicht ab. Das steht so im übernommenen Quelltext und ist von [E-39](../Intern/BEFUNDE.md#e-39) unabhängig. Bei einer Neuanlage desselben Namens würde der alte Spool weiterbenutzt (Vermutung). **Schwere: gering.**

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| K1 | `TestE39` bleibt grün mit abgeschalteter Bedingung (`FALSE && bWarAktuell`) und mit `RemoveKey` vor `SetCurrent` | mittel | nein, vor dem Merge nachschärfen |
| K2 | `ChangePassword` lässt bei Konto ohne „@“ die gewählte Persönlichkeit bis Programmende als aktuelle stehen; Einstellungen lesen aus ihr, schreiben nach `[Settings]` (Vorschlag [E-203](../Intern/BEFUNDE.md#e-203)) | mittel | nein |
| K3 | Kennwort einer gelöschten, nicht aktuellen Persönlichkeit bleibt in `m_Passwords`; gleichnamige Neuanlage in derselben Sitzung erbt es (Vorschlag [E-204](../Intern/BEFUNDE.md#e-204)) | mittel | nein |
| K4 | Gemessene Folge von [E-39](../Intern/BEFUNDE.md#e-39) ist ein verwaister Abschnitt mit leerer Zeile, den Eudora nicht liest; *kritisch* nur bei zurückkehrendem echtem Kennwort (Vermutung) | gering | nein, Entscheidung Gregor |
| K5 | `E-39p`/`E-39v` prüfen weder `war-aktuell=1` noch den Meldungstext; Fälle blieben grün, wenn der Vorlauf nicht mehr wirkt | gering | nein |
| K6 | README/CHANGELOG/[E-39](../Intern/BEFUNDE.md#e-39) nennen den ab Werk ausgeblendeten Menüweg; Aussage über alle `SetCurrent`-Paare zu weit | gering | nein |
| K7 | `spool\<Name>\` bleibt nach dem Löschen stehen (Originalverhalten) | gering | nein |
