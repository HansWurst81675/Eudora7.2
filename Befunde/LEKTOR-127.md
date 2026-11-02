# <a id="lektor-127"></a>LEKTOR-127 — Bestand nach `Doku/FUNKTIONEN.md` (Was Eudora kann und wo man es findet), Zweig was_eudora_alles_kann nach a2975236 (02.11.2026)

Rolle: [AGENTEN.md](../Intern/AGENTEN.md). Vorgänger: [LEKTOR-126](LEKTOR-126.md#lektor-126).
Arbeitsbaum `.wt/lektor`, Zweig `wt/lektor-20261102f`, abgezweigt von `origin/was_eudora_alles_kann`, Stand `a2975236`.
Umfang: alle `.md` aus `git ls-files '*.md'` ohne `Arbeitsweise/` und `Befunde/` gegen den Bestand. Geändert seit `d5ecca2f` (Merge von #202) sind `Doku/FUNKTIONEN.md` (neu, 976 Zeilen), `tools/WERKZEUGE.md`, `tools/ZWEIGE.md` und das neue Werkzeug `tools/funktionen-auslesen.pl` (`git diff --stat d5ecca2f HEAD`, 4 Dateien, gemessen). Schwerpunkt nach Auftrag: `Doku/FUNKTIONEN.md` — Stichproben gegen `EudoraRes.rc` und den Code, Herkunftsmarken *bestätigt* gegen ihre Belege, Widersprüche zu FAQ, README und BEFUNDE. Nichts gebaut, nichts gestartet.

## Kurz

`FUNKTIONEN.md` ist in den nachprüfbaren Angaben sehr genau. Von **88 Stichproben** (Kürzel, Vorgaben, Schlüsselnamen, Zeilenangaben, Zählungen, quer durch alle fünf Abschnitte) stimmen 88 mit der Ressourcendatei oder dem Code (gemessen, Liste unten). Jede Marke **bestätigt** hat einen Beleg, der das Gesagte trägt — bei zweien ist der Beleg enger als der Satz ([L-127.7](#l-127.7)). Falsch ist ein Klickweg: Schritt 9 der Liste *Zum Bestätigen* erwartet Strg+J „im Menü *Special* bei *Junk*“, *Junk* steht aber im Menü *Message*; Gregor müsste den Schritt als nicht bestanden melden, obwohl das Programm richtig ist ([L-127.1](#l-127.1)). Drei Kürzel hängen am Tastaturlayout und heißen auf einer deutschen Tastatur anders ([L-127.2](#l-127.2)). *Insert System Configuration* hängt eine Kopie der `Eudora.ini` an — die Datei sagt das nicht ([L-127.4](#l-127.4)). Die Stand-Köpfe melden `e122_imap_datum` mit „PR folgt“, obwohl #202 gemergt ist, zum vierten Mal in Folge ([L-127.3](#l-127.3)). Acht Funde, keiner am Programm. Nach Auftrag ist nichts berichtigt.

## Funde aus LEKTOR-126

Nach dem [Nachtrag](LEKTOR-126.md#nachtrag-02-11-2026) standen vier auf erledigt, einer auf teilweise, einer bewusst stehen gelassen. Heute, am Stand `a2975236`, der `main` nach #202 enthält (gemessen):

| Fund | Stand | Stelle (gemessen) |
|---|---|---|
| [L-126.1](LEKTOR-126.md#l-126.1) TESTPLAN [E-122](../Intern/BEFUNDE.md#e-122) (Eingangsdatum beim Hochladen nach IMAP verschoben) | erledigt, Rest Kleinkram unverändert | `Intern/TESTPLAN.md:352` *„1. Im lokalen *In* eine Mail aussuchen, deren Uhrzeit du kennst (Spalte“* — ob die Spalte Absender- oder Ortszeit zeigt, sagt der Schritt weiter nicht; betrifft nur den freiwilligen Schritt 4 |
| [L-126.2](LEKTOR-126.md#l-126.2) Stand-Köpfe | **wieder veraltet** | siehe [L-127.3](#l-127.3) |
| [L-126.3](LEKTOR-126.md#l-126.3) CHANGELOG | erledigt, **wieder veraltet** | `CHANGELOG.md:116` *„**Zweig `e122_imap_datum`** (nach dem Merge von #201; PR folgt).“* — gemergt als #202 (`d5ecca2f`). Siehe [L-127.3](#l-127.3) |
| [L-126.4](LEKTOR-126.md#l-126.4) README | erledigt, Zahl wieder veraltet | `README.md:179` *„im Quellstand behoben, kommt mit dem nächsten Paket“* stimmt; `README.md:98` *„(206 LEKTOR- und PRÜFER-Berichte)“*, gezählt an `a2975236` 207 (`ls Befunde/LEKTOR-[0-9]*.md Befunde/PRUEFER-[0-9]*.md \| wc -l`), mit diesem Bericht 208 |
| [L-126.5](LEKTOR-126.md#l-126.5) Titelzeilen | vermerkt, unverändert | `tools/TESTLAEUFE.md:735` weiter ohne `[Eudora …]`; am 02.11. sind es jetzt 10 Starts ohne Titelzeile (`:715`, `:719`, `:721`, `:722`, `:724`, `:728`, `:730`, `:732`, `:735`, `:736`) |
| [L-126.6](LEKTOR-126.md#l-126.6) Zeilennummer | erledigt | `Intern/BEFUNDE.md:384` *„`ImapMailbox.cpp:4282`“* |

## Funde

### <a id="l-127.1"></a>L-127.1 — *Zum Bestätigen* Nr. 9: Strg+J steht bei *Junk* im Menü *Message*, nicht im Menü *Special*

**Gewicht: mittel.** Ein Klickweg für Gregor mit falscher Erwartung: Er sähe *Junk* nicht im Menü *Special* und müsste „nicht bestanden“ melden, obwohl das Programm tut, was es soll ([Erst prüfen, dann anweisen](../Arbeitsweise/erst-pruefen-dann-anweisen.md)). (gemessen am Quelltext)

- `Doku/FUNKTIONEN.md:970` *„im Menü *Special* steht Strg+J bei *Junk* bzw. bei *Filter Messages*“*.
- `Eudora71/Eudora/EudoraRes.rc:5774` *„`MENUITEM "&Junk", ID_JUNK`“* steht im Popup *Message* (`:5660` *„`POPUP "&Message"`“*), so auch `Doku/FUNKTIONEN.md:174` selbst.
- `Eudora71/Eudora/mainfrm.cpp:8506-8516`: mit *Junk*-Belegung bekommt *Special → Filter Messages* den Text *„`\tCtrl+Shift+L`“* (`:8509`) und *Message → Junk* *„`\tCtrl+J`“* (`:8510`), *Not Junk* *„`\tCtrl+Shift+J`“*; sonst nur *Filter Messages* *„`\tCtrl+J`“* (`:8516`).

**Vorschlag:** *richtig ist:* „Häkchen an: *Message → Junk* zeigt Strg+J, *Special → Filter Messages* zeigt Strg+Umschalt+L. Häkchen aus: *Special → Filter Messages* zeigt Strg+J, *Junk* kein Kürzel.“

### <a id="l-127.2"></a>L-127.2 — Drei Kürzel hängen am Tastaturlayout: Strg+', Strg+\\ und Strg+>

**Gewicht: mittel.** Die Datei nennt die Tasten nach der US-Tastatur; auf einer deutschen Tastatur liegt der Befehl auf einer anderen Taste. (Tabelle gemessen; die Zuordnung der Tasten: belegt aus der Windows-Beschreibung der virtuellen Tastencodes — `VK_OEM_5` und `VK_OEM_7` sind dort ausdrücklich als „kann je Tastatur abweichen“ geführt —, an einer deutschen Tastatur nicht gemessen; welches Layout Gregor benutzt: Vermutung, deutsch)

- `Eudora71/Eudora/EudoraRes.rc:274` *„`VK_OEM_7, ID_EDIT_PASTEASQUOTATION, VIRTKEY, CONTROL`“* — auf der US-Tastatur die Taste `'`, auf der deutschen **Ä**. `Doku/FUNKTIONEN.md:102` und `:403` *„Strg+'“*.
- `EudoraRes.rc:273` *„`VK_OEM_5, ID_PROCESS_ALL, VIRTKEY, CONTROL`“* — US `\`, deutsch **^**. `Doku/FUNKTIONEN.md:404` *„Strg+\\\\“*.
- `EudoraRes.rc:271-272` *„`VK_OEM_PERIOD, ID_EDIT_TEXT_ADD_QUOTE, VIRTKEY, SHIFT, CONTROL`“* — also Strg+Umschalt+**Punkt**. `Doku/FUNKTIONEN.md:108` und `:402` schreiben *„Strg+> (= Strg+Umschalt+.)“*; die Klammer stimmt, das „Strg+>“ nur auf der US-Tastatur. Auf der deutschen ist `>` eine eigene Taste (Umschalt+`<`), Strg+Umschalt+`<` löst den Befehl nicht aus.
- `Strg+,` und `Strg+.` (`VK_OEM_COMMA`, `VK_OEM_PERIOD`) liegen auf beiden Tastaturen gleich.

Der Menütext zeigt die US-Schreibweise (`:5529` *„`Paste As &Quotation\tCtrl+'`“*), das ist Eudoras Text und bleibt so.

**Vorschlag:** In Abschnitt 2 bei den drei Zeilen „auf deutscher Tastatur: Strg+Ä / Strg+^ / Strg+Umschalt+.“ dazuschreiben, mit der Marke *Vorlage*. Ob das stimmt, ist ein Handgriff am Programm und gehört dann in *Zum Bestätigen*.

### <a id="l-127.3"></a>L-127.3 — Stand-Köpfe: `e122_imap_datum` „PR folgt“ nach dem Merge von #202 — zum vierten Mal in Folge; der laufende Zweig steht nirgends

**Gewicht: mittel.** Wie [L-124.2](LEKTOR-124.md#l-124.2), [L-125.5](LEKTOR-125.md#l-125.5), [L-126.2](LEKTOR-126.md#l-126.2). Die dort vorgeschlagene Schranke gibt es nicht (`grep -n 'PR folgt' tools/*.pl`: kein Treffer). (gemessen)

- `d5ecca2f` *„Merge pull request #202 from HansWurst81675/e122_imap_datum“*.
- `Intern/WEITERMACHEN.md:3` *„Zweig `e122_imap_datum`, PR folgt: [[E-122](../Intern/BEFUNDE.md#e-122)] behoben …“* und weiter hinten im selben Absatz noch *„Zweig `e122_imap_datum` in Arbeit: [[E-122](../Intern/BEFUNDE.md#e-122)] behoben und am IMAP-Prüfserver gemessen.“* (der Rest aus [L-126.2](LEKTOR-126.md#l-126.2)).
- `Intern/AUFGABEN.md:8` *„danach Zweig `e122_imap_datum` ([[E-122](../Intern/BEFUNDE.md#e-122)] behoben und gemessen, PR folgt): [[E-143](../Intern/BEFUNDE.md#e-143)] Suchfenster eingebaut …; Zweig `e122_imap_datum` in Arbeit“* — der Bezug ist weiter verrutscht (das Suchfenster kam mit #201).
- `tools/ZWEIGE.md:204` *„PR folgt.“*; `CHANGELOG.md:116` *„(nach dem Merge von #201; PR folgt)“*.
- Der laufende Zweig `was_eudora_alles_kann` und `Doku/FUNKTIONEN.md` kommen in `WEITERMACHEN.md`, `AUFGABEN.md` und `CHANGELOG.md` nicht vor (`grep -n 'FUNKTIONEN\|was_eudora'`: nur `tools/ZWEIGE.md` und `tools/WERKZEUGE.md`). Wer morgen mit `sitzungsbeginn.pl` anfängt, liest „Reihenfolge danach: [E-178](../Intern/BEFUNDE.md#e-178) …“ und weiß nichts vom offenen Doku-Zweig.

**Vorschlag:** Köpfe auf „#202 gemergt“, den Satz „in Arbeit“ streichen, den Zweig `was_eudora_alles_kann` mit Stand eintragen. Und die Schranke aus [L-126.2](LEKTOR-126.md#l-126.2): ein Zweigname, der mit „PR folgt“ steht, darf nicht in `git log origin/main --merges --grep 'Merge pull request'` vorkommen. Beim vierten Auftreten ist das nach [Fehlerklassen abstellen](../Arbeitsweise/fehlerklassen-abstellen.md) überfällig.

### <a id="l-127.4"></a>L-127.4 — *Help → Insert System Configuration* hängt eine Kopie der `Eudora.ini` an; die Datei sagt nur „fügt Systemangaben ein“

**Gewicht: mittel.** Wer einen Fehlerbericht schreibt, sollte wissen, dass seine Einstellungsdatei mitgeht — mit Servernamen, Anmeldenamen und Adressen. (gemessen am Quelltext; ob Kennwörter wirklich herausgenommen werden: nur der Text der Ressource, nicht nachgesehen)

- `Doku/FUNKTIONEN.md:254` *„fügt die Systemangaben in die offene neue Nachricht ein“*.
- `Eudora71/Eudora/compmsgd.cpp:2695` *„`// Attach Eudora_C.Ini`“* in `CCompMessageDoc::ReadSystemInfo`, aufgerufen aus `CompMessageFrame.cpp` (`OnInsertSystemConfiguration`, *„`doc->SetHeaderLine(HEADER_ATTACHMENTS, sAttach);`“*).
- `Eudora71/Eudora/EudoraRes.rc:8137` (`IDS_REPORT_BUG_MSG_TEXT`) *„it will attach a copy of your Eudora.ini file, minus any passwords“*.
- Nebenbei `Doku/FUNKTIONEN.md:251` *Report A Bug* „ohne Statuszeilentext“: stimmt, aber der Befehl legt eine neue Nachricht mit QUALCOMMs Fragebogen an (`eudora.cpp:564` lädt `IDS_REPORT_BUG_MSG_TEXT`). Die Adresse darin ist die von QUALCOMM (Vermutung, nicht nachgesehen) — für Anwender dieser Portierung kein Weg.

**Vorschlag:** In der Zeile „… und hängt eine Kopie der `Eudora.ini` an (laut Eudora ohne Kennwörter)“; bei *Report A Bug* „öffnet eine Nachricht mit dem Fragebogen von QUALCOMM; Fehler dieser Portierung bitte über GitHub melden“. Ob die Kennwörter wirklich herausgenommen werden, ist eine Frage für den PRÜFER, bevor die Datei das zusagt.

### <a id="l-127.5"></a>L-127.5 — Die Datei sagt nicht, für welche Fassung sie gilt; die Zeile zum Suchfenster beschreibt 7.2.1.130, nicht den Quellstand

**Gewicht: Kleinkram.** (gemessen)

- `Doku/FUNKTIONEN.md:1-35` nennt keine Fassung; `perl tools/doku-pruefen.pl` meldet *„Doku/FUNKTIONEN.md nennt weder den Quellstand 7.2.1.130 noch die Paketnummer 7.2.1.130 (hoechste genannte Fassung: 7.2.1.129)“*.
- `:189-190` *„aus dem Suchfenster heraus kommt der Hinweis je Nachricht statt einmal ([[E-143](../Intern/BEFUNDE.md#e-143)] …)“*. Im Quellstand ist das geändert: `README.md:187` *„Für das Suchfenster im Quellstand geändert, kommt mit dem nächsten Paket“*, `Intern/TESTPLAN.md:340` *„neuer Bau ein Hinweis bei drei Treffern“*. Andere Zeilen sagen den Bezug selbst (`:872` *„bis 7.2.1.128“*, `:891` *„im Quellstand berichtigt“*), diese nicht.
- Unter *Transfer* (`:179-190`) steht [E-143](../Intern/BEFUNDE.md#e-143) (Out-Hinweis), aber nicht, dass Verschieben **im selben IMAP-Konto** die Anzeige zweier Mails verwechseln kann ([E-184](../Intern/BEFUNDE.md#e-184), [E-189](../Intern/BEFUNDE.md#e-189), `README.md` *Bekannte Fehler*, dort mit *„**Vorsicht** beim Löschen“*). Die Datei will keine Fehlerliste sein; wo sie aber Fehler je Eintrag nennt, fehlt dieser.

**Vorschlag:** Oben einen Satz „Stand: Quellstand nach 7.2.1.130 (02.11.2026)“; `:190` auf „bis 7.2.1.130 je Nachricht; im Quellstand einmal je Übertragung“.

### <a id="l-127.6"></a>L-127.6 — Drei „unklar“ sind am Quelltext klärbar

**Gewicht: Kleinkram.** Die Datei kennzeichnet ehrlich, was sie nicht weiß; drei davon stehen im Code. (gemessen am Quelltext)

- **Strg+Leertaste** — `Doku/FUNKTIONEN.md:405` *„ob die Taste wirkt, ist **unklar**“*. `Eudora71/Eudora/PaigeEdtView.cpp:2990-2992` *„`// Clear style (Plain Text)` … `if ((nChar == VK_SPACE) && ( GetKeyState(VK_CONTROL)<0 ) )` … `OnClearFormatting();`“* — der Editor behandelt sie selbst, ohne Tastentabelle.
- **`SelectedTextURL1` … `7`** — `:354` *„Was ein solcher Eintrag genau enthalten muss, ist hier **unklar**“*. `mainfrm.cpp:8195-8200`: Menüname, Tabulator, dann der Rest; `QCSelectedTextURLCommand.cpp:53` *„`ResultURL.Format(m_URLFormat, pData);`“* mit dem markierten Text, vorher URL-kodiert (`mainfrm.cpp:7933` *„`EscapedURLText = EscapeURL(SelText);`“*), dann `LaunchURL`. Ein Eintrag sieht also aus wie `SelectedTextURL1=Wikipedia<Tab>https://de.wikipedia.org/wiki/%s` (Beispiel von mir, nicht ausprobiert). Der Eintrag wird an vorletzter Stelle in *Edit* eingefügt (`:8217` *„`::GetMenuItemCount(m_hEditMenu) - 2`“*), nicht ganz unten.
- **`FixedDateFormat`-Platzhalter** — `:662` *„was sie bedeuten, steht nicht im Dialog (**unklar**)“*. `Eudora71/QCUtils/src/services.cpp:172-175` *„`%1 Time`, `%2 Date`, `%3 Day of week`, `%4 Timezone`“* (Kommentar zu `TimeDateStringFormatMT`, das `summary.cpp:2960` mit `FixedDateFormat` aufruft). Die Vorgabe `%1 %2 %4` heißt also Zeit, Datum, Zeitzone.

### <a id="l-127.7"></a>L-127.7 — Zwei Belege sind enger als der Satz; fünf Verweise auf TESTPLAN ohne Anker

**Gewicht: Kleinkram.** (gemessen)

- **Strg+W** — `Doku/FUNKTIONEN.md:78` und `:343` *„**bestätigt** … ([[E-137](../Intern/BEFUNDE.md#e-137)], 27.10.2026: schließt das Fenster, nicht mehr ganz Eudora)“*. [E-137](../Intern/BEFUNDE.md#e-137) betrifft nur die **Wazoo-Leiste** (*„`Strg-W` auf der Wazoo-Leiste (Adressbuch, Filter, Postfächer …)“*), bestätigt ist *„`Wazoo-Leiste wird versteckt`“*. Für Nachrichten- und Postfachfenster gibt der Beleg nichts her. Besser: „bestätigt für die angedockten Werkzeugfenster“.
- **`LogLevel`** — `:928` *„**bestätigt** für `58527`: Gregors Protokolle tragen die Spurmarken“*. Die Spurmarken belegen das Bit 32768 (Misc), nicht den Wert 58527; [E-120](../Intern/BEFUNDE.md#e-120) nennt für Gregor `LogLevel=58591`. Besser: „bestätigt, dass Spurmarken mit dem Bit 32768 erscheinen“.
- `:187`, `:197`, `:211`, `:268`, `:896` verlinken `../Intern/TESTPLAN.md` ohne Anker; der Beleg steht in `Intern/TESTPLAN.md:309` `#e-143-naechstes` (*„**Bestätigt am 01.11.2026 …** **Am 02.11.2026 ebenso Schritt 1–2 im Filterfenster** … **Ebenso am 02.11.2026 Schritt 3 und 4 vollständig**“*). Der Inhalt trägt alle fünf Marken.

### <a id="l-127.8"></a>L-127.8 — Kleinkram im übrigen Bestand

**Gewicht: Kleinkram.** (gemessen)

- `Intern/EINSTELLUNGEN.md:166` und `:214` *„`filtersd.cpp:1133`“* für `FilterMayDeleteFromServer` — die Zeile steht heute in `Eudora71/Eudora/filtersd.cpp:1155` (*„`_T("Settings"), _T("FilterMayDeleteFromServer"), 0, INIPath);`“*); in `:1133` steht ein Kommentar zu `ImapFiltersd.cpp`. `FUNKTIONEN.md:935` nennt richtig `:1155`, die beiden Dateien widersprechen sich also.
- `Intern/EINSTELLUNGEN.md:159` *„`EudoraRes.rc:8463`“* für `LogLevel` — heute `:8465` (*„`IDS_INI_DEBUG_LOG_LEVEL "LogLevel\n25759"`“*).
- `tools/funktionen-auslesen.pl:6-11`: der Kopf nennt `--kuerzel` nicht, `tools/WERKZEUGE.md:73` schon.
- `Doku/FUNKTIONEN.md:900-902` zwei Trennlinien `---` hintereinander.
- `README.md:98` „206“, siehe oben.

## Stichproben zu `Doku/FUNKTIONEN.md` (gemessen)

Alle gegen `Eudora71/Eudora/EudoraRes.rc` und den genannten Code an `a2975236`; *stimmt* heißt: Kürzel, Wert oder Zeile wie in der Datei.

- **Tastentabelle** (`EudoraRes.rc:263-373`): 81 Zeilen mit `VIRTKEY`, 81 verschiedene Kombinationen aus Taste und Umschaltern, keine doppelt (eigene Zählung) — stimmt mit `:296` und `:424`. Einzeln geprüft und stimmend: Strg+0 *Out*, Strg+1 *In*, Strg+6 *Check Spelling*, Strg+D, Strg+E (mit Umschalt), Strg+F → `ID_CTRL_F`, Strg+Umschalt+F → `ID_SHIFT_CTRL_F`, Strg+G, Strg+H, Strg+J/Strg+Umschalt+J, Strg+K, Strg+L/Strg+Umschalt+L, Strg+R, Strg+S/Strg+Umschalt+S (`ID_SAVE_ALL`), Strg+W/Strg+Umschalt+W (`ID_CLOSE_ALL`), Strg+Y, Strg+Z/Strg+Umschalt+Z, Alt+Rück, Umschalt+Entf, Strg+Einfg, Umschalt+Einfg, F1, Umschalt+F1, F3, Umschalt+F4, Umschalt+F5, F6/Umschalt+F6, Strg+F6, F7 → `IDA_TOGGLEHEADER` (31).
- **Menütexte** (`EudoraRes.rc:5493ff.`): *Find Text* `\tCtrl+Shift+F` (`:5608`), *Find Messages* `\tCtrl+F` (`:5612`), *Clear Formatting* `\tCtrl+Space`, *Finish Address Book Entry* `\tCtrl+,` (`:5599`), *Directory Services* `\tCtrl+Y` (`:5820`), *Reply* ohne Kürzel im Menütext (`:5663`) (6).
- **Umschaltbare Belegungen am Code**: `OnCtrlF`/`OnShiftCtrlF` mit `m_bSwitchFindAccel` (`mainfrm.cpp:4289-4305`), `OnCtrlJ`/`OnShiftCtrlJ`/`OnShiftCtrlL` nur bei `CTRL_J_JUNK` (`:4390-4411`, `JunkMail.h:62` *„`CTRL_J_JUNK 1`“*), `OnMessageReplyCtrlR` (`:4574-4586`), Strg+R am belegten Menüeintrag (`:4602-4603`, `:4625-4626`), `OnCloseAll` `:4415`, `OnSaveAll` `:4440`, `SelectedTextURL` 1–3 → Strg+7–9, 4–7 → Strg+2–5 (`:8203-8224` mit `:8097`) (8).
- **Zeilenangaben**: `IDR_MAINFRAME MENU` `:5493`, `IDR_CONTEXT_POPUPS` `:5855`, `IDR_FILTER_MENUS` `:6081`, `RemoveChangePassword` `mainfrm.cpp:8372-8373`, `DisableStatistics` `:10508-10510`, `CDynamicMailboxMenu` `:8367`, `CDynamicPluginMenu` `:8310`, `CheckForMailEvery` `eudora.cpp:2607-2621`, `AutoOKTimeout` `guiutils.cpp:181`, `TurboRedirect` `summary.cpp:1495`, Kehrwert-Bit `settings.cpp:2084-2088`, `CtrlJMapping` 1/2 `settings.cpp:921-926`, `FilterMayDeleteFromServer` `filtersd.cpp:1155`, `DEFAULT_SWM_MODE (2)` = `SWM_MODE_PRO` (`QCSharewareManager.h:48-59`) (14).
- **INI-Vorgaben** (je `"Name\nWert"` in `EudoraRes.rc`): `SmtpAuthAllowed` 1, `CheckForMailEvery` 0, `DonotCheckWithBattery` 0, `SSLReceiveUse` 1, `SSLSendUse` 1, `LeaveMailOnServer` 0, `BigMessageThreshold` 40960, `IMAPMinDownload` 1, `IMAPMaxDownloadSize` 0, `TrashMailboxName` Trash, `ImmediateSend` 1, `KeepCopies` 1, `UseSubmissionPort` 0, `ReplyTo:ToCc:` 0, `ReplyToAll` 0, `TextAsDoc` 1, `ExplodeMimeDigest` 0, `MessageFont` Arial, `MessageFontBaseSize` 1, `PrinterFontBaseSize` 2, `ScreenFontBaseSize` 1, `ShowCoolBars` 1, `ShowLargeButtons` 1, `FetchInlineContent` 1, `ShowOnlyInTray` 0, `UseBidentAlways` 1, `MessageWidth` 80, `MessageLines` 20, `SetPreviewRead` 0, `SetPreviewReadSeconds` 5, `EasyOpen` 1, `ZoomWindows` 1, `RunHtmlCode` 0, `MailboxShowJunk` 0, `MaxRecentMailbox` 10, `Fumlub` 1, `DragSelectMessages` 0, `WarnQueueStyledText` 1, `IgnoreMixedDigits` 1, `SpellOnQueue` 0, `AutoCompListboxDelay` 500, `MaximumHistorySize` 100, `FixedDateFormat` `%1 %2 %4`, `RecentDateFormat` `%1`, `OldDateHours` 24, `OldDateFormat` `%3`, `AncientDateHours` 168, `AncientDateFormat` `%2`, `LabelColor1` 33023, `LabelColor2` 255, `LabelColor7` 4210816, `LabelText1` `Label 1`, `Alert` 1, `Sound` 1, `AutoOK` 1, `AutoOKTimeout` 120, `CtrlJMapping` 0, `SwitchFindKeyAccl` 0, `RemoveChangePassword` 1, `DisableStatistics` 0, `DeleteFetchedJunk` 1, `UseMyFilterWindowPosition` 0, `KeepHTMLInResponses` 1, `ForwardOriginalHTML` 1, `WarnSpellUnavailable` 1, `MaxConcurrentTasks` 10, `LogLevel` 25759, `LogFileSize` 10000, `WholeSummaryLabelColor` 1, `Mode` -1 (70; ohne Doppelzählung mit oben 29 weitere Zeilen der Datei).
- **Abweichende Vorgaben der `DEudora.ini`** (`tools/DEudora.ini`): `SSLSendUse=2` (`:46`), `SSLReceiveUse=2` (`:55`), `LeaveMailOnServer=1` (`:63`), `DeleteFetchedJunk=0` (`:90`), `UseMyFilterWindowPosition=1` (`:117`), `LogLevel=58527` (`:253`) (6).
- **Zählungen**: `perl tools/funktionen-auslesen.pl --zaehlen` *„MENU-Ressourcen 18, MENUITEM mit Text 406, Optionsseiten 32, IDS_INI-Zeichenketten 842“*; verschiedene `IDS_INI_…` in `--optionen`: 284; `TabooHeaders` 44 Einträge (`EudoraRes.rc:10020`) — alle wie in der Datei (3). `--selbsttest`: *„alle gruen“*.

Summe: 88 Stichproben (die INI-Zeilen gezählt nach Tabellenzeilen der Datei, nicht nach Schlüsseln), keine Abweichung. Die Funde oben liegen alle **außerhalb** dessen, was das Werkzeug aus der Ressource liest: Erwartungen in Klickwegen, Tastaturlayout, Verhalten am Code.

**Herkunftsmarken *bestätigt*** — jede gegen ihren Beleg gelesen (gemessen): [E-115](../Intern/BEFUNDE.md#e-115) (Strg+F, *„Ctrl+F (*Find Messages*)“*), FAQ 16 (*„funktioniert mit ctrl-shift-F“*, F3), [E-93](../Intern/BEFUNDE.md#e-93) (*Forward*), [E-120](../Intern/BEFUNDE.md#e-120) und FAQ 5 (*„undelete hat sie wieder geholt“*), [E-140](../Intern/BEFUNDE.md#e-140) (*Save As* aus dem Verfassen-Fenster), [E-48](../Intern/BEFUNDE.md#e-48) (*„die Beschriftungen stimmen mit dem Menü *Window*“*), [E-160](../Intern/BEFUNDE.md#e-160), [E-134](../Intern/BEFUNDE.md#e-134), [E-171](../Intern/BEFUNDE.md#e-171), [E-80](../Intern/BEFUNDE.md#e-80), [E-139](../Intern/BEFUNDE.md#e-139), FAQ 2/3 (06.09.2026), FAQ 9 (*„labels funktionieren. paßt.“*), FAQ 14 (`TidyAttach=1`), TESTPLAN `e-143-naechstes` — tragen das Gesagte; enger als der Satz nur Strg+W und `LogLevel` ([L-127.7](#l-127.7)). *Vorlage* ist nirgends fälschlich zu *bestätigt* hochgestuft.

**Widersprüche zu FAQ, README, BEFUNDE**: keine gefunden. Geprüft: `CtrlJMapping` und der erste Start ohne Filter (FAQ 12, [E-75](../Intern/BEFUNDE.md#e-75), `EINSTELLUNGEN.md:213`), SSL-Werte und Ports (FAQ 2), `TabooHeaders` (`EINSTELLUNGEN.md:218` *„**44** Einträge“*), `LogLevel` 25759/58527 (FAQ 17, `ANWENDER.md:432`, `:467`), verneinte Filtervergleiche bis 7.2.1.128 (`README.md:156`), *Find Messages* mit *Headers* nur am Quelltext (FAQ 16, *Zum Bestätigen* Nr. 6). Einzige Abweichung zwischen zwei Dateien ist die Zeile `filtersd.cpp` ([L-127.8](#l-127.8)), und dort hat `FUNKTIONEN.md` recht. Dass FAQ, README und ANWENDER nicht auf `FUNKTIONEN.md` verweisen, ist nach Auftrag gewollt (Gregor: später) und kein Fund.

## Werkzeuge

`perl tools/doku-pruefen.pl` (gemessen): *„Kein Widerspruch gefunden.“* „Zur Kenntnis“: 19 Dateien ohne 7.2.1.130, neu darunter *„Doku/FUNKTIONEN.md … (hoechste genannte Fassung: 7.2.1.129)“* (siehe [L-127.5](#l-127.5)). Die Funde [L-127.1](#l-127.1) bis [L-127.4](#l-127.4) sieht das Werkzeug nicht.

`perl tools/offene-befunde.pl` (gemessen):

```
    offen laut Intern/BEFUNDE.md  52
      davon aktuell gemessen      10  (ab Nummer 125)
        davon nur am Quelltext     0  (gegengelesen, kein Lauf)
      davon veraltet gemessen     26
      davon NIE gemessen          16
    in Intern/WEITERMACHEN.md     52

  52 offene Befunde, in beiden Listen gleich.
```

`perl tools/pruefe-regressionstest.pl` (gemessen): *„Kein neues "behoben" ohne Regressionstest.“*; Einstufung *„kritisch 70 … unkritisch 46“*, unverändert gegenüber [LEKTOR-126](LEKTOR-126.md#werkzeuge) (seit `d5ecca2f` keine Änderung an `Intern/BEFUNDE.md`).

`perl tools/ziel-stand.pl` (gemessen): *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“*

`perl tools/rollen-faellig.pl` (gemessen): fällig LEKTOR (dieser Lauf), PRÜFER und CHRONIST (*„seit seinem Bericht (12d47ba) haben sich 18 Datei(en) in seinem Bereich geaendert“*). Für den Zweig `was_eudora_alles_kann` selbst ist ein PRÜFER nicht nötig — er ändert keinen Code; `tools/funktionen-auslesen.pl` ist ein Lesewerkzeug mit Selbsttest.

## Was nur Gregor entscheiden kann

Nichts. Alle Funde betreffen Doku, Buchführung und Testform; das hat Gregor dem Hauptagenten übertragen. Ob Gregor die korrigierten Klickwege ([L-127.1](#l-127.1)) oder die Tasten auf deutscher Tastatur ([L-127.2](#l-127.2)) am Programm ansieht, gehört zur Liste *Zum Bestätigen* und ist eine Frage der Testreihenfolge.

## <a id="nachtrag-02-11-2026"></a>Nachtrag 02.11.2026

Gegengelesen: `git diff 86e58a79..origin/was_eudora_alles_kann` (7 Dateien, Stand `a46ff55f`, nach `tools/arbeitsbaum-angleichen.sh`). Keine neue Runde.

| Fund | Stand | Stelle (gemessen) |
|---|---|---|
| [L-127.1](#l-127.1) Klickweg Nr. 9 | erledigt | `Doku/FUNKTIONEN.md`, *Zum Bestätigen* Nr. 9: *„Häkchen an: *Message → Junk* zeigt Strg+J, *Special → Filter Messages* zeigt Strg+Umschalt+L. Häkchen aus: *Special → Filter Messages* zeigt Strg+J, *Junk* kein Kürzel (`mainfrm.cpp:8506-8516`)“* |
| [L-127.2](#l-127.2) Tastaturlayout | erledigt | Abschnitt 2 nennt bei `VK_OEM_7`, `VK_OEM_5` und `VK_OEM_PERIOD` mit Umschalt die deutschen Tasten *„vermutlich … nicht gemessen“*, dazu ein Absatz **Tastaturlayout**; *Edit → Text → Add Quote Level* heißt jetzt *„Strg+Umschalt+. (Menütext: Strg+>)“*; neu *Zum Bestätigen* Nr. 13 (Strg+Ä und Strg+Umschalt+Punkt am Programm). „Strg+>“ steht nur noch als Menütext (2 Treffer, beide so gekennzeichnet) |
| [L-127.3](#l-127.3) Stand-Köpfe | erledigt, Schranke offen | `Intern/WEITERMACHEN.md:3` *„**Stand 02.11.2026 abends.** Laufend: Zweige `was_eudora_alles_kann` … #202 (`e122_imap_datum`) sind gemergt“*; `Intern/AUFGABEN.md:8` mit *„gemergt als #202“*, der Bezug des Suchfensters steht jetzt bei #201; `tools/ZWEIGE.md:204` und `CHANGELOG.md:116` *„gemergt als #202“*. „`e122_imap_datum` in Arbeit“: 0 Treffer in beiden Dateien. **Rest:** die Schranke gegen „PR folgt“ nach einem Merge gibt es weiter nicht (`grep -n 'PR folgt' tools/*.pl`: kein Treffer) |
| [L-127.4](#l-127.4) Insert System Configuration | erledigt | *„**und hängt eine Kopie der `Eudora.ini` an** (`CCompMessageDoc::ReadSystemInfo`, `compmsgd.cpp:2695`) … ob die Kennwörter wirklich herausfallen, ist nicht nachgesehen“*; *Report A Bug* verweist auf `ANWENDER.md#einen-fehler-melden` |
| [L-127.5](#l-127.5) Bezugsfassung, Suchfenster | erledigt | oben *„**Stand:** Quellstand nach dem Testpaket 7.2.1.130 (02.11.2026)“*; Suchfenster *„bis 7.2.1.130 je Nachricht; im Quellstand … einmal je Übertragung (seit #201 …)“*; unter *Transfer* neu [E-184](../Intern/BEFUNDE.md#e-184)/[E-189](../Intern/BEFUNDE.md#e-189) mit *„Vorsicht beim Löschen“*. `perl tools/doku-pruefen.pl` führt `Doku/FUNKTIONEN.md` nicht mehr unter „Zur Kenntnis“ (0 Treffer) und meldet *„Kein Widerspruch gefunden.“* |
| [L-127.6](#l-127.6) drei „unklar“ | erledigt | Strg+Leertaste *„der Editor fängt die Taste selbst ab (`PaigeEdtView.cpp:2990-2992`)“*; `SelectedTextURL` mit Aufbau, URL-Kodierung, *„an vorletzter Stelle im Menü *Edit*“*; `FixedDateFormat` *„`%1` Uhrzeit, `%2` Datum, `%3` Wochentag, `%4` Zeitzone (`QCUtils/src/services.cpp:172-175`)“*. Weiter **unklar**, bewusst und so gekennzeichnet: die Wirkung von Strg+\ und MoodWatch — beide waren nicht Teil des Funds |
| [L-127.7](#l-127.7) enge Belege, Anker | erledigt | Strg+W *„**bestätigt** für die angedockten Werkzeugfenster … sonst Vorlage“* (beide Stellen); `LogLevel` *„**bestätigt** nur für das Spurmarken-Bit `32768`“*; alle fünf TESTPLAN-Verweise auf `#e-143-naechstes` |
| [L-127.8](#l-127.8) Kleinkram | erledigt bis auf README | `Intern/EINSTELLUNGEN.md` *„`filtersd.cpp:1155`“* an beiden Stellen, `LogLevel` *„`EudoraRes.rc:8465`“*; mitgezogen `8464`, `8466`, `8691`, `8658`, `8153`, `10019`, `10463` — alle sieben gegen `EudoraRes.rc` nachgesehen, stimmen; `tools/funktionen-auslesen.pl:10` nennt `--kuerzel`; die doppelte Trennlinie ist weg. `README.md:98` steht weiter bei *„206“* (heute 208) — nach Auskunft des Hauptagenten bewusst, Gregor: README später |

Ergebnis: Sieben der acht Funde sind erledigt, [L-127.8](#l-127.8) bis auf die bewusst stehen gelassene README-Zahl. Offen bleibt aus [L-127.3](#l-127.3) die Schranke gegen „PR folgt“ nach dem Merge. Neue Fehler im Diff: keine gefunden. Für Gregor ist nichts zu entscheiden.
