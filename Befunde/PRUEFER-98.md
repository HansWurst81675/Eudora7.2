# <a id="pruefer-98"></a>PRUEFER-98

Prüfung des Zweigs `e199_festbreite`. Mein Zweig ist wt/pruefer-20261104e, abgezweigt von `origin/e199_festbreite`. Seit `aa1692b6` kamen unter `Eudora71/` und `tools/` drei Commits dazu: `4ae1c87e` (Wirkprobe in `tools/messen-e178.ps1`), `1ba00341` (Behebung und `Tests/TestE199.cpp`) und `f8c3dbf5` (nur `tools/TESTLAEUFE.md` und Buchführung). Geprüft habe ich `1ba00341` und den Teil von `4ae1c87e`, der in `messen-e178.ps1` steht. Eudora habe ich weder gebaut noch gestartet, kein Fenster geöffnet und keinen Prüfstand angefasst. Die Testsuite habe ich in meinem Baum gebaut und gefahren. Die Prüfstandläufe (rot an `aa1692b6`, grün an `1ba00341`) habe ich nicht selbst gemessen, sie sind mir genannt worden.

## Ergebnis vorweg

Die Behebung ist richtig. Wer im Bearbeiten-Modus Text markiert und *Festbreite* gibt, bekommt keine Zeichen `t;` mehr in den Text. Eudora sucht die Platzhalter jetzt in genau der Form, in der sie im Dokument stehen, und ersetzt sie vollständig. Es gibt keinen Fall, in dem die Umwandlung der Platzhalter mit etwas anderem als `"\r\n"` endet und doch gekürzt werden müsste. Eine zweite Stelle mit demselben Fehler gibt es im Quelltext nicht. Die Testsuite läuft mit **410/410**. Mit der alten Datei und mit drei weiteren Rücknahmen wird der Test rot.

Zwei kleine Dinge habe ich gefunden, beide gering:

- **Die Messung am Prüfstand sieht nur eine Form des Mülls (K1, belegt).** Sie zählt `t;`. Bleibt dagegen ein ganzer Platzhalter sichtbar stehen oder wird die Festbreite gar nicht angewendet, meldet sie trotzdem grün. Das Ausschalten der Festbreite (`SplitTagOff`, vier der sechs Stellen) durchläuft sie gar nicht. Am 04.11. wurde das von Hand nachgesehen (5 `<TT>`), das Urteil des Skripts prüft es nicht.
- **Der Test prüft Text, nicht Wirkung (K2, gemessen).** Ein zusätzliches blindes Abschneiden in anderer Schreibweise (`Delete(… - 2, 2)`) bleibt grün.

