# PRÜFER-15 — E-104 auf Datenverlust: **nein, es geht kein Text verloren**

Stand: 17.09.2026. Geprüfter Commit: `eed2e4e` („E-104: Kopfzeilen kleben nicht
mehr zusammen, verdorbene INI-Werte repariert"), enthalten in `origin/main`
(`5cf45b7`); `compmsgd.cpp` und `msgutils.cpp` sind seit `eed2e4e` unverändert
(`git diff --stat eed2e4e origin/main` meldet nichts).

Zweig `wt/pruefer-e104` von `origin/main`, eigener Arbeitsbaum
`Eudora7.2-wt-pruefer`. **Kein Quelltext geändert.**

Auftrag: nur Datenverlust, alles andere hat Zeit.

---

## Die Antwort in einem Satz

**Nein.** Durch die Änderung in `compmsgd.cpp` geht kein Text verloren, und es
wird auch kein Müll geschrieben — `UnwrapText` arbeitet nachweislich im
übergebenen Puffer, verschiebt den Anfang nie und gibt genau den Zeiger zurück,
den es bekommen hat. `pFile->Put( CopyText )` schreibt damit byteweise
dasselbe, was `pFile->Put( UnwrapText( CopyText ) )` geschrieben hätte.

**Das Paket kann in dieser Hinsicht raus.** Es bleiben vier Mängel, davon einer
gewichtig (M-1: derselbe Fehler steht im Lesefenster-Weg unverändert offen).

---

## Frage 1 — Schreibt der neue Code noch alles?

`UnwrapText` (`Eudora71/Eudora/msgutils.cpp:453-512`), ganz gelesen. Drei
Messungen am Quelltext:

**a) Es gibt genau einen Puffer.** `char* Beg = text; char* t = text;` — Lese-
und Schreibzeiger starten beide auf dem übergebenen Zeiger. Es wird nirgends
etwas alloziert. Geschrieben wird ausschließlich über
`strncpy(t, Beg, End2 - Beg + 1)` mit `t <= Beg`, dazu `*++End2 = ' '` und am
Ende `*t = 0`.

**b) Der Rückgabewert ist das Argument.** Letzte Zeile: `return (text);` —
buchstäblich der Eingabezeiger, unverändert. Der einzige andere
Rückgabepunkt ist `if (!text) return (NULL);`. Damit ist der Tausch
`Put(UnwrapText(X))` → `UnwrapText(X); Put(X)` eine Identität.

**c) Es wird nie vor `text` geschrieben.** Das ist der Punkt, an dem ein Fehler
teuer gewesen wäre, weil `pszRumpf` jetzt mitten in `CopyText` zeigt und ein
Rückwärtsschreiben die Kopfzeilen zerstören würde. Nachgerechnet:

    else                                   // msgutils.cpp:495
    {
        End2 = End - 1;
        while (End2 != Beg && (*End2 == '\r' || *End2 == ' ' || *End2 == '\t'))
            End2--;
        ...
        *++End2 = ' ';
    }

`End2 = End - 1` könnte nur dann unter `Beg` rutschen, wenn `End == Beg` wäre.
Dieser Fall erreicht den `else`-Zweig aber nie: die Prüfkette davor fängt ihn
zweifach ab — `else if (End - Beg < 40)` (Zeile 480) greift bei `End == Beg`
mit `0 < 40`, und `else if (End == Beg || ...)` (Zeile 484) steht ohnehin
darüber. In den `else`-Zweig kommt nur, wer `End - Beg >= 40` hat; dort ist
`End2 >= Beg + 39`. Die `while`-Schleife bricht bei `End2 == Beg` ab, `*++End2`
schreibt also frühestens auf `Beg + 1`. **Kein Schreibzugriff unterhalb von
`pszRumpf`.** Die Kopfzeilen bleiben Byte für Byte stehen.

