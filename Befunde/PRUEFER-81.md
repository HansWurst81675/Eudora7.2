# <a id="pruefer-81"></a>PRUEFER-81

Lauf nach [PRUEFER-80](PRUEFER-80.md#pruefer-80), geprüft: `34ff9e92..HEAD -- Eudora71 tools Releases/1.0` (66f845aa, ba3ea71b, 034162bc, 12d47ba5), Zweig wt/pruefer-20261102 (von `origin/e177_filter_programm`). Schwerpunkt [E-177](../Intern/BEFUNDE.md#e-177).

## Ergebnis vorweg

Die Behebung tut, was sie verspricht: Eine per POP empfangene UTF-8-Nachricht landet in der Datei für das Programm jetzt mit der Angabe „windows-1252“, und das passt zu den Bytes. Das habe ich an den drei Dateien und am Protokoll des Prüfstands nachgelesen; die Testsuite läuft bei mir durch, und die Gegenprobe aus dem Commit wird wirklich rot. Zwei Lücken bleiben, beide klein und beide schon im gemeinsamen Kern von „Speichern unter“ angelegt, nicht neu von [E-177](../Intern/BEFUNDE.md#e-177). Erstens: Eine Nachricht mit der ungewöhnlichen Schreibweise `charset=utf8` übersetzt Eudora beim Empfang nicht. Der Kern hält sie trotzdem für übersetzt und schreibt „windows-1252“ über echte UTF-8-Bytes. Auf dem Filterweg war das vorher richtig und ist jetzt falsch. Damit stimmt auch die Begründung im Messskript nicht ganz, warum der Fall `[roh]` nicht zählt. Zweitens: Ausgehende Nachrichten nehmen einen anderen Weg, und der schreibt weiter gar keine Zeichensatzangabe. Nichts davon hält das nächste Paket auf.

## 1. Die Behebung am Quelltext

- `CReadMessageDoc::SaveAs` (ReadMessageDoc.cpp:531-600) hat zwei Ausgänge, beide gehen jetzt über `E140TextFuerDatei` (:594, :599). Der zweite Parameter `bKopfzeilen && !m_Sum->IsSubPart()` ist genau die Umkehrung der Bedingung, unter der vorher `FindBody` lief (:545). Der Kern bekommt also nur dann „hat Kopfzeilen“ gesagt, wenn der Text wirklich mit Kopfzeilen beginnt. Richtig, am Quelltext belegt.
- **Einziger Aufrufer**: `CFilter::SetupCommandLine` (filtersd.cpp:2074, Aufruf :2117) — `grep` über `Eudora71` findet keinen weiteren `->SaveAs(sa)` auf ein `CReadMessageDoc`. Am Quelltext belegt. `SetupCommandLine` setzt vorher `IncludeHeaders=1` (:2116), `E104SchalterLesen` liefert in `SaveAs` also immer 1.
- **`IsSubPart`**: das Bit `MSF_SUB_PART` (summary.h:48) wird nirgends im Quelltext gesetzt; `IsSubPart()` wird nur in `SaveAs` gelesen (:545, :594, :599). Der Zweig ist damit praktisch tot, die Bedingung schadet nicht. Am Quelltext belegt. Dass `bKopfzeilen` hier immer 1 ist, heißt: der Ausdruck im zweiten Parameter ist heute gleichwertig zu `true` (siehe K5).
- **Lebensdauer**: `(LPCTSTR) E140TextFuerDatei(...)` ist ein Zeiger in ein temporäres `CString`, das bis zum Ende des vollen Ausdrucks lebt — also über `SA.PutText` hinaus. `CopyText` wird erst danach freigegeben (:595). Richtig.
- **„Absätze raten“**: `UnwrapText` läuft vorher nur über den Rumpf (:553-582). Der Kern trennt danach an der ersten Leerzeile, und die bleibt beim Entfalten stehen. Am Quelltext belegt, nicht gemessen.
- **HTML**: der Fall e118 (text/html, windows-1252, roh eingelegt, ohne `<x-html>`) bleibt unverändert, Protokoll `C:\Temp\E177\Mailverzeichnis\eudora.log`: `typ=text/html charset=windows-1252 … ct-ersetzt=0 … geaendert=0`. Gemessen (vom Hauptagenten, von mir nachgelesen). Empfangenes HTML mit `<x-html>`-Marke und `<meta charset=UTF-8>` deckt `TestE101.cpp` am Kern ab („F3 Gegenprobe“), grün.
- **windows-1251 und andere unübersetzte Zeichensätze** bei einteiligen Nachrichten: der Kern lässt die Angabe stehen (msgutils.cpp:4320-4328, PRUEFER-37 F3), `TestE101.cpp` „[E-101](../Intern/BEFUNDE.md#e-101) F3: windows-1251 im Kopf bleibt stehen“ grün. Bei **mehrteiligen** nicht — siehe K2.
- **Nachrichten ohne Content-Type** mit Hochbytes bekommen `MIME-Version`/`Content-Type` ergänzt (msgutils.cpp:4535-4588). Das ist die Entscheidung aus [E-101](../Intern/BEFUNDE.md#e-101), kein neuer Fehler.

## 2. Messung am Prüfstand (nur gelesen)

Die drei Dateien `C:\Temp\E177\Mailverzeichnis\e177-1.txt` bis `-3.txt` (08:45) gelesen:

| Datei | Nachricht | Kopf | Rumpf | Urteil |
|---|---|---|---|---|
| e177-1 | [pop] | `X-Original-Content-Type: …utf-8`, `Content-Type: text/plain; charset="windows-1252"` | `80`, `FC DF`, `E4 F6 FC` … (cp1252) | passt |
| e177-2 | [roh] | dieselbe Umbenennung, `charset="windows-1252"` | `E2 82 AC`, `C3 BC` … (UTF-8) | **falsch** |
| e177-3 | e118 | `Content-Type: text/html; charset=windows-1252` unverändert | cp1252 | passt |

Das deckt sich mit der Meldung in 12d47ba5 und mit den drei `E-140 speichern aus Filteraktion an Programm (E-177)`-Zeilen im Protokoll. Für `[roh]` ist die Behebung ein Rückschritt (vorher stand dort richtig `utf-8`). Ob das zählt, hängt an der Begründung im Skript — dazu K1 und K3.

## 3. Testsuite und Gegenproben (in meinem Baum)

Gemessen, `cmd /c Eudora71\Tests\RunTests.cmd`:

| Lauf | Änderung (vorübergehend) | Ergebnis |
|---|---|---|
| 1 | keine | 359/359 |
| G1 | ReadMessageDoc.cpp:599 auf `return (SA.PutText(Text));` | **358/359**, rot genau `E-177 … schreibt nur ueber E140TextFuerDatei`, Satz *„Text ohne 'Absaetze raten' geht mit der Original-Kopfzeile hinaus“* |
| G2 | ReadMessageDoc.cpp:599, zweiter Parameter durch `true` ersetzt | **359/359** — bleibt grün (K5) |
| P | Messfälle A-D in `TestE101.cpp` angehängt (Kern über `UTE101_SpeicherfassungAufbereiten`) | 359/359, Ausgabe siehe K1, K2 |

Nach jedem Lauf zurückkopiert, `cmp` gegen die Sicherung gleich, `git status` leer.

## Funde

### K1 — `charset=utf8` (ohne Bindestrich): echte UTF-8-Bytes bekommen „windows-1252“

**Was passiert.** Eudora übersetzt beim Empfang nur ab Index 3 (TextReader.cpp:267, ImapDownload.cpp ebenso). Den Index liefert `FindMIMECharset` (mime.cpp:383-403) mit genauem `stricmp` gegen `us-ascii`, `iso-8859-1`, `iso-8859-15`, `utf-8` (EudoraRes.rc:9409-9412, rs.cpp:806-810). `utf8` steht nicht in der Liste: Index -1, der Rumpf bleibt **UTF-8** im Postfach. Am Quelltext belegt. Der Kern zählt `utf8` aber zu den Angaben, bei denen „der Rumpf nachweislich CP1252 ist“ (msgutils.cpp:4324, ebenso im `<meta>`-Zweig :4482). Er benennt die Kopfzeile deshalb um und schreibt `windows-1252`, sobald ein Byte 0x80-0x9F vorkommt — bei UTF-8 fast immer.

**Gemessen am Kern** (Messfall A): `Content-Type: text/plain; charset=utf8` über `Gr C3 BC C3 9F e E2 82 AC` → `X-Original-Content-Type: text/plain; charset=utf8` und `Content-Type: text/plain; charset="windows-1252"`, `ct-ersetzt=1`. Ein Leser zeigt „GrÃ¼ÃŸe â‚¬“.

**Was das für [E-177](../Intern/BEFUNDE.md#e-177) heißt.** Auf dem Filterweg stand vorher die Original-Angabe `utf8` da, und die war richtig. Jetzt ist sie falsch: für diese Schreibweise ist die Behebung ein Rückschritt. Genau das zeigt der Fall `[roh]` am Prüfstand. Die Begründung im Skript, *„roh eingelegtes UTF-8 gibt es nach einem Empfang nicht“* (messen-e177.ps1, Kopf und Auswertung; pruefstand-faelle.txt), gilt für `utf-8`, nicht für `utf8`. Dieselbe Lücke hat „Speichern unter“ seit PRUEFER-37 F3: In dessen Tabelle steht „alles andere: -1, nicht übersetzt“, der Vorschlag darunter nahm `utf8` trotzdem in die CP1252-Liste auf.

**Häufigkeit**: Vermutung, selten (eine Schreibweise, die manche Skripte und Massenversender verwenden). Nicht über POP gemessen.

**Behebung (Vorschlag, klein):** `utf8` aus der Liste in msgutils.cpp:4324 nehmen. Haltbarer ist es, die Liste aus derselben Regel abzuleiten wie den Empfang: übersetzt ist, was `FindMIMECharset` ≥ 3 liefert, und unverändert CP1252-verträglich ist, was 0 bis 2 liefert. So hat es [NP3-8](../Intern/BEFUNDE.md#np3-8) gelehrt. `latin1` in derselben Liste ist harmlos: unübersetzt sind das Latin-1-Bytes, und die Angabe ISO-8859-1/windows-1252 passt.
**Kennung: E-197** (gehört in den Kern von [E-101](../Intern/BEFUNDE.md#e-101), wirkt auf alle drei Wege und jetzt auch auf [E-177](../Intern/BEFUNDE.md#e-177)). **Schwere: klein.**

### K2 — mehrteilige Nachricht mit unübersetztem Textteil: der Zeichensatz wird aus den Bytes geraten

**Was passiert.** Steht im Kopf `multipart/…` und die Grenze nicht im Rumpf (der Normalfall nach dem Empfang), ersetzt der Kern die Zeile **ohne** Blick auf den Zeichensatz des Textteils (msgutils.cpp:4383). Der neue Zeichensatz kommt allein aus den Bytes: windows-1252 oder ISO-8859-1. War der Textteil `windows-1251`, `koi8-r` oder `iso-8859-2`, liegt er unübersetzt im Postfach (siehe K1), und die neue Angabe ist falsch.

**Gemessen am Kern** (Messfall B): `Content-Type: multipart/mixed; boundary="XYZ"` über `C0 E1 E2 20 EF F0 E8 E2 E5 F2` (kyrillisch, CP1251) → `Content-Type: text/plain; charset="ISO-8859-1"`, `ct-ersetzt=1`. Ein Leser zeigt „Àáâ ïðèâåò“.

**Für [E-177](../Intern/BEFUNDE.md#e-177):** vorher trug die Datei `multipart/mixed` ohne Teile (auch unbrauchbar, aber ohne falsche Zeichensatzangabe); jetzt steht eine bestimmte, falsche Angabe da. Kein Byteverlust. Der Teil-Zeichensatz steht in der Postfachdatei nicht mehr; ihn kennt nur der Empfang. Eine Behebung müsste ihn mitschreiben oder auf eine Angabe verzichten, wenn der Kopf multipart ist und die Bytes nicht nachweislich CP1252 sind. Das ist eine Abwägung, kein Einzeiler. Vermutung: selten bei Gregor.
**Kennung: E-198** (Kern von [E-101](../Intern/BEFUNDE.md#e-101)). **Schwere: klein.**

### K3 — ausgehende Nachrichten nehmen einen anderen Weg und schreiben gar keine Angabe

`SetupCommandLine` verzweigt für `Sum->IsComp()` (filtersd.cpp:2106-2109): `IncludeHeaders=0`, dann `CCompMessageDoc::WriteAsText` (compmsgd.cpp:3839). Dort schreibt `pFile->Put(szBody)` (:3931) bzw. `UnwrapText` (:3923) den reinen Rumpf **ohne** Kopf und ohne `E140TextFuerDatei`. Das trifft eine Filterregel *Outgoing* (`WTA_OUTGOING`, filtersd.h:64) mit „Notify Application … %6“ und *manual* auf Nachrichten in Out. Ein Text mit Umlauten geht dann ohne jede Zeichensatzangabe an das Programm: die „fehlende Angabe“ aus [E-140](../Intern/BEFUNDE.md#e-140), nur auf diesem Weg. Am Quelltext belegt, nicht gemessen. Weder der [E-177](../Intern/BEFUNDE.md#e-177)-Eintrag noch das Messskript erwähnen diesen Zweig; das Skript misst nur In. Nebenbei: `delete CopyText;` (compmsgd.cpp:3925) gibt ein `new[]`-Feld mit skalarem `delete` frei. Das ist alter QUALCOMM-Code und bei `char` unter MSVC folgenlos; ich führe es nicht als Fund. **Schwere: klein.** Vorschlag: im E-177-Eintrag als Rest fortschreiben, keine neue Kennung.

### K4 — Messskript: Begründung für e118 und die festgeschriebene Erwartung `roh=falsch`

- messen-e177.ps1 (Kopf): *„falsche-angabe/fehlende-angabe zaehlen nur [pop] und e118 - die Wege, auf denen Eudora eine Nachricht wirklich empfaengt“*. e118 wird aber ebenso **roh** in `In.mbx` gelegt wie `[roh]` (Abschnitt `-Vorbereiten`), nicht empfangen. In der Sache trägt das, weil `windows-*` beim Empfang nicht übersetzt wird (Index 0) und roh eingelegt deshalb dasselbe ist wie empfangen. Der Satz begründet es aber falsch. Am Quelltext belegt.
- pruefstand-faelle.txt schreibt `roh=falsch` in die **Erwartung**. Wer K1 behebt oder `[roh]` auf eine echte UTF-8-Erkennung umstellt, bekommt den Fall rot, obwohl es besser geworden ist. Zur Auskunft geführte Werte gehören nicht in die Erwartung; das Skript sagt selbst, `[roh]` „steht nur zur Auskunft da“. Vorschlag: `roh=` aus der Erwartungszeile nehmen oder dort ausdrücklich als bekannten Fehlstand (E-197) benennen.
- Das Urteil je Weg selbst ist haltbar: `Charset` liest nur den Kopf bis zur ersten Leerzeile, und `^Content-Type:` trifft `X-Original-Content-Type:` nicht. `Rumpfart` trennt UTF-8-Folgen sauber von Einzelbytes. Fehlt die Datei für `[pop]`, bleibt `pop=-` und die Erwartung `pop=passt` schlägt an. Am Quelltext belegt.

**Schwere: klein** (Doku/Erwartung).

### K5 — TestE177 prüft den zweiten Parameter nicht

Gegenprobe G2 (oben): den Ausdruck `( bKopfzeilen && !m_Sum->IsSubPart() ) ? true : false` durch `true` ersetzt — **359/359, grün**. Gemessen. Folgen hätte das, wenn `SaveAs` einen Rumpf **ohne** Kopf bekäme. Der Kern hält dann den ersten Absatz für den Kopf und setzt `MIME-Version`/`Content-Type` mitten in den Text. Gemessen am Kern, Messfall D: `Erster Absatz …\r\n\r\nZweiter Absatz` → nach dem ersten Absatz stehen drei Kopfzeilen. Heute ist das nicht erreichbar (`IncludeHeaders` ist auf dem einzigen Weg 1, `MSF_SUB_PART` wird nie gesetzt, siehe §1). Erst ein zweiter Aufrufer oder ein Eingriff in `SetupCommandLine` würde es auslösen. Vorschlag: im Test zusätzlich `QT_Zaehle(pFn, "( bKopfzeilen && !m_Sum->IsSubPart() )") == 2` prüfen. **Schwere: klein.**

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| K1 (E-197) | `charset=utf8` bleibt beim Empfang UTF-8, die Datei sagt danach „windows-1252“; auf dem Filterweg ein Rückschritt gegenüber vorher | klein | nein |
| K2 (E-198) | mehrteilige Nachricht mit kyrillischem o. ä. Textteil bekommt einen geratenen Zeichensatz | klein | nein |
| K3 | ausgehende Nachrichten gehen ohne jede Zeichensatzangabe an das Programm (anderer Zweig, unverändert) | klein | nein |
| K4 | Skript begründet e118 falsch; `roh=falsch` steht als Erwartung fest | klein | nein |
| K5 | Test fängt einen falschen Kopfzeilen-Parameter nicht (G2 grün) | klein | nein |