**Kein Fund hält den Merge auf.** Neue Kennungen habe ich nicht vergeben, beide Funde setzen [E-199](../Intern/BEFUNDE.md#e-199) fort. E-230 und E-231 bleiben frei.

## 1. Liefert `Text2Html` je ein anderes Ende als `"\r\n"`?

**Was hineingeht (belegt).** Die sechs Platzhalter sind feste Zeichenketten ohne `\r`, Leerzeichen oder `>` am Anfang. In `SplitTagOff` sind es `"<eudoradeleteend>"`, `"<eudoradeletestart>"` (TridentReadMessageView.cpp:3387-3388), `"<x-eudoratempON>"` und `"<x-eudoratempOFF>"` (:3519-3522, `IDS_EUDORATEMP_TAG` = `"x-eudoratemp"`, EudoraRes.rc:8445). In `WrapTag` sind es die letzten beiden (:3969-3972). Aufgerufen wird immer `Text2Html(x, FALSE, FALSE)`. Damit gilt `bConvertQuotesToExcerpt = TRUE` (Vorgabe) und `bConvertEmoticonTriggersToImageTags = FALSE`.

**Was herauskommt (belegt, Text2Html.cpp).**

| Zweig in `Text2Html` | Stelle | bei den Platzhaltern |
|---|---|---|
| Zitatebene (`>` am Zeilenanfang) | :392-421 | die Platzhalter beginnen mit `<`, also Ebene 0, kein `ExcerptOn`/`ExcerptOff` (auch nicht nach der Schleife, :1065-1069) |
| `<div>` je Zeile | :423-433 | nur wenn ein `\r` gefunden wird, hier nicht |
| Leerzeichen am Ende, `&nbsp;` | :1035-1041 | nur mit `bDivTag`, hier nicht |
| `<br>` und `"\r\n"` | :1045-1056 | nur wenn die Zeile auf `\r` endet, hier nicht |
| URL-`</div>` | :1029-1033 | nur mit `bConvertURLs`, hier FALSE |
| Emoticons | :978-1027 | aus |
| `"From "` am Anfang | :436-439 | nein |

Heraus kommt also genau die maskierte Zeichenkette, etwa `&lt;x-eudoratempON&gt;`. Es gibt nichts abzuschneiden, weder `"\r\n"` noch `"\n"`, `<br>` oder ein Leerzeichen. Die neue Bedingung `Right(2) == "\r\n"` ist für diese festen Eingaben nie wahr. Die Behebung wirkt also wie das Streichen der sechs Schnitte. Die Bedingung schadet nicht und schützt, falls jemand `Text2Html` ändert (Hinweis T1).

**Originalfehler (belegt).** Die sechs blinden Schnitte stehen schon im ersten Commit `567a5d87`. `Text2Html.cpp` ist seitdem nur in `2fb15664` geändert worden.

## 2. Werden die Platzhalter danach gefunden und ersetzt?

**Form im Dokument (belegt und indirekt gemessen).** Die Platzhalter werden mit `put_text` bzw. `insertAdjacentText` als **Text** eingefügt (:3560, :3564, :3584, :3588). In `get_htmlText` erscheinen sie deshalb maskiert als `&lt;…&gt;`. Dass dort `&gt;` stand, zeigt der alte Fehler selbst: übrig blieb `t;`, der Rest von `&gt;` (gemessen an `aa1692b6`, mir genannt). Dieselbe Form baut `ExpandTag` (Link) von Hand: `"&lt;" + szTempTag + "&gt;"` (:3352, :3357). Die gekürzten Platzhalter (`&lt;x-eudoratempON&gt;`) passen also genau.

**Ersetzen (belegt).**

| Platzhalter | Suche | entfernt wird | vorher (mit Schnitt) | jetzt |
|---|---|---|---|---|
| On/Off in `WrapTag` | :4088, :4101 | Platzhalter, ersetzt durch `<TT>`/`</TT>` | `t;` blieb stehen | vollständig |
| On/Off in `SplitTagOff` | :3679, :3692 | Platzhalter, ersetzt durch Start- bzw. Endtag | `t;` blieb stehen | vollständig |
| `eudoradeleteend` | :3652-3658 | Platzhalter **plus** `szEndTag` (`</TT>`) | entfernt wurden der Platzhalter und nur drei Zeichen von `</TT>`, übrig blieb `T>` | Platzhalter und Endtag |
| `eudoradeletestart` | :3663-3669 | Platzhalter **plus** `szStartTag` | ebenso: der Platzhalter und der Starttag bis auf seine letzten zwei Zeichen (bei `<TT>`: `T>`) | Platzhalter und Starttag |

Die beiden Löschwege waren vor der Behebung also ebenfalls um zwei Zeichen verschoben. Übrig blieb dort nicht `t;`, sondern das Ende des Tags (`T>`). Die neue Wirkprobe hätte das nicht gesehen (K1). Jetzt stimmt die Länge. Ob `</TT>` im `htmlText` wirklich unmittelbar hinter dem Platzhalter steht, ist am Quelltext nicht zu sehen (`insertAdjacentText("BeforeEnd")` legt es so nahe). Das ist eine Vermutung, zur Laufzeit hat es niemand gemessen.

**Wird nicht gefunden (belegt).** Findet `Find` einen Platzhalter nicht (`l < 0`), bleibt er als sichtbarer Text `<x-eudoratempON>` stehen. Das war schon im Original so und ist durch `1ba00341` nicht wahrscheinlicher geworden, sondern unwahrscheinlicher.

## 3. Andere Stellen mit demselben blinden Schnitt

Belegt durch grep über `Eudora71` (ohne `Tests/`):

- `GetLength() *- *2` trifft außer den sechs Stellen fünf weitere: ConConMessage.cpp:2898 und :2961 (prüfen mit `IsCRLF`), ExceptionHandler.cpp:357 (`"0 "` vorn), html2text.cpp:370/:562/:904/:1676 und QCCustomToolBar.cpp:1236 (Anführungszeichen beidseits bzw. Prüfung auf `\r`), Trnslate.cpp:4401 (Länge eines selbst gebauten `"\r\n…"`). Keine davon schneidet nach `Text2Html`.
- Alle 64 Aufrufe von `Text2Html(`: in den zwei Zeilen danach kürzt nur `TridentReadMessageView.cpp` (die sechs Stellen). Die Treffer auf `delete [] Flowed` in mapicmc.cpp:488 und msgutils.cpp:1347 geben Speicher frei.
- Die Platzhalter `IDS_EUDORATEMP_TAG` gibt es nur in `TridentReadMessageView.cpp` (`ExpandTag`, `SplitTagOff`, `WrapTag`).

## 4. Wirkprobe in `tools/messen-e178.ps1`

**Muster (gemessen in PowerShell, ohne Eudora).** `(?<![A-Za-z0-9#&])t;`:

| Probe | Treffer | richtig? |
|---|---|---|
| `<LI><TT>t;Vierbyte` | 1 | ja |
| `<LI>t; <BR>` | 1 | ja |
| `&gt;`, `&quot;`, `&#116;` | 0 | ja |
| `&lt;x-eudoratempON&gt;` (Platzhalter sichtbar stehen geblieben) | 0 | **nein**, siehe K1 |
| `<TT>T>Vierbyte` (Rest der alten Löschwege) | 0 | **nein**, siehe K1 |
| `&amp;t;` | 1 | Fehlalarm nur, wenn im Text ein echtes `&t;` stünde. Die Prüfmail enthält das nicht |

Fehlalarme in der Prüfmail sehe ich nicht. In `messen-e178.ps1` steht `t;` sonst nur in Kommentaren (am Quelltext belegt). Die Kopfzeilen der Mail (`text/html; charset`) haben einen Buchstaben vor dem `;`. Der Bereich ab `LastIndexOf('From ???@???')` ist richtig gewählt. Fehlt die Zeile, wird die ganze Datei gezählt, das ist strenger, nicht blinder.

**Was das Urteil nicht prüft (belegt).** `Zustand` (:221-232) wertet je Schritt nur Emoji, Kyrillisch und `?` aus. Das Urteil `tt=passt` sagt also nicht, dass die Festbreite angewendet wurde. Die Schritte sind `fett`, `kursiv`, `link`, `tt` (:368-373). `tt` ruft `WrapTag` auf (`OnBlkfmtFixedwidth` ohne gesetzte Festbreite, :2988-3015). `SplitTagOff` wird nur gerufen, wenn die Festbreite in der Auswahl schon gilt (:2995-3004). Das kommt im Ablauf nicht vor. Die vier `SplitTagOff`-Stellen sind deshalb nur am Quelltext belegt, nicht gemessen.

## 5. Test

Gemessen in meinem Baum. Ich habe die Quelle mit Perl `:raw` über Zeilenanker geändert, der Ersatztext stand in einer Skriptdatei, und jede Probe hat genau einen Treffer gemeldet. Danach habe ich die Datei aus der Sicherung im Scratchpad zurückgeholt und mit `cmp` byte-gleich geprüft. `git status` war danach leer. Die Läufe ohne Bau sind gültig, weil der Test die Quelle zur Laufzeit liest. Jeder rote Lauf meldete genau `[FEHL] E-199: WrapTag/SplitTagOff schneiden "\r\n" nur ab, wenn es da ist`.

Ein erster Durchgang verlor die Rückstriche der Suchmuster in der Shell. G2 bis G4 meldeten 0 Treffer. Die Ergebnisse habe ich verworfen und den Durchgang mit `\x5c` statt Rückstrich wiederholt. Die Tabelle zeigt nur den zweiten Durchgang.

| Probe | Treffer | Ergebnis | Erwartung |
|---|---|---|---|
| Stand wie eingecheckt, Bau und Lauf | – | 410/410 | grün |
| G1: alte Datei aus `aa1692b6` | ganze Datei | **1 rot** | rot, passt |
| G2: Wächter vor dem Off-Schnitt in `WrapTag` gestrichen (:4082) | 1 | **1 rot** | rot, passt |
| G3: Wächter vor dem Delete-Ende-Schnitt in `SplitTagOff` gestrichen (:3636) | 1 | **1 rot** | rot, passt |
| G4: `==` zu `!=` umgedreht (:3642, schneidet dann immer) | 1 | **1 rot** | rot, passt |
| G5: falsche Variable im Wächter (`szTempOffTag.Right` vor dem On-Schnitt, :4079) | 1 | 410/410 grün | grün ist hier richtig: der Wächter ist für beide Variablen nie wahr (§1), das Verhalten bleibt gleich |
| G6: hinter dem Off-Schnitt in `WrapTag` zusätzlich `szTempOffTag.Delete( szTempOffTag.GetLength() - 2, 2 );` | 1 | 410/410 grün | rot, siehe K2 |
| G7: `Right( 2 )` mit Leerraum statt `Right(2)` (:3639) | 1 | 1 rot | Fehlalarm bei gleichem Verhalten. Hinnehmbar, der Test sagt dann, was er sucht |

## Funde

### <a id="k1"></a>K1 (gering, belegt): die Messung am Prüfstand sieht nur eine Form des Mülls

- **Wo:** `tools/messen-e178.ps1:416-422` zählt nur `t;`. `Zustand` (:221-232) prüft je Schritt nicht, ob die Formatierung angewendet wurde.
- **Folge:** Drei Fehlerbilder melden `E-178p` grün:
  - Ein Platzhalter wird nicht gefunden und bleibt als `<x-eudoratempON>` sichtbar stehen.
  - Die Löschwege lassen `T>` stehen (so wäre es vor der Behebung gewesen, §2).
  - `WrapTag` steigt vorher aus, und es entsteht gar kein `<TT>`.

  Am 04.11. hat das jemand von Hand ausgeschlossen (5 `<TT>`, `f8c3dbf5`), das Skript selbst tut es nicht. `SplitTagOff` (Festbreite ausschalten, vier der sechs Stellen) durchläuft der Prüfstand gar nicht.
- **Einschätzung:** Für diese Behebung genügt das. Die Wirkprobe hat den gemeldeten Fehler rot gezeigt und die Behebung grün. Als Wache gegen eine spätere Rückkehr ist sie zu schmal.
- **Vorschlag:** In der gespeicherten Fassung außerdem `eudoratemp` und `eudoradelete` zählen (müssen 0 sein). Nach dem Schritt `tt` ein `<TT` im Dokument verlangen. Wenn es mit wenig Aufwand geht, einen fünften Schritt „Festbreite aus“ auf einem Teil der eben festbreit gesetzten Auswahl, der `SplitTagOff` mit den On/Off-Platzhaltern durchläuft.

### <a id="k2"></a>K2 (gering, gemessen): der Test erkennt ein blindes Abschneiden nur in einer Schreibweise

- Der Test zählt `.GetLength() - 2 );` und den Wächter. Ein weiteres Abschneiden in anderer Form, etwa `Delete( x.GetLength() - 2, 2 )` (G6), bleibt grün, obwohl dann wieder `t;` im Text steht.
- Den Fall G5 (falsche Variable im Wächter) muss der Test nicht erkennen, er ändert nichts am Verhalten.
- **Vorschlag:** In beiden Abschnitten `GetLength() - 2` ohne die folgenden Zeichen zählen (4 bzw. 2). Dann fällt jede zusätzliche Kürzung um zwei auf. Den Rückgabewert von `Text2Html` für die Platzhalter direkt zu prüfen, wäre die bessere Probe. Das scheitert vermutlich daran, dass `Text2Html` an `GetIniShort` und `InitHtmlStrings` hängt (Vermutung, nicht versucht).

## Hinweise (keine Funde)

- **T1 (belegt):** Die Bedingung `Right(2) == "\r\n"` ist für die sechs festen Platzhalter nie wahr (§1). Das Ergebnis ist dasselbe wie beim Streichen der Schnitte. Ich würde sie stehen lassen, weil sie eine spätere Änderung an `Text2Html` abfängt. Der Kommentar an den sechs Stellen stimmt.
- **T2 (belegt):** Der Befund [E-199](../Intern/BEFUNDE.md#e-199) nennt `TridentReadMessageView.cpp:4074-4077` und `:3636-3642`. Das sind die Zeilen an `aa1692b6`. Seit `1ba00341` stehen die Stellen bei :4078-4083 und :3635-3646. Für die Ursache ist das richtig, weil sie den alten Stand beschreibt. Wer nachliest, findet im heutigen Stand sechs Zeilen weiter unten.
- **T3 (belegt, nicht durch `1ba00341` berührt):** `ExpandTag` (Link) prüft das Ergebnis von `Find` nicht auf `-1` (:3352-3359). Fehlt ein Platzhalter, würde der Text um die Länge des Platzhalters falsch zerschnitten. Das stand so schon im Original. Im Prüfstand läuft der Link-Schritt grün. Ein Anlass zum Handeln besteht nicht.
- **Bytes (gemessen):** `TridentReadMessageView.cpp` hat vor und nach der Behebung 18 CRLF und keine Bytes über 127. Neu sind 6 Zeilen mit LF, das passt zur Umgebung. `TestE199.cpp` hat wie die anderen Testdateien (`TestE188.cpp`, `TestMain.cpp`) nur LF.

## Übersicht

| Fund | Was passiert | Schwere | Hält den Merge auf? |
|---|---|---|---|
| [K1](#k1) | Prüfstand `E-178p` meldet grün, wenn ein Platzhalter sichtbar stehen bleibt, `T>` übrig bleibt oder keine Festbreite entsteht. `SplitTagOff` wird nicht durchlaufen | gering | nein |
| [K2](#k2) | `TestE199` bleibt grün bei einem zusätzlichen blinden Abschneiden in anderer Schreibweise | gering | nein |
| T1 | Wächter ist für die festen Platzhalter nie wahr, wirkt wie Streichen | – | nein |
| T2 | Zeilennummern im Befund beziehen sich auf `aa1692b6` | – | nein |
| T3 | `ExpandTag` prüft `Find` nicht auf `-1` (Original) | – | nein |