**d) Der Puffer kann nur kürzer werden, nie länger.** Je Durchlauf werden
`End + 1 - Beg` Bytes gelesen und `End2 - Beg + 1` Bytes geschrieben, mit
`End2 <= End`. Es gibt keinen Überlauf und keine verschobene Terminierung: das
abschließende `*t = 0` steht an der neuen, nie späteren Endposition.
`CopyText` bleibt eine gültige NUL-terminierte Zeichenkette.

**e) Der Schreibweg nimmt strlen.** `pFile->Put(CopyText)` bindet
`JJFile::Put(const char*, long = -1)` (`Eudora71/QCUtils/inc/jjfile.h:98`), das
an `JJFileMT::Write_` durchreicht; dort steht
`if (lNumBytesToWrite < 0) lNumBytesToWrite = strlen(pBuffer);`
(`Eudora71/QCUtils/src/jjfile.cpp:925-926`). Geschrieben wird also genau bis zu
dem NUL, das `UnwrapText` gesetzt hat — Kopfzeilen plus entfalteter Rumpf,
vollständig.

**f) Der Rumpf wird genauso entfaltet wie vorher.** `UnwrapText` ist
gedächtnislos: jeder Durchlauf sieht nur die laufende Zeile und höchstens zwei
Zeichen der nächsten (`End[1]`, `End[2]`). Ein Start mitten im Puffer liefert
für die Zeilen ab `pszRumpf` dieselben Entscheidungen wie ein Start ganz vorn.
Der Rumpf sieht nach der Änderung aus wie vorher.

**g) `CopyText == NULL`.** `FindBody(NULL)` gibt `NULL` zurück, die Schranke
`pszRumpf && *pszRumpf` fängt es, `Put(NULL)` liefert `S_OK` („successfully
wrote nothing", `jjfile.cpp:920-921`). Vorher rief `UnwrapText(NULL)` →
`NULL` → `Put(NULL)`: identisches Verhalten, keine Regression.

**Ergebnis Frage 1: die Änderung ist korrekt. Kein Textverlust, kein Müll.**

---

## Frage 2 — `FindBody` und die Zeilenenden

**Der Fehlschlagfall tritt auf diesem Weg nicht ein — gemessen, nicht geraten.**

Der Text entsteht in `PgCompMsgView::GetMessageAsText`
(`Eudora71/Eudora/PgCompMsgView.cpp:333-364`). Bei `IncludeHeaders == TRUE`
gilt `szText = hdrs; szText += Body;` mit `hdrs` aus
`CCompMessageDoc::GetMessageHeaders` (`Eudora71/Eudora/compmsgd.cpp:4057-4126`).
Dort wird jede Kopfzeile als

    hdrs += ( CRString(IDS_HEADER_TO + i) + " " + GetHeaderLine(i) + "\r\n" );

gebaut und am Ende **`hdrs += "\r\n";`** angehängt (Zeile 4124). Die
Zeichenkette endet damit zwingend auf `"\r\n\r\n"`, und zwar unabhängig davon,
was Paige für den Rumpf liefert. Die Trennstelle ist nicht geraten, sie wird
hier explizit erzeugt. Eine leere Kopfzeile erzeugt keine frühere Fundstelle,
weil zwischen Name und Zeilenende immer noch `": "` bzw. `" "` steht
(`"Cc: \r\n"`). `dateMaybe` wird vorangestellt (`"Date: …\r\n"`, einfaches
CRLF) und verschiebt die erste Fundstelle nicht.

Für den Fall `bKopfzeilen == FALSE` wird `FindBody` gar nicht gerufen.

**Und wenn `FindBody` doch einmal scheitert**, liefert es
`message + strlen(message)`, `*pszRumpf == 0`, `UnwrapText` läuft nicht. Das
ist **kein Datenverlust** — geschrieben wird der vollständige, nur nicht
entfaltete Text. Es entspricht exakt dem Vorbild in `tocview.cpp:3157-3160`,
wo `FindBody` denselben Zeiger liefert und `UnwrapText` auf der leeren
Zeichenkette sofort zurückkehrt. Die neue Fassung ist hier also *nicht*
schlechter als die Vorlage, sondern gleich.

**Nackte LF oder nackte CR im Rumpf:** auch das kostet keinen Text.
`UnwrapText` sucht `strchr(Beg, '\n')`. Findet es keins, greift
`if (!End) End2 = End = Beg + strlen(Beg) - 1;` — Regel 1, „on last line":
`strncpy` kopiert den ganzen Rest unverändert auf sich selbst, `Beg = End + 1`
zeigt auf das NUL, die Schleife endet, `*t = 0` steht an der alten Stelle.
Identität. Bei nackten CR (Paige-Absatzzeichen) also: „Absätze raten" wirkt
nicht — was **schon vor** `eed2e4e` so war und kein Befund dieses Commits ist.

Was `GetTextAs(..., PgDataTranslator::kFmtText)` konkret liefert, habe ich
nicht bis in den Paige-Übersetzer hinein gemessen; für die Datenverlustfrage
ist es unerheblich, weil alle drei Fälle (CRLF, nur LF, nur CR) nachgerechnet
verlustfrei sind. Falls die Absatzerkennung im Rumpf nicht greift, ist das eine
Wirkungs-, keine Verlustfrage — gehört in einen eigenen Befund, nicht in dieses
Paket.

---

## Frage 3 — `SetIniShort` aus `E104SchalterLesen`

**Gefahrlos.** Drei Messungen:

**a) Kein Datei-I/O, kein Fremdzustand.** `SetIniShort`
(`Eudora71/Eudora/rs.cpp:649-656`) formatiert mit `itoa` und ruft
`SetIniString` (`rs.cpp:620-646`). Das schreibt nur in die globale Ablage
`g_IniEntries` und setzt `IES_DIRTY`. Kein `WritePrivateProfileString`, kein
Dateizugriff, keine Anzeige. Zusätzlich: `GetIniShort` selbst legt beim ersten
Lesen einen Eintrag in derselben `g_IniEntries` an — der Lesepfad verändert die
Ablage also ohnehin. `E104SchalterLesen` fügt **keine neue Risikoklasse** hinzu.
Der Aufrufweg (`CCompMessageDoc::OnFileSaveAs` → `SaveAsFile`) ist ein
MFC-Befehlsbehandler, also Hauptfaden.

