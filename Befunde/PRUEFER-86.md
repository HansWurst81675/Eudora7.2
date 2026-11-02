# <a id="pruefer-86"></a>PRUEFER-86

Lauf nach PRUEFER-85 (liegt auf `e39_persona_loeschen`, noch nicht auf `main`). Geprüft wurde `456c95e1..HEAD -- Eudora71 tools Releases/1.0` auf Zweig wt/pruefer-20261102f (von `origin/e194_e196_speichern_unter`, Stand 8898df05). Inhaltlich sind das 522b8bbb (Zweig, Prüfnachricht), 7869f5cb (Behebung, Tests, Messskript) und 8898df05 (Merge von #206, neuer Befund [E-205](../Intern/BEFUNDE.md#e-205)). Schwerpunkte: [E-194](../Intern/BEFUNDE.md#e-194), [E-195](../Intern/BEFUNDE.md#e-195), [E-196](../Intern/BEFUNDE.md#e-196), ihre Rückwirkung auf [E-140](../Intern/BEFUNDE.md#e-140) und [E-177](../Intern/BEFUNDE.md#e-177), `TestE194.cpp`, `TestE196.cpp`, `tools/messen-e194.ps1` und [E-205](../Intern/BEFUNDE.md#e-205). Eudora habe ich weder gebaut noch gestartet. `C:\Temp\E194`, `E194K`, `E194-alt`, `E194K-alt`, `E194-140`, `E194-177` und `E194-178` habe ich nur gelesen.

## Ergebnis vorweg

Die drei Behebungen tun, was sie sollen. Aus der Postfachliste gespeichert, steht in der Datei kein `<x-flowed>` mehr, der Kopf sagt `format=flowed`, die Zeilen bleiben wie in der Mail. Die `.htm`-Dateien beider Fenster tragen jetzt eine Zeichensatzangabe. Der Speicherdialog der Nachrichtenfenster bietet kein `.rtf` mehr an. Das zeigen die Dateien in `C:\Temp\E194` und `E194K` gegen `E194-alt` und `E194K-alt`. Die Testsuite läuft mit 378/378, sechs von sieben Gegenproben werden rot.

Zwei Dinge halte ich für wichtiger als die Behebungen selbst. Erstens ist die Ursache von [E-205](../Intern/BEFUNDE.md#e-205) am Quelltext belegt, und sie reicht weiter als die Datei: Jedes *Speichern unter* mit Kopfzeilen schreibt die Uhrzeit der Nachricht in der Zusammenfassung um. Bei einer Nachricht, die mit *Send Later* auf eine Uhrzeit gestellt ist, verschiebt jedes solche Speichern den Sendezeitpunkt um die Zeitzone, also um eine Stunde im Winter (K1, Kette belegt, Folge nicht gemessen). Zweitens stimmt die Begründung zu [E-195](../Intern/BEFUNDE.md#e-195) nicht ganz. Das Fenster für Textdateien (*File → New*, *File → Open*) schreibt bei `.rtf` echtes RTF. Dort war der gestrichene Eintrag also kein leeres Versprechen (K2).

Dazu kommen fünf kleine Funde zum Kern, einer zu `E196HtmlZeichensatz`, einer zum Test und einer zum Messskript (K3 bis K9). Ein neuer Fund liegt außerhalb des Zweigs: *Speichern unter* als `.txt` aus dem Nachrichtenfenster ohne Kopfzeilen lässt die Zitatzeichen `>` weg. Zitierter Text ist in der Datei dann nicht mehr von eigenem zu unterscheiden (K10, gemessen, Originalverhalten). Vorschlag dafür: [E-206](../Intern/BEFUNDE.md#e-206).

Für das Paket: Keiner der Funde hält das nächste Paket auf. Über K1 sollte Gregor entscheiden, bevor [E-205](../Intern/BEFUNDE.md#e-205) als *wichtig* stehen bleibt. K2 ist eine Entscheidung, ob das Textdatei-Fenster seinen RTF-Eintrag zurückbekommt.

## 1. Die Behebung am Quelltext

**[E-194](../Intern/BEFUNDE.md#e-194), Kern `E101SpeicherfassungAufbereiten`.**

- **Erkennung.** `<x-html` (mit Zusätzen), `<x-flowed>` und `<x-rich>` werden nur als Anfang des Rumpfs erkannt (msgutils.cpp:4016-4021). Das passt zum Empfangsweg: TextReader.cpp:136-142 schreibt `<x-flowed>` mit `PutLine` auf eine eigene Zeile, :107-110 `<x-rich>` mit `Put` ohne Zeilenende. Text in derselben Zeile bleibt nach [P-28](PRUEFER-14.md#p-28) stehen (msgutils.cpp:4107-4119). Die Gegenstücke stehen in :392-408. Belegt.
- **Gegenstück vor einer Anhangszeile.** Für x-flowed und x-rich wird das letzte `</…>` auch dann entfernt, wenn danach noch Text folgt. Bedingung ist, dass es allein auf seiner Zeile steht (msgutils.cpp:4173-4183). Für x-html bleibt es bei [P-19](PRUEFER-13.md#p-19) (`!bWarHtml`, :4175). Belegt, Folge siehe K4.
- **Angabe im Kopf.** `format=flowed` wird in beiden Zweigen angehängt, in denen der Kern selbst eine Content-Type-Zeile schreibt (:4606-4607 mit Kopf, :4665-4666 ohne). Eine vorgefundene Zeile, die stehen bleibt, behält ihre eigenen Parameter. Belegt.
- **Ohne Kopfzeilen und ohne Hochbytes** bekommt x-flowed keinen Kopf (:4613, `bWarFlowed` fehlt dort absichtlich, Test `Test_E194_NurAscii`). Dann geht die Angabe `format=flowed` verloren. Die Zeilen bleiben aber, also geht kein Text verloren. Das ist vertretbar und kein Fund.
- **Untertyp.** `enriched` nur bei `bWarRich` und nur, wenn weder Marker noch Kopf HTML sagen (:4466-4467). Belegt, siehe K5.
- **Spur.** `huelle=` am Ende (:4682, :4697). Gemessen in `C:\Temp\E194\Mailverzeichnis\eudora.log`: `… rumpf-vorher=298 rumpf-nachher=275 … huelle=x-flowed`. Die 23 Byte Unterschied sind `<x-flowed>\r\n` (12) und `</x-flowed>` ohne Zeilenende (11) am Ende des Postfachtexts.

**Rückwirkung auf [E-140](../Intern/BEFUNDE.md#e-140) und [E-177](../Intern/BEFUNDE.md#e-177).** Beide laufen über `E140TextFuerDatei` in denselben Kern (ReadMessageDoc.cpp:594, :599 für die Filteraktion, :668, :681 und compmsgd.cpp:3476, :3489 für die Fenster). Was sich für sie ändert: eine Hülle `x-flowed` oder `x-rich` wird jetzt abgenommen. Vorher ging sie mit hinaus, an das Programm der Filteraktion genauso. Am Prüfstand gemessen ist nur der Fall ohne Hülle. In `C:\Temp\E194-140` und `E194-177` steht in jeder Spurzeile `huelle=-`. Eine Mail mit `format=flowed` über *Notify Application* ist nicht gemessen. Am Kern ist sie durch `Test_E194_MitKopf` abgedeckt (Kopfzeilen, Hochbytes, `ct-ersetzt`). Mit Kopfzeilen gemessen ist das Nachrichtenfenster: `E194K\…\e194-lesen.txt` trägt `X-Original-Content-Type: text/plain; charset=utf-8; format=flowed` und darunter die neue Zeile mit `format=flowed`. Der Rumpf ist roh, die Zitatzeichen und weichen Umbrüche stehen da.

**[E-195](../Intern/BEFUNDE.md#e-195), Filter.** `IDS_TXT_HTML_FILE_FILTER` nutzen compmsgd.cpp:3358, saveas.cpp:92 (Nachrichtenfenster), signatur.cpp:73 und textfile.cpp:110. Die ersten drei werten die Endung `.rtf` nicht aus. Belegt. `textfile.cpp` tut es über den View, siehe K2. Ein Filterindex wird nirgends ausgewertet (`nFilterIndex` kommt im Quelltext nicht vor), das Streichen verschiebt also keine Zuordnung. Belegt.

**[E-196](../Intern/BEFUNDE.md#e-196), `E196HtmlZeichensatz`.** Der Text kommt in beiden Fenstern aus der Anzeige. Trident liefert über `E136HtmlAusBstr` (TridentReadMessageView.cpp:2924, TridentView.cpp:4112), Paige als ANSI. Dass die Funktion jede Angabe auf windows-1252 umschreibt, auch windows-1251, ist deshalb richtig. Anders als im Kern von [E-101](../Intern/BEFUNDE.md#e-101) (PRÜFER-37 F4) liegen die Bytes hier nicht roh aus dem Postfach vor. Belegt. Entitäten fasst die Funktion nicht an (`Test_E196_Entitaeten`, grün). Die Grenze „andere ANSI-Codepage“ steht schon in [E-196](../Intern/BEFUNDE.md#e-196). Gemessen sind die Orte, an denen die Angabe eingesetzt wurde: `ort=html` im Verfassen-Fenster ohne Kopfzeilen (`<html>\r\n<head><meta …></head>`), `ort=anfang` in den drei anderen Dateien. Einen Fehler fand ich nur bei leerem Wert (K7).

**Bytes.** `msgutils.cpp` 18 CRLF / 5053 LF / 0 Byte >127, `TestE194.cpp` 0 / 173 / 0. Gemessen vor und nach meinen Gegenproben, gleich.

## 2. E-205: die Ursache am Quelltext

`befund-suchen.pl ComposeDate` findet nur [E-205](../Intern/BEFUNDE.md#e-205). Ich schreibe dort fort und lege keine neue Kennung an.

- **Herkunft der 3600.** `CCompMessageDoc::InitializeNew` setzt `m_Sum->m_TimeZoneMinutes = -GetGMTOffset() * 60;` und `m_Seconds = time(NULL) - m_TimeZoneMinutes;` (compmsgd.cpp:229-230, unverändert seit dem Originalstand 567a5d87). Der Name sagt Minuten, im Feld stehen Sekunden. Die Uhrzeit in `m_Seconds` stimmt trotzdem: `SetDate` benutzt dieselbe Form, `time - Offset in Sekunden`, wenn auch in Minuten gerechnet (summary.cpp:2912-2918, compmsgd.cpp:1793). Belegt.
- **Rechnung.** `ComposeDate(dateMaybe, m_Sum)` (compmsgd.cpp:3417) gibt beides an `ComposeDateMT` weiter (sendmail.h:39-40, sendmail.cpp:659). Dort steht `GMTTime += TimeZoneMinutes * 60` (QCUtils/src/services.cpp:2094). Das sind 3600 × 60 s, also 60 Stunden, und die Zone wird als `+6000` ausgegeben (:2126). Belegt. Gegen die Messung gerechnet: gespeichert 02.11. 16:04:32 Ortszeit (Dateizeit `E194K\…\e194-verfassen.htm`), das sind 15:04:32 UTC. `m_Seconds` = 14:04:32 UTC (:230), plus 60 h = 05.11. 02:04:32 UTC. `CTime::GetHour` gibt Ortszeit aus, also 03:04:32. In der Datei steht `Date: Thu, 05 Nov 2026 03:04:32 +6000`. Das passt auf die Sekunde. Der Abstand zur Speicherzeit ist damit 59 Stunden, nicht „genau 60“, wie in [E-205](../Intern/BEFUNDE.md#e-205) steht.
- **Das Umschreiben.** `ComposeDate` mit `SumToSetDate` setzt `m_Seconds` auf den verschobenen Wert, setzt `m_TimeZoneMinutes` und ruft `FormatDate` (sendmail.cpp:661-666). Bei einer neuen Nachricht steht danach in *Out* bis zum nächsten Speichern das Datum in drei Tagen. Dann setzt `SetDate( time(NULL) … )` es zurück (compmsgd.cpp:1793). Belegt. Für eine schon *eingereihte* Nachricht gilt das nicht, siehe K1.
- **Zweiter Aufrufer.** `CTocView::OnFileSaveAs` ruft denselben `ComposeDate( szDateMaybe, pSummary )` für jede nicht empfangene Nachricht der Liste (tocview.cpp:3142). Belegt.

## 3. Testsuite und Gegenproben (in meinem Baum)

Gemessen. Die Basis lief über `cmd /c Eudora71\Tests\RunTests.cmd`. Jede Gegenprobe hat `msgutils.cpp` mit Perl `:raw` geändert, Treffer jeweils 1, und danach die Suite neu gebaut, weil `Extract.ps1` den Kern beim Bau schneidet. Danach habe ich die Sicherung byte-genau zurückgeschrieben. `cmp` gegen die Sicherung meldete keinen Unterschied, `git status` war leer. Die Proben in Abschnitt 4 liefen über eine vorübergehende Ergänzung von `TestE194.cpp`, auch die ist zurückgesetzt und mit `cmp` geprüft.

| Lauf | Änderung (vorübergehend) | Ergebnis |
|---|---|---|
| 0 | keine | 378/378 |
| G1 | `if ( FALSE && !bNurLeerraum && !bWarHtml )`: Gegenstück vor Anhangszeile nie entfernen | 377/378, rot `E-194: </x-flowed> auf eigener Zeile vor einer Anhangszeile …` |
| G2 | `bWarRich` aus dem Zweig „ohne Kopf, Kopf ergänzen“ | 377/378, rot `E-194: <x-rich> wird zu text/enriched` |
| G3a | `format=flowed` im Zweig ohne Kopfzeilen entfernt | 377/378, rot `E-194: <x-flowed> verlaesst das Haus nicht …` |
| G3b | `format=flowed` im Zweig mit Kopfzeilen entfernt | 377/378, rot `E-194: mit Kopfzeilen …` |
| G4 | Bedingung „Gegenstück steht am Zeilenanfang“ entfernt | **378/378, grün** (K8) |
| G5 | `E196HtmlZeichensatz`: `if ( szWert != szWunsch )` → `if ( FALSE )` | 377/378, rot `E-196: vorhandene Angabe …` |
| G7 | Erkennung `<x-rich>` entfernt | 377/378, rot `E-194: <x-rich> wird zu text/enriched` |

Die Quelltextprüfungen für die Stelle in beiden `SaveAsFile` und für den Filter habe ich gelesen, aber nicht gegengeprobt. Sie verlangen Reihenfolge und genau einen Aufruf. Das trägt.

## 4. Proben am Kern (Gegenvermutungen)

Gemessen an den aus `msgutils.cpp` geschnittenen Funktionen, Ausgabe gekürzt (`|` = Zeilenende CRLF).

| Probe | Eingang (Rumpf) | Ergebnis |
|---|---|---|
| M1 | zwei flowed-Teile mit Anhangszeile dazwischen | erstes `<x-flowed>` und letztes `</x-flowed>` weg, **in der Mitte bleiben `</x-flowed>` und `<x-flowed>` stehen** (K3) |
| M2 | flowed-Teil, dann HTML-Teil | `<x-html>`/`</x-html>` bleiben, Kopf sagt `text/plain; format=flowed` (K3) |
| M3 | Anhangszeile zuerst, dann flowed | nichts abgenommen, `huelle=-` (K3) |
| M5 | Kopf `format=flowed; delsp=yes`, Hochbytes | neuer Kopf `format=flowed` **ohne** `delsp=yes`, alte Zeile als `X-Original-Content-Type` (K6) |
| M6 | Kopf `text/richtext; charset=iso-8859-1`, `<x-rich>` | Kopf bleibt (Zeichensatz passt), Spur sagt `typ=text/enriched` (K5) |
| M7 | x-html, dann `</x-html>` auf eigener Zeile, dann Anhangszeile | **`</x-html>` bleibt stehen** (K4) |
| H1 | `<div>Date: x</div>` vor `<html><head>` | Angabe hinter `<head>`, also nach dem Text. Bei kurzem Vorspann unschädlich (Browser suchen in den ersten 1024 Byte), kein Fund |
| H2 | zwei `<meta>` (utf-8, windows-1251) | beide auf windows-1252, richtig (Abschnitt 1) |
| H3 | `<meta charset="">` | **`<meta charset=""windows-1252>`** (K7) |
| H4 | `<!-- <head> -->` vorn | Angabe **im Kommentar** eingesetzt (K7) |

## 5. Messskript und Prüfstandsfälle

- **Trifft es den Weg?** Ja. Die Nachricht kommt über POP (`anhang-pruefdaten.pl --pop`). Das Skript prüft, dass `<x-flowed>` in `In.mbx` steht, ehe es misst (`mbx=1`). Es speichert dann über `ID_FILE_SAVE_AS` aus Liste, Nachrichtenfenster und Verfassen-Fenster und liest die Dateityp-Liste des echten Dialogs. Die Spurzeilen in `eudora.log` bestätigen alle vier Wege: `E-101 speichern …`, `E-140 … aus Nachrichtenfenster`, `E-196 … aus Nachrichtenfenster` und `… aus Verfassen-Fenster`. Gemessen.
- **Gegenprobe haltbar?** Ja. `E194-alt\…\e194-liste.txt` hat `<x-flowed>` (Spur ohne `huelle=`, `rumpf-nachher=298`). `e194-lesen.htm` hat am alten Bau 409 Byte und kein `<meta>`, am neuen 485 Byte und ein `<meta>` (76 Byte). Gemessen.
- **Was die Fälle nicht prüfen:** siehe K9.

## 6. Funde

### K1: E-205 verschiebt bei eingereihten Nachrichten den Sendezeitpunkt

Belegt in jedem Glied, die Folge im Programm ist nicht gemessen. Eine Nachricht mit *Queue* oder *Send Later* hat ein korrektes `m_TimeZoneMinutes` in Minuten, gesetzt über `SetDate` (summary.cpp:2918). Speichert man sie mit *Kopfzeilen einschließen* aus dem Verfassen-Fenster (compmsgd.cpp:3417) oder aus *Out* (tocview.cpp:3142), stimmt die `Date:`-Zeile in der Datei. Aber `ComposeDate` schreibt `m_Seconds` um eine Zeitzone weiter (sendmail.cpp:653, :663). Beim Einreihen wird dieser Wert bewusst erhalten („honour the time for which it was originally queued“, compmsgd.cpp:1783-1787). `SendMail` vergleicht für *Send Later* `m_Seconds + m_TimeZoneMinutes * 60` mit der Uhr (sendmail.cpp:3866, :3892), und die gesendete `Date:`-Zeile kommt aus demselben Wert (sendmail.cpp:3329). Jedes solche Speichern verschiebt also den Sendezeitpunkt und das Datum der Mail um +1 h im Winter und +2 h im Sommer (Vermutung, nicht gemessen). Ob der verschobene Wert auch ein Beenden überlebt, hängt daran, ob die Inhaltsliste danach geschrieben wird. Das habe ich nicht geprüft.

Das ist genau der Fall, für den [E-205](../Intern/BEFUNDE.md#e-205) *kritisch* vorsieht. Ich schlage vor, es dort fortzuschreiben und zu messen (Prüfstand: *Send Later* auf eine Zeit, *Speichern unter* mit Kopfzeilen zweimal, Datum in *Out* und `m_Seconds` in der Spur ablesen). Für die Behebung genügt an beiden Stellen derselbe Aufruf ohne Rückschreiben, `ComposeDate( dateMaybe, m_Sum->m_Seconds, m_Sum->m_TimeZoneMinutes )`, wie summary.cpp:1355. Dazu kommt in compmsgd.cpp:229-230 Minuten statt Sekunden (`-GetGMTOffset()`, `m_Seconds = time(NULL) - m_TimeZoneMinutes * 60`). Die 59 statt 60 Stunden im Befundtext sollten mit berichtigt werden (Abschnitt 2). **Schwere: mittel**, Entscheidung über die Stufe bei Gregor.

### K2: Das Textdatei-Fenster schreibt `.rtf` wirklich als RTF

Am Quelltext belegt. `CTextFileDoc::OnFileSaveAs` (textfile.cpp:102-113) benutzt `IDS_TXT_HTML_FILE_FILTER` und speichert über `OnSaveDocument`. `CTextFileDoc::Serialize` reicht an den View weiter (textfile.cpp:97). `CTextFileView::Serialize` wählt die Ausgabe nach der Endung, `.rtf` ergibt `PgDataTranslator::kFmtRtf` (TextFileView.cpp:118-124), und das baut einen `PaigeRTFExportFilter` (Paige_io.cpp:787-788). [E-195](../Intern/BEFUNDE.md#e-195) und 7869f5cb sagen, `CTextFileDoc` speichere als Text und kein Aufrufer werte `.rtf` aus. Für dieses Fenster stimmt das nicht. Öffnen lässt sich `.rtf` dort weiterhin (`IDS_MAIN_OPENFILE_FILTER`, EudoraRes.rc:8550).

Verloren geht wenig. Wer `name.rtf` eintippt, bekommt weiter RTF, nur der Eintrag in der Liste fehlt. Zwei Wege sind denkbar. Entweder einen eigenen Filter ohne `.rtf` für die drei Nachrichtenwege und `IDS_TXT_HTML_FILE_FILTER` für Textdatei und Signatur lassen, wie er war. Oder es so lassen und nur den Befundtext berichtigen. Gregors Satz *„ein speichern als RFT nicht notwendig“* fiel zum Nachrichtenfenster. **Schwere: gering**, Entscheidung Gregor.

### K3: E-194 ist nur für Nachrichten mit einem Textteil behoben

Gemessen am Kern (M1-M3). TextReader setzt die Hülle je Textteil (TextReader.cpp:107-142, :392-408). Eine Nachricht mit zwei flowed-Teilen behält in der Datei ein `</x-flowed>` und ein `<x-flowed>` in der Mitte. Steht vor dem Text eine Anhangszeile, wird gar nichts abgenommen. Folgt einem flowed-Teil ein HTML-Teil, bleiben dessen Klammern stehen, und der Kopf sagt `text/plain; format=flowed`. Es geht dabei nichts verloren, es bleibt nur stehen, was vorher auch stand. Wie oft Eudora solche Rümpfe ablegt, habe ich nicht gemessen. Weitergeleitete Mails mit eingebetteter Nachricht sind ein Kandidat (Vermutung). Vorschlag: in [E-194](../Intern/BEFUNDE.md#e-194) als Grenze vermerken. **Schwere: gering.**

### K4: Vor einer Anhangszeile bleibt `</x-html>` stehen

Gemessen am Kern (M7). Die neue Regel „Gegenstück allein auf seiner Zeile, danach darf noch etwas folgen“ gilt nur für x-flowed und x-rich (msgutils.cpp:4175). Eine HTML-Mail mit Anhang hat genau diese Form: TextReader schließt die Hülle mit `PutLine` (TextReader.cpp:398-402), danach folgen die `Attachment Converted:`-Zeilen. So bleibt `</x-html>` in der Datei, hinter `</html>`. Die Begründung aus dem Kommentar, *mitten in einer Zeile ist es zitierter Text*, trifft auf HTML genauso zu wie auf die beiden anderen. Warum x-html ausgenommen bleibt, steht nicht da. Das ist Originalverhalten seit [E-101](../Intern/BEFUNDE.md#e-101), kein Rückschritt. Wie häufig der Fall in echten Postfächern ist, habe ich nicht gemessen (Vermutung: häufig). Vorschlag: `!bWarHtml` streichen und einen Test für HTML mit Anhang dazu. **Schwere: gering.**

### K5: `<x-rich>` steht auch für `text/richtext`, ausgegeben wird `text/enriched`

Am Quelltext belegt. TextReader.cpp:63-64 und :107 setzen `<x-rich>` für `richtext` und `enriched` gleich. Der Kern nennt den Untertyp immer `enriched` (msgutils.cpp:4466-4467). Ohne Kopfzeilen, oder wenn die Kopfzeile wegen des Zeichensatzes ersetzt wird, steht über einem RFC-1341-Rumpf (`<nl>`, `<lt>`) dann `text/enriched`. Bleibt die Kopfzeile stehen, ist es richtig (M6). `text/richtext` ist selten. **Schwere: gering.**

### K6: `delsp=yes` fällt weg

Gemessen am Kern (M5). Wird die Kopfzeile ersetzt, steht in der neuen nur `format=flowed`, der Parameter `delsp=yes` bleibt nur in `X-Original-Content-Type`. Ein Leser fügt dann beim Zusammensetzen das Leerzeichen vor dem weichen Umbruch mit ein, ein getrenntes Wort bekommt eine Lücke (Vermutung zur Wirkung). Eudora selbst kennt `delsp` nirgends (kein Treffer im Quelltext). Vorschlag: den Parameter aus der alten Zeile übernehmen, wenn er dort steht. **Schwere: gering.**

### K7: `E196HtmlZeichensatz` verschreibt eine leere Angabe und setzt in einen Kommentar ein

Gemessen am Kern (H3, H4). Bei `charset=""` überspringt die Schleife beide Anführungszeichen (msgutils.cpp:4882-4883), der Wert ist leer, und der neue Name wird hinter das zweite Anführungszeichen geschrieben. Heraus kommt `<meta charset=""windows-1252>`, eine Angabe ohne gültigen Wert. Der Kern aus [E-101](../Intern/BEFUNDE.md#e-101) schützt sich davor mit `nWertEnde > q` (msgutils.cpp:4564). Hier fehlt die Prüfung (:4896). Zweitens findet `TagAnfang` ein `<head` auch in einem Kommentar. Bei `<!-- <head> -->` landet die Angabe im Kommentar und wirkt nicht. Beides kommt aus Eudoras Anzeige praktisch nicht vor (Vermutung). Vorschlag: `nWertEnde > q` wie in [E-101](../Intern/BEFUNDE.md#e-101) und bei leerem Wert eine Angabe einsetzen. **Schwere: gering.**

### K8: TestE194 schützt die Bedingung „Gegenstück am Zeilenanfang“ nicht

Gemessen (G4). Ohne `( nEnde == 0 || szRumpf[nEnde-1] == '\n' )` bleibt die Suite grün. Der Gegenfall im Test hat Text hinter dem zitierten `</x-flowed>` auf derselben Zeile. Den fängt schon die Bedingung „danach Zeilenende“, nicht die erste. Mit der Änderung würde ein `… schrieb </x-flowed>` am Zeilenende, als letztes Vorkommen im Rumpf, entfernt und die Zeile mit der nächsten zusammengezogen. Vorschlag: `"<x-flowed>\r\nEr schrieb </x-flowed>\r\nNachsatz\r\n"` als Gegenprobe, erwartet unverändert. **Schwere: gering.**

### K9: Das Messskript prüft weder Umbruch noch Zeichen und nie eine Anhangszeile

Belegt an tools/messen-e194.ps1 und Testdaten/e194-flowed-umlaute.eml. Die Zeile `E194 DATEI` nennt `euro=`, `umlaute=` und `umbruch=`, aber `ERGEBNIS` übernimmt keinen dieser Werte. Gingen die weichen Umbrüche verloren oder würde das Euro-Zeichen zu `?`, blieben `E-194p`/`E-194k` grün. Die Prüfnachricht ist einteilig, ohne Anhang. Die neue Regel für `</x-flowed>` vor einer Anhangszeile ist am Programm also nie gelaufen, nur am Kern. Die Dateien selbst sind in Ordnung, das habe ich nachgesehen: `0x80` und die Umlaute stehen da, in `e194-liste.txt` bleibt `so lang, \r\n` mit Leerzeichen am Zeilenende. Vorschlag: `liste-umbruch=` und `liste-euro=` in die ERGEBNIS-Zeile aufnehmen, dazu eine zweite Prüfnachricht mit PDF-Anhang. **Schwere: gering.**

### K10: `.txt` aus dem Nachrichtenfenster ohne Kopfzeilen verliert die Zitatzeichen (Vorschlag: E-206)

Gemessen. `C:\Temp\E194\Mailverzeichnis\e194-lesen.txt` (ohne Kopfzeilen) hat die Zeile `Zitat aus einer frueheren Nachricht, ebenfalls umbrochen.` ohne `> ` davor, dazu je zwei bis drei zusätzliche Leerzeilen um jeden Absatz und drei Leerzeilen am Anfang. In `E194K\…\e194-lesen.txt` (mit Kopfzeilen) steht `> Zitat …` richtig. Die Datei ist am alten Bau byte-gleich (`cmp` mit `E194-alt\…\e194-lesen.txt`). Es ist also Originalverhalten und keine Folge dieses Zweigs. Die Ursache ist am Quelltext belegt: Ohne Kopfzeilen holt die Trident-Ansicht den Text mit `IHTMLTxtRange::get_text` (TridentReadMessageView.cpp:2910, über `GetMessageAsText` :2946). Das liefert den sichtbaren Text, das Zitat ist dort ein `<BLOCKQUOTE>` mit Balken und ohne Zeichen. In der gespeicherten Datei ist zitierter Text von eigenem nicht mehr zu unterscheiden.

`befund-suchen.pl GetMessageAsText`: kein Befund. Unter `CReadMessageDoc::SaveAsFile` stehen [E-80](../Intern/BEFUNDE.md#e-80), [E-101](../Intern/BEFUNDE.md#e-101), [E-140](../Intern/BEFUNDE.md#e-140), [E-195](../Intern/BEFUNDE.md#e-195) und [E-196](../Intern/BEFUNDE.md#e-196). Keiner davon nennt die Zitatzeichen. Mit Kopfzeilen nimmt `CTridentReadMessageView::GetAllText` bei einer unveränderten Klartextnachricht den Rohtext aus dem Postfach (`GetFullMessage(RAW)`, TridentReadMessageView.cpp:2003-2025). Daher kommt der Unterschied. Vorschlag: als [E-206](../Intern/BEFUNDE.md#e-206) aufnehmen. Behebung etwa so: ohne Kopfzeilen unter derselben Bedingung den Rumpf desselben Rohtexts nehmen (`FindBody`), statt `get_text`. **Schwere: mittel** (es geht Bedeutung verloren, nicht Text).

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| K1 | [E-205](../Intern/BEFUNDE.md#e-205): `ComposeDate` mit Rückschreiben verschiebt bei eingereihten und *Send Later*-Nachrichten bei jedem *Speichern unter* mit Kopfzeilen den Sendezeitpunkt um die Zeitzone (Kette belegt, Folge Vermutung); Ursache der +6000 belegt (compmsgd.cpp:229, Sekunden statt Minuten); 59 statt 60 Stunden | mittel | nein, Stufe von [E-205](../Intern/BEFUNDE.md#e-205) entscheiden |
| K2 | Textdatei-Fenster schreibt `.rtf` als echtes RTF; die Begründung zu [E-195](../Intern/BEFUNDE.md#e-195) stimmt für dieses Fenster nicht | gering | nein, Entscheidung Gregor |
| K3 | Bei mehreren Textteilen, Anhang vorn oder flowed+HTML bleiben Klammern in der Datei | gering | nein |
| K4 | `</x-html>` vor einer Anhangszeile bleibt stehen (Originalverhalten, neue Regel gilt nur für x-flowed/x-rich) | gering | nein |
| K5 | `text/richtext` wird als `text/enriched` ausgewiesen | gering | nein |
| K6 | `delsp=yes` fällt beim Ersetzen der Kopfzeile weg | gering | nein |
| K7 | `charset=""` wird zu `charset=""windows-1252`; `<head>` im Kommentar wird getroffen | gering | nein |
| K8 | `TestE194` bleibt grün ohne die Bedingung „Gegenstück am Zeilenanfang“ | gering | nein |
| K9 | `messen-e194.ps1`: ERGEBNIS prüft weder Umbruch noch Euro/Umlaute, die Prüfnachricht hat keinen Anhang | gering | nein |
| K10 | `.txt` aus dem Nachrichtenfenster ohne Kopfzeilen verliert die Zitatzeichen `>` (Originalverhalten, Vorschlag [E-206](../Intern/BEFUNDE.md#e-206)) | mittel | nein |

## Nachtrag 02.11.2026

Geprüft wurde `ed7b9d83..e12e267d` auf `e194_e196_speichern_unter`. Das sind cecab886 (Funde dieses Berichts eingearbeitet, [E-205](../Intern/BEFUNDE.md#e-205) fortgeschrieben, [E-206](../Intern/BEFUNDE.md#e-206) neu) und e12e267d (Behebung von [E-205](../Intern/BEFUNDE.md#e-205)). Mein Baum wurde mit `tools/arbeitsbaum-angleichen.sh` vorgespult. Eudora habe ich weder gebaut noch gestartet. `C:\Temp\E205` und `C:\Temp\E205-alt` habe ich nur gelesen.

### Ergebnis vorweg

Die Behebung von [E-205](../Intern/BEFUNDE.md#e-205) ist richtig, und K1 ist in seinem wichtigsten Teil widerlegt. Gemessen am alten Bau (`C:\Temp\E205-alt`) geben beide Speicherungen einer eingereihten Nachricht dieselbe `Date:`-Zeile (`16:54:55 +0100`, zweimal, aus *Out* wie aus der Liste). Der Grund steht am Quelltext: `FormatDate` liest die Zone aus dem eben geschriebenen Datumstext zurück und zieht sie von `m_Seconds` wieder ab (`FormatDateMT`, QCUtils/src/services.cpp:2067-2076). Bei gültiger Zone hebt sich die Verschiebung also auf. Nur `+6000` liegt außerhalb ±2400 und bleibt stehen, daher die 119 Stunden beim zweiten Speichern. Meine Vermutung, *Send Later* werde verschoben, war falsch. Ich hatte `FormatDate` nicht bis in `FormatDateMT` gelesen.

Die Testsuite läuft mit 382/382. Von acht Gegenproben an den neuen Stellen werden sieben rot, eine bleibt grün (N3). Neu sind drei Funde. N1: Das Signaturfenster schreibt `.rtf` **nicht** als RTF, die Begründung zu K2 in [E-195](../Intern/BEFUNDE.md#e-195), im Kommentar von saveas.cpp und in TestE196.cpp stimmt für dieses Fenster nicht. *Speichern unter* aus dem Signaturfenster schreibt nach dem Quelltext gar nichts in die Datei (Vorschlag: [E-207](../Intern/BEFUNDE.md#e-207)). N2: der Fall `E-205p` erwartet `zone=+0100` und wird in der Sommerzeit rot. N3: eine Schranke in `E196HtmlZeichensatz` ist ungetestet. Keiner der drei hält das Paket auf.

### E-205 am Quelltext

- **Zone überall in Minuten?** Ja. Alle Leser rechnen `m_TimeZoneMinutes * 60` (sendmail.cpp:242-261, :3866, :3892; compmsgd.cpp:2794; tocdoc.cpp:920, :1160; JunkMail.cpp; pop.cpp:624, :633; summary.cpp:2689). Alle anderen Schreiber setzen Minuten (`SetDate` summary.cpp:2918, `Build` :2440, changeq.cpp:218, `FormatDateMT`). Die Stelle in `InitializeNew` war die einzige mit Sekunden. `-GetGMTOffset() * 60` steht sonst nirgends. Belegt.
- **Senden (sendmail.cpp:3329).** `ComposeDate(Date, SMTPmsg->m_Sum)` schreibt weiter zurück. Bei gültiger Zone gleicht `FormatDate` das aus, siehe oben. Vor dem Senden setzt das Sichern `SetDate` (compmsgd.cpp:1803), die Zone ist dann ohnehin in Minuten. Unverändert zu lassen ist richtig. Belegt. Am Prüfstand gemessen ist, dass die Zusammenfassung nicht wandert (`q1`/`q2` gleich). Das gesendete `Date:` selbst ist nicht gemessen. In [E-205](../Intern/BEFUNDE.md#e-205) steht *„nichts ging falsch hinaus — gemessen“*. Richtig wäre: am Quelltext belegt, an der Zusammenfassung gemessen.
- **Alte Zusammenfassungen mit 3600 in einer `.toc`.** Die Zone wird als `short` geschrieben und gelesen (summary.cpp:2576, :2497-2498), 3600 überlebt also ein Speichern der Inhaltsliste. `Read` ruft `SetDate()` ohne Sekunden (summary.cpp:2500), das setzt die Zone nicht neu. Eine solche Zusammenfassung entsteht nur aus einer neuen Nachricht, die nie gesichert wurde, deren Inhaltsliste aber trotzdem geschrieben wurde. Jedes Sichern heilt sie über `SetDate( time(NULL) … )`. Was sie bis dahin anrichtet, ist dasselbe Datum `+6000` beim Speichern unter. Ein Pfad, auf dem eine ungesicherte neue Nachricht in *Out* stehen bleibt, ist mir nicht bekannt (Vermutung: ein Absturz bei offenem Verfassen-Fenster). Keine Behebung nötig, ein Satz in [E-205](../Intern/BEFUNDE.md#e-205) genügt.
- **Messung.** `C:\Temp\E205-alt`: `neu1` `Thu, 05 Nov 2026 03:54:43 +6000`, `neu2` `Sat, 07 Nov 2026 15:54:43 +6000`, `q1`/`q2`/`liste1`/`liste2` je `Mon, 02 Nov 2026 16:54:55 +0100`. `C:\Temp\E205`: alle sechs `Mon, 02 Nov 2026 17:02:04` bzw. `17:02:15 +0100`, Dateizeiten 17:02:10 bis 17:02:40. Gemessen (Dateien gelesen).

### Filter

`IDS_MSG_SAVEAS_FILE_FILTER` hat die Nummer 3130. Sie kommt in resource.h genau einmal vor (33130 ist eine andere Nummer). Aufrufer: compmsgd.cpp:3368 und saveas.cpp:98 nehmen den neuen Filter, signatur.cpp:73 und textfile.cpp:110 den alten mit `.rtf`. Weitere Aufrufer gibt es nicht. Belegt.

### Gegenproben

Gemessen, wie in Abschnitt 3. Sicherung der vier Dateien, Perl `:raw`, Treffer je 1, nach jedem Lauf zurück, `cmp` gleich, `git status` leer.

| Lauf | Änderung (vorübergehend) | Ergebnis |
|---|---|---|
| 0 | keine | 382/382 |
| H1 | compmsgd.cpp `InitializeNew` wieder `-GetGMTOffset() * 60` und `- m_TimeZoneMinutes` | 381/382, rot `E-205 (Quelltext): InitializeNew legt die Zone in Minuten an` |
| H2 | tocview.cpp wieder `ComposeDate( szDateMaybe, pSummary )` | 381/382, rot `E-205 (Quelltext): Speichern unter schreibt die Zusammenfassung nicht zurueck` |
| H3 | msgutils.cpp `delsp=yes` nicht mehr anhängen | 381/382, rot `E-194 PRUEFER-86 K5/K6 …` |
| H4 | msgutils.cpp Untertyp immer `enriched` | 381/382, rot `E-194 PRUEFER-86 K5/K6 …` |
| H5 | `E196HtmlZeichensatz`: Kommentare nicht mehr ausblenden | 381/382, rot `E-196 PRUEFER-86 K7 …` |
| H6 | `E196HtmlZeichensatz`: Schranke `nGegen < nZu` entfernt | **382/382, grün** (N3) |
| H7 | Bedingung „Gegenstück am Zeilenanfang“ entfernt (wie G4) | 381/382, rot `E-194: </x-flowed> auf eigener Zeile …`, K8 ist damit geschlossen |
| H8 | saveas.cpp wieder `IDS_TXT_HTML_FILE_FILTER` | 381/382, rot `E-195 (Quelltext): Speicherdialog fuer Nachrichten ohne .rtf …` |

### N1: Das Signaturfenster schreibt bei *Speichern unter* nichts (Vorschlag: E-207)

Am Quelltext belegt, nicht gemessen. `CSignatureDoc::OnFileSaveAs` setzt `m_SaveAs` und ruft `CDocument::OnSaveDocument` (signatur.cpp:69-89). `CSignatureDoc::Serialize` ruft bei `m_SaveAs` ausdrücklich `pView->CPaigeEdtView::Serialize(ar)` (signatur.cpp:100-103). Diese Funktion gibt es nicht mehr: Sie ist seit dem Originalstand auskommentiert („03-17-2000 Commented this function as this is moved to TextFileView.Cpp“, PaigeEdtView.cpp:5594-5634, Deklaration PaigeEdtView.h:361). Der Aufruf landet also bei `CObject::Serialize`, und die tut nichts (MFC afx.inl:105-106). `OnSaveDocument` legt die Datei neu an und setzt danach das Geändert-Kennzeichen zurück. Heraus kommt eine leere Datei, und das Fenster gilt als gesichert. Das gilt für jede Endung, nicht nur `.rtf` (Vermutung zur Wirkung, nicht gemessen; die Signatur selbst bleibt unberührt, weil *Speichern unter* in eine andere Datei schreibt).

Damit stimmt die Begründung für K2 nur zur Hälfte. Das Textdatei-Fenster schreibt RTF (`CTextFileView::Serialize`), das Signaturfenster nicht. Falsch sind der Satz *„bzw. `CPaigeEdtView::Serialize` → `PgDataTranslator::kFmtRtf`“* in [E-195](../Intern/BEFUNDE.md#e-195), der Kommentar in saveas.cpp:93-97 und der Kommentar in `Test_E195_Filter` (TestE196.cpp). Für den Filter selbst ändert sich nichts. Ob das Signaturfenster ihn mit oder ohne `.rtf` bekommt, ist gleich, solange es nichts schreibt.

`befund-suchen.pl CPaigeEdtView::Serialize`, `OnFileSaveAs` und `signatur.cpp` finden nur [E-97](../Intern/BEFUNDE.md#e-97), [E-195](../Intern/BEFUNDE.md#e-195) und [E-205](../Intern/BEFUNDE.md#e-205), keiner nennt das. Vorschlag: als [E-207](../Intern/BEFUNDE.md#e-207) aufnehmen, zuerst messen (Signatur öffnen, *File → Save As*, Dateigröße). Für die Behebung genügt bei `m_SaveAs` ein Aufruf von `CSignatureView::Serialize`, der Text oder HTML schreibt (signatur.cpp:158-172). **Schwere: mittel**, wenn die Messung die leere Datei zeigt (der Anwender hält etwas für gesichert, was nicht gesichert ist).

### N2: Der Fall `E-205p` hängt an der Jahreszeit

Belegt an tools/pruefstand-faelle.txt. Erwartet wird `zone=+0100`, das Skript liest die Zone aus der Datei. Ab der Umstellung auf Sommerzeit schreibt Eudora richtig `+0200`, und der Fall wird rot, ohne dass etwas kaputt ist. Vorschlag: im Skript die Rechnerzone ermitteln und `zone=passt` ausgeben. **Schwere: gering.**

### N3: Der Test zu K7 prüft die Schranke `nGegen < nZu` nicht

Gemessen (H6). Ohne die Schranke bleibt die Suite grün. Der Testfall `content="text/html; charset="` hat hinter dem Tag kein weiteres Anführungszeichen. `Find` liefert dann -1, und die Schranke wird nie gebraucht. Steht im Dokument danach noch ein Attribut in Anführungszeichen, würde ohne Schranke das schließende Anführungszeichen von `content` übersprungen und der Name dahinter gesetzt. Der Code ist richtig, der Test sieht es nur nicht. Vorschlag: denselben Fall mit `<p class="x">` dahinter. **Schwere: gering.**

### Übersicht Nachtrag

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| K1 | Vermutung „*Send Later* wird verschoben“ widerlegt (gemessen am alten Bau, `FormatDateMT` gleicht aus); Behebung von [E-205](../Intern/BEFUNDE.md#e-205) richtig | – | nein |
| N1 | Signaturfenster: *Speichern unter* ruft eine auskommentierte Funktion, die Datei bleibt leer (belegt, nicht gemessen); Begründung zu K2 in BEFUNDE, saveas.cpp und TestE196.cpp falsch (Vorschlag [E-207](../Intern/BEFUNDE.md#e-207)) | mittel | nein |
| N2 | `E-205p` erwartet `zone=+0100`, rot in der Sommerzeit | gering | nein |
| N3 | Gegenprobe H6 grün: der Test zu K7 braucht die Schranke `nGegen < nZu` nie | gering | nein |

## Nachtrag 2, 02.11.2026

Geprüft wurde `dde4db0d..9e098eb9` auf `e194_e196_speichern_unter`, also die Behebung von [E-207](../Intern/BEFUNDE.md#e-207) (Speichern unter im Signaturfenster) und die eingearbeiteten N2 und N3. Mein Baum wurde mit `tools/arbeitsbaum-angleichen.sh` vorgespult. Eudora habe ich weder gebaut noch gestartet. `C:\Temp\E207` und `C:\Temp\E207-alt` habe ich nur gelesen.

### Ergebnis vorweg

Die Behebung von [E-207](../Intern/BEFUNDE.md#e-207) ist richtig. Gemessen: Am alten Bau sind `e207-sig.txt` und `e207-sig.htm` je 0 Byte groß. Am neuen Bau hat die `.txt` 43 Byte, die `.htm` 79 Byte. Beide enthalten den Signaturtext mit der eingetippten Marke `Q7Z` und den Umlauten, die `.htm` als `<html><body>…<br>…</body></html>`. Die Signaturdatei `Sigs\Standard.txt` hat nach dem Lauf denselben Inhalt wie vorher. Die Testsuite läuft mit 383/383. Von drei Gegenproben am neuen Test werden zwei rot, eine bleibt grün (N5).

Ein Rest bleibt, und er ist Originalverhalten. Nach *Speichern unter* steht im Fenstertitel der Name der Kopie. Das Dokument zeigt aber weiter auf die Signatur, und es gilt als gesichert. Beim Schließen fragt Eudora also nicht, und die Änderungen stehen nur in der Kopie, nicht in der Signatur (gemessen: `frage=0 sig=unveraendert` bei eingetippter Marke). Ein späteres *Save* schreibt in die Signatur, obwohl der Titel die Kopie nennt (belegt). Ich stufe das als gering ein (N4). Kein Fund hält das Paket auf.

### E207SpeichernUnter gegen MFC

- **Dateiname.** `CDocument::OnSaveDocument` öffnet über `GetFile` eine `CMirrorFile`. Gibt es die Zieldatei schon, schreibt sie in eine Zwischendatei `MFC*.TMP`, setzt `m_strFileName` aber auf den gewünschten Namen (MFC doccore.cpp:648-651). `GetFileName()` liefert deshalb in beiden Fällen den Zielnamen ohne Pfad, also die richtige Endung. Belegt.
- **Endungen.** `CompareNoCase` gegen `IDS_HTM_EXTENSION` und `IDS_HTML_EXTENSION`. `.HTM`, `.Html` und `.html` werden also HTML, alles andere wird Text. Ohne Punkt (`nPunkt < 0`) wird es Text. Ein Punkt im Verzeichnisnamen stört nicht, weil `GetFileName` keinen Pfad enthält. Belegt. Gemessen ist nur `.txt` und `.htm`.
- **`ar.GetFile()` und Export am Archiv vorbei.** Das ist dasselbe Muster wie in `CSignatureView::Serialize` (signatur.cpp:180-195) und `CTextFileView::Serialize`. Vorher wird nichts ins Archiv geschrieben, es gibt also nichts zu leeren. Belegt.
- **Signaturdatei unangetastet?** Ja. `OnFileSaveAs` ruft `CDocument::OnSaveDocument(pathName)` mit dem Pfad aus dem Dialog (signatur.cpp:85). `m_strPathName` ändert sich nicht, weil nur `DoSave` `SetPathName` ruft. Gemessen: `Sigs\Standard.txt` ist vor und nach dem Lauf gleich.
- **Gesichert oder geändert?** Nach dem Aufruf ist das Dokument „ungeändert“ (`SetModifiedFlag(FALSE)` in signatur.cpp:117 und in `OnSaveDocument`). Siehe N4.
- **`.rtf` und Zeichensatz.** Der Dialog des Signaturfensters bietet weiter *Rtf Files* an (signatur.cpp:73) und schreibt darunter Text. Die `.htm` trägt kein `<meta charset>`, die Umlaute stehen als Latin-1 in der Datei (gemessen, `e207-sig.htm`). Beides steht schon in [E-207](../Intern/BEFUNDE.md#e-207) unter „Nicht geändert“. Ich bestätige es am Quelltext und an der Datei. Kein neuer Fund.

### Messskript

- **Trifft es den Weg?** Ja. `ID_FILE_SAVE_AS` geht an das Hauptfenster, nachdem das Signaturfenster mit `WM_MDIACTIVATE` nach vorn geholt wurde. MFC leitet den Befehl an das Dokument des aktiven Kindfensters, also an `CSignatureDoc::OnFileSaveAs` (signatur.cpp:32). Die alten Dateien mit 0 Byte belegen das. Ein anderer Weg hätte am alten Bau Inhalt geschrieben. Gemessen.
- **Ist die Gegenprobe haltbar?** Ja. Die Marke `Q7Z` steht in den neuen Dateien, und vorher fragte Eudora beim Schließen nach (`geaendert=1`). Das Fenster war also wirklich geändert, und gespeichert wurde der Inhalt des Fensters, nicht die Datei auf der Platte. Gemessen.
- **Was der Fall festschreibt.** `E-207p` erwartet `frage=0 sig=unveraendert`. Damit ist das Verhalten aus N4 zum Sollwert geworden. Das ist in Ordnung, solange N4 so entschieden ist. Wird N4 behoben, muss der Fall mit.

### Gegenproben am Test „E-207 (Quelltext)“

Gemessen. Sicherung von `signatur.cpp`, Perl `:raw`, Treffer je 1, danach zurück, `cmp` gleich, `git status` leer.

| Lauf | Änderung (vorübergehend) | Ergebnis |
|---|---|---|
| 0 | keine | 383/383 |
| J1 | wieder `pView->CPaigeEdtView::Serialize(ar);` | 382/383, rot `E-207 (Quelltext) …` |
| J2 | `theTxr.ExportData( pDatei, format );` auskommentiert | 382/383, rot `E-207 (Quelltext) …` |
| J3 | hinter `format = PgDataTranslator::kFmtHtml;` gleich wieder `format = PgDataTranslator::kFmtText;` (`.htm` wird Text) | **383/383, grün** (N5) |

### N5: Der Test „E-207 (Quelltext)“ prüft nicht, dass `.htm` wirklich HTML wird

Gemessen (J3). Der Test verlangt nur, dass die Zeile `format = PgDataTranslator::kFmtHtml;` und der Vergleich mit `IDS_HTM_EXTENSION` irgendwo in der Funktion stehen. Ob die Zuweisung wirkt, prüft er nicht. Am Prüfstand fängt der Fall `E-207p` das (`htm=passt` verlangt HTML-Tags). Die Suite allein sieht es nicht. Vorschlag: die Folge `if ( szEndung.CompareNoCase( CRString( IDS_HTM_EXTENSION ) ) == 0 || … ) format = PgDataTranslator::kFmtHtml; theTxr.ExportData( pDatei, format );` als Ganzes nach `QT_LeerraumZusammen` verlangen. **Schwere: gering.**

### N4: Nach *Speichern unter* aus dem Signaturfenster gelten die Änderungen als gesichert, stehen aber nicht in der Signatur

Gemessen am Prüfstand (`C:\Temp\E207`: Marke eingetippt, *Speichern unter* zweimal, beim Schließen keine Frage, `Sigs\Standard.txt` unverändert). Die Ursache ist belegt. `CSignatureDoc::OnFileSaveAs` setzt den Titel auf den Namen der Kopie (signatur.cpp:79-83) und schreibt die Kopie über `OnSaveDocument`. Den Pfad des Dokuments ändert das nicht, das Geändert-Kennzeichen löscht es aber (signatur.cpp:117). Das ist so seit dem Originalstand 567a5d87.

Für den Anwender heißt das: Wer an der Signatur etwas ändert, *Speichern unter* als Sicherungskopie wählt und das Fenster schließt, hat die Änderungen nur in der Kopie. Die Signatur ist die alte, und Eudora hat nicht gefragt. Wer stattdessen weiterarbeitet und *Save* wählt, schreibt in die Signatur, obwohl der Titel die Kopie nennt. Verloren geht in beiden Fällen nichts, aber die Änderung landet nicht dort, wo der Anwender sie erwartet.

Vorschlag, eine von zwei Richtungen. (a) *Speichern unter* als Kopie behandeln: den Titel nicht umsetzen und das Geändert-Kennzeichen so lassen, wie es war. (b) Ein echtes *Speichern unter*: danach `SetPathName` auf die Kopie. (a) passt besser zu einem Signaturfenster. Die Entscheidung liegt bei Gregor. **Schwere: gering.**

### Übersicht Nachtrag 2

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| N1 | Behebung von [E-207](../Intern/BEFUNDE.md#e-207) richtig, am Prüfstand gemessen (vorher 0 Byte, nachher Inhalt mit Marke, Signatur unverändert) | – | nein |
| N4 | Nach *Speichern unter* gilt das Signaturfenster als gesichert, die Änderungen stehen aber nur in der Kopie; späteres *Save* schreibt in die Signatur, der Titel nennt die Kopie (Originalverhalten) | gering | nein, Entscheidung Gregor |
| N5 | Gegenprobe J3 grün: der Test „[E-207](../Intern/BEFUNDE.md#e-207) (Quelltext)“ merkt nicht, wenn `.htm` als Text geschrieben wird; am Prüfstand fängt es `E-207p` | gering | nein |
