# PRÜFER-12 — die Umsetzung der eigenen Funde nachgerechnet

Stand: 17.09.2026, Zweig `e97-speichern-absturz`. Geprüft wurden `220c0de`
(E-100, setzt P-5/P-6/P-7 um) und `1d37623` (E-99, setzt P-13 um).

Gelesen wurden nicht nur die Diffs, sondern `SaveAsDialog.cpp` ganz,
`PgMsgView.cpp` `ExportMessage`/`SaveInfo` ganz, `CPaigeEdtView::PrepareUndo`,
`UpdateChangeState` und `OnEditUndo` ganz, `PgCompMsgView::load_signature`,
`CPaigeEdtView::SetTextAs`, `CPaigeEdtView::MakeAutoURLSpaghetti`,
`E88OriginalEinsetzen` ganz, dazu die MFC-Quellen `dlgfile.cpp` und `afx.h`.

---

## Kurzantwort auf die Frage, bei der ein Fehler teuer wäre

**Nein — `GetFileNameFromDialog` füllt den Puffer im Fehlerfall nicht.** Der
frühe `return` (Zeile 429/430) lässt `realFileName` (`OnOK:387`)
uninitialisiert.

**Schaden entsteht daraus heute nicht, und 1.0.65 muss deshalb nicht
zurückgezogen werden.** Drei voneinander unabhängige Gründe, jeder für sich
ausreichend:

1. Der Aufrufer liest den Puffer **nur** innerhalb von `if (m_IsStat)`
   (`OnOK:391`). `m_IsStat` ist nachweislich immer FALSE: der Konstruktor setzt
   ihn auf FALSE (Zeile 35, mit dem Vermerk *„For Now"*), `OnInitDialog` setzt
   ihn am Ende beider Zweige wieder auf FALSE (161/165 und 228), und die einzige
   Stelle, die ihn TRUE setzen könnte, ist `ToggleStat:257` — die hängt an
   `ON_BN_CLICKED(IDC_STATIONERY)`, und diesen Schalter gibt es nicht (E-98).
2. Der **Dateiname, mit dem Eudora wirklich arbeitet**, kommt nirgends aus
   diesem Puffer, sondern aus `theDlg.GetPathName()` — `tocview.cpp:3091`,
   `saveas.cpp:107`, `compmsgd.cpp:3379`. `realFileName` ist eine lokale
   Variable, die `OnOK` nie verlässt.
3. Auf der Vista-Schiene wird `OnOK` ohnehin nicht erreicht. MFC 14.38 führt die
   Zustimmung über `IFileDialogEvents::OnFileOk` → `CFileDialog::OnFileNameOK`
   (`dlgfile.cpp:605-609`); `CSaveAsDialog` überschreibt `OnFileNameOK` nicht.
   Genau das sagen die drei „Hack alert!"-Kommentare von 1996 an den
   Aufrufstellen auch schon.

**Trotzdem ist es ein Mangel, und er gehört behoben** — siehe P-14. Er ist
allerdings **nicht durch `220c0de` entstanden**: schon vorher verließ die
Funktion den Puffer unbeschrieben, wenn `dlgPtr->GetDlgItem(edt1)` NULL lieferte
(`if (fileNameWnd)`, Zeile 436). Der neue Wächter hat einen zweiten Weg zu einem
Loch hinzugefügt, das seit 1996 offen ist.

---

## Frage 1 — die vier Wächter

### P-14 — `GetFileNameFromDialog` verletzt ihren eigenen Vertrag

`SaveAsDialog.cpp:412-438`. Die Funktion heißt „hol den Dateinamen" und
verspricht damit, `buf` zu beschreiben. Sie tut es auf **zwei** Wegen nicht:
beim neuen `return` (429) und bei `fileNameWnd == NULL` (436). Der Aufrufer hat
keine Möglichkeit, das zu bemerken — die Funktion liefert `void`.

Richtig ist eine Zeile am Anfang, vor jedem `return`:

```cpp
void CSaveAsDialog::GetFileNameFromDialog(char *buf, int bufLen)
{
	CWnd *dlgPtr = NULL;

	// Der Vertrag dieser Funktion ist "buf ist danach eine Zeichenkette".
	// Sie kehrt an zwei Stellen zurueck, ohne zu schreiben; ohne diese
	// Zeile stuende dort der Inhalt des Stapels.
	if (buf && bufLen > 0)
		buf[0] = 0;

	if (IsVersion4())
	...
```

Zusätzlich — und unabhängig davon empfehlenswert, weil es auch den Fall
abdeckt, dass die Funktion eines Tages anders scheitert — `OnOK:387`:

```cpp
	char realFileName[_MAX_PATH + 1];
	realFileName[0] = 0;
	GetFileNameFromDialog(realFileName, _MAX_PATH);
```

Was ohne das im Ernstfall geschähe, ist kein hübsches Bild: `strstr` und
`strrchr` liefen über nicht gesetzten Stapelspeicher bis zum ersten Nullbyte,
danach hinge `strcat(realFileName, ".sta")` einen Text an eine Zeichenkette
unbekannter Länge — ein Überlauf. Scharf wird das in dem Moment, in dem jemand
E-98 behebt und `m_IsStat` wieder TRUE werden kann. Wer E-98 anfasst, muss P-14
vorher erledigen.

### P-15 — der Wächter in `SetFileNameInDialog` und `StatDir` sitzt an der falschen Prüfung

`SetFileNameInDialog:440-471` und `StatDir:289-364`. Beide berechnen `dlgPtr`,
und beide **benutzen es auf dem `IsVersion4()`-Zweig gar nicht**: dort steht
`SetControlText(edt1, ...)` (463 bzw. 326 und 349). Der neue Wächter schützt
also genau den Aufruf nicht, der auf diesem Zweig stattfindet.

Und dieser Aufruf ist nicht harmlos. `CFileDialog::SetControlText`
(`dlgfile.cpp`) lautet auf der Vista-Schiene:

```cpp
HRESULT hr = (static_cast<IFileDialogCustomize*>(m_pIFileDialogCustomize))->SetControlLabel(nID, dest.GetString());
ENSURE(SUCCEEDED(hr));
```

`edt1` ist kein Steuerelement, das über `IFileDialogCustomize` angelegt wurde —
`SetControlLabel` schlägt fehl. Und `ENSURE` ist **nicht** `ASSERT`:
`afx.h:381` definiert es als `ENSURE_THROW(cond, ::AfxThrowInvalidArgException())`
— es wirft, auch im Release.

Heute unerreichbar (beide Funktionen hängen an `m_IsStat` bzw. am fehlenden
Stationery-Schalter). Aber die Commit-Nachricht zu E-100 sagt, sie würden
*„scharf, sobald E-98 behoben wird"* — und dann trägt der Wächter nicht. Er
sollte nicht das Gefühl erzeugen, die Funktionen seien jetzt sicher. Richtig
wäre, ihn dorthin zu ziehen, wo er wirkt, und den Vista-Zweig getrennt zu
behandeln:

```cpp
	if (IsVersion4())
	{
		// SetControlText geht auf der Vista-Schiene ueber
		// IFileDialogCustomize::SetControlLabel und ENSUREt das Ergebnis;
		// edt1 ist dort kein bekanntes Steuerelement. ENSURE wirft auch im
		// Release (afx.h:381). Solange IDD_SAVEAS_EXT nicht lebt (E-98),
		// gibt es hier nichts zu setzen.
		return;
	}

	if (dlgPtr == NULL)
		return;
```

### `ToggleStat` — Wächter harmlos und folgerichtig

`ToggleStat:234-287`. Der frühe `return` überspringt das Setzen von `m_IsStat`,
das Umschalten des Dateifilters und `StatDir()`. Erreichbar ist die Funktion nur
über `ON_BN_CLICKED(IDC_STATIONERY)` — eine Klickmeldung setzt ein Fenster
voraus, und dann ist `GetParent()` nicht NULL. Der Wächter kann also gar nicht
greifen; er ist reine Vorsorge und nimmt niemandem etwas weg.

### `GetFileNameFromDialog` — Wächter selbst ist richtig

Der Zugriff `dlgPtr->GetDlgItem(edt1)` (435) ist derselbe Absturz wie E-97, und
er steht — anders als bei `ToggleStat`/`StatDir` — auf einem Weg, der aus
`OnOK()` kommt. Der Wächter gehört dorthin. Nur muss er `buf` hinterlassen wie
versprochen (P-14).

---

## Frage 2 — die Vorbelegung im Konstruktor

### Ist `GetIniShort` im Konstruktor gefahrlos? Ja.

`GetIniShort` (`rs.cpp:503`) ruft `GetIniString` (`rs.cpp:252`). Dessen
Vorbedingungen sind:

* `ASSERT(::IsMainThreadMT())` — alle drei Konstruktionsstellen liegen in
  UI-Befehlsbehandlungen (`CTocView::OnFileSaveAs`, `saveas.cpp`,
  `compmsgd.cpp`), also auf dem Hauptfaden.
* `g_IniEntries`, `g_Personalities` und `INIPath` müssen stehen — das richtet
  `InitInstance` ein, lange vor jedem Speichern-Befehl.
* `CSaveAsDialog` wird an allen drei Stellen als **lokale Variable** angelegt;
  es gibt keine statische oder globale Instanz, deren Konstruktor vor
  `InitInstance` liefe.

Ein Fenster braucht `GetIniShort` nicht. Der Aufruf ist also an dieser Stelle
genauso sicher wie in `OnInitDialog`, wo er ohnehin schon steht.

### Gleiche Bedeutung, gleiche Polarität? Ja, mit einer Fußnote.

`OnInitDialog:146-160` setzt `m_Inc = FALSE` und dann `m_Inc = TRUE`, **wenn**
`GetIniShort(IDS_INI_INCLUDE_HEADERS)` ungleich 0 ist. Der Konstruktor setzt
`m_Inc` auf den Wert selbst. Beide Schlüssel haben laut `EudoraRes.rc:8217-8218`
die Vorgabe `0`, und zurückgeschrieben werden nur `0` und `1`
(`SetIniShort(..., (short) theDlg.m_Inc)`). Im gesamten Umlauf sind also nur 0
und 1 im Spiel — Bedeutung und Polarität sind identisch.

Fußnote: stünde in der INI von Hand ein anderer Wert als 0/1 — etwa `2` —,
trüge der Konstruktor die `2` weiter, während `OnInitDialog` daraus `1` machte.
Beides ist „wahr", es ändert nichts am Verhalten. Wer es buchstabengleich haben
will, schreibt `m_Inc = GetIniShort(IDS_INI_INCLUDE_HEADERS) ? TRUE : FALSE;`.
Das ist Geschmack, kein Mangel.

### Überschreibt jetzt ein Weg die Einstellung des Anwenders? Nein.

Durchgerechnet für die Vista-Schiene, auf der `OnInitDialog` möglicherweise
nicht läuft:

1. Konstruktor: `m_Inc` = Wert aus der INI.
2. `OnOK` — **falls** überhaupt erreicht — schreibt
   `SetIniInt(IDS_INI_INCLUDE_HEADERS, m_IncludeHeaders.GetCheck())`
   (`OnOK:381`). `m_IncludeHeaders` ist nicht angebunden, `GetCheck()` geht über
   `::SendMessage(NULL, ...)` und liefert 0. **Hier würde die Einstellung des
   Anwenders gelöscht.**
3. Nach `DoModal()` schreibt die Aufrufstelle `m_Inc` zurück — also den Wert aus
   Schritt 1.

Schritt 3 macht Schritt 2 rückgängig. Vor `220c0de` stand in Schritt 3 ein
uninitialisierter Wert; jetzt steht dort der ursprüngliche. Die Vorbelegung ist
damit **nicht nur ein geschlossener Weg, sondern die Reparatur von `OnOK:381`**
gleich mit. Eine Schleife ohne Wirkung — und ohne Schaden. Genau richtig so.

### Zugabe: ein Weg, den P-5 noch nicht gesehen hatte

`OnInitDialog` weist `m_Inc`/`m_Guess` nur innerhalb von
`if (IsVersion4()) { if (m_IsMessage) ... }` zu. Die Aufrufstelle in
`saveas.cpp:104-107` schreibt sie aber **ohne** Prüfung auf `m_IsMessage` in die
INI. Beim Speichern von etwas, das keine Nachricht ist, gingen also auch auf der
alten Schiene zwei uninitialisierte Werte in die Einstellungen. Die Vorbelegung
im Konstruktor schließt auch diesen Weg — er war in P-5 nicht benannt.

---

## Frage 3 — E-99, der einrastende Merker

### P-16 — Gibt es einen Weg zu einem zu frühen TRUE? Gemessen: nein.

`m_bE88AnwenderHatGetippt` wird an genau einer Stelle gesetzt
(`PgMsgView.cpp:443-444`), aus `HasChanged()`. `HasChanged()` ist
`m_ccLastSaved != m_chngCount`, und `m_chngCount` wird **ausschließlich** in
`CPaigeEdtView::UpdateChangeState` verändert (`PaigeEdtView.cpp:6486/6490`).
Deren Aufrufer sind vollständig:

| Aufrufer | Zeile | zählt |
|---|---|---|
| `CPaigeEdtView::PrepareUndo` | 6091 | `kAddChange`, aber nur wenn `!useDeleteStack` |
| `CPaigeEdtView::OnEditUndo` | 6173 | `kUndoChange` |
| `CPaigeEdtView::OnEditRedo` | 6288 | `kRedoChange` |
| `CSpellPaige` (Rechtschreibung) | `spellpaige.cpp:362, 737, 760` | `kAddChange` |

Die Frage lautet damit: ruft ein **programmatischer** Vorgang `PrepareUndo`,
bevor exportiert wird? Nachgesehen, Weg für Weg:

* **Einsetzen des Zitats.** `PgCompMsgView::OnInitialUpdate:179` →
  `PgMsgView::ImportMessage` → `PgDataTranslator::ImportData`. Kein
  `PrepareUndo`. Zählt **nicht**.
* **Signatur einsetzen.** `PgCompMsgView::load_signature:374-441` arbeitet mit
  `pgDelete`/`pgInsert` unmittelbar und ruft `SetTextAs(..., false, false, false)`
  — der dritte `false` ist `bPrepareUndo` (`PaigeEdtView.cpp:7031`). Zählt
  **nicht**. Das gilt auch für den Signaturwechsel über die Werkzeugleiste
  (`CCompMessageFrame::OnSetSignature:1660` → `OnSignatureChanged` →
  `load_signature`).
* **Briefpapier.** Wirkt über den Rumpf, den `CSummary::ComposeMessage` ablegt,
  also über denselben Importweg. Zählt **nicht**.
* **`QuoteText`.** Läuft in `CSummary::ComposeMessage` (`summary.cpp:1365/1414`),
  bevor das Verfassendokument den Editor überhaupt sieht. Zählt **nicht**.
* **`MakeAutoURLSpaghetti`.** Das ist die gefährlichste der vier, denn sie läuft
  **innerhalb von `ExportMessage` selbst** (`PgMsgView.cpp:397`), also wenige
  Zeilen bevor `HasChanged()` gelesen wird (443). Sie verändert den
  Paige-Inhalt. Ihr Rumpf (`PaigeEdtView.cpp:8087` bis rund 8520) enthält
  **kein** `PrepareUndo` — der nächste steht erst in `OnBlkfmtFixedwidth`
  (8558). Zählt **nicht**. Hätte sie gezählt, wäre der Merker bei **jedem**
  Export sofort TRUE gewesen und E-88 vollständig zurückgefallen.

Übrig bleiben als Zähler: Tippen, Einfügen, Ziehen und Ablegen,
Auszeichnungsänderungen (`undo_format`), Emoticons und angenommene
Rechtschreibvorschläge. Das sind durchweg **echte Eingriffe des Anwenders in den
Text**; dass sie den Merker setzen, ist gewollt — bei ihnen würde das Einsetzen
des Originals genau diesen Eingriff wegwerfen. Ein zu frühes TRUE aus
programmatischer Ursache habe ich **nicht** gefunden.

Nebenbei nachgerechnet, weil es die Verlässlichkeit des Zählers trägt:
`PrepareUndo:6041-6056` erzwingt beim **ersten** Tastendruck nach einem Sichern
ausdrücklich einen neuen Undo-Eintrag (`!HasChanged()` → `prevUndo = MEM_NULL`)
und zählt ihn. Nur die *folgenden* Tastendrücke werden in denselben Eintrag
gefaltet und nicht mehr gezählt — da steht `HasChanged()` bereits auf TRUE. Der
erste Tastendruck nach jedem Export kommt also garantiert an. Und `OnEditUndo`
zählt symmetrisch je Eintrag herunter, die Lösch-Hilfsstapel bleiben auf beiden
Seiten ungezählt — der Zähler kann nicht davonlaufen.

### P-17 — Geht noch irgendwo getippter Text verloren? Nicht auf einem Weg, den ich finden konnte.

Der Merker sitzt auf dem **Dokument** und rastet ein; `E88OriginalEinsetzen`
verwirft den Editortext nur im Zweig `nFund < 0` **und** bei
`bAnwenderHatGetippt == false` (`msgutils.cpp:2996-3002`). Geprüfte Wege:

* **Sichern, dann senden** — der Weg, der E-99 ausgelöst hat: erster Export
  setzt den Merker, zweiter liest ihn. Geschlossen.
* **Entwurf schließen und aus Out wieder öffnen.** Neues `CCompMessageDoc`, der
  Merker ist wieder FALSE — aber `m_szE88OriginalHTML` ebenfalls leer: gesetzt
  wird es einzig in `CSummary::ComposeMessage` (`summary.cpp:1551`), nicht beim
  Lesen aus Out. `E88OriginalEinsetzen` urteilt dann *„EDITOR (kein Original
  gemerkt)"*. Kein Verlust.
* **Rückgängig bis auf den Ausgangsstand.** `m_chngCount` fällt auf
  `m_ccLastSaved` zurück, `HasChanged()` wird FALSE — aber der Text ist dann
  auch wieder der Ausgangstext. Richtig so.
* **Reihenfolge innerhalb von `ExportMessage`.** Der Merker wird in Zeile
  443-444 gesetzt, `E88OriginalEinsetzen` erst in 446 gerufen. Schon der
  **erste** Export nach dem Tippen ist geschützt — nicht erst der zweite.
* **`ExportMessage(pMsgDoc)` mit fremdem Dokument.** Der Merker würde aus der
  Änderungslage *dieser* Ansicht in ein *fremdes* Dokument geschrieben. Kein
  Aufrufer übergibt den Parameter (einziger Aufruf: `SaveInfo:601`, ohne
  Argument), der Weg existiert heute nicht. Als Falle für später notiert.
* **`PgFixedCompMsgView::ExportMessage`** (`PgFixedCompMsgView.cpp:136-172`)
  ruft ebenfalls `SaveChangeState()`, kennt aber weder den Merker noch
  `E88OriginalEinsetzen`. Da dort nie ersetzt wird, kann dort auch nichts
  verlorengehen.

**Bewertung:** die E-99-Behebung ist richtig, an der richtigen Stelle, und der
Merker ist nicht zu schnell TRUE. Kein Mangel.

Noch nicht gemessen ist sie: es gibt keine `eudora.log` mit der Zeile
`Fassung=…` aus dem Ablauf *tippen → Entwurf sichern → senden*. Die Rechnung
oben ersetzt die Messung nicht, sie sagt nur, wo zu messen wäre
(vgl. `Arbeitsweise/eingebaute-messung-auslesen.md`).

---

## Frage 4 — Stand von P-8 bis P-12

`Eudora71/Eudora/PGHTMIMP.CPP` ist seit `d1edf31` (7.2.0.62) unverändert —
`d1edf31` liegt **vor** PRÜFER-11. Es hat sich also nichts bewegt:

| Punkt | Stand | Nachgesehen |
|---|---|---|
| P-8 `PaigeHTMLImportTextDescent` wird nie beschrieben | **offen** | 1827 legt mit 3 an, einzige Zuweisung ist der Ascent in 2053 |
| P-9 Kommentar beschreibt die Bedingung falsch | **offen** | unverändert |
| P-10 13/3 für Text nach einem Bild zu wenig | **offen**, ungemessen | 3096-3097 unverändert |
| P-11 Spurmarke liest `memory_ref` als `const char*` | **offen** | 2178-2182 unverändert, weiter in 1.0.65 ausgeliefert |
| P-12 Kommentare mit E-95 statt E-96 ausgezeichnet | **offen** | Zeilen 9, 2049, 2157, 3041, 3061 |

P-1 bis P-3 sind mit `220c0de` im Quelltext berichtigt worden (Kommentartexte),
P-7 ebenfalls (`OnTypeChange:535` steht jetzt vor 538). P-4 läuft als E-98
weiter, P-5/P-6 als E-100 umgesetzt, P-13 als E-99.

---

## Was noch zu tun ist, in dieser Reihenfolge

1. **P-14** — `buf[0] = 0;` in `GetFileNameFromDialog`, zwei Zeilen. Ohne das
   darf E-98 nicht angefasst werden.
2. **P-15** — den Wächter in `StatDir`/`SetFileNameInDialog` dorthin ziehen, wo
   er wirkt, und die `SetControlText`-Falle (`ENSURE` wirft im Release) im
   Quelltext benennen. Ebenfalls Voraussetzung für E-98.
3. **P-11** — die Spurmarke misst nach wie vor nichts.
4. **P-8 bis P-10, P-12** — unverändert wie in PRÜFER-11 beschrieben.

## Was ich nicht prüfen konnte

* Ob `OnInitDialog` auf der Vista-Schiene erreicht wird. Nach P-16 ist das für
  `m_Inc`/`m_Guess` jetzt **gleichgültig** — beide Wege führen zum selben Wert.
  Die Frage ist damit nicht beantwortet, aber entschärft.
* Der Ablauf *tippen → Entwurf sichern → senden* am laufenden Programm (P-17).
* Ob `OnOK` auf der Vista-Schiene wirklich nie erreicht wird. Aus `dlgfile.cpp`
  erschlossen (`OnFileOk` → `OnFileNameOK`), nicht gemessen. Für P-14 ist das
  nur einer von drei Gründen, warum heute kein Schaden entsteht.