**b) Es kann nichts überschrieben werden, was der Anwender gerade gesetzt hat.**
Die Reihenfolge ist gemessen: `theDlg.DoModal()` (`compmsgd.cpp:3362`) →
`CSaveAsDialog::OnOK` schreibt `SetIniInt(...)` (`SaveAsDialog.cpp:381-382`)
bzw. der Ersatzweg `SetIniShort(...)` bei `IsVersion4()`
(`compmsgd.cpp:3375-3376`) → **erst danach** `SaveAsFile(&theFile, szPathName)`
(`compmsgd.cpp:3396`). `E104SchalterLesen` liest also, was der Anwender gerade
gewählt hat, und schreibt nur zurück, wenn dieser Wert weder 0 noch 1 ist.
Eine frische Wahl ist immer 0 oder 1 (siehe c) und bleibt unangetastet.

**c) Kein Schlüssel darf hier legitim größer als 1 sein.** Alle Aufrufstellen
von `E104SchalterLesen` (`grep` über `Eudora71/`): genau zwei, beide in
`compmsgd.cpp:3434` und `:3438`, für `IDS_INI_INCLUDE_HEADERS` und
`IDS_INI_GUESS_PARAGRAPHS`. Beide Werte stammen aus Kästchen, die mit
**`BS_AUTOCHECKBOX`** erzeugt werden (`SaveAsDialog.cpp:186` und `:193`) — also
zweiwertig, `GetCheck()` liefert nur `BST_UNCHECKED` (0) oder `BST_CHECKED` (1),
nie `BST_INDETERMINATE` (2). Auch `m_Inc`/`m_Guess` werden in `OnInitDialog`
auf `FALSE`/`TRUE` gezogen (`SaveAsDialog.cpp:146-160`). Ein Wert > 1 ist auf
diesen beiden Schlüsseln immer verdorben. **Die Reparatur setzt nichts
Legitimes zurück.**

