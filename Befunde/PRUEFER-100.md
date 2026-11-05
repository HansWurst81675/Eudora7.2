# <a id="pruefer-100"></a>PRUEFER-100

Geprüft habe ich den Zweig `e223_e222_e193rest`. Mein Zweig ist wt/pruefer-20261105, abgezweigt von `origin/e223_e222_e193rest` (Stand `d8b2b1f1`). Geprüft ist alles, was seit `2c8c2790` unter `Eudora71/`, `tools/` und `Releases/1.0` dazukam: [E-223](../Intern/BEFUNDE.md#e-223) (`POPSession.cpp`), [E-222](../Intern/BEFUNDE.md#e-222) (`TridentView.cpp`, `Trnslate.cpp`), die Tests `TestE222.cpp` und `TestE223.cpp`, die Messskripte `messen-e223.ps1`, `messen-e222.ps1` und `messen-e193f.ps1` und die neuen Fälle in `pruefstand-faelle.txt`. Unter `Releases/1.0` hat sich nichts geändert. Eudora habe ich weder gebaut noch gestartet, kein Fenster geöffnet und keinen Prüfstand angefasst. Die Testsuite habe ich in meinem Baum gebaut und gefahren. Die Prüfstandläufe stehen im Befund, gemessen habe ich sie nicht.

## Ergebnis vorweg

Beide Behebungen tun am Quelltext, was sie sollen. Die Testsuite läuft mit **424/424** (gemessen). Mit den alten drei Quelldateien sind genau die drei neuen Tests rot, mit einer auskommentierten Behebung (`#if 0`) ebenfalls (gemessen, §4).

**Das Wichtigste betrifft Gregors laufenden Test, nicht den Code (K1).** Schritt 3 im Testplan sagt: eine Persönlichkeit nehmen, deren Kennwort nicht gespeichert ist, *„oder vorher Special → Forget Password(s)“*. *Forget Password* löscht aber nur das gespeicherte Kennwort, nicht das Häkchen *Remember password*. Ist das Häkchen schon gesetzt, erscheint es im Dialog schon angehakt, und dann hat auch das alte 7.2.2.133 das Kennwort sofort gespeichert. Der Test besteht in diesem Fall mit und ohne Behebung. Er zeigt den Fehler nur, wenn das Häkchen im Dialog **leer** ist und Gregor es selbst setzt.

Bei [E-223](../Intern/BEFUNDE.md#e-223) stimmt der Persönlichkeitskontext auf allen drei Wegen, auf denen der Kennwortdialog für POP kommt. IMAP ist nicht betroffen. Die Behebung behebt nebenbei auch die Gegenrichtung: wer das Häkchen im Dialog **abwählt**, dessen Kennwort hat das alte Programm trotzdem gespeichert (K2, Gewinn, aber nicht dokumentiert). Neu erreichbar ist ein Randfall mit falschem Kennwort (K3).

Bei [E-222](../Intern/BEFUNDE.md#e-222) trifft das Messskript den Weg des Mausklicks. Der Prüfstand legt die `.ems` aber in einen Pfad ohne Leerzeichen und ohne Umlaut (K4, Vermutung). `messen-e193f.ps1` misst nur Mails in windows-1252 mit 8bit. Der Befund schreibt das Ergebnis allgemeiner, als die Messung trägt (K5).

**Kein Fund hält das Paket oder den Merge auf.** K1 sollte Gregor sofort erfahren, weil er gerade testet. Neue E-Kennungen habe ich nicht vergeben.

## 1. E-223: Was die Behebung tut

**Der Ablauf (am Quelltext belegt).** `CPOPSession::GetPOPPassword_` (`POPSession.cpp:2848-2885`) liest `SavePass` aus `QCPOPSettings` (:2852). Dessen `GrabSettings` hat `SavePassword` beim Anlegen gelesen (`QCMailSettings.cpp:188`), also vor dem Dialog. Der Dialog `GetPassword` (`password.cpp:157-185`) schreibt das Häkchen bei OK mit `SetIniLong` in den INI-Zwischenspeicher (:177) und löscht bei leerem Häkchen ein gespeichertes Kennwort (:178-179). Die Behebung liest danach `GetIniShort(IDS_INI_SAVE_PASSWORD)` neu (:2867). Das liest denselben Zwischenspeicher, in den der Dialog eben geschrieben hat. Auf die Platte muss dafür nichts.

**Abbruch im Dialog (belegt).** Bei *Cancel* oder leerem Kennwort gibt `GetPassword` FALSE zurück, ohne etwas zu schreiben, und `GetPOPPassword_` kehrt vor dem Neulesen mit -1 zurück (:2860-2861). Unverändert.

**Die Persönlichkeit (belegt).** `QCPOPSettings::GrabSettings` schaltet für das Lesen auf seine eigene Persönlichkeit und danach zurück (`QCMailSettings.cpp:144-145`). `GetPassword` wird hier ohne Persönlichkeit aufgerufen und arbeitet in der **aktuellen** (`password.cpp:162-166`). Das Neulesen arbeitet ebenfalls in der aktuellen. Der neue Wert kommt also immer aus derselben Persönlichkeit, in die der Dialog geschrieben hat. Ob die aktuelle die richtige ist, entscheidet der Aufrufer:

| Aufrufer | aktuelle Persönlichkeit beim Dialog | Persönlichkeit von `QCPOPSettings` | gleich? |
|---|---|---|---|
| *Check Mail*, `GetMail.cpp:179` | `SetCurrent(Persona)` in :154 | `Persona` (:174) | ja |
| Senden über POP, `SMTPSession.cpp:931` (`PreProcessPOPSend`) | `strRelayPersona`, `sendmail.cpp:3934` bzw. :3853 | `m_strPersona` = `strRelayPersona` (`sendmail.cpp:3955`) | ja |
| SMTP-Anmeldung mit POP-Kennwort, `SMTPSession.cpp:1426` (`GetLogin`, aus :953) | wie oben | `m_strPersona` | ja |

`::POPPassword` gehört ohnehin zur aktuellen Persönlichkeit (`persona.cpp`, `SavePassInfo`/`RestorePassInfo`). `SetIniString(IDS_INI_SAVE_PASSWORD_TEXT, …)` schreibt `rs.cpp:1239-1251` ausdrücklich in die aktuelle. Die Behebung macht den Ablauf also einheitlicher als vorher: vorher stammte nur `SavePass` aus `QCPOPSettings`, alles andere aus der aktuellen Persönlichkeit.

**IMAP (belegt).** `CImapAccount::Login` ruft `GetPassword(…, m_strPersona)` (`EuImap/src/ImapAccount.cpp:3849`) und fragt erst danach `MustSavePasswordToDisk` (:3879). Das liest `SavePassword` beim Aufruf in der eigenen Persönlichkeit (:1172-1178). IMAP war nicht betroffen. Der Befund stimmt.

**Das falsche Kennwort (belegt, Teil von K3).** Mit Häkchen wird das Kennwort jetzt schon beim ersten Mal **vor** der Anmeldung gespeichert (:2868-2869). Lehnt der Server ab, setzt `POPSession.cpp:1839` `m_bCleanup`, weil `m_Settings->GetSavePass()` (vor dem Dialog gelesen) leer ist. Der Destruktor löscht das Kennwort dann wieder (:356-357, `ClearPassword`). Das ist der Normalfall und richtig. Ausnahmen siehe K3.

## 2. E-222: Was die Behebung tut

**Der Weg (belegt).** `msgutils.cpp:2155-2231` baut aus der Zeile `Run Plugin:"<pfad>.ems <5335.0002>"` den Anker `href="file://<pfad> <5335.0002>" EUDORA=PLUGIN`. Vorher prüft es die Kennung schon selbst mit `sscanf(…) == 2` (:2203). Beim Klick holt `CTridentView::DoSpecialAttachment` den Verweis von Trident (`TridentView.cpp:2934`), schneidet `file:///` ab (:2970), wandelt `%20` und jetzt auch `%3C`/`%3c`/`%3E`/`%3e` zurück (:2973-2983) und gibt ihn an `XLateDisplay` (:3015). Dort trennt `strstr(inFileCmd, ".ems ")` Pfad und Kennung (`Trnslate.cpp:4191-4201`). `InterpretFile` liest die Kennung (:4513-4526).

**Die beiden Aufrufer (belegt).** `DoSpecialAttachment` wird aus `TridentView.cpp:3072` und :3344 gerufen. Es gilt für Nachrichtenfenster (`CTridentReadMessageView`) und Vorschau (`CTridentPreviewView`) gleich (:2997-3006). Die Textansicht (Paige, `PgHLinks.cpp:272`, :340) gibt den Verweis unkodiert weiter und war nie betroffen.

**Auch die Registrierungs-Anhänge (belegt, harmlos).** Die Rückwandlung gilt auch für `isEudoraInfoAttachment` (:3018-3021). Ein Windows-Dateiname kann weder `<` noch `>` enthalten. Ein wörtliches `%3C` im Dateinamen gibt es praktisch nicht.

**`sscanf` (belegt).** `moduleID` und `transID` sind jetzt mit 0 vorbelegt, und `GetTranslator` läuft nur bei zwei erkannten Feldern (:4516-4520). Sonst kommt dieselbe Meldung wie bisher. Damit verhält sich `InterpretFile` wie die Anzeige in `msgutils.cpp:2203`. `firstTrans` ist bei den anderen beiden Aufrufen NULL (`TransReader.cpp:208`, `Trnslate.cpp:4686`), dort ändert sich nichts.

## 3. Treffen die Messskripte den Weg?

**`messen-e223.ps1` (am Skript belegt).** Es stellt `[Settings]` auf `SavePassword=0` ohne `SavePasswordText` und ohne weitere Persönlichkeiten. Es schickt *File → Check Mail* (32772), also `GetMail.cpp:179` → `DoGetPassword_` → `GetPOPPassword_`. Das Häkchen setzt es per `BM_SETCHECK` und liest es zurück. `DDX_Check` liest beim OK genau diesen Zustand (`password.cpp:94`). Dann *File → Exit* und die INI lesen. Das ist der Weg des Fehlers, und die Ausgangslage `SavePassword=0` ist genau die, in der er auftritt. Die Positivprobe (Kennwortfrage kam, Häkchen gesetzt, `PASS` kam am Prüfserver an) schließt einen blinden Lauf aus. Am alten Bau `ini-kennwort=0`, am neuen `=1`. Die Messung unterscheidet also. Nicht gemessen: die Gegenrichtung (K2) und das falsche Kennwort (K3). Der Befund sagt das selbst.

**`messen-e222.ps1` (am Skript belegt).** Die Nachricht mit der Zeile `Run Plugin:` wird von Hand nach `In.mbx` gelegt, nicht vom Plugin beim Abruf erzeugt. Für den Klick ist das gleich, weil die Anzeige die Zeile in beiden Fällen in `msgutils.cpp` in einen Anker verwandelt. Der Klick geht als `WM_LBUTTONDOWN`/`UP` an das Fenster `Internet Explorer_Server` an die Mitte des Ankers. `elementFromPoint` prüft vorher, dass der Punkt den Anker trifft. Das ist der Weg des Mausklicks über `LaunchURL` → `DoSpecialAttachment` (:3072). Der Fall `E-222p` lässt jede Kennung außer `kodiert` als grün gelten. Das ist richtig, denn am Prüfstand fehlt CAPICOM, und „erkannt“ oder ein Fehler des Plugins selbst sind beide schon hinter der Behebung. `E-222w` verlangt zusätzlich, dass der Klick sichtbar etwas bewirkt hat. Eine Grenze siehe K4.

**`messen-e193f.ps1` (am Skript und an den Testdaten belegt).** Es misst *Edit → Find* über `WM_FINDREPLACE` (`E-193f`) und über den echten Suchdialog (`E-193fd`), je Mail und Wort ein frisches Fenster, mit „Zebrafink“ als Gegenprobe. Das trifft den Weg des Anwenders. Alle acht Testmails sind aber `Content-Type: text/html; charset="windows-1252"` mit `Content-Transfer-Encoding: 8bit`, der Umlaut steht roh als Byte (`Testdaten/e193-f1.eml` bis `-f8.eml`). Siehe K5.

## 4. Gegenproben an den Tests

Alle gemessen in meinem Baum, danach die drei Quelldateien aus einer Sicherung zurückgeholt und mit `cmp` als byte-gleich bestätigt. `git status` war danach leer.

| Lauf | Quelle | Ergebnis |
|---|---|---|
| 1 | Zweigstand `d8b2b1f1` | 424/424 grün |
| 2 | `POPSession.cpp`, `TridentView.cpp`, `Trnslate.cpp` aus `2c8c2790` | 421/424, rot genau: [E-222](../Intern/BEFUNDE.md#e-222) Klammern, [E-222](../Intern/BEFUNDE.md#e-222) `sscanf`, [E-223](../Intern/BEFUNDE.md#e-223) Neulesen |
| 3 | Behebung [E-223](../Intern/BEFUNDE.md#e-223) und die vier `Replace` von [E-222](../Intern/BEFUNDE.md#e-222) je in `#if 0 … #endif` | 422/424, rot: [E-222](../Intern/BEFUNDE.md#e-222) Klammern, [E-223](../Intern/BEFUNDE.md#e-223) Neulesen |

Lauf 3 zeigt: der Test erkennt auch eine stillgelegte Behebung, nicht nur eine fehlende. `TestE223` prüft zusätzlich, dass `m_Settings->SavePass()` genau einmal vorkommt und das Speichern-oder-Löschen danach noch an `SavePass` hängt. Das deckt ab, dass jemand das Neulesen durch einen zweiten Aufruf von `QCPOPSettings` ersetzt. Die Tests lesen nur Quelltext. Dass der Weg im Programm wirkt, zeigen die Prüfstände.

## Funde

### <a id="k1"></a>K1 (mittel, belegt): Testplan-Schritt 3 besteht auch am alten Bau, wenn Gregor *Forget Password* nimmt

- **Wo:** `Intern/TESTPLAN.md`, Schritt 3: *„Eine Persönlichkeit nehmen, deren Kennwort nicht gespeichert ist (oder vorher Special → Forget Password(s)).“*
- **Was passiert:** *Forget Password* geht über `ForgetPasswordByDialog` (`password.cpp:705-728`) nach `CPersonality::ForgetPasswords` (`persona.cpp:891-914`). Das löscht nur `SavePasswordText` und `POPPassword`, nicht `SavePassword`. Hatte die Persönlichkeit das Häkchen schon, zeigt der Dialog es angehakt (`password.cpp:170`). Dann ist auch `SavePass` aus `QCPOPSettings` schon 1, und das alte Programm hat das Kennwort sofort gespeichert. Der Fehler tritt nur auf, wenn `SavePassword` vorher 0 ist. Gregors Persönlichkeit `<Dominant>` hat laut Befund seit dem 04.11.2026 `SavePassword=1`.
- **Folge:** Mit *Forget Password* an `<Dominant>` besteht der Schritt am neuen und am alten Bau. Er sagt dann nichts über [E-223](../Intern/BEFUNDE.md#e-223).
- **Vorschlag:** Den Schritt so fassen: *„Im Kennwortdialog muss das Häkchen Remember password **leer** sein, bevor du es setzt. Ist es schon angehakt, vorher unter Tools → Options → Checking Mail ‚Save password‘ abwählen, OK, dann Special → Forget Password(s).“* Gregor sofort Bescheid geben, weil er gerade testet. War das Häkchen bei seinem Test schon angehakt, ist Schritt 3 nicht aussagekräftig. Gemessen ist der Fehler am Prüfstand trotzdem (`E-223p`).

### <a id="k2"></a>K2 (gering, belegt): Die Behebung ändert auch das Abwählen des Häkchens, und das steht nirgends

- **Wo:** `POPSession.cpp:2852`, :2867-2869, `password.cpp:177-179`.
- **Was passiert (altes Programm):** Persönlichkeit mit `SavePassword=1`, aber ohne gespeichertes Kennwort (etwa nach *Forget Password*). Der Dialog kommt angehakt, der Anwender **wählt das Häkchen ab**. `GetPassword` schreibt `SavePassword=0` und löscht `SavePasswordText`. Danach schrieb `GetPOPPassword_` mit dem alten `SavePass=1` das Kennwort **doch** in die INI (:2868-2869). Es landete beim Beenden auf der Platte, obwohl der Anwender es nicht wollte. Gelöscht wurde es erst beim nächsten Abruf im nächsten Lauf (`else if (!SavePass && pszPasswordText)`, :2877-2878).
- **Mit der Behebung:** `SavePass` ist nach dem Dialog 0, das Kennwort wird nicht geschrieben. Richtig.
- **Folge:** Ein Gewinn, aber weder im Befund noch im Kommentar noch im Test genannt, und nicht gemessen.
- **Vorschlag:** Im Befund unter *Behebung* einen Satz nachtragen. `messen-e223.ps1` könnte die Gegenrichtung als zweiten Fall bekommen (`SavePassword=1`, kein Text, Häkchen per `BM_SETCHECK` 0, danach erwartet `SavePasswordText` fehlt). Nicht dringend.

### <a id="k3"></a>K3 (gering, belegt): Falsches Kennwort mit Häkchen bleibt bei manchen Servern gespeichert

- **Wo:** `POPSession.cpp:1839-1876`, Destruktor :356-357.
- **Was passiert:** Mit der Behebung wird ein Kennwort mit Häkchen schon beim ersten Mal vor der Anmeldung gespeichert. Lehnt der Server ab, löscht Eudora es normalerweise wieder (K3 gilt nicht für den Normalfall). Kündigt der Server aber `RESP-CODES`/`AUTH-RESP-CODE` an und antwortet ohne `[AUTH]`, setzt :1849-1850 `m_bCleanup = false`. Dasselbe gilt, wenn die Antwort ein Wort aus `PasswordOKWordList` enthält (:1862-1872). Dann bleibt das falsche Kennwort gespeichert. Beim nächsten Abruf kommt kein Dialog, nur wieder die Ablehnung. Heraus kommt der Anwender nur mit *Forget Password*.
- **Neu ist nur der Zeitpunkt:** Wer das Häkchen schon hatte, hatte diesen Ablauf auch im Original. Neu ist er jetzt schon beim ersten Setzen.
- **Folge:** Randfall, nichts geht verloren. Gregors Messplan im Befund nennt die Gegenprobe „erst falsches Kennwort mit Häkchen“, gemessen ist sie nicht.
- **Vorschlag:** Keiner für dieses Paket. Im Befund als bekannte Grenze vermerken.

### <a id="k4"></a>K4 (gering, Vermutung): E-222 ist nur an einem Anhangspfad ohne Leerzeichen und ohne Umlaut gemessen

- **Wo:** `messen-e222.ps1`, `-Vorbereiten`: `.ems` liegt unter `C:\Temp\E222\Mailverzeichnis\attach`. `TridentView.cpp:2973-2983`.
- **Was passiert:** Leerzeichen im Pfad wandelt `%20` seit jeher zurück (belegt), das ist nur am Prüfstand nicht mitgemessen. Steht im Pfad ein Umlaut, etwa im Benutzernamen unter `C:\Users\…`, kodiert Trident ihn vermutlich als `%C3%BC` oder `%FC`. Den wandelt niemand zurück. Dann findet `CTLMime::CreateMimeType` (`Trnslate.cpp:4529`) die Datei nicht, und `DeMimeMsg` läuft auf einen Pfad, den es nicht gibt (:4551). Was der Anwender dann sieht, ist ungemessen.
- **Folge:** Der Befund nennt das volle Zurückwandeln schon als „nicht umgesetzt“. Für Gregor ist das nur wichtig, wenn sein Anhangsordner einen Umlaut hat.
- **Vorschlag:** Bei Gregors Test nachsehen, ob der Pfad in der Zeile `Run Plugin:` Leerzeichen oder Umlaute hat. Beim nächsten Prüfstandlauf den Anhangsordner einmal mit Leerzeichen anlegen. Das ist ein billiger Fall.

### <a id="k5"></a>K5 (gering, belegt): „Emoji und inneres charset widerlegt“ gilt nur für windows-1252 mit 8bit

- **Wo:** `Testdaten/e193-f1.eml` bis `-f8.eml`, alle `charset="windows-1252"`, `Content-Transfer-Encoding: 8bit`. Der Befund [E-193](../Intern/BEFUNDE.md#e-193) schreibt: *„Weder die Emoji noch das innere charset sind die Ursache.“*
- **Was passiert:** Weitergeleitete Outlook-Rundmails kommen oft als `quoted-printable` oder in UTF-8. Dann übersetzt Eudora beim Empfang, und das innere `meta charset=utf-8` trifft auf andere Bytes als in der Messung. Welche Kodierung Gregors Mail hatte, steht weder im Befund noch im Skript.
- **Folge:** Die Messung widerlegt die Vermutung nur für diese Kodierung. Der Befund nennt die echte Anzeigedatei `eud*.htm` schon als nächsten Schritt. Das deckt die Lücke ab, sobald sie da ist.
- **Vorschlag:** Den Satz im Befund auf „bei windows-1252, 8bit“ einschränken. Aus dem Kopf von Gregors Mail `Content-Type` und `Content-Transfer-Encoding` notieren. Den Inhalt nicht ins Repo legen.

## Hinweise (keine Funde)

- **T1 (belegt):** `DisableSavePassword` (`IDS_DISABLE_SAVE_PASSWORD`) sperrt das Häkchen nur im Einstellungsfenster (`settings.cpp:2091-2095`) und setzt es beim Start auf 0 (`eudora.cpp:1227-1228`). Im Kennwortdialog bleibt es bedienbar. Das alte Programm speicherte dann beim zweiten Abruf derselben Sitzung (`SavePass` aus dem Zwischenspeicher, :2875-2876), die Behebung schon beim ersten. Original, durch die Behebung nur früher.
- **T2 (belegt):** Der Kommentar zu [E-223](../Intern/BEFUNDE.md#e-223) sagt „in die INI geschrieben“. Gemeint ist der INI-Zwischenspeicher, auf die Platte kommt der Wert erst beim Beenden. Für die Behebung ist das gleich, weil `GetIniShort` denselben Zwischenspeicher liest.
- **T3 (belegt):** `XLateDisplay` schreibt in den Puffer von `szHRef`, den es als `const char*` bekommt (`Trnslate.cpp:4192-4195`). Original, ohne Folge, weil `szHRef` danach nicht mehr gebraucht wird.
- **T4 (belegt):** `Version.h` stand bei diesem Bericht (05.11.2026) auf 7.2.2.134 in allen vier Angaben, `Tests.vcxproj` und `TestMain.cpp` führen beide neuen Testdateien genau einmal, keine Fallkennung in `pruefstand-faelle.txt` steht doppelt.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| [K1](#k1) | Testplan-Schritt 3 mit *Forget Password* besteht auch am alten Bau, weil das Häkchen gesetzt bleibt | mittel | nein; Gregor sofort sagen, Schritt neu fassen |
| [K2](#k2) | Behebung verhindert auch das Speichern trotz abgewähltem Häkchen; undokumentiert, ungemessen | gering | nein |
| [K3](#k3) | falsches Kennwort mit Häkchen bleibt bei Servern mit `AUTH-RESP-CODE` ohne `[AUTH]` gespeichert, jetzt schon beim ersten Mal | gering | nein |
| [K4](#k4) | [E-222](../Intern/BEFUNDE.md#e-222) nur an ASCII-Pfad ohne Leerzeichen gemessen; Umlaut im Anhangspfad vermutlich weiter kaputt | gering | nein |
| [K5](#k5) | E-193f widerlegt Emoji/inneres charset nur für windows-1252 mit 8bit | gering | nein |
| T1 | `DisableSavePassword` wirkt im Kennwortdialog nicht (Original) | – | nein |
| T2 | „INI“ im Kommentar meint den Zwischenspeicher | – | nein |
| T3 | `XLateDisplay` schreibt in einen `const`-Puffer (Original) | – | nein |
| T4 | Version, Testprojekt, Fallliste stimmig | – | nein |