---

## Frage 4 — Hat `bKopfzeilen` überall denselben Wert wie vorher?

**Nein.** In `CCompMessageDoc::SaveAsFile` stehen jetzt drei Leser desselben
Schlüssels nebeneinander, zwei davon ungeschützt:

* `compmsgd.cpp:3415` — `if ( GetIniShort( IDS_INI_INCLUDE_HEADERS ) )` für
  `dateMaybe` (**roh**)
* `compmsgd.cpp:3429` — `GetMessageAsHTML(msg, GetIniShort( ... ))` im
  HTML-Zweig (**roh**)
* `compmsgd.cpp:3434` — `E104SchalterLesen( ... )` (**geprüft**)

Bei Gregors verdorbenem `IncludeHeaders=16720` gilt beim **ersten** Speichern
nach dem Einspielen: Zeile 3415 sieht 16720 → wahr → `dateMaybe` wird gebaut.
Zeile 3434 sieht 16720 → setzt auf 0 → `bKopfzeilen = FALSE` → der Text kommt
**ohne** Kopfzeilen. Ergebnis: die Datei beginnt mit einer einzelnen
`Date:`-Zeile und danach unmittelbar der Rumpf, ohne Leerzeile. Ab dem zweiten
Speichern stimmen alle drei überein.

Das ist **kein Datenverlust** (die Kopfzeilen werden nicht angefordert, nicht
abgeschnitten) und auch kein Verkleben: `pszRumpf` ist in diesem Fall
`CopyText`, `UnwrapText` läuft also über die `Date:`-Zeile. Die ist nach
`IDS_SMTP_DATE_FORMAT` (`services.cpp:2119-2128`, „Date: %0.3s, %02d %0.3s %4d
%02d:%02d:%02d" plus `" %4"`-Zonenanhang) 37 Zeichen lang, mit dem `\r` davor
`End - Beg == 38`. Regel 3 in `UnwrapText` (`msgutils.cpp:480`,
`End - Beg < 40` → „this line is short") lässt sie stehen. **Der Abstand zum
Verkleben beträgt zwei Zeichen.** Das ist Zufall, kein Schutz — siehe M-2.

---

## Mängel

### M-1 (gewichtig) — derselbe Fehler steht im Lesefenster-Weg unverändert offen

`eed2e4e` hat nur `CCompMessageDoc` behoben. Der identische ungeschützte
Aufruf steht zweimal in `CReadMessageDoc` — das ist der Weg „geöffnete
**empfangene** Nachricht → Datei → Speichern unter":

**Stelle 1: `Eudora71/Eudora/ReadMessageDoc.cpp:603-608`**

    view->GetMessageAsText(msg, GetIniShort( IDS_INI_INCLUDE_HEADERS ));
    if ( GetIniShort( IDS_INI_GUESS_PARAGRAPHS ) )
    {
        char *CopyText = ::SafeStrdupMT( msg );
        if ( pFile->Put( UnwrapText( CopyText ) ) != S_OK )

Richtig wäre dort dasselbe wie jetzt in `compmsgd.cpp:3466-3473`:

    const BOOL bKopfzeilen = E104SchalterLesen( IDS_INI_INCLUDE_HEADERS );

    view->GetMessageAsText(msg, bKopfzeilen);

    if ( E104SchalterLesen( IDS_INI_GUESS_PARAGRAPHS ) )
    {
        char*   CopyText = ::SafeStrdupMT( msg );
        char*   pszRumpf = bKopfzeilen
                         ? (char*) ::FindBody( CopyText )
                         : CopyText;

        if ( pszRumpf && *pszRumpf )
            ::UnwrapText( pszRumpf );

        if ( pFile->Put( CopyText ) != S_OK )

**Stelle 2: `Eudora71/Eudora/ReadMessageDoc.cpp:535-552`** (`CReadMessageDoc::SaveAs`)

    if (!GetIniShort(IDS_INI_INCLUDE_HEADERS) || m_Sum->IsSubPart())
        Text = FindBody(Text);
    ...
    if (GetIniShort(IDS_INI_GUESS_PARAGRAPHS))
    {
        char* CopyText = ::SafeStrdupMT(Text);
        BOOL Status = SA.PutText(UnwrapText(CopyText));

Hier ist `FindBody` **genau umgekehrt** eingesetzt: es wird gerufen, wenn die
Kopfzeilen *nicht* mitsollen, und nicht gerufen, wenn sie mitsollen — also
genau dann nicht, wenn `UnwrapText` den Schutz bräuchte. Richtig:

    const BOOL  bKopfzeilen = E104SchalterLesen( IDS_INI_INCLUDE_HEADERS )
                              && !m_Sum->IsSubPart();
    const char* Text = GetText();

    if (!bKopfzeilen)
        Text = FindBody(Text);

    if (Text == NULL)
        return FALSE;

    if (E104SchalterLesen(IDS_INI_GUESS_PARAGRAPHS))
    {
        char* CopyText = ::SafeStrdupMT(Text);
        if (CopyText == NULL)
            return FALSE;

        char* pszRumpf = bKopfzeilen ? (char*) ::FindBody( CopyText )
                                     : CopyText;
        if (pszRumpf && *pszRumpf)
            ::UnwrapText( pszRumpf );

        BOOL Status = SA.PutText(CopyText);
        delete [] CopyText;
        return (Status);
    }

**Warum das dringlich ist.** Gregors gemeldeter Fall war eine Nachricht
„aus dem geöffneten Fenster" mit `From:`/`Subject:`/`Cc:` — die Reihenfolge und
das leere `Cc:` passen zum Kopfzeilensatz des Verfassenfensters
(`GetMessageHeaders`, `IDS_HEADER_TO + i`), deshalb ist die behobene Stelle
plausibel die getroffene. Aber `markus.bakus@gmx.de` ist ein **Absender**, also
eine empfangene Nachricht. Speichert Gregor nach diesem Paket eine empfangene
Nachricht aus ihrem eigenen Fenster, **tritt derselbe Fehler wieder auf**, und
zwar mit derselben Sichtbarkeit wie am 17.09. Vor der Auslieferung sollte
wenigstens nachgesehen werden, welche der beiden Klassen sein Fenster
tatsächlich bedient hat. Kein Datenverlust, aber der Befund ist nur zur Hälfte
geschlossen.

### M-2 (mittel) — zwei rohe Leser neben dem geprüften

`Eudora71/Eudora/compmsgd.cpp:3415` und `:3429`. Richtig wäre, den Schalter
**einmal** oben zu lesen und überall denselben Wert zu verwenden:

    const BOOL  bKopfzeilen = E104SchalterLesen( IDS_INI_INCLUDE_HEADERS );

    char dateMaybe[64];
    *dateMaybe = 0;
    if ( bKopfzeilen )
    {
        ComposeDate( dateMaybe, m_Sum );
        ...
    }

und in Zeile 3429 `GetMessageAsHTML(msg, bKopfzeilen)`. Dann verschwindet auch
der einsame `Date:`-Kopf aus Frage 4, und der HTML-Zweig repariert die INI
genauso wie der Textzweig (derzeit gar nicht).

### M-3 (klein) — `filtersd.cpp` schreibt einen verdorbenen Wert wieder zurück

`Eudora71/Eudora/filtersd.cpp:2048` liest `short ih = GetIniShort(...)` roh und
stellt ihn in Zeile 2083 mit `SetIniShort(IDS_INI_INCLUDE_HEADERS, ih)` wieder
her. Läuft ein Filter mit „Nachricht als Datei" **bevor** zum ersten Mal
gespeichert wird, trägt die INI danach den verdorbenen Wert erneut. Die
Reparatur ist dadurch nicht dauerhaft, nur vertagt. Richtig:
`short ih = E104SchalterLesen(IDS_INI_INCLUDE_HEADERS);` in Zeile 2048.

### M-4 (klein) — `tocview.cpp` repariert nicht mit

`Eudora71/Eudora/tocview.cpp:3098-3099` liest beide Schlüssel roh
(`BOOL(::GetIniShort(...))`). Der **Schutz** gegen das Verkleben ist dort
vorhanden (Zeile 3149-3160, das Vorbild), es geht also nur um die Reparatur des
verdorbenen Werts. Sauber wäre `E104SchalterLesen` auch hier. Kein
Datenverlust.

---

## Nicht beanstandet

* `CCompMessageDoc::WriteAsText` (`compmsgd.cpp:3836-3931`) hat in Zeile 3920
  ebenfalls ein nacktes `Put( UnwrapText( CopyText ))`. Das ist **richtig so**:
  `szBody = GetText()` liefert dort bereits nur den Rumpf, die Kopfzeilen
  werden getrennt mit `pFile->Put(...)` geschrieben (Zeilen 3848-3855). Alle
  Aufrufer aus `compmsgd.cpp` (489, 3327, 4037) übergeben zudem
  `bIsStationery = TRUE`, womit der Zweig gar nicht läuft; der einzige Aufrufer
  mit `FALSE` ist `filtersd.cpp:2064`, und auch dort sind die Kopfzeilen außer
  Reichweite. `CReadMessageDoc::WriteAsText` ist ein `return FALSE;`-Rumpf
  (`ReadMessageDoc.cpp:426-431`).
* `mainfrm.cpp:3868` und `PaigeEdtView.cpp:7935` rufen `UnwrapText` auf
  Zwischenablage-/Einfügetext ohne Kopfzeilen. Nicht betroffen.
* Der Spurmarkentext in `E104SchalterLesen` (`msgutils.cpp:4270-4278`) nennt
  Schlüsselnummer und alten Wert in **einer** Zeile — entspricht
  `Arbeitsweise/zwei-werte-in-eine-ausgabe.md`.

---

## Umfang dieser Prüfung

Ganz gelesen: `UnwrapText` (`msgutils.cpp:448-512`), `FindBody`
(`msgutils.cpp:330-352`), `E104SchalterLesen` (`msgutils.cpp:4221-4280`),
`CCompMessageDoc::SaveAsFile` (`compmsgd.cpp:3399-3492`),
`CCompMessageDoc::OnFileSaveAs` (`compmsgd.cpp:3320-3396`),
`CCompMessageDoc::GetMessageHeaders` (`compmsgd.cpp:4057-4126`),
`CCompMessageDoc::WriteAsText` (`compmsgd.cpp:3836-3931`),
`PgCompMsgView::GetMessageAsText` (`PgCompMsgView.cpp:333-364`),
`CReadMessageDoc::SaveAs`/`SaveAsFile`/`WriteAsText`
(`ReadMessageDoc.cpp:426-431, 535-560, 573-630`),
`SetIniString`/`SetIniShort` (`rs.cpp:620-656`),
`JJFileMT::Write_` (`QCUtils/src/jjfile.cpp:915-954`) und `jjfile.h:84-104`,
`ComposeDate`/`ComposeDateMT` (`sendmail.cpp:644-669`,
`QCUtils/src/services.cpp:2084-2133`),
`CSaveAsDialog` Konstruktor/`OnInitDialog`/`OnOK`
(`SaveAsDialog.cpp:30-60, 140-215, 370-395`),
`CTocView::OnFileSaveAs` (`tocview.cpp:3080-3165`),
`filtersd.cpp:2040-2090`.

`grep` über `Eudora71/` nach `UnwrapText`, `FindBody`, `E104SchalterLesen`,
`IDS_INI_INCLUDE_HEADERS`, `IDS_INI_GUESS_PARAGRAPHS` — alle Fundstellen oben
abgehandelt.

**Nicht geprüft** (außerhalb des Auftrags): der Bau, die Doku zu E-104, die
Frage, was `PgDataTranslator::kFmtText` für Zeilenenden liefert, und alles
außerhalb von `eed2e4e`.
