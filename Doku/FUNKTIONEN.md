# Was Eudora kann und wo man es findet

Zurück zum [Einstieg](../README.md) · [Häufige Fragen](FAQ.md) ·
[Bedienung](ANWENDER.md)

Diese Übersicht zählt auf, was in Eudora 7.2 steht: die **Menüs**, die Seiten
unter ***Tools → Options***, die **Filteraktionen** und eine Auswahl von
**`Eudora.ini`-Schlüsseln**, die keine Optionsseite haben. Die Namen stehen
englisch und kursiv, so wie das Programm sie zeigt.

**Woher jede Zeile stammt.** Die letzte Spalte trägt eine Marke:

| Marke | heißt |
|---|---|
| Vorlage | aus der Ressourcendatei `Eudora71/Eudora/EudoraRes.rc` oder dem Code gelesen — so **steht** es im Programm; in dieser Portierung hat es noch niemand eigens angeklickt |
| am Prüfstand gemessen | neu in dieser Portierung; am laufenden Programm auf dem Prüfstand gemessen, von Gregor noch nicht gesehen |
| **bestätigt** | Gregor hat es am laufenden Programm gesehen; der Verweis führt zum Beleg in [FAQ](FAQ.md), [BEFUNDE](../Intern/BEFUNDE.md) oder [TESTPLAN](../Intern/TESTPLAN.md) |

**Stand:** Release 7.2.1.131 (02.11.2026). Was sich gegenüber älteren
Fassungen geändert hat, steht an der Zeile dabei.

Was nur *Vorlage* ist, kann trotzdem tun, was dasteht — es ist nur nicht
nachgesehen. Die Liste der Einträge, deren Bestätigung am meisten hilft, steht
am Ende: [Zum Bestätigen durch Gregor](#zum-bestätigen-durch-gregor).

**Der Funktionsumfang.** Eudora 7.1 kannte drei Betriebsarten; im
*Light*-Modus fehlen einzelne Optionsseiten und Menüeinträge sind grau.
Dieser Bau läuft im bezahlten Modus mit vollem Umfang (`BUILD_BOX_OR_SITE_R_VERSION`
in `Eudora.vcxproj`, daraus `SWM_MODE_PRO` in `QCSharewareManager.h:54-59`;
*Help → About Eudora* zeigt *Paid Mode*, siehe
[ANWENDER.md](ANWENDER.md#was-in-einen-fehlerbericht-gehört--help--about-eudora)).
Alles unten Aufgezählte ist also da, sofern nicht anders vermerkt.

**Nachrechnen.** Die Tabellen sind mit `perl tools/funktionen-auslesen.pl`
aus der Ressourcendatei gezogen (`--menues`, `--optionen`, `--ini <Name>`);
die Zeilennummern dort führen an die Fundstelle. Die deutschen Halbsätze
übersetzen den **Statuszeilentext** des Eintrags (der Teil vor `\n` in der
`STRINGTABLE`); wo es keinen gibt, steht *ohne Statuszeilentext* und nur, was
sich aus dem Namen ohne Raten sagen lässt.

**Inhalt**

1. [Menüs](#1-menüs)
2. [Tastenkürzel auf einen Blick](#2-tastenkürzel-auf-einen-blick)
3. [*Tools → Options*](#3-tools--options)
4. [Filter: Zeitpunkte, Bedingungen, Aktionen](#4-filter-zeitpunkte-bedingungen-aktionen)
5. [`Eudora.ini`-Schlüssel ohne Optionsseite](#5-eudoraini-schlüssel-ohne-optionsseite)
6. [Die Abschnitte der `Eudora.ini`](#6-die-abschnitte-der-eudoraini)
7. [Zum Bestätigen durch Gregor](#zum-bestätigen-durch-gregor)

---

## 1. Menüs

**Ein Menü für alle Fenster.** Das Hauptmenü (`IDR_MAINFRAME`,
`EudoraRes.rc:5493`) gilt für Postfach-, Lese- und Verfassen-Fenster
gleichermaßen; die Ressourcendatei hat kein eigenes Menü für die beiden
Nachrichtenfenster. Was im jeweiligen Fenster keinen Sinn ergibt, ist grau.
Unterschiede gibt es nur im **Rechtsklickmenü** — siehe
[Rechtsklickmenüs](#rechtsklickmenüs).

**Tastenkürzel.** Alle auf einen Blick, nach Taste sortiert:
[Abschnitt 2](#2-tastenkürzel-auf-einen-blick). In den Tabellen hier steht,
was im Menütext hinter dem Eintrag steht,
dazu Kürzel aus der Tastentabelle (`IDR_MAINFRAME ACCELERATORS`,
`EudoraRes.rc:263`) für Einträge ohne eigenes. Viele Kürzel gibt es zusätzlich
**mit Umschalt** — das ruft dieselbe Funktion auf, die dann, wo der
Statuszeilentext es sagt, etwas anderes tut (etwa *Check Mail* mit Umschalt:
Auswahl der Übertragungsoptionen).

**Dynamische Untermenüs.** Die Menüs *Mailbox* und *Transfer* und einige
Untermenüs (mit ▸) sind in der Ressourcendatei leer; Eudora füllt sie zur
Laufzeit aus Postfächern, Empfängerliste, Briefpapier, Persönlichkeiten und
Zusatzmodulen. Woraus, steht jeweils dabei.

### *File*

| Eintrag | Kürzel | Was es tut | Herkunft |
|---|---|---|---|
| *New File* | | legt eine neue Textdatei an | Vorlage |
| *Open File…* | Strg+O | öffnet eine vorhandene Textdatei | Vorlage |
| *Open Attachment* | Enter | öffnet den Anhang in der Zeile mit dem Cursor | Vorlage |
| *Close* | Strg+W | schließt das aktive Fenster; mit Umschalt alle Fenster (Strg+Umschalt+W) | **bestätigt** für Strg+W in den angedockten Werkzeugfenstern (Adressbuch, Filter, Postfächer): schließt das Fenster, nicht mehr ganz Eudora ([E-137](../Intern/BEFUNDE.md#e-137), 27.10.2026); für Nachrichten- und Postfachfenster Vorlage |
| *Save* | Strg+S | sichert das aktive Fenster; Strg+Umschalt+S ist *Save All* (Kennung `ID_SAVE_ALL`, ohne Statuszeilentext) | Vorlage |
| *Save As…* | | sichert das aktive Fenster unter neuem Namen — bei einer Nachricht als Datei. Endung immer `.txt` ([E-128](../Intern/BEFUNDE.md#e-128), *bleibt `.txt` auch bei HTML*); zwei Kästchen fehlen im Dialog ([E-98](../Intern/BEFUNDE.md#e-98), *Kopfzeilen einschließen / Absätze raten*) | **bestätigt** aus dem Verfassen-Fenster ([E-140](../Intern/BEFUNDE.md#e-140), 01.11.2026, Datei mit Zeichensatzangabe) |
| *Save As Stationery* | | sichert das aktive Fenster als Briefpapier | Vorlage |
| *Send Queued Messages* | Strg+T | verschickt die verfassten und in *Out* wartenden Nachrichten | Vorlage |
| *Check Mail* | Strg+M | holt neue Post; mit Umschalt die Übertragungsoptionen | Vorlage |
| *Work Offline* | | schaltet die Verbindung ab bzw. wieder zu (ohne Statuszeilentext; Schalter `Offline`, siehe [*Incoming Mail*](#incoming-mail)) | Vorlage |
| *Print Setup…* | | Drucker und Druckoptionen wählen | Vorlage |
| *Print Preview* | | Druckvorschau ([E-169](../Intern/BEFUNDE.md#e-169), *manche HTML-Mails ohne Bilder in der Vorschau*) | Vorlage |
| *Print…* | Strg+P | druckt das aktive Fenster | Vorlage |
| *Print One* | | druckt ein Exemplar auf den Standarddrucker, ohne Dialog | Vorlage |
| *Import…* | | übernimmt Nachrichten, Postfächer und Adressbücher aus anderen Programmen | Vorlage |
| *Exit* | Strg+Q | beendet Eudora, fragt nach ungesicherten Fenstern; mit Umschalt werden nur die Fensterpositionen gesichert, ohne zu beenden | Vorlage |

### *Edit*

| Eintrag | Kürzel | Was es tut | Herkunft |
|---|---|---|---|
| *Undo* | Strg+Z, Alt+Rück | macht den letzten Schritt rückgängig | Vorlage |
| *Redo* | Strg+Umschalt+Z | stellt den rückgängig gemachten Schritt wieder her | Vorlage |
| *Cut* | Strg+X, Umschalt+Entf | ausschneiden in die Zwischenablage | Vorlage |
| *Copy* | Strg+C, Strg+Einfg | kopieren in die Zwischenablage | Vorlage |
| *Paste* | Strg+V, Umschalt+Einfg | Zwischenablage einfügen | Vorlage |
| *Paste Special…* | | ohne Statuszeilentext | Vorlage |
| *Paste As Quotation* | Strg+' (deutsche Tastatur vermutlich Strg+Ä, siehe [Abschnitt 2](#sonderzeichen-und-einzeltasten)) | fügt die Zwischenablage als Zitat ein | Vorlage |
| *Clear* | | löscht die Markierung | Vorlage |
| *Text* ▸ *Plain* | | nimmt die Formatierung der Markierung weg | Vorlage |
| *Text* ▸ *Bold* / *Italic* / *Underline* | Strg+B / Strg+I / Strg+U | fett / kursiv / unterstrichen (umschaltend) | Vorlage |
| *Text* ▸ *Strikeout* | | durchgestrichen (umschaltend) | Vorlage |
| *Text* ▸ *Typewriter* | | Schreibmaschinenschrift | Vorlage |
| *Text* ▸ *Add Quote Level* | Strg+Umschalt+. (Menütext: Strg+>) | eine Zitatebene mehr | Vorlage |
| *Text* ▸ *Remove Quote Level* | Strg+. | eine Zitatebene weniger | Vorlage |
| *Text* ▸ *Size* ▸ *Very Small* … *Humongous* | | sieben Schriftgrößen für die Markierung | Vorlage |
| *Text* ▸ *Color* | | Textfarbe | Vorlage |
| *Text* ▸ *Last Text Color* | | die zuletzt benutzte Textfarbe | Vorlage |
| *Text* ▸ *Font* | | Schriftart | Vorlage |
| *Text* ▸ *Margins* ▸ *Normal* / *Indent In* / *Indent Out* | | ohne Einzug / Einzug vergrößern / verkleinern | Vorlage |
| *Text* ▸ *Left* / *Right* / *Center* | | Absatz links, rechts, mittig | Vorlage |
| *Text* ▸ *Bulleted List* | | Aufzählung | Vorlage |
| *Text* ▸ *Make Hyperlink* | | macht aus dem markierten Text einen Verweis | Vorlage |
| *Text* ▸ *Format Painter* | | überträgt die Formatierung der Markierung auf den nächsten markierten Text | Vorlage |
| *Text* ▸ *Clear Formatting* | Strg+Leertaste | entfernt die Formatierung | Vorlage |
| *Insert* ▸ *Picture…* | | fügt ein Bild an der Cursorstelle ein | Vorlage |
| *Insert* ▸ *Downloadable Picture…* | | fügt einen Platzhalter für ein nachzuladendes Bild ein | Vorlage |
| *Insert* ▸ *Horizontal Line* | | waagerechte Linie | Vorlage |
| *Insert Emoticon* | | fügt ein Emoticon ein | Vorlage |
| *Select All* | Strg+A | markiert den ganzen Inhalt des Feldes | Vorlage |
| *Wrap Selection* | | setzt feste Zeilenumbrüche in die Markierung; mit Umschalt nimmt es sie heraus | Vorlage |
| *Finish Address Book Entry* | Strg+, | vervollständigt einen angefangenen Kurznamen; mit Umschalt wird er aufgelöst | Vorlage |
| *Insert Recipient* ▸ | | Liste der Empfänger, die mit *Special → Add as Recipient* aufgenommen wurden | Vorlage |
| *Find* ▸ *Find Text* | Strg+Umschalt+F | sucht in der offenen Nachricht | **bestätigt** ([FAQ 16](FAQ.md#16-wie-blende-ich-alle-kopfzeilen-ein-und-wieder-aus), 31.10.2026) |
| *Find* ▸ *Find Text Again* | F3, Strg+G | nächster Treffer | **bestätigt** für F3 ([FAQ 16](FAQ.md#16-wie-blende-ich-alle-kopfzeilen-ein-und-wieder-aus)) |
| *Find* ▸ *Find Messages* | Strg+F | öffnet das Suchfenster über viele Postfächer | **bestätigt** ([E-115](../Intern/BEFUNDE.md#e-115), 13.10.2026) |
| *Find* ▸ *Find Messages Using* ▸ | | gespeicherte Suchen (`CDynamicSavedSearchMenu`, `mainfrm.cpp:8380`) | Vorlage |
| *Find* ▸ *Search Web* / *Search Eudora* / *Search Mailbox* / *Search Mailfolder* | | sucht den markierten Text im Netz, in allen Postfächern, im Postfach, im Ordner (ohne Statuszeilentext) | Vorlage |
| *Sort* ▸ *Sort by Status* … *Sort by Subject* | | sortiert das Postfach nach Zustand, Dringlichkeit, Anhang, Label, Absender, Datum, Größe, Serverzustand, Stimmung (*Mood*), Junk-Punktzahl oder Betreff | Vorlage |
| *Sort* ▸ *Group by Subject* | | hält nach dem Sortieren Nachrichten mit gleichem Betreff zusammen | Vorlage |
| *Check Spelling* | Strg+6 | Rechtschreibprüfung — **fehlt in diesem Paket**, Eudora meldet das beim Start ([E-139](../Intern/BEFUNDE.md#e-139), *Meldung kam nach jedem Start wieder*) | Vorlage |
| *Message Plug-ins* ▸ | | Befehle der Zusatzmodule (Übersetzer) | Vorlage |

### *Mailbox*

In der Ressourcendatei leer; gefüllt von `QCMailboxDirector.cpp:1960-2010`.
Oben die vier Systempostfächer *In*, *Out*, *Junk*, *Trash*, danach ein
Untermenü *Recent* mit den zuletzt benutzten Postfächern (so viele, wie
[`MaxRecentMailbox`](#mailboxes) sagt, Vorgabe 10; bei 0 entfällt es), dann
*New…* zum Anlegen und darunter Ihre eigenen Postfächer und Ordner. Ein
Ordner ist ein Untermenü mit demselben Aufbau.

| Eintrag | Kürzel | Was es tut | Herkunft |
|---|---|---|---|
| *In* | Strg+1 | öffnet das Postfach mit der eingegangenen Post | Vorlage |
| *Out* | Strg+0 | öffnet das Postfach mit der wartenden Post | Vorlage |
| *New…* | | legt ein neues Postfach oder einen Ordner an | Vorlage |

### *Message*

| Eintrag | Kürzel | Was es tut | Herkunft |
|---|---|---|---|
| *New Message* | Strg+N | neue Nachricht | Vorlage |
| *Reply* | Strg+R | antwortet dem Absender; ob Strg+R allen antwortet, legt [*Replying*](#replying) fest | Vorlage |
| *Reply to All* | | antwortet allen Empfängern | Vorlage |
| *Forward* | | leitet eine Kopie weiter | **bestätigt** ([E-93](../Intern/BEFUNDE.md#e-93), 13.10.2026: eine weitergeleitete Nachricht erneut weitergeleitet, vollständig) |
| *Redirect* | | leitet um (der ursprüngliche Absender bleibt) | Vorlage |
| *Send Again* | | verschickt die Nachricht erneut — auch um zurückgekommene Post wiederherzustellen | Vorlage |
| *New Message To* ▸ / *Forward To* ▸ / *Redirect To* ▸ | | dasselbe an einen Empfänger aus der Empfängerliste (*Special → Add as Recipient*) | Vorlage |
| *New Message With* ▸ / *Reply With* ▸ / *Reply to All With* ▸ | | dasselbe mit einem Briefpapier (*Tools → Stationery*) | Vorlage |
| *Attach File* | Strg+H | hängt eine Datei an | Vorlage |
| *Attach* ▸ | | Anhang-Befehle der Zusatzmodule (`CDynamicPluginMenu`, `mainfrm.cpp:8310`) | Vorlage |
| *Send Immediately* | Strg+E | verschickt sofort bzw. stellt in *Out*; mit Umschalt Zeitpunkt wählen | Vorlage |
| *Change* ▸ *Queuing…* | | wann die Nachricht verschickt wird | Vorlage |
| *Change* ▸ *Status* ▸ | | setzt den Zustand: *Unread*, *Read*, *Replied*, *Forwarded*, *Redirected*, *Recovered*; bei ausgehender Post *Unsendable*, *Sendable*, *Queued*, *Time Queued*, *Sent*, *Unsent* | Vorlage |
| *Change* ▸ *Priority* ▸ | | *Highest* bis *Lowest* | Vorlage |
| *Change* ▸ *Label* ▸ | | *None* oder eines der sieben Labels; die Namen kommen aus [*Labels*](#labels) | **bestätigt** ([FAQ 9](FAQ.md#9-wie-markiere-ich-wichtige-mails-farbig), 29.10.2026: *„labels funktionieren“*). Geht beim Verschieben im selben IMAP-Konto verloren ([E-170](../Intern/BEFUNDE.md#e-170), *Label nur lokal gespeichert*) |
| *Change* ▸ *Server Status* ▸ | | merkt eine POP-Nachricht auf dem Server vor: *Leave*, *Fetch*, *Delete*, *Fetch then Delete* | Vorlage |
| *Change* ▸ *Personality* ▸ | | ordnet die Nachricht einem anderen Konto zu | Vorlage |
| *Junk* / *Not Junk* | | markiert als Junk bzw. nicht Junk ([FAQ 13](FAQ.md#13-warum-landet-nichts-automatisch-in-junk--und-was-ich-dabei-nicht-tun-sollte)) | Vorlage |
| *Delete* | Strg+D | legt die Nachricht in den Papierkorb (*Trash*) | Vorlage |
| *UnDelete* | | hebt die Löschmarke wieder auf (nur IMAP) | **bestätigt** ([FAQ 5](FAQ.md#5-im-imap-posteingang-fehlen-mails-die-der-webmailer-zeigt), [E-120](../Intern/BEFUNDE.md#e-120), 13.10.2026) |
| *Purge Messages* | | entfernt die als gelöscht markierten Nachrichten endgültig (nur IMAP) | Vorlage |

### *Transfer*

Aufgebaut wie *Mailbox* (`CDynamicMailboxMenu`, `mainfrm.cpp:8367`), nur
**verschiebt** ein Klick die markierten Nachrichten in das gewählte Postfach,
statt es zu öffnen; *New…* legt ein Postfach an und verschiebt hinein.

| Eintrag | Was es tut | Herkunft |
|---|---|---|
| ein Postfach | verschiebt die markierten Nachrichten dorthin | **bestätigt**, dass *Out* im Hauptmenü *Transfer* wählbar ist ([TESTPLAN, E-143](../Intern/TESTPLAN.md#e-143-naechstes), 02.11.2026) |

Beim Verschieben nach *Out* fragt Eudora nach. Aus dem Suchfenster heraus kam
der Hinweis bis 7.2.1.130 je Nachricht; seit 7.2.1.131 kommt er einmal je
Übertragung (#201, [E-143](../Intern/BEFUNDE.md#e-143), *Out-Hinweis je Treffer*).

Beim Verschieben zwischen zwei Ordnern **desselben IMAP-Kontos** kann Eudora
Betreff und Absender zweier Mails verwechseln, wenn im Ziel schon eine Mail
mit derselben internen Nummer liegt — Vorsicht beim Löschen des doppelten
Eintrags ([E-184](../Intern/BEFUNDE.md#e-184), [E-189](../Intern/BEFUNDE.md#e-189);
[README, *Bekannte Fehler*](../README.md#bekannte-fehler)).

### *Special*

| Eintrag | Kürzel | Was es tut | Herkunft |
|---|---|---|---|
| *Filter Messages* | Strg+J | lässt die Filter mit Häkchen *Manual* über die markierten Nachrichten laufen. Ob Strg+J filtert oder nach *Junk* schiebt, ist umschaltbar ([FAQ 12](FAQ.md#12-filter-messages-strgj-tut-nichts)) | Vorlage |
| *Make Filter* | | baut einen Filter aus der Nachricht ([FAQ 10](FAQ.md#10-wie-baue-ich-schnell-einen-filter-aus-einer-mail)) | **bestätigt** ([TESTPLAN, E-143](../Intern/TESTPLAN.md#e-143-naechstes), 01.11.2026: Ziel *Out* ist dort grau, alle anderen wählbar) |
| *Make Address Book Entry…* | Strg+K | legt einen Kurznamen für die Adressen der Nachricht an | Vorlage |
| *Add as Recipient* | | nimmt den markierten Text in die Empfängermenüs auf | Vorlage |
| *Remove Recipient* ▸ | | nimmt einen Empfänger wieder heraus | Vorlage |
| *Empty Trash* | | löscht alles im Papierkorb endgültig; Anhänge nur mit [*Delete attachments when emptying Trash*](#attachments) ([FAQ 14](FAQ.md#14-werden-anhänge-gelöscht-wenn-ich-die-mail-lösche)) | **bestätigt** mit `TidyAttach=1` ([FAQ 14](FAQ.md#14-werden-anhänge-gelöscht-wenn-ich-die-mail-lösche), 29.10.2026) |
| *Compact Mailboxes* | | gibt ungenutzten Platz in allen Postfächern frei | Vorlage |
| *Forget Password(s)* | | fragt beim nächsten Abruf wieder nach dem Kennwort | Vorlage |
| *Change Password…* | | ändert das Kennwort auf dem POP-Server — **ab Werk ausgeblendet**: `RemoveChangePassword` ist eingebaut `1` und nimmt den Eintrag beim Start heraus (`mainfrm.cpp:8372-8373`) | Vorlage |
| *Message Plug-ins Settings…* | | Einstellungen der Zusatzmodule | Vorlage |

### *Tools*

| Eintrag | Kürzel | Was es tut | Herkunft |
|---|---|---|---|
| *Filters* | | Fenster zum Bearbeiten der Filter ([FILTER.md](../Intern/FILTER.md#einen-filter-anlegen)) | **bestätigt** ([TESTPLAN, E-143](../Intern/TESTPLAN.md#e-143-naechstes), 02.11.2026, *Transfer To* im Filterfenster) |
| *Filter Report* | | Fenster mit dem Filterbericht ([FILTER.md](../Intern/FILTER.md#der-filterbericht)) | Vorlage |
| *Mailboxes* | | Fenster zum Anlegen, Umbenennen, Löschen und Verschieben von Postfächern | Vorlage |
| *File Browser* | | Dateifenster der Windows-Oberfläche | Vorlage |
| *Stationery* | | Briefpapier anlegen und anwenden | Vorlage |
| *Signatures* | | Signaturen verwalten | Vorlage |
| *Personalities* | | Konten (*Personalities*) verwalten ([FAQ 7](FAQ.md#7-wie-lege-ich-ein-zweites-konto-an)) | **bestätigt**: *New…* öffnet den Assistenten ohne Windows-Meldung ([E-160](../Intern/BEFUNDE.md#e-160), 27.10.2026) |
| *Task Status* | | laufende Hintergrundaufgaben | Vorlage |
| *Task Errors* | | Fehler der Hintergrundaufgaben | Vorlage |
| *Address Book* | Strg+L | Adressbuch mit den Kurznamen ([FAQ 8](FAQ.md#8-wie-lege-ich-einen-kurznamen-an-und-nutze-ihn-beim-schreiben)) | **bestätigt**: *New* und Kurzname ([E-134](../Intern/BEFUNDE.md#e-134), 21.10.2026) |
| *Directory Services* | Strg+Y | Suche über Ph und Finger — **fällt hier aus**, es fehlen `MFC71.DLL`/`MSVCP71.dll` ([ANWENDER.md](ANWENDER.md#was-es-nicht-kann)) | Vorlage |
| *Link History* | | Liste der angeklickten Verweise | Vorlage |
| *Statistics* | | Nutzungsstatistik; grau, wenn `DisableStatistics=1` (`mainfrm.cpp:10503-10511`) | Vorlage |
| *Reset Tools…* | | ohne Statuszeilentext; setzt die Werkzeugleisten zurück (`OnResetTools`, `mainfrm.cpp:7350`) | Vorlage |
| *Options…* | | die Einstellungen — siehe [Abschnitt 3](#3-tools--options) | **bestätigt** (Seiten *Checking Mail*, *Labels*, *Attachments*, siehe dort) |

Zusatzmodule können vor *Options…* eigene Einträge einfügen
(`mainfrm.cpp:8395-8405`).

### *Window*

| Eintrag | Kürzel | Was es tut | Herkunft |
|---|---|---|---|
| *Cascade* | Umschalt+F5 | Fenster überlappend anordnen | Vorlage |
| *Tile Horizontal* | Umschalt+F4 | Fenster untereinander | Vorlage |
| *Tile Vertical* | | Fenster nebeneinander | Vorlage |
| *Arrange Icons* | | Symbole unten anordnen | Vorlage |
| *Send To Back* | Strg+F6 | schickt das aktive Fenster nach hinten | Vorlage |

Darunter hängt Windows die Liste der offenen Fenster an; dieselben Namen
stehen auf der Registerleiste unten ([E-48](../Intern/BEFUNDE.md#e-48),
**bestätigt** am 09.09.2026: *Beschriftungen stimmen mit dem Menü Window*).

### *Help*

| Eintrag | Kürzel | Was es tut | Herkunft |
|---|---|---|---|
| *Topics* | F1 | Hilfethemen | Vorlage |
| *Context Sensitive Help* | Umschalt+F1 | Hilfe zum angeklickten Knopf, Menü oder Fenster | Vorlage |
| *Technical Support* | | wie man technische Hilfe bekommt (Angaben von QUALCOMM) | Vorlage |
| *Report A Bug* | | ohne Statuszeilentext; legt eine neue Nachricht mit dem Fragebogen von QUALCOMM an (`eudora.cpp:564`, `IDS_REPORT_BUG_MSG_TEXT`). Fehler dieser Portierung bitte so melden, wie [ANWENDER.md](ANWENDER.md#einen-fehler-melden) es beschreibt | Vorlage |
| *Tip of the Day* | | Tipp des Tages | Vorlage |
| *Keyboard Shortcuts* | | **ab 7.2.2:** zeigt die Übersicht [Tastenkürzel auf einen Blick](#2-tastenkürzel-auf-einen-blick) als Seite im Standard-Browser (Datei `Hilfe\Tastenkuerzel.html` neben `Eudora.exe`; fehlt sie, sagt eine Meldung, wo sie erwartet wird) ([A-5](../Intern/BEFUNDE.md#a-5)) | am Prüfstand gemessen |
| *Settings Reference* | | **ab 7.2.2:** zeigt [*Tools → Options*](#3-tools--options) mit den `Eudora.ini`-Schlüsseln und die [Schlüssel ohne Optionsseite](#5-eudoraini-schlüssel-ohne-optionsseite) im Standard-Browser (`Hilfe\Einstellungen.html`) ([A-5](../Intern/BEFUNDE.md#a-5)) | am Prüfstand gemessen |
| *Payment & Registration* | | bezahlen, registrieren, Modus wechseln, nach neuen Fassungen sehen | Vorlage |
| *Insert System Configuration* | | fügt die Systemangaben in die offene neue Nachricht ein **und hängt eine Kopie der `Eudora.ini` an** (`CCompMessageDoc::ReadSystemInfo`, `compmsgd.cpp:2695`) — mit Servern, Anmeldenamen und Adressen; laut Eudoras eigenem Text „minus any passwords“ (`IDS_REPORT_BUG_MSG_TEXT`), ob die Kennwörter wirklich herausfallen, ist nicht nachgesehen | Vorlage |
| *About Eudora…* | | Fassung und Pfade; **Copy info** legt sie für einen Fehlerbericht auf die Zwischenablage ([ANWENDER.md](ANWENDER.md#was-in-einen-fehlerbericht-gehört--help--about-eudora)) | Vorlage |

### Rechtsklickmenüs

Die Kontextmenüs stehen in `IDR_CONTEXT_POPUPS` (`EudoraRes.rc:5855`) und
einigen eigenen Ressourcen. Aufgezählt ist, was **nicht** schon gleichlautend
im Hauptmenü steht; die Untermenüs *Change Status*, *Change Priority*,
*Change Label*, *Change Server Status* entsprechen *Message → Change*.

| Wo man rechts klickt | Einträge | Was nur hier steht | Herkunft |
|---|---|---|---|
| **in einer gelesenen Nachricht** (*Received Msgs*) | *Copy*, *Search Web/Eudora/Mailbox/Mailfolder*, *Transfer to*, *Reply*, *Reply to All*, *Forward*, *Redirect*, *Make Filter*, *View Source*, *Send to Browser*, Anhangbefehle, *Junk*, *Not Junk*, *Recalculate Junk Score*, *Delete* | *View Source*: zeigt den Quelltext der Nachricht · *Send to Browser*: öffnet sie im Webbrowser · *Transfer to*: verschiebt in das Postfach, dessen Name markiert ist (ohne Statuszeilentext) · auf einem Anhang: *Open Attachment With…* (mit gewähltem Programm), *Save Attachment As…* (an anderen Ort kopieren), *Explore Attachment* (Explorer am Anhangverzeichnis), *Copy Attachment…*, *Delete Attachment…* (mit Umschalt am Papierkorb vorbei) · *Recalculate Junk Score*: Junk-Punktzahl neu berechnen | **bestätigt** für *Search Mailfolder* ohne Markierung ([E-171](../Intern/BEFUNDE.md#e-171), 01.11.2026 an Gregors Protokoll) |
| **im Verfassen-Fenster** (*Comp Message*) | *Cut*, *Copy*, *Paste*, *Paste Special…*, *Paste As Quotation*, die vier *Search …*, *Attach File*, *Send Again*, *Change Queuing…*, *Check Spelling* | — | Vorlage |
| **in der Postfachliste** (*Mailbox*) | *Reply*, *Reply to All*, *Make Filter*, *Change Status/Priority/Label/Server Status*, *Junk*, *Not Junk*, *Recalculate Junk Score*, *Delete Message* | — | **bestätigt** für *Make Filter* ([TESTPLAN, E-143](../Intern/TESTPLAN.md#e-143-naechstes), 01.11.2026) |
| **in `Out`** (*Out Mbx*) | *Send Immediately*, *Send Again*, *Make Filter*, *Change Queuing…*, *Change Status* (nur die Zustände ausgehender Post), *Change Priority*, *Change Label*, *Delete Message* | — | Vorlage |
| **in einem IMAP-Postfach** (*ImapMailbox*) | wie in der Postfachliste, dazu *UnDelete Message*, *Fetch* ▸, *Remove Cached Contents* | *Fetch* ▸ *Include Attachments*: alle Teile vom Server holen · *Fetch* ▸ *Use Defaults*: mit den eingestellten Vorgaben holen · *Remove Cached Contents*: die lokal zwischengespeicherte Fassung verwerfen | Vorlage |
| **auf einem IMAP-Postfach in der Ordnerliste** | *Resynchronize Mailbox*, *Resynchronize Mail Folder*, *Resynchronize on Mail Check*, *Show Deleted Messages*, *Refresh Mailbox List* | Inhalt mit dem Server abgleichen · beim Abruf automatisch abgleichen · gelöschte IMAP-Nachrichten zeigen ([FAQ 5](FAQ.md#5-im-imap-posteingang-fehlen-mails-die-der-webmailer-zeigt)) · Ordnerliste neu vom Server holen | Vorlage |
| **auf einem Postfach oder Ordner** (*Tools → Mailboxes*) | *Open* bzw. *Expand/Collapse* (Enter), *Find Messages…*, *Find Messages Using* ▸, *New…*, *Delete* (Entf), *Rename* (F2) | *Find Messages…*: Suchfenster mit diesem Postfach vorgewählt | Vorlage |
| **auf einem Kurznamen** (*Address Book*) | *New…*, *Delete* (Entf), *Rename* (F2), *Move To…*, *Copy To…*, *Add to Recipient List*, *Remove From Recipient List*, *Add to BossWatch List*, *Remove from BossWatch List* | alle ohne Statuszeilentext | Vorlage |
| **auf einer Persönlichkeit** (*Tools → Personalities*) | *Check Mail*, *Send Queued Messages*, *Test*, *Message* ▸ (*New Message As*, *Reply As*, *Reply to All As*, *Forward As*, *Redirect As*, *Send Again As*), *New…*, *Delete* (Entf), *Properties* (Alt+Enter) | *Test*: prüft Server und Anmeldung der gewählten Konten · *Properties*: Kontoeinstellungen, darin die Verschlüsselung ([FAQ 2](FAQ.md#2-welche-verschlüsselung-und-welchen-port-nehme-ich)) · vor dem Löschen der **gerade benutzten** Persönlichkeit auf eine andere wechseln ([E-39](../Intern/BEFUNDE.md#e-39), *Reste kommen wieder*) | **bestätigt** für *New…* ([E-160](../Intern/BEFUNDE.md#e-160)) |
| **auf einem Briefpapier** (*Tools → Stationery*) | *New…*, *Edit*, *Delete*, *Rename*, *New Message With* (Enter), *Reply With*, *Reply to All With* | — | Vorlage |
| **auf einer Signatur** (*Tools → Signatures*) | *New…*, *Edit* (Enter), *Delete* (Entf), *Rename* (F2) | — | Vorlage |
| **in *Link History*** | *Copy*, *View*, *Remove*, *Change Date Display* ▸ (*Remind Me*, *Bookmark*, *Just Date*) | ohne Statuszeilentext | Vorlage |
| **auf einem Spaltenkopf der Postfachliste** | *<Spalte> None*, *Ascending*, *Descending*, *Group by Subject* | nach dieser Spalte nicht / aufsteigend / absteigend sortieren | Vorlage |
| **auf dem Rahmen der Leisten** (*ControlBars*) | *Toolbar*, *Status Bar*, *Search Bar*, *Customize …* | Leisten ein- und ausblenden, Werkzeugleiste anpassen | Vorlage |
| **auf einem Reiter der angedockten Fenster** | *Tab Location* ▸ *Top/Bottom/Left/Right*, *Show Single Tab* | wo die Reiter stehen; Reiter auch bei nur einem Fenster zeigen | Vorlage |
| **auf der Registerleiste der offenen Fenster** | *Restore*, *Minimize*, *Maximize*, *Close* (Strg+F4) | — | Vorlage |
| **im *File Browser*** | *Back*, *Forward*, *Up One Level*, *Set as Home Folder*, *View* ▸, *Refresh* (F5), *Paste*, *New Folder*, *Properties* | — | Vorlage |
| **auf dem Symbol in der Taskleiste** | *Exit*, *Minimize to System Tray*, *Always Show Tray Icon*, *Work Offline*, *New Message*, *Check Mail*, *Open Eudora* | — | Vorlage |
| **in einem Eingabefeld** | *Undo*, *Cut*, *Copy*, *Paste*, *Delete*, *Select All* | — | Vorlage |

**Einmal die Kopfzeilen ein- und ausblenden** geht nicht über ein Menü,
sondern über den Knopf ***Blah Blah Blah*** in der Leiste des
Nachrichtenfensters (**bestätigt**, [FAQ 16](FAQ.md#16-wie-blende-ich-alle-kopfzeilen-ein-und-wieder-aus),
[E-80](../Intern/BEFUNDE.md#e-80)).

---

## 2. Tastenkürzel auf einen Blick

**Woher.** Eudora hat **eine** Tastentabelle, `IDR_MAINFRAME ACCELERATORS`
(`EudoraRes.rc:263-373`, 81 Zeilen); die Lese-, Verfassen- und
Postfachfenster haben keine eigene — die Ressourcendatei enthält keine
weitere `ACCELERATORS`-Ressource. Die Tabelle hängt am Hauptfenster und gilt
deshalb überall; Windows reicht den Befehl an das gerade aktive Fenster
weiter, und **wirken** kann er nur dort, wo ein Fenster ihn behandelt. Die
Spalte *wo es gilt* ist daraus abgeleitet: aus den Quelldateien, die den
Befehl per `ON_COMMAND` behandeln (`perl tools/funktionen-auslesen.pl --kuerzel`
listet sie je Zeile). Dazu kommen Kürzel, die **nur im Menütext** stehen
(hinter dem Tabulator, etwa *Delete*`\tDel`) — die behandelt das Fenster
selbst, nicht die Tabelle.

**Mit Umschalt.** Fast jedes Strg-Kürzel steht in der Tabelle ein zweites
Mal mit Umschalt und ruft **denselben** Befehl auf. Ob der dann etwas anderes
tut, sagt der Statuszeilentext; wo er nichts sagt, steht die Zeile nicht
eigens da.

**Wo es gilt** — die Abkürzungen der Spalte:
*überall* (Hauptfenster, jedes Fenster) · *Postfachliste* · *Lesefenster* ·
*Verfassen-Fenster* · *Textfeld* (jedes Eingabe- oder Textfeld, auch die
Kopfzeilen im Verfassen-Fenster) · *Liste* (das genannte Werkzeugfenster).

### Strg + Buchstabe

| Kürzel | was es tut | wo es gilt | Menüeintrag | Herkunft |
|---|---|---|---|---|
| Strg+A | alles im Feld markieren | Textfeld, Postfachliste, Suchfenster, *Link History* | [*Edit → Select All*](#edit) | Vorlage |
| Strg+B | fett (umschaltend) | Verfassen-Fenster; Lesefenster im Bearbeiten-Modus | [*Edit → Text → Bold*](#edit) | Vorlage |
| Strg+C | kopieren; ebenso Strg+Einfg | überall, wo markiert werden kann | [*Edit → Copy*](#edit) | Vorlage |
| Strg+D | Nachricht in den Papierkorb | Postfachliste, Lesefenster, Verfassen-Fenster, Suchfenster | [*Message → Delete*](#message) | Vorlage |
| Strg+E | sofort senden bzw. nach *Out* stellen; **mit Umschalt** Versandzeitpunkt wählen | Verfassen-Fenster, Postfachliste | [*Message → Send Immediately*](#message) | Vorlage |
| Strg+F | ***Find Messages*** — **umschaltbar:** mit `SwitchFindKeyAccl=1` in der `Eudora.ini` (Vorgabe `0`) tauschen Strg+F und Strg+Umschalt+F (`mainfrm.cpp:4289-4305`) | überall | [*Edit → Find → Find Messages*](#edit) | **bestätigt** ([E-115](../Intern/BEFUNDE.md#e-115), 13.10.2026) |
| Strg+G | nächster Treffer (wie F3) | überall | [*Edit → Find → Find Text Again*](#edit) | Vorlage |
| Strg+H | Datei anhängen | Verfassen-Fenster | [*Message → Attach File*](#message) | Vorlage |
| Strg+I | kursiv (umschaltend) | Verfassen-Fenster; Lesefenster im Bearbeiten-Modus | [*Edit → Text → Italic*](#edit) | Vorlage |
| Strg+J | **doppelt belegt, umschaltbar:** mit `CtrlJMapping=1` *Junk*, sonst ***Filter Messages*** (`mainfrm.cpp:4390-4397`). Einstellbar unter [*Junk Mail Extras*](#junk-mail-extras); diese Portierung stellt beim ersten Start ohne Filter auf *Filter Messages* ([FAQ 12](FAQ.md#12-filter-messages-strgj-tut-nichts), [E-75](../Intern/BEFUNDE.md#e-75)) | Postfachliste, Lese- und Verfassen-Fenster | [*Special → Filter Messages*](#special) bzw. [*Message → Junk*](#message) | Vorlage |
| Strg+K | Adressbucheintrag aus der Nachricht | Postfachliste, Lese- und Verfassen-Fenster, Adressbuch | [*Special → Make Address Book Entry…*](#special) | Vorlage |
| Strg+L | Adressbuch öffnen | überall | [*Tools → Address Book*](#tools) | Vorlage |
| Strg+M | Post holen; **mit Umschalt** die Übertragungsoptionen | überall | [*File → Check Mail*](#file) | Vorlage |
| Strg+N | neue Nachricht | überall | [*Message → New Message*](#message) | Vorlage |
| Strg+O | Textdatei öffnen | überall | [*File → Open File…*](#file) | Vorlage |
| Strg+P | drucken | Lese-, Verfassen-, Postfach-, Adressbuchfenster | [*File → Print…*](#file) | Vorlage |
| Strg+Q | beenden; **mit Umschalt** nur die Fensterpositionen sichern | überall | [*File → Exit*](#file) | Vorlage |
| Strg+R | **umschaltbar:** antwortet dem Absender, **mit Umschalt** allen. Mit *Map Ctrl+R to “Reply to All”* ([*Replying*](#replying), `ReplyToAll=1`) genau umgekehrt (`mainfrm.cpp:4574-4586`) | Postfachliste, Lesefenster | [*Message → Reply*](#message) / *Reply to All* (der Menütext zeigt Strg+R am jeweils belegten Eintrag) | Vorlage |
| Strg+S | sichern | Verfassen-Fenster, Lesefenster, Textdateien, Suchfenster | [*File → Save*](#file) | Vorlage |
| Strg+T | wartende Post verschicken | überall | [*File → Send Queued Messages*](#file) | Vorlage |
| Strg+U | unterstrichen (umschaltend) | Verfassen-Fenster; Lesefenster im Bearbeiten-Modus | [*Edit → Text → Underline*](#edit) | Vorlage |
| Strg+V | einfügen; ebenso Umschalt+Einfg | Textfeld, *File Browser* | [*Edit → Paste*](#edit) | Vorlage |
| Strg+W | Fenster schließen; **mit Umschalt** alle (siehe unten) | überall | [*File → Close*](#file) | **bestätigt** für die angedockten Werkzeugfenster ([E-137](../Intern/BEFUNDE.md#e-137), 27.10.2026: schließt das Fenster, nicht mehr ganz Eudora); sonst Vorlage |
| Strg+X | ausschneiden; ebenso Umschalt+Entf | Textfeld | [*Edit → Cut*](#edit) | Vorlage |
| Strg+Y | *Directory Services* — fällt hier aus ([ANWENDER.md](ANWENDER.md#was-es-nicht-kann)) | überall | [*Tools → Directory Services*](#tools) | Vorlage |
| Strg+Z | rückgängig; ebenso Alt+Rück | Textfeld, Postfachliste | [*Edit → Undo*](#edit) | Vorlage |

### Strg + Ziffer

| Kürzel | was es tut | wo es gilt | Menüeintrag | Herkunft |
|---|---|---|---|---|
| Strg+0 | Postfach *Out* öffnen | überall | [*Mailbox → Out*](#mailbox) | Vorlage |
| Strg+1 | Postfach *In* öffnen | überall | [*Mailbox → In*](#mailbox) | Vorlage |
| Strg+2 … Strg+5, Strg+7 … Strg+9 | **frei belegbar, ab Werk ohne Wirkung:** führen die Einträge `SelectedTextURL1` … `SelectedTextURL7` aus der `Eudora.ini` (`[Settings]`) mit dem markierten Text aus — 1 bis 3 auf Strg+7 bis Strg+9, 4 bis 7 auf Strg+2 bis Strg+5; jeder Eintrag erscheint dann an vorletzter Stelle im Menü *Edit* (`mainfrm.cpp:8183-8225`). Aufbau am Quelltext: Menüname, Tabulator, Webadresse mit `%s`; der markierte Text wird URL-kodiert für `%s` eingesetzt und die Adresse im Browser geöffnet (`mainfrm.cpp:7933`, `QCSelectedTextURLCommand.cpp:53`). Etwa `SelectedTextURL1=Wikipedia<Tab>https://de.wikipedia.org/wiki/%s` — Beispiel, nicht ausprobiert | überall | — (erst mit Eintrag in *Edit*) | Vorlage |
| Strg+6 | Rechtschreibprüfung — fehlt in diesem Paket ([E-139](../Intern/BEFUNDE.md#e-139)) | Verfassen-Fenster | [*Edit → Check Spelling*](#edit) | Vorlage |

### Strg + Umschalt + …

Nur die, die etwas anderes tun als ohne Umschalt.

| Kürzel | was es tut | wo es gilt | Menüeintrag | Herkunft |
|---|---|---|---|---|
| Strg+Umschalt+F | ***Find Text*** — Suche in der offenen Nachricht; mit `SwitchFindKeyAccl=1` stattdessen *Find Messages* | überall | [*Edit → Find → Find Text*](#edit) | **bestätigt** ([FAQ 16](FAQ.md#16-wie-blende-ich-alle-kopfzeilen-ein-und-wieder-aus), 31.10.2026) |
| Strg+Umschalt+J | ***Not Junk*** — **nur** wenn Strg+J auf *Junk* steht, sonst ohne Wirkung (`mainfrm.cpp:4399-4404`; ohne Statuszeilentext) | Postfachliste, Lesefenster, Suchfenster | [*Message → Not Junk*](#message) | Vorlage |
| Strg+Umschalt+L | ***Filter Messages*** — **nur** wenn Strg+J auf *Junk* steht, sonst ohne Wirkung (`mainfrm.cpp:4406-4411`; ohne Statuszeilentext) | Postfachliste, Lese- und Verfassen-Fenster | [*Special → Filter Messages*](#special) | Vorlage |
| Strg+Umschalt+R | das Gegenteil von Strg+R (siehe dort) | Postfachliste, Lesefenster | [*Message → Reply to All*](#message) | Vorlage |
| Strg+Umschalt+S | **alle** offenen Fenster sichern (`OnSaveAll`, `mainfrm.cpp:4440`; ohne Statuszeilentext) | überall | — | Vorlage |
| Strg+Umschalt+W | **alle** offenen Fenster schließen (`OnCloseAll`, `mainfrm.cpp:4415`; ohne Statuszeilentext) | überall | — | Vorlage |
| Strg+Umschalt+Z | wiederherstellen | Verfassen-Fenster; Lesefenster im Bearbeiten-Modus | [*Edit → Redo*](#edit) | Vorlage |
| Strg+Umschalt+, | Kurzname **auflösen** statt nur vervollständigen | Textfeld | [*Edit → Finish Address Book Entry*](#edit) | Vorlage |

### Funktionstasten

| Kürzel | was es tut | wo es gilt | Menüeintrag | Herkunft |
|---|---|---|---|---|
| F1 | Hilfe zum aktuellen Fenster oder Befehl | überall | [*Help → Topics*](#help) | Vorlage |
| Umschalt+F1 | Hilfe zum angeklickten Element | überall | [*Help → Context Sensitive Help*](#help) | Vorlage |
| F3 | nächster Treffer | überall | [*Edit → Find → Find Text Again*](#edit) | **bestätigt** ([FAQ 16](FAQ.md#16-wie-blende-ich-alle-kopfzeilen-ein-und-wieder-aus)) |
| Umschalt+F4 | Fenster untereinander | überall | [*Window → Tile Horizontal*](#window) | Vorlage |
| Strg+F4 | aktives Fenster schließen | Registerleiste der Fenster | Rechtsklick auf einen Reiter → *Close* ([Rechtsklickmenüs](#rechtsklickmenüs)) | Vorlage |
| Umschalt+F5 | Fenster überlappend | überall | [*Window → Cascade*](#window) | Vorlage |
| F5 | Ansicht auffrischen | *File Browser* | Rechtsklick → *Refresh* | Vorlage |
| F6 / Umschalt+F6 | zum nächsten / vorigen Fensterteil | geteilte Fenster | — | Vorlage |
| Strg+F6 | aktives Fenster nach hinten | überall | [*Window → Send To Back*](#window) | Vorlage |
| F7 | ohne Statuszeilentext. Am Code: in der **Postfachliste** wechselt es die Höhe der Liste gegenüber der Vorschau (piept, wenn keine Vorschau da ist, `TocFrame.cpp`, `OnToggleHeader`); im **Verfassen-Fenster** klappt es den Kopfbereich zu und wieder auf (`CompMessageFrame.cpp`, `OnToggleHeader`). Am Programm nicht gesehen | Postfachliste, Verfassen-Fenster | — | Vorlage |
| F2 | umbenennen | Listen: Postfächer, Kurznamen, Signaturen, Briefpapier | Rechtsklick → *Rename* | Vorlage |

### Alt + …

| Kürzel | was es tut | wo es gilt | Menüeintrag | Herkunft |
|---|---|---|---|---|
| Alt+Rück | rückgängig (wie Strg+Z) | Textfeld, Postfachliste | [*Edit → Undo*](#edit) | Vorlage |
| Alt+Enter | Kontoeinstellungen | Liste *Personalities* | Rechtsklick → *Properties* | Vorlage |
| Alt+Pfeiltasten | zur nächsten / vorigen Nachricht — ab Werk; welche Pfeiltasten, stellt [*Miscellaneous*](#miscellaneous) ein (`AltArrows=1`, `PlainArrows`, `CtrlArrows`) | Lesefenster | — | Vorlage |

### Sonderzeichen und Einzeltasten

| Kürzel | was es tut | wo es gilt | Menüeintrag | Herkunft |
|---|---|---|---|---|
| Strg+, | Kurznamen vervollständigen | Textfeld | [*Edit → Finish Address Book Entry*](#edit) | Vorlage |
| Strg+. | eine Zitatebene weniger | Verfassen-Fenster | [*Edit → Text → Remove Quote Level*](#edit) | Vorlage |
| Strg+Umschalt+. (`VK_OEM_PERIOD` mit Umschalt; Menütext und US-Tastatur: Strg+>) | eine Zitatebene mehr. Auf der deutschen Tastatur ist `>` eine eigene Taste — dort gilt Strg+Umschalt+**Punkt**, nicht Strg+Umschalt+`<` (vermutlich, nicht gemessen) | Verfassen-Fenster | [*Edit → Text → Add Quote Level*](#edit) | Vorlage |
| Strg+' (`VK_OEM_7`; deutsche Tastatur vermutlich **Strg+Ä**, nicht gemessen) | Zwischenablage als Zitat einfügen | Verfassen-Fenster; Lesefenster im Bearbeiten-Modus | [*Edit → Paste As Quotation*](#edit) | Vorlage |
| Strg+\\ (`VK_OEM_5`; deutsche Tastatur vermutlich **Strg+^**, nicht gemessen) | ohne Statuszeilentext; am Code fordert es die Nachbearbeitung der Hintergrundaufgaben an (`OnProcessAllofThem`, `mainfrm.cpp:4588`). **Wirkung unklar** — was die Nachbearbeitung für den Anwender sichtbar tut, ist nicht untersucht | überall | — | Vorlage |
| Strg+Leertaste | Formatierung entfernen — steht nicht in der Tastentabelle, der Editor fängt die Taste selbst ab (`PaigeEdtView.cpp:2990-2992`) | Verfassen-Fenster | [*Edit → Text → Clear Formatting*](#edit) | Vorlage |
| Umschalt+Entf | ausschneiden | Textfeld | [*Edit → Cut*](#edit) | Vorlage |
| Strg+Einfg / Umschalt+Einfg | kopieren / einfügen | Textfeld | [*Edit → Copy*](#edit) / *Paste* | Vorlage |
| Enter | öffnen: den Anhang unter dem Cursor (Lesefenster), das Postfach oder den Ordner (*Mailboxes*), eine neue Nachricht mit dem Briefpapier bzw. dem Konto (*Stationery*, *Personalities*), die Signatur zum Bearbeiten (*Signatures*) | je nach Fenster | [*File → Open Attachment*](#file), Rechtsklickmenüs | Vorlage |
| Entf (Menütext *Del*) | löschen: Postfach, Ordner, Kurzname, Signatur, Briefpapier, Persönlichkeit | Listen | Rechtsklick → *Delete* | Vorlage |

**Tastaturlayout.** Die Tastentabelle nennt virtuelle Tastencodes; drei davon
(`VK_OEM_5`, `VK_OEM_7`, und `VK_OEM_PERIOD` mit Umschalt) liegen auf der
deutschen Tastatur auf anderen Tasten als auf der US-Tastatur, nach der die
Menütexte geschrieben sind. Die deutschen Tasten oben sind aus der
Beschreibung der Tastencodes abgeleitet, am Programm nicht gemessen; `Strg+,`
und `Strg+.` liegen auf beiden gleich.

**Doppel- und Sonderbelegungen auf einen Blick**

* **Strg+J** — *Filter Messages* oder *Junk*, je nach `CtrlJMapping`; davon
  hängen auch **Strg+Umschalt+J** (*Not Junk*) und **Strg+Umschalt+L**
  (*Filter Messages*) ab, die sonst nichts tun.
* **Strg+R / Strg+Umschalt+R** — *Reply* und *Reply to All*, vertauschbar
  über `ReplyToAll`.
* **Strg+F / Strg+Umschalt+F** — *Find Messages* und *Find Text*,
  vertauschbar über `SwitchFindKeyAccl` (keine Optionsseite).
* **Strg+2 … Strg+9 ohne 6** — frei belegbar über `SelectedTextURL1` … `7`.
* **F3 und Strg+G**, **Strg+Z und Alt+Rück**, **Strg+C und Strg+Einfg**,
  **Strg+V und Umschalt+Einfg**, **Strg+X und Umschalt+Entf** — je zwei
  Tasten für denselben Befehl.
* Keine Taste ist in der Tabelle zweimal vergeben (nachgezählt mit
  `--kuerzel`).

---

## 3. *Tools → Options*

Links die Kategorien, rechts die Seite. **32 Seiten**, in dieser Reihenfolge:
`CSettingsDialog::OnInitDialog` (`settings.cpp:378-425`) lädt die Dialoge mit
den Ressourcennummern 2 bis 33 der Reihe nach, die Liste wird nicht sortiert.
Im *Light*-Modus fehlen *Spell Checking*, *Auto-completion*, *MoodWatch*,
*Statistics*, *Junk Mail*, *Junk Mail Extras*, *Content Concentrator*,
*Find Messages* und *BossWatch* — hier sind alle da (siehe
[oben](#was-eudora-kann-und-wo-man-es-findet)). Zusatzmodule können eigene
Seiten anhängen (`settings.cpp:427-455`).

**Wie eine Einstellung in die `Eudora.ini` kommt.** Jedes Steuerelement,
dessen Kennung eine `IDS_INI_…`-Nummer ist, liest und schreibt genau den
Schlüssel dieser Nummer (`settings.cpp:801-806` und `:1771-1777`). Daraus
folgen drei Regeln für die Tabellen:

* **Häkchen** schreiben `1` (gesetzt) oder `0`. Bei *umgekehrt* gilt das
  Gegenteil: das Häkchen zeigt `0` als gesetzt (Bit `0x8000` der Kennung,
  `settings.cpp:2084-2088`).
* **Auswahlknöpfe** einer Gruppe haben **je Knopf einen eigenen Schlüssel**;
  der gewählte steht auf `1`, die anderen auf `0`.
* Der **Abschnitt** der `Eudora.ini`, in dem der Schlüssel steht, ist in
  der Spalte *Abschnitt* genannt (aus der Kennung gelesen, `GetSectionID`
  in `rs.cpp`). Auf den Optionsseiten ist das `[Settings]`. Steht dort
  „`[Settings]` bzw. `[Persona-<Name>]`“, kann jedes **zusätzliche** Konto
  den Schlüssel eigens haben: er steht dann im Abschnitt dieses Kontos und
  wird über dessen Kontoeinstellungen (*Tools → Personalities*, Rechtsklick
  → *Properties*) gesetzt, nicht über *Tools → Options* — die Optionsseiten
  schreiben in `[Settings]`, also für das Hauptkonto. Welche Schlüssel das
  sind und woher die Liste stammt:
  [Abschnitt 6](#was-ein-zusätzliches-konto-eigens-haben-kann).
  Ein Eintrag im falschen Abschnitt wirkt nicht, ohne Meldung.

**Vorgabe** ist der eingebaute Wert aus `EudoraRes.rc`. Wo die `DEudora.ini`
des Pakets für **neu angelegte** Mailverzeichnisse etwas anderes vorgibt,
steht es dahinter; warum, steht in
[EINSTELLUNGEN.md, *Was hier anders eingestellt ist*](../Intern/EINSTELLUNGEN.md#abweichungen).
Ein leeres Feld heißt: keine Vorgabe.

### Getting Started

Die wichtigsten Kontoangaben auf einer Seite; dieselben Schlüssel stehen
auch auf *Checking Mail* und *Sending Mail*.

| Einstellung | Schlüssel | Abschnitt | Vorgabe | Bedeutung | Herkunft |
|---|---|---|---|---|---|
| *Real name* | `RealName` | `[Settings]` bzw. `[Persona-<Name>]` | | Ihr Name im Absender | Vorlage |
| *Email address* | `ReturnAddress` | `[Settings]` bzw. `[Persona-<Name>]` | | Ihre Absenderadresse | Vorlage |
| *Mail Server (Incoming)* | `PopServer` | `[Settings]` bzw. `[Persona-<Name>]` | | Server für den Abruf | Vorlage |
| *User Name* | `LoginName` | `[Settings]` bzw. `[Persona-<Name>]` | | Anmeldename beim Abruf | Vorlage |
| *SMTP Server (Outgoing)* | `SMTPServer` | `[Settings]` bzw. `[Persona-<Name>]` | | Server für den Versand | Vorlage |
| *Allow authentication* | `SmtpAuthAllowed` | `[Settings]` bzw. `[Persona-<Name>]` | `1` | Anmeldung beim Versandserver erlauben | Vorlage |

### Checking Mail

| Einstellung | Schlüssel | Abschnitt | Vorgabe | Bedeutung | Herkunft |
|---|---|---|---|---|---|
| *Mail Server* | `PopServer` | `[Settings]` bzw. `[Persona-<Name>]` | | Server für den Abruf | Vorlage |
| *User Name* | `LoginName` | `[Settings]` bzw. `[Persona-<Name>]` | | Anmeldename | Vorlage |
| *Check for mail every … minute(s)* | `CheckForMailEvery` | `[Settings]` | `0` | Abstand des automatischen Abrufs; `0` = kein automatischer Abruf (`eudora.cpp:2607-2621`) | Vorlage |
| *Don't check without a network connection* | `DontCheckUnconnected` | `[Settings]` | `0` | automatischen Abruf auslassen, solange keine Netzverbindung besteht | Vorlage |
| *Don't check when using battery* | `DonotCheckWithBattery` | `[Settings]` | `0` | automatischen Abruf im Akkubetrieb auslassen | Vorlage |
| *Send on check* | `SendOnCheck` | `[Settings]` | `1` | beim Abruf die wartende Post mit verschicken | Vorlage |
| *Secure Sockets when Receiving* | `SSLReceiveUse` | `[Settings]` bzw. `[Persona-<Name>]` | `1` (neu: `2`) | Verschlüsselung beim Abruf: `0` nie, `1` falls verfügbar, `2` erforderlich auf eigenem Port (995), `3` erforderlich über STARTTLS ([FAQ 2](FAQ.md#2-welche-verschlüsselung-und-welchen-port-nehme-ich)) | **bestätigt** ([FAQ 2](FAQ.md#2-welche-verschlüsselung-und-welchen-port-nehme-ich), 06.09.2026: Port 995, TLSv1.3) |
| Knopf *Last SSL Info* | — | | | zeigt, wie die letzte Abrufverbindung verschlüsselt war ([FAQ 3](FAQ.md#3-wie-sehe-ich-ob-die-verbindung-wirklich-verschlüsselt-ist)) | **bestätigt** ([FAQ 3](FAQ.md#3-wie-sehe-ich-ob-die-verbindung-wirklich-verschlüsselt-ist), 06.09.2026) |

### Incoming Mail

Die Seite zeigt je nach Wahl von *POP* oder *IMAP* andere Felder.

| Einstellung | Schlüssel | Abschnitt | Vorgabe | Bedeutung | Herkunft |
|---|---|---|---|---|---|
| *Server configuration:* *POP* / *IMAP* | `UsesPOP` / `UsesIMAP` | `[Settings]` bzw. `[Persona-<Name>]` | `1` / `0` | Abrufverfahren des Kontos | Vorlage |
| *Leave mail on server* (POP) | `LeaveMailOnServer` | `[Settings]` bzw. `[Persona-<Name>]` | `0` (neu: `1`) | abgeholte Post auf dem Server lassen | Vorlage |
| *Delete from server after … day(s)* (POP) | `DeleteMailFromServer`, Tage `LeaveOnServerDays` | `[Settings]` bzw. `[Persona-<Name>]` | `0`, `0` | auf dem Server gelassene Post nach so vielen Tagen löschen | Vorlage |
| *Delete from server when emptied from Trash* (POP) | `ServerDelete` | `[Settings]` bzw. `[Persona-<Name>]` | `0` | beim Leeren des Papierkorbs auch auf dem Server löschen | Vorlage |
| *Skip messages over … K in size* (POP) | `SkipBigMessages`, Grenze `BigMessageThreshold` | `[Settings]` bzw. `[Persona-<Name>]` | `0`, `40960` | große Nachrichten nur anlesen | Vorlage |
| *IMAP Mailbox Location Prefix* (IMAP) | `ImapDirectoryPrefix` | `[Settings]` bzw. `[Persona-<Name>]` | | Wurzel der Ordner auf dem IMAP-Server | Vorlage |
| *For new mail, download:* *Minimal headers only* / *Full message except attachments over … K* (IMAP) | `IMAPMinDownload` / `IMAPOmitAttachments`, Grenze `IMAPMaxDownloadSize` | `[Settings]` bzw. `[Persona-<Name>]` | `1` / `0`, `0` | wie viel einer neuen IMAP-Nachricht sofort geholt wird | Vorlage |
| *When I delete a message:* *Mark it as deleted* / *Move it to:* (IMAP) | `MarkAsDeleted` / `TransferToTrashOnDelete`, Ziel `TrashMailboxName` | `[Settings]` bzw. `[Persona-<Name>]` | `1` / `0`, `Trash` | Löschen nur markieren (dann [FAQ 5](FAQ.md#5-im-imap-posteingang-fehlen-mails-die-der-webmailer-zeigt)) oder in einen Papierkorbordner verschieben | Vorlage |
| *Offline* | `Offline` | `[Settings]` | `0` | ohne Verbindung arbeiten; kein automatischer Abruf | Vorlage |
| *Authentication style:* *Passwords* / *Kerberos* / *APOP* / *RPA* | `AuthenticatePassword` / `AuthenticateKerberos` / `AuthenticateAPOP` / `AuthenticateRPA` | `[Settings]` bzw. `[Persona-<Name>]` | `1` / `0` / `0` / `0` | Anmeldeverfahren beim Abruf | Vorlage |

### Sending Mail

| Einstellung | Schlüssel | Abschnitt | Vorgabe | Bedeutung | Herkunft |
|---|---|---|---|---|---|
| *Email address* | `ReturnAddress` | `[Settings]` bzw. `[Persona-<Name>]` | | Absenderadresse | Vorlage |
| *Domain to add to unqualified addresses* | `DomainQualifier` | `[Settings]` bzw. `[Persona-<Name>]` | | wird an Adressen ohne `@…` angehängt | Vorlage |
| *SMTP server* | `SMTPServer` | `[Settings]` bzw. `[Persona-<Name>]` | | Versandserver | Vorlage |
| *SMTP Relay Personality* | `RelayPersona` | `[Settings]` | | über welches Konto verschickt wird | Vorlage |
| *Allow authentication* | `SmtpAuthAllowed` | `[Settings]` bzw. `[Persona-<Name>]` | `1` | Anmeldung beim Versandserver erlauben | Vorlage |
| *Immediate send* | `ImmediateSend` | `[Settings]` | `1` | *Send* verschickt sofort statt nur nach *Out* zu stellen | Vorlage |
| *Send on check* | `SendOnCheck` | `[Settings]` | `1` | wie auf *Checking Mail* | Vorlage |
| *Use submission port (587)* | `UseSubmissionPort` | `[Settings]` bzw. `[Persona-<Name>]` | `0` | Port 587 statt 25 | Vorlage |
| *Secure Sockets when Sending* | `SSLSendUse` | `[Settings]` bzw. `[Persona-<Name>]` | `1` (neu: `2`) | Verschlüsselung beim Versand, Werte wie beim Abruf; `2` = eigener Port 465 ([FAQ 2](FAQ.md#2-welche-verschlüsselung-und-welchen-port-nehme-ich)) | Vorlage |
| Knopf *Last SSL Info* | — | | | zeigt die Verschlüsselung der letzten Versandverbindung | Vorlage |

### Composing Mail

| Einstellung | Schlüssel | Abschnitt | Vorgabe | Bedeutung | Herkunft |
|---|---|---|---|---|---|
| *Default Stationery* | `Stationery` | `[Settings]` bzw. `[Persona-<Name>]` | | Briefpapier für neue Nachrichten | Vorlage |
| *Signature* | `Signature` | `[Settings]` bzw. `[Persona-<Name>]` | | Standardsignatur | Vorlage |
| *Word wrap* | `WordWrap` | `[Settings]` | `1` | Zeilen beim Schreiben umbrechen | Vorlage |
| *Keep copies* | `KeepCopies` | `[Settings]` | `1` | verschickte Nachrichten in *Out* behalten | Vorlage |
| *May use quoted-printable* | `UseQP` | `[Settings]` | `1` | Kodierung *quoted-printable* erlauben | Vorlage |
| *Tabs in body of message* | `TabsInBody` | `[Settings]` | `1` | Tabulatoren im Text erlauben | Vorlage |
| *Show signature while composing* | `InlineSignature` | `[Settings]` | `1` | Signatur schon im Verfassen-Fenster zeigen | Vorlage |

### Internet Dialup

| Einstellung | Schlüssel | Abschnitt | Vorgabe | Bedeutung | Herkunft |
|---|---|---|---|---|---|
| *Have Eudora connect using Dial-up networking* | `AutoConnection` | `[Settings]` | `0` | Wählverbindung selbst aufbauen | Vorlage |
| *Entry* | `AutoConnectionName` | `[Settings]` | | welche Wählverbindung; Knöpfe *Edit…* und *New…* | Vorlage |
| *Hang-up after receiving and sending* | `RasCloseAfterDone` | `[Settings]` | `1` | nach Abruf und Versand auflegen | Vorlage |
| *Close connection on Exit* | `RasCloseOnExit` | `[Settings]` | `1` | beim Beenden auflegen | Vorlage |
| *Only do automatic mail checks when a network connection is already established* | `DontCheckUnconnected` | `[Settings]` | `0` | derselbe Schlüssel wie auf *Checking Mail* | Vorlage |

### Replying

| Einstellung | Schlüssel | Abschnitt | Vorgabe | Bedeutung | Herkunft |
|---|---|---|---|---|---|
| *Map Ctrl+R to “Reply to All”* | `ReplyToAll` | `[Settings]` | `0` | Strg+R antwortet allen statt nur dem Absender | Vorlage |
| *Copy original's priority to reply* | `CopyPriority` | `[Settings]` | `0` | Antwort übernimmt die Dringlichkeit | Vorlage |
| *Automatically Fcc to original mailbox* | `AutoFCC` | `[Settings]` | `0` | Kopie der Antwort in das Postfach des Originals | Vorlage |
| *Include signature on reply* | `IncludeSigReply` | `[Settings]` | `1` | Signatur auch in Antworten | Vorlage |
| *Quote only the selected text on Reply or Forward* | `ReplySelection` | `[Settings]` | `1` | nur den markierten Text zitieren | Vorlage |
| *Generate multiple messages on Reply to multiple messages* | `MultipleRepliesForMultipleSelection` | `[Settings]` | `0` | eine Antwort je markierter Nachricht statt einer gemeinsamen | Vorlage |
| *Include yourself* | `IncludeSelf` | `[Settings]` | `0` | bei *Reply to All* sich selbst nicht herausnehmen | Vorlage |
| *Put original To: recipients in Cc: field* | `ReplyTo:ToCc:` | `[Settings]` | `0` | bei *Reply to All* die ursprünglichen `To:`-Empfänger nach `Cc:` | Vorlage |

### Attachments

| Einstellung | Schlüssel | Abschnitt | Vorgabe | Bedeutung | Herkunft |
|---|---|---|---|---|---|
| *Encoding method:* *MIME* / *BinHex* / *Uuencode* | `SendMIME` / `SendBinHex` / `SendUuencode` | `[Settings]` | `1` / `0` / `0` | wie Anhänge verpackt werden | Vorlage |
| *Attachment directory* | `AutoReceiveAttachmentsDirectory` | `[Settings]` | | Verzeichnis für empfangene Anhänge (leer: `attach` im Mailverzeichnis, siehe [FAQ 1](FAQ.md#1-wie-nehme-ich-bei-einer-neuen-fassung-post-konten-und-filter-mit)) | Vorlage |
| *Put text attachments in body of message* | `TextAsDoc`, **umgekehrt** | `[Settings]` | `1` (Häkchen aus) | Textanhänge in den Nachrichtentext übernehmen statt als Datei | Vorlage |
| *Receive MIME digest as a mailbox attachment* | `ExplodeMimeDigest` | `[Settings]` | `0` | eine MIME-Sammelnachricht als Postfach-Anhang ablegen | Vorlage |
| *Delete attachments when emptying Trash* | `TidyAttach` | `[Settings]` | `0` | beim Leeren des Papierkorbs die Anhang-Dateien mit löschen ([FAQ 14](FAQ.md#14-werden-anhänge-gelöscht-wenn-ich-die-mail-lösche)) | **bestätigt** mit `1` ([FAQ 14](FAQ.md#14-werden-anhänge-gelöscht-wenn-ich-die-mail-lösche), 29.10.2026) |
| *Delete automatic attachments:* *Never* / *After sending message* / *When message emptied from Trash* | `AutoAttachedDeleteNever` / `AutoAttachedDeleteSend` / `AutoAttachedDeleteTrash` | `[Settings]` | `0` / `0` / `1` | wann Dateien gelöscht werden, die Eudora selbst angehängt hat | Vorlage |

### Fonts

| Einstellung | Schlüssel | Abschnitt | Vorgabe | Bedeutung | Herkunft |
|---|---|---|---|---|---|
| *Proportional* | `MessageFont` | `[Settings]` | `Arial` | Schrift der Nachrichten | Vorlage |
| *Fixed-width* | `MessageFixedFont` | `[Settings]` | `Courier New` | Schrift mit fester Breite | Vorlage |
| *Use proportional font by default* | `UseProportionalAsDefault` | `[Settings]` | `1` | Proportionalschrift als Standard | Vorlage |
| *Size* (Nachrichten) | `MessageFontBaseSize` | `[Settings]` | `1` | Größenstufe, Liste von *smallest* bis *largest* | Vorlage |
| Drucker: *Font*, *Size* | `PrinterFont`, `PrinterFontBaseSize` | `[Settings]` | `Arial`, `2` | Schrift beim Drucken | Vorlage |
| Bildschirm: *Font*, *Size* | `ScreenFont`, `ScreenFontBaseSize` | `[Settings]` | `Arial`, `1` | Schrift der Listen und Felder | Vorlage |

### Display

| Einstellung | Schlüssel | Abschnitt | Vorgabe | Bedeutung | Herkunft |
|---|---|---|---|---|---|
| *Show toolbar* | `ShowToolBar` | `[Settings]` | `1` | Werkzeugleiste zeigen | Vorlage |
| *Show toolbar tips* | `ShowToolTips` | `[Settings]` | `1` | Hinweise über den Knöpfen | Vorlage |
| *Show cool bars* | `ShowCoolBars` | `[Settings]` | `1` | flache Leisten | Vorlage |
| *Show large buttons* | `ShowLargeButtons` | `[Settings]` | `1` | große Knöpfe | Vorlage |
| *Show status bar* | `ShowStatusBar` | `[Settings]` | `1` | Statuszeile zeigen | Vorlage |
| *Show category icons* | `ShowCategoryIcons` | `[Settings]` | `1` | Symbole in der Kategorienliste dieses Dialogs | Vorlage |
| *Show MDI task bar* | `ShowMDITaskbar` | `[Settings]` | `1` | Registerleiste der offenen Fenster ([E-48](../Intern/BEFUNDE.md#e-48), *war abgeschaltet, seit 7.2.0.25 da*) | Vorlage |
| *Automatically download HTML graphics* | `FetchInlineContent` | `[Settings]` | `1` | Bilder aus dem Netz in HTML-Mails nachladen | Vorlage |
| *Display attached images inline* | `DisplayImageAttachmentsInMessages` | `[Settings]` | `1` | Bildanhänge im Text zeigen | Vorlage |
| *Display emoticons as pictures* | `DisplayEmoticonsAsPictures` | `[Settings]` | `1` | Emoticons als Bild | Vorlage |
| *Minimize Eudora to the system tray* | `ShowOnlyInTray` | `[Settings]` | `0` | beim Verkleinern nur als Symbol in der Taskleiste | Vorlage |
| *Always show icon in system tray* | `AlwaysShowTrayIcon` | `[Settings]` | `0` | Symbol in der Taskleiste immer zeigen | Vorlage |

### Viewing Mail

| Einstellung | Schlüssel | Abschnitt | Vorgabe | Bedeutung | Herkunft |
|---|---|---|---|---|---|
| *Use Microsoft's viewer* | `UseBidentAlways` | `[Settings]` | `1` | HTML mit der Windows-Komponente anzeigen | Vorlage |
| *Use separate settings from Internet Explorer* | `SeparateMSHTMLSettings` | `[Settings]` | `0` | eigene Einstellungen statt der des Internet Explorer | Vorlage |
| *Message window width* / *height* | `MessageWidth` / `MessageLines` | `[Settings]` | `80` / `20` | Anfangsgröße des Nachrichtenfensters in Zeichen und Zeilen | Vorlage |
| *Show message preview pane* | `MailboxPreviewPane` | `[Settings]` | `1` | Vorschau unter der Postfachliste | Vorlage |
| *Mark previewed messages as read after … second(s)* | `SetPreviewRead`, `SetPreviewReadSeconds` | `[Settings]` | `0`, `5` | in der Vorschau gezeigte Nachricht nach so vielen Sekunden als gelesen markieren | Vorlage |
| *Automatically open next message* | `EasyOpen` | `[Settings]` | `1` | nach Löschen oder Verschieben die nächste öffnen | Vorlage |
| *Zoom windows when opening* | `ZoomWindows` | `[Settings]` | `1` | Fenster beim Öffnen vergrößern | Vorlage |
| *Allow executables in HTML content* | `RunHtmlCode` | `[Settings]` | `0` | ausführbaren Inhalt im HTML zulassen | Vorlage |

### Mailboxes

| Einstellung | Schlüssel | Abschnitt | Vorgabe | Bedeutung | Herkunft |
|---|---|---|---|---|---|
| Spalten *Status*, *Junk*, *Priority*, *Attachment*, *Label*, *Who*, *Date*, *Size*, *Server status*, *Mood Watch*, *Subject* | `MailboxShowStatus`, `MailboxShowJunk`, `MailboxShowPriority`, `MailboxShowAttachment`, `MailboxShowLabel`, `MailboxShowSender`, `MailboxShowDate`, `MailboxShowSize`, `MailboxShowServerStatus`, `MailboxShowMood`, `MailboxShowSubject` | `[Settings]` | alle `1`, nur *Junk* `0` | welche Spalten die Postfachliste zeigt | Vorlage |
| *Show mailbox lines* | `ShowMailboxLines` | `[Settings]` | `0` | Trennlinien zwischen den Zeilen | Vorlage |
| *Show count of selected messages in size box* | `ShowSelectedSummaryCount` | `[Settings]` | `0` | Zahl der markierten Nachrichten unten links | Vorlage |
| *Close messages with mailbox* | `MailboxSuperclose` | `[Settings]` | `0` | offene Nachrichten mit dem Postfach schließen | Vorlage |
| *Select newly inserted messages (FUMLUB)* | `Fumlub` | `[Settings]` | `1` | neu eingefügte Nachrichten markieren | Vorlage |
| *… items in the Recent mailbox menus* | `MaxRecentMailbox` | `[Settings]` | `10` | Länge von *Recent* in *Mailbox* und *Transfer*; `0` blendet es aus | Vorlage |
| *Allow drag and drop transfers* | `AllowDragAndDropTransfers` | `[Settings]` | `1` | Nachrichten durch Ziehen verschieben | Vorlage |
| *Allow drag-select of messages* | `DragSelectMessages` | `[Settings]` | `0` | durch Ziehen mehrere markieren | Vorlage |

### Styled Text

| Einstellung | Schlüssel | Abschnitt | Vorgabe | Bedeutung | Herkunft |
|---|---|---|---|---|---|
| *Show formatting toolbar* | `ShowStyledTextToolbar` | `[Settings]` | `1` | Formatleiste im Verfassen-Fenster | Vorlage |
| *Send both plain and styled* / *Send styled text only* / *Send plain text only* | `SendPlainAndStyled` / `SendStyledOnly` / `SendPlainOnly` | `[Settings]` | `1` / `0` / `0` | was beim Versand einer formatierten Nachricht hinausgeht | Vorlage |
| *Ask me each time* | `WarnQueueStyledText` | `[Settings]` | `1` | vor dem Versand fragen | Vorlage |
| *Send the signature with styles* | `SendStyledSig` | `[Settings]` | `0` | Signatur formatiert verschicken | Vorlage |

### Spell Checking

**Die Rechtschreibprüfung fehlt in diesem Paket** — Eudora meldet es; die
Meldung lässt sich seit 7.2.1.129 abschalten ([E-139](../Intern/BEFUNDE.md#e-139),
**bestätigt** am 31.10.2026). Die Einstellungen sind deshalb ohne Wirkung zu
erwarten (am Programm nicht geprüft).

| Einstellung | Schlüssel | Abschnitt | Vorgabe | Bedeutung | Herkunft |
|---|---|---|---|---|---|
| *Ignore capitalized words* / *with all capitals* / *with numbers* / *with mixed case* | `IgnoreCappedWords` / `IgnoreAllCaps` / `IgnoreMixedDigits` / `IgnoreMixedCase` | `[Settings]` | `0` / `0` / `1` / `0` | welche Wörter übergangen werden | Vorlage |
| *Report doubled words* | `ReportDoubledWords` | `[Settings]` | `1` | doppelte Wörter melden | Vorlage |
| *Suggest words*, *Phonetic words*, *Split words*, *Typographic words* | `AlwaysSuggest`, `SuggestPhoneticSpellings`, `SuggestSplitWords`, `SuggestTypographicWords` | `[Settings]` | `1`, `0`, `1`, `1` | welche Vorschläge kommen | Vorlage |
| *Automatically as you type* / *Only when requested* | — / `ManualSpellCheck` | `[Settings]` | — / `0` | beim Tippen oder nur auf Anforderung prüfen | Vorlage |
| *Ignore original text* | `IgnoreOriginalSpell` | `[Settings]` | `1` | Zitiertes nicht prüfen | Vorlage |
| *Warn me when sending/queuing message with misspellings* | `SpellOnQueue` | `[Settings]` | `0` | vor dem Versand warnen | Vorlage |

### Auto-completion

| Einstellung | Schlüssel | Abschnitt | Vorgabe | Bedeutung | Herkunft |
|---|---|---|---|---|---|
| Quellen *History File*, *Address Book*, *Plug-in Addresses* | `DoHistoryCompletion`, `DoABCompletion`, `DoPluginCompletion` | `[Settings]` | `1`, `1`, `1` | woraus Adressen beim Tippen ergänzt werden | Vorlage |
| *Don't auto-complete, just list matches* | `AutoCompListOnly` | `[Settings]` | `0` | nur Treffer zeigen, nicht einsetzen | Vorlage |
| *Use drop down list for completion choices* | `PopupNameCompleter` | `[Settings]` | `1` | Auswahlbox unter dem Feld ([FAQ 8](FAQ.md#8-wie-lege-ich-einen-kurznamen-an-und-nutze-ihn-beim-schreiben)) | Vorlage |
| *Names should appear in alphabetical order* | `ACListInAlphaOrder` | `[Settings]` | `0` | Treffer alphabetisch | Vorlage |
| *Add the From: lines of replied-to messages* | `AddFromLinesToHistory` | `[Settings]` | `1` | Absender beantworteter Nachrichten in die Liste | Vorlage |
| *Time to wait before popping up Auto-completion box (Milliseconds)* | `AutoCompListboxDelay` | `[Settings]` | `500` | Wartezeit bis zur Auswahlbox | Vorlage |
| *Maximum entries to keep in history* | `MaximumHistorySize` | `[Settings]` | `100` | Länge der Liste | Vorlage |

### Date Display

| Einstellung | Schlüssel | Abschnitt | Vorgabe | Bedeutung | Herkunft |
|---|---|---|---|---|---|
| *Local timezone* / *Sender's timezone* | `LocalTimeDisplay` / `SenderTimeDisplay` | `[Settings]` | `1` / `0` | Zeit in Ihrer oder in der Zeitzone des Absenders | Vorlage |
| *Fixed:* / *Age-sensitive:* | `FixedDateDisplay` / `AgeSensitiveDateDisplay` | `[Settings]` | `1` / `0` | ein festes Format oder eines nach Alter der Nachricht | Vorlage |
| Format zu *Fixed* | `FixedDateFormat` | `[Settings]` | `%1 %2 %4` | Platzhalter: `%1` Uhrzeit, `%2` Datum, `%3` Wochentag, `%4` Zeitzone (`QCUtils/src/services.cpp:172-175`); die Vorgabe zeigt also Uhrzeit, Datum, Zeitzone | Vorlage |
| *RECENT format*, *Hours to be OLD*, *OLD format*, *Hours to be ANCIENT*, *ANCIENT format* | `RecentDateFormat`, `OldDateHours`, `OldDateFormat`, `AncientDateHours`, `AncientDateFormat` | `[Settings]` | `%1`, `24`, `%3`, `168`, `%2` | Formate und Altersgrenzen für *Age-sensitive* | Vorlage |

### Labels

| Einstellung | Schlüssel | Abschnitt | Vorgabe | Bedeutung | Herkunft |
|---|---|---|---|---|---|
| Farbfeld *1* … *7* | `LabelColor1` … `LabelColor7` | `[Settings]` | Windows-Farbwerte (`33023`, `255`, `16711935`, `16744448`, `16711680`, `32768`, `4210816`) | Farbe des Labels; Klick öffnet die Farbwahl | **bestätigt** ([FAQ 9](FAQ.md#9-wie-markiere-ich-wichtige-mails-farbig), 29.10.2026) |
| Name daneben | `LabelText1` … `LabelText7` | `[Settings]` | `Label 1` … `Label 7` | Name im Menü *Change → Label* und in der Spalte *Label* | **bestätigt** ([FAQ 9](FAQ.md#9-wie-markiere-ich-wichtige-mails-farbig), 29.10.2026) |

### Getting Attention

| Einstellung | Schlüssel | Abschnitt | Vorgabe | Bedeutung | Herkunft |
|---|---|---|---|---|---|
| *Use an alert dialog box* | `Alert` | `[Settings]` | `1` | bei neuer Post ein Hinweisfenster | Vorlage |
| *Open mailbox* | `OpenInMailbox` | `[Settings]` | `1` | bei neuer Post das Postfach öffnen | Vorlage |
| *Play a sound* | `Sound` | `[Settings]` | `1` | bei neuer Post ein Klang | Vorlage |
| Klangdatei, Knopf *Use Default* | `NewMailSound` | `[Settings]` | | welche Klangdatei | Vorlage |
| *Generate filter report* | `FilterReport` | `[Settings]` | `0` | Filterbericht schreiben ([FILTER.md](../Intern/FILTER.md#der-filterbericht)) | Vorlage |

### Background Tasks

| Einstellung | Schlüssel | Abschnitt | Vorgabe | Bedeutung | Herkunft |
|---|---|---|---|---|---|
| Spalten *Task*, *Persona*, *Status*, *Details*, *Progress* | `TaskStatusShowColTask`, `…Persona`, `…Status`, `…Details`, `…Progress` (alle mit `TaskStatusShowCol` davor) | `[Settings]` | `1`, `1`, `1`, `0`, `1` | Spalten im Fenster *Task Status* | Vorlage |
| *Wait for … seconds of user inactivity before processing/filtering downloaded messages* | `TaskMgrWaitTime` | `[Settings]` | `20` | so viele Sekunden ohne Eingabe abwarten, bevor abgeholte Post verarbeitet und gefiltert wird | Vorlage |
| *Bring error window to front* | `TaskErrorBringToFront` | `[Settings]` | `1` | Fehlerfenster nach vorn holen | Vorlage |
| *Bring task status window to front* | `TaskStatusBringToFront` | `[Settings]` | `0` | Fenster *Task Status* nach vorn holen | Vorlage |

### Automation

| Einstellung | Schlüssel | Abschnitt | Vorgabe | Bedeutung | Herkunft |
|---|---|---|---|---|---|
| *Automation enabled from this machine* | `AutomationEnabled` | `[Settings]` | `0` | andere Programme dürfen Eudora fernsteuern | Vorlage |
| *Warn on Automation auto-send of messages* | `WarnComAutoSend` | `[Settings]` | `1` | warnen, wenn ein fernsteuerndes Programm Post verschickt | Vorlage |

### Extra Warnings

Je Häkchen eine Rückfrage vor der genannten Handlung.

| Einstellung | Schlüssel | Abschnitt | Vorgabe | Herkunft |
|---|---|---|---|---|
| *Delete unread mail* | `WarnDeleteUnread` | `[Settings]` | `1` | Vorlage |
| *Delete queued mail* | `WarnDeleteQueued` | `[Settings]` | `1` | Vorlage |
| *Delete unsent mail* | `WarnDeleteUnsent` | `[Settings]` | `1` | Vorlage |
| *Delete … or more messages at a time* | `WarnDeleteManyMessages`, Zahl `WarnDeleteManyMessagesThreshold` | `[Settings]` | `1`, `50` | Vorlage |
| *Delete a message from the Search results* | `WarnDeleteSearchResult` | `[Settings]` | `1` | Vorlage |
| *Queue a message with no subject* | `WarnQueueNoSubject` | `[Settings]` | `0` | Vorlage |
| *Queue a message bigger than … K* | `WarnQueueBigMessage`, Größe `WarnQueueBigMessageSize` | `[Settings]` | `1`, `500` | Vorlage |
| *Quit with messages queued to be sent* | `WarnQuitWithQueued` | `[Settings]` | `1` | Vorlage |
| *Empty the Trash mailbox* | `WarnEmptyTrash` | `[Settings]` | `1` | Vorlage |
| *Start Eudora and it's not the default mailer* | `WarnDefaultMailto` | `[Settings]` | `1` | Vorlage |
| *Launch a program from a message* | `WarnLaunchProgram` | `[Settings]` | `1` | Vorlage |
| *Launch a program externally* | `WarnExternalLaunchAttach` | `[Settings]` | `1` | Vorlage |
| *Forward files that are not in the attachment directory* | `ForwardingFilesNotInAttachDirAction` | `[Settings]` | `1` | Vorlage |
| *Enter an invalid server when creating a new personality* | `WarnValidateHost` | `[Settings]` | `1` | Vorlage |

### MAPI

| Einstellung | Schlüssel | Abschnitt | Vorgabe | Bedeutung | Herkunft |
|---|---|---|---|---|---|
| *Never* / *When Eudora is running* / *Always* | `MAPIUseNever` / `MAPIUseEudora` / `MAPIUseAlways` | `[Settings]` | `1` / `0` / `0` | ob andere Programme über MAPI („Senden an E-Mail-Empfänger“) Eudora benutzen | Vorlage |
| *Never* / *After sending message* / *When message emptied from Trash* | `MAPIDeleteNever` / `MAPIDeleteSend` / `MAPIDeleteTrash` | `[Settings]` | `0` / `0` / `1` | wann über MAPI angehängte Dateien gelöscht werden | Vorlage |
| *Send single MAPI file attachment as inline attachment (TXT and HTML files only)* | `InlineMapiTextAttachment` | `[Settings]` | `1` | einzelnen Text- oder HTML-Anhang in den Text übernehmen | Vorlage |
| *Warn on MAPI auto-send of messages* | `WarnMapiAutoSend` | `[Settings]` | `1` | warnen, wenn ein Programm über MAPI selbst verschickt | Vorlage |

### Advanced Network

| Einstellung | Schlüssel | Abschnitt | Vorgabe | Bedeutung | Herkunft |
|---|---|---|---|---|---|
| *Network open timeout* | `NetworkOpenTimeout` | `[Settings]` | `300` | Wartezeit beim Verbindungsaufbau in Sekunden | Vorlage |
| *Network timeout after* | `NetworkTimeout` | `[Settings]` | `300` | Wartezeit auf eine Antwort in Sekunden | Vorlage |
| *Network buffer size of* | `NetworkBufferSize` | `[Settings]` | `4096` | Puffergröße in Byte | Vorlage |
| *Cache network info* | `NetworkCaching` | `[Settings]` | `0` | Netzangaben zwischenspeichern | Vorlage |
| *Unload Winsock DLL after closing socket* | `NetImmediateClose` | `[Settings]` | `0` | Netzbibliothek nach jeder Verbindung entladen | Vorlage |

### Kerberos

| Einstellung | Schlüssel | Abschnitt | Vorgabe | Bedeutung | Herkunft |
|---|---|---|---|---|---|
| Kerberos *On* / *Off* | `KerberosOn` / `KerberosOff` | `[Settings]` | `0` / `1` | Kerberos-Anmeldung | Vorlage |
| Kerberos 4 *On* / *Off* | `Kerberos4On` / `Kerberos4Off` | `[Settings]` | `0` / `1` | Kerberos 4 | Vorlage |
| *Kerberos POP3 port*, *Realm*, *Service name*, *Service format* | `KerberosPort`, `KerberosRealm`, `KerberosService`, `KerberosFormat` | `[Settings]` | leer, leer, `rcmd`, `%1.%4@%3` | Angaben für den Kerberos-Server | Vorlage |

### MoodWatch

Bewertet den Ton einer Nachricht. Ob die Bewertung in diesem Paket arbeitet,
ist **unklar** (nicht untersucht).

| Einstellung | Schlüssel | Abschnitt | Vorgabe | Bedeutung | Herkunft |
|---|---|---|---|---|---|
| *Enable MoodWatch* | `DoMoodWatchCheck` | `[Settings]` | `1` | MoodWatch einschalten | Vorlage |
| Warnen, wenn: *Message seems it might be offensive* / *is probably offensive* / *is on fire* / *Never* | `MoodWatchWarnWhenMightBeOffensive` / `MoodWatchWarnWhenProbablyOffensive` / `MoodWatchWarnFire` / `Never` | `[Settings]` | `0` / `1` / `0` / `0` | ab welcher Stufe gewarnt wird. Der Schlüssel des letzten Knopfs heißt in der Ressourcendatei wirklich nur `Never` (`IDS_INI_MOOD_MAIL_NEVER`) | Vorlage |
| Zurückhalten, wenn: dieselben vier Stufen | `MoodWatchDelayWhenMightBeOffensive` / `MoodWatchDelayWhenProbablyOffensive` / `MoodWatchDelayFire` / `MoodWatchDelayNever` | `[Settings]` | `0` / `0` / `0` / `1` | ab welcher Stufe der Versand verzögert wird | Vorlage |
| *Scan new mail as it arrives* | `MoodWatchIncomingCheck` | `[Settings]` | `1` | eingehende Post bewerten | Vorlage |
| *Scan stored mail in the background* | `MoodCheckBackground` | `[Settings]` | `1` | vorhandene Post im Hintergrund bewerten | Vorlage |

### Statistics

| Einstellung | Schlüssel | Abschnitt | Vorgabe | Bedeutung | Herkunft |
|---|---|---|---|---|---|
| Farbe und Art der Kurven *1*, *2*, *3* | `CurrentGraphColor`/`CurrentGraphType`, `PreviousGraphColor`/`PreviousGraphType`, `AverageGraphColor`/`AverageGraphType` | `[Settings]` | `255`/`1`, `32768`/`0`, `16711680`/`0` | Darstellung im Fenster *Statistics* (aktueller Zeitraum, voriger, Durchschnitt — nach den Schlüsselnamen) | Vorlage |
| *Count IMAP messages in Inbox only* | `ImapStatisticsForInboxOnly` | `[Settings]` | `1` | bei IMAP nur den Posteingang zählen | Vorlage |
| Knopf *Reset Statistics* | — | | | Statistik löschen | Vorlage |

### Miscellaneous

| Einstellung | Schlüssel | Abschnitt | Vorgabe | Bedeutung | Herkunft |
|---|---|---|---|---|---|
| *Switch messages with:* *Unmodified arrow keys* / *Ctrl+arrow keys* / *Alt+arrow keys* | `PlainArrows` / `CtrlArrows` / `AltArrows` | `[Settings]` | `0` / `0` / `1` | mit welchen Pfeiltasten man zur nächsten oder vorigen Nachricht wechselt | Vorlage |
| *Empty Trash when exiting* | `EmptyTrashOnQuit` | `[Settings]` | `0` | Papierkorb beim Beenden leeren | Vorlage |
| *Say OK to alerts after … seconds* | `AutoOK`, `AutoOKTimeout` | `[Settings]` | `1`, `120` | Hinweisfenster nach so vielen Sekunden selbst schließen (`guiutils.cpp:181`) | Vorlage |
| *Turbo redirect by default* | `TurboRedirect` | `[Settings]` | `0` | *Redirect* verschickt ohne Verfassen-Fenster (`summary.cpp:1495`; Wirkung nach Eudora 7.1, hier nicht nachgesehen) | Vorlage |
| *Include outdated 'Return-Receipt-To'* | `ReturnReceiptFlag` | `[Settings]` | `0` | die veraltete Kopfzeile für Empfangsbestätigungen mitschicken | Vorlage |
| *Automatically expand nicknames* | `AutoExpandNicknames` | `[Settings]` | `0` | Kurznamen beim Tippen auflösen | Vorlage |
| *Auto-save messages every … minute(s)* | `AutoSaveMessagesEvery` | `[Settings]` | `10` | offene Nachrichten in diesem Abstand sichern | Vorlage |
| *Hide address books from simple viruses* | `HideABookFromVirus` | `[Settings]` | `0` | Adressbücher vor einfachen Schadprogrammen verstecken | Vorlage |

### Junk Mail

Die Junk-Bewertung arbeitet hier nur, wenn `MFC71.DLL` und `MSVCP71.dll`
schon auf dem Rechner liegen; sonst bleibt jede Punktzahl 0
([FAQ 13](FAQ.md#13-warum-landet-nichts-automatisch-in-junk--und-was-ich-dabei-nicht-tun-sollte)).
Alle Schlüssel mit Bedeutung: [FILTER.md, *Junk*](../Intern/FILTER.md#junk).

| Einstellung | Schlüssel | Abschnitt | Vorgabe | Bedeutung | Herkunft |
|---|---|---|---|---|---|
| *Consider mail junk if score is at least* (Schieberegler) | `MinScoreToJunk` | `[Settings]` | `50` | Schwelle | Vorlage |
| *Mail isn't junk if sender is in an address book* | `AddressBookIsWhitelist` | `[Settings]` | `0` | Absender im Adressbuch nie Junk | Vorlage |
| *Put Not Junk-ed senders in address book* | `NonJunkToAddressBook` | `[Settings]` | `1` | *Not Junk* nimmt den Absender ins Adressbuch | Vorlage |
| *Automatically place junk in Junk mailbox* | `UseJunkMailbox` | `[Settings]` | `0` | Junk nach *Junk* verschieben (beim ersten Mal fragt Eudora, [E-166](../Intern/BEFUNDE.md#e-166)) | Vorlage |
| *Junk mailbox is never marked unread* | `JunkNeverUnread` | `[Settings]` | `0` | *Junk* nie als ungelesen markieren | Vorlage |
| *Ignore date on junk* | `IgnoreJunkDate` | `[Settings]` | `1` | Datum von Junk nicht beachten | Vorlage |
| *Remove mail that is at least … days old* | `AgeJunkOff`, `AgeJunkOffDays` | `[Settings]` | `1`, `30` | alten Junk entfernen | Vorlage |
| *Warn before removing* | `WarnBeforeAging` | `[Settings]` | `1` | vorher fragen | Vorlage |

### Junk Mail Extras

| Einstellung | Schlüssel | Abschnitt | Vorgabe | Bedeutung | Herkunft |
|---|---|---|---|---|---|
| *Only remove junk whose score is at least* | `MinAgeOffScore` | `[Settings]` | `0` | nur Junk ab dieser Punktzahl entfernen | Vorlage |
| *Junking a message assigns it a score of* | `ManualJunkScore` | `[Settings]` | `100` | Punktzahl bei *Junk* von Hand | Vorlage |
| *Trim old junk to mailbox* | `JunkTrimMbox` | `[Settings]` | `Trash` | wohin alter Junk kommt | Vorlage |
| *Add 'Not Junk'ed senders to Address Book* | `NonJunkAddressBook` | `[Settings]` | | welches Adressbuch | Vorlage |
| *Delete fetched junk from server* | `DeleteFetchedJunk` | `[Settings]` | `1` (neu: `0`) | als Junk Eingestuftes auf dem Server löschen ([E-74](../Intern/BEFUNDE.md#e-74), *hatte Gregors Serverpostfach geleert*) | Vorlage |
| *Use Ctrl-J for Junk* | `CtrlJMapping` | `[Settings]` | `0` | Häkchen gesetzt schreibt `1` (Strg+J = *Junk*), sonst `2` (Strg+J = *Filter Messages*) (`settings.cpp:921-926`; [FAQ 12](FAQ.md#12-filter-messages-strgj-tut-nichts)) | Vorlage |

### Content Concentrator

Kürzt angezeigte Nachrichten nach einem Profil.

| Einstellung | Schlüssel | Abschnitt | Vorgabe | Bedeutung | Herkunft |
|---|---|---|---|---|---|
| *Preview Pane* | `ConConPreviewProfile` | `[Settings]` | `Compact` | Profil für die Vorschau | Vorlage |
| *Message Window* | `ConConMessageWindowProfile` | `[Settings]` | `None` | Profil für das Nachrichtenfenster | Vorlage |
| *Profile* (mehrere Nachrichten) | `ConConMultipleMessagesProfile` | `[Settings]` | `Terse` | Profil, wenn mehrere markiert sind | Vorlage |
| *Maximum # to Concentrate* | `ConConMultipleMessageMaxNum` | `[Settings]` | `20` | höchstens so viele zusammenfassen | Vorlage |
| *Require matching subjects or senders* | `ConConMultipleMessagesRequireRelated` | `[Settings]` | `1` | nur zusammengehörige | Vorlage |
| *Generate multiple messages on Reply* | `MultipleRepliesForMultipleSelection` | `[Settings]` | `0` | derselbe Schlüssel wie auf *Replying* | Vorlage |

### BossWatch

Warnt vor dem Versand an bestimmte Adressen (Liste über das Rechtsklickmenü
im Adressbuch, *Add to BossWatch List*).

| Einstellung | Schlüssel | Abschnitt | Vorgabe | Bedeutung | Herkunft |
|---|---|---|---|---|---|
| *Warn me additionally with a dialog* | `BPAdditionalWarnDialog` | `[Settings]` | `0` | zusätzlich ein Hinweisfenster | Vorlage |
| *When sending to more than …* / *When I do a Reply All* | `BPWarnDialogRecipients`, Zahl `BPWarnDialogNumRecipients` / `BPWarnDialogReplyAll` | `[Settings]` | `0`, `0` / `0` | wann das Fenster kommt | Vorlage |
| *Speak addresses* | `BPSpeakHarmfulAddresses` | `[Settings]` | `0` | Adressen vorlesen | Vorlage |
| Stimme | `Select Voice` | `[Settings]` | | welche Stimme (der Schlüssel heißt so, mit Leerzeichen, `IDS_INI_BP_SPEAK`) | Vorlage |
| Vorlesen *When sending to more than …* / *When I do a Reply All* | `BPSpeakHarmfulAddressesRecipients`, `BPSpeakHarmfulAddressesNumberRecipients` / `BPSpeakHarmfulAddressesReplyAll` | `[Settings]` | `0`, `0` / `0` | wann vorgelesen wird | Vorlage |
| *Outside domain* / *Inside domain*, je mit Liste | `BPWarnOutsideDomains`, `BPOutsideDomains` / `BPWarnInsideDomains`, `BPInsideDomains` | `[Settings]` | `0`, leer / `0`, leer | Warnung bei Versand außerhalb bzw. innerhalb dieser Domains | Vorlage |
| *Color code BossWatch addresses using this color* | `BPSetColorCodeAddresses`, Farbe `BPColorCode` | `[Settings]` | `1`, `255,0,255` | BossWatch-Adressen farbig zeigen | Vorlage |

### Find Messages

| Einstellung | Schlüssel | Abschnitt | Vorgabe | Bedeutung | Herkunft |
|---|---|---|---|---|---|
| *Use fast (indexed) search* | `UseIndexedSearch` | `[Settings]` | `1` | Suche über einen Index | Vorlage |
| Knöpfe *Index Email Now*, *Re-Index Email…* | — | | | Index jetzt aufbauen bzw. neu aufbauen | Vorlage |
| *Show index update progress in Task Status Window* … *updates are pending* | `ShowIndexUpdateProgress`, `IndexUpdateMinimumToShowProgress` | `[Settings]` | `1`, `100` | Fortschritt zeigen, wenn so viele Aktualisierungen anstehen | Vorlage |
| *Include deleted IMAP messages in search results* | `FindDeletedIMAPMessages` | `[Settings]` | `1` | als gelöscht markierte IMAP-Nachrichten mitfinden | Vorlage |

---

## 4. Filter: Zeitpunkte, Bedingungen, Aktionen

Ausführlich — mit Fundstellen, Reihenfolge, Filterbericht und Speicherort —
steht alles in [FILTER.md](../Intern/FILTER.md); hier nur die Übersicht.
Filter legt man unter *Tools → Filters* an oder mit *Special → Make Filter*
aus einer Nachricht ([FAQ 10](FAQ.md#10-wie-baue-ich-schnell-einen-filter-aus-einer-mail));
gespeichert wird beim Verlassen des Fensters nach Rückfrage
([FAQ 11](FAQ.md#11-wie-speichere-ich-einen-filter)).

**Wann ein Filter läuft** — drei Häkchen je Regel
([FILTER.md](../Intern/FILTER.md#wann-ein-filter-läuft)):

| Häkchen | läuft | Herkunft |
|---|---|---|
| *Incoming* | nach dem Abholen über die neue Post | **bestätigt** (Filter auf `From:` beim Abholen, [FAQ 9](FAQ.md#9-wie-markiere-ich-wichtige-mails-farbig), 29.10.2026) |
| *Outgoing* | beim Senden | Vorlage |
| *Manual* | bei *Special → Filter Messages*; ohne dieses Häkchen tut der Lauf von Hand nichts ([FAQ 12](FAQ.md#12-filter-messages-strgj-tut-nichts)) | Vorlage |

**Bedingungen** — zwei je Regel, verknüpft mit *ignore*, *and*, *or* oder
*unless* ([FILTER.md](../Intern/FILTER.md#bedingungen)):

| Teil | Auswahl | Herkunft |
|---|---|---|
| *Header* | `To:`, `From:`, `Subject:`, `Cc:`, `Reply-To:`, «Any Header», «Body», «Any Recipient», «Personality», «Junk Score» — oder jede andere eingetippte Kopfzeile | **bestätigt** für `From:` ([FAQ 9](FAQ.md#9-wie-markiere-ich-wichtige-mails-farbig)); den Eintrag «Personality» hat Gregor gesehen, den Lauf damit nicht ([FAQ 6](FAQ.md#6-wie-trenne-ich-die-post-verschiedener-konten)) |
| Vergleich | *contains*, *doesn't contain*, *is*, *is not*, *starts with*, *ends with*, *appears*, *doesn't appear*, *intersects nickname*, *doesn't intersect nickname*, *intersects address book*, *doesn't intersect address book*, *matches regexp (case insensitive)*, *matches regexp*; nur für «Junk Score»: *is less than*, *is greater than* | **bestätigt** für *contains* ([FAQ 9](FAQ.md#9-wie-markiere-ich-wichtige-mails-farbig)). Verneinte Vergleiche trafen bis 7.2.1.128 jede Nachricht ([README, *Bekannte Fehler*](../README.md#bekannte-fehler), erste Zeile); «Junk Score» *is less than* trifft hier jede Nachricht, solange die Junk-Bewertung nicht arbeitet ([FAQ 13](FAQ.md#13-warum-landet-nichts-automatisch-in-junk--und-was-ich-dabei-nicht-tun-sollte)) |

**Aktionen** — fünf Plätze je Regel, abgearbeitet von oben nach unten
([FILTER.md](../Intern/FILTER.md#aktionen); Menü `IDR_FILTER_MENUS`,
`EudoraRes.rc:6081`):

| Aktion | was sie tut | Herkunft |
|---|---|---|
| *None* | nichts | Vorlage |
| *Make Status* | setzt den Zustand (gelesen, ungelesen, …) | Vorlage |
| *Make Priority* | setzt, hebt (*Raise*) oder senkt (*Lower*) die Dringlichkeit | Vorlage |
| *Make Label* | vergibt ein Label. Einmal standen die Labels ausgegraut da ([E-173](../Intern/BEFUNDE.md#e-173), *Filter löschen und neu anlegen hilft*) | **bestätigt** ([FAQ 9](FAQ.md#9-wie-markiere-ich-wichtige-mails-farbig), 29.10.2026, Label 6) |
| *Make Personality* | ordnet die Nachricht einem Konto zu | Vorlage |
| *Make Subject* | ersetzt den Betreff; `&` steht für den alten | Vorlage |
| *Play Sound* | spielt eine Klangdatei | Vorlage |
| *Speak* | liest Absender und/oder Betreff vor | Vorlage |
| *Open* | öffnet das Postfach oder die Nachricht | Vorlage |
| *Print* | druckt die Nachricht | Vorlage |
| *Notify User* | meldet die Nachricht wie unter [*Getting Attention*](#getting-attention) oder nur im Filterbericht | Vorlage |
| *Notify Application* | übergibt die Nachricht an ein Programm ([E-177](../Intern/BEFUNDE.md#e-177), *Zeichensatzangabe der Zwischendatei, berichtigt in 7.2.1.131*) | Vorlage |
| *Forward To* / *Redirect To* | leitet weiter bzw. um | Vorlage |
| *Reply with* | antwortet mit einem Briefpapier | Vorlage |
| *Server Options* | merkt *Fetch* oder *Delete* auf dem Server vor. **Löschen auf dem Server ist hier gesperrt**, bis `FilterMayDeleteFromServer=1` gesetzt ist ([FILTER.md](../Intern/FILTER.md#die-aktion-server-options), [E-73](../Intern/BEFUNDE.md#e-73), *Filter leerte ein Serverpostfach*) | Vorlage |
| *Copy To* | legt eine Kopie in ein Postfach | Vorlage |
| *Transfer To* | verschiebt in ein Postfach; *Out* ist als Ziel grau ([E-143](../Intern/BEFUNDE.md#e-143)) | **bestätigt** ([FAQ 9](FAQ.md#9-wie-markiere-ich-wichtige-mails-farbig) 29.10.2026; *Out* grau: [TESTPLAN](../Intern/TESTPLAN.md#e-143-naechstes), 02.11.2026) |
| *Junk* | behandelt die Nachricht wie von Hand gejunkt, verschiebt nach *Junk* | Vorlage |
| *Skip Rest* | keine weiteren Filter für diese Nachricht | **bestätigt** ([FAQ 9](FAQ.md#9-wie-markiere-ich-wichtige-mails-farbig), 29.10.2026) |

---

## 5. `Eudora.ini`-Schlüssel ohne Optionsseite

Die Ressourcendatei kennt **842** `IDS_INI_…`-Schlüssel (gezählt mit
`perl tools/funktionen-auslesen.pl --zaehlen`); 284 davon stehen auf einer
Optionsseite. Aufgenommen ist hier nur, was **mindestens eine** dieser
Bedingungen erfüllt:

* eine Frage aus der [FAQ](FAQ.md) oder ein Befund nennt den Schlüssel als
  Abhilfe oder Ursache;
* diese Portierung hat ihn neu eingeführt oder seine Vorgabe geändert;
* er verändert, was der Anwender sieht, und ist sonst nirgends einstellbar.

Nicht aufgenommen: Fensterpositionen, Spaltenbreiten, Zähler und die vielen
Schlüssel, die Eudora selbst schreibt. Wer einen bestimmten Schlüssel sucht:
`perl tools/funktionen-auslesen.pl --ini <Name>`.

**Bevor man etwas einträgt:** Eudora beenden — beim Beenden schreibt es die
Datei zurück. Der **Abschnitt** ergibt sich aus der Nummer, nicht aus dem
Namen, und ein Eintrag im falschen Abschnitt wirkt nicht, ohne Meldung
([EINSTELLUNGEN.md, Regel 1.1](../Intern/EINSTELLUNGEN.md#1-fünf-regeln-die-für-jeden-schlüssel-gelten)).
`perl tools/pruefe-ini-abschnitte.pl --was <Name>` sagt ihn an.

| Schlüssel | Abschnitt | Vorgabe | Bedeutung | Herkunft |
|---|---|---|---|---|
| `LogLevel` | `[Debug]` | `25759` (neu: `58527`) | wie viel in `eudora.log` landet — eine **Summe von Schaltern**; `58527` schreibt zusätzlich die Spurmarken dieser Portierung. Der Schalter `32` schreibt das Kennwort mit ([FAQ 17](FAQ.md#17-wie-schreibt-eudora-mehr-ins-protokoll-loglevel), Tabelle in [ANWENDER.md](ANWENDER.md#mehr-ins-protokoll-schreiben-lassen)) | **bestätigt** nur für das Spurmarken-Bit `32768`: Gregors Protokolle tragen die Spurmarken, etwa `E-139 Rechtschreibhinweis` ([E-139](../Intern/BEFUNDE.md#e-139), 31.10.2026); der Wert `58527` selbst und die übrigen Schalter: Vorlage |
| `LogFileName` | `[Debug]` | `eudora.log` | Name der Protokolldatei | Vorlage |
| `LogFileSize` | `[Debug]` | `10000` | ab welcher Größe das Protokoll umgebrochen wird | Vorlage |
| `ShowAllHeaders` | `[Settings]` | `0` | ob eine Nachricht mit allen Kopfzeilen aufgeht (Anfangszustand von *Blah Blah Blah*, [FAQ 16](FAQ.md#16-wie-blende-ich-alle-kopfzeilen-ein-und-wieder-aus)) | Vorlage |
| `TabooHeaders` | `[Settings]` | Liste mit 44 Einträgen | welche Kopfzeilen *Blah Blah Blah* versteckt. **Ein eigener Eintrag ersetzt die ganze Liste** ([FAQ 16](FAQ.md#16-wie-blende-ich-alle-kopfzeilen-ein-und-wieder-aus), [E-80](../Intern/BEFUNDE.md#e-80)) | Vorlage (die eingebaute Liste: **bestätigt**, [E-80](../Intern/BEFUNDE.md#e-80), 11.09.2026) |
| `WholeSummaryLabelColor` | `[Settings]` | `1` | `1`: die ganze Zeile der Postfachliste in Label-Farbe; `0`: nur die Spalte *Label* ([FAQ 9](FAQ.md#9-wie-markiere-ich-wichtige-mails-farbig)) | **bestätigt** für `1` ([FAQ 9](FAQ.md#9-wie-markiere-ich-wichtige-mails-farbig), 29.10.2026: Zeile grün) |
| `FilterIncomingMail` | `[Settings]` | `1` | mit `0` laufen beim Abholen gar keine Filter ([FILTER.md](../Intern/FILTER.md#wann-ein-filter-läuft)) | Vorlage |
| `FilterMayDeleteFromServer` | `[Settings]` | `0` (keine Ressourcennummer, fest im Code `filtersd.cpp:1155`) | **gibt es nur hier**: erst mit `1` darf die Filteraktion *Server Options → Delete* auf dem Server löschen ([E-73](../Intern/BEFUNDE.md#e-73)) | Vorlage |
| `KeepHTMLInResponses` | `[Settings]` | `1` | **gibt es nur hier**: Antworten und Weiterleiten behalten die HTML-Auszeichnung ([E-87](../Intern/BEFUNDE.md#e-87)) | **bestätigt** ([TESTPLAN, *Weiterleiten behält die HTML-Formatierung*](../Intern/TESTPLAN.md#e-87-am-release), 29.10.2026 an 1.0.127) |
| `ForwardOriginalHTML` | `[Settings]` | `1` | **gibt es nur hier**: beim Weiterleiten geht das Original-HTML hinaus, wenn das Zitat unverändert ist ([E-88](../Intern/BEFUNDE.md#e-88), [E-93](../Intern/BEFUNDE.md#e-93)) | **bestätigt** ([E-93](../Intern/BEFUNDE.md#e-93), 13.10.2026) |
| `WarnSpellUnavailable` | `[Settings]` | `1` | **gibt es nur hier**: mit `0` (Kästchen in der Meldung) kommt der Hinweis auf die fehlende Rechtschreibprüfung nicht mehr | **bestätigt** ([E-139](../Intern/BEFUNDE.md#e-139), 31.10.2026) |
| `MaxConcurrentTasks` | `[Settings]` | `10` | wie viele Hintergrundaufgaben gleichzeitig laufen; `0` = ohne Grenze ([EINSTELLUNGEN.md](../Intern/EINSTELLUNGEN.md#3-schalter-ohne-menüpunkt)) | Vorlage |
| `MessageStyleSheet` | `[Settings]` | eingebautes Stylesheet | Aussehen der Nachrichtenansicht; eine `read.css` neben `Eudora.exe` ersetzt es ganz ([EINSTELLUNGEN.md](../Intern/EINSTELLUNGEN.md#3-schalter-ohne-menüpunkt), [E-81](../Intern/BEFUNDE.md#e-81), *Kopfzeilen schwarz auf schwarz*) | Vorlage |
| `RemoveChangePassword` | `[Settings]` | `1` | blendet *Special → Change Password…* aus; mit `0` erscheint der Eintrag (`mainfrm.cpp:8372-8373`) | Vorlage |
| `DisableStatistics` | `[Settings]` | `0` | mit `1` ist *Tools → Statistics* grau (`mainfrm.cpp:10508-10510`) | Vorlage |
| `AccountDir` | `[Settings]` bzw. `[Persona-<Name>]` | | Unterverzeichnis eines IMAP-Kontos im Mailverzeichnis; fehlt das Verzeichnis, tut IMAP nichts ([EINSTELLUNGEN.md, 2.2](../Intern/EINSTELLUNGEN.md#2-beim-einrichten-und-beim-umsteigen-auf-eine-neue-fassung)) | Vorlage |
| `Mode` | `[Settings]` | `-1` | Betriebsart; `1` wäre *Light* (keine Werbung, dafür weniger Funktionen, siehe oben). **Nicht nachgemessen** — nicht ohne Not ändern ([AN-2](../Intern/BEFUNDE.md#an-2), *Werbeabruf beim Start*) | Vorlage |
| `UseMyFilterWindowPosition` | `[Window Position]` | `0` (neu: `1`) | die Breite der linken Spalte im Filterfenster überlebt den Neustart nur mit `1` | Vorlage |
| `FloatCx<id>`, `FloatCy<id>` | `[ToolBar-ToolBarManager]` | kein Eintrag | **gibt es nur hier**: Größe eines losgerissenen Fensters über den Neustart ([E-84](../Intern/BEFUNDE.md#e-84)) | Vorlage |

Die Abweichungen dieser Portierung vom Original stehen vollständig an einer
Stelle: [EINSTELLUNGEN.md, *Was hier anders eingestellt ist als im Original*](../Intern/EINSTELLUNGEN.md#abweichungen).
Die rund 40 Filter- und Junk-Schlüssel: [FILTER.md, *Die Einstellungen in der `Eudora.ini`*](../Intern/FILTER.md#die-einstellungen-in-der-eudoraini).

---

## 6. Die Abschnitte der `Eudora.ini`

Die `Eudora.ini` im Mailverzeichnis ist in Abschnitte geteilt, jeder beginnt
mit einer Zeile in eckigen Klammern. **Nicht alles steht in `[Settings]`.**

### In welcher Reihenfolge Eudora sucht

Für jeden Schlüssel mit einer `IDS_INI_…`-Nummer fragt Eudora nacheinander
(`rs.cpp:449-464`) und nimmt den ersten Treffer:

1. den Abschnitt der **gerade aktiven Persönlichkeit** — beim Hauptkonto
   (`<Dominant>`) ist das `[Settings]`, sonst `[Persona-<Name>]`
   (`persona.cpp:876-911`);
2. den Abschnitt, der zur **Nummer** des Schlüssels gehört, in der
   `Eudora.ini` (siehe Tabelle unten);
3. denselben Abschnitt in der **`DEudora.ini`** neben `Eudora.exe`;
4. den eingebauten Wert aus `EudoraRes.rc` (`rs.cpp:461-464`).

Daraus folgt: ein Schlüssel, der in `[Debug]` gehört, aber in `[Settings]`
steht, wird über Stufe 1 gefunden und **scheint zu wirken, solange nur das
Hauptkonto aktiv ist** — bis ein zweites Konto die Arbeit übernimmt
([EINSTELLUNGEN.md, Regel 1.3](../Intern/EINSTELLUNGEN.md#1-fünf-regeln-die-für-jeden-schlüssel-gelten)).
Ein Eintrag im falschen Abschnitt wirkt nicht, und Eudora meldet nichts.
Wohin ein Schlüssel gehört, sagt `perl tools/pruefe-ini-abschnitte.pl --was <Name>`.

**Geschrieben** wird so: *Tools → Options* schreibt in den Abschnitt, der zur
Nummer gehört (`FlushINIFile`, `rs.cpp:1257`) — außer `SavePassword` und
`SavePasswordText`, die in den Abschnitt der aktiven Persönlichkeit gehen
(`rs.cpp:1238-1252`). Die Kontoeinstellungen eines Kontos schreiben in
dessen Abschnitt, beim Hauptkonto in `[Settings]` (`SavePersonaInfo`,
`persona.cpp:931-940`).

### Die Abschnitte

| Abschnitt | was darin steht | Fundstelle | Herkunft |
|---|---|---|---|
| `[Settings]` | fast alle Schlüssel: die Nummern bis 10800 und ab 11101 — und zugleich die Kontoeinstellungen des **Hauptkontos** | `GetSectionID`, `rs.cpp:89-97`; Hauptkonto `persona.cpp:876-911` | Vorlage |
| `[Debug]` | die Nummern 10801 bis 10900, etwa `LogLevel`, `LogFileName`, `LogFileSize` ([FAQ 17](FAQ.md#17-wie-schreibt-eudora-mehr-ins-protokoll-loglevel)) | `rs.cpp:95-96` | Vorlage |
| `[Window Position]` | die Nummern 10901 bis 11100: Fensterpositionen und -größen, dazu `UseMyFilterWindowPosition` | `rs.cpp:93-94` | Vorlage |
| `[Personalities]` | die Liste der **zusätzlichen** Konten, je Zeile `Persona0=Persona-<Name>`, `Persona1=…` | `persona.cpp:79-90` (Abschnittsname `IDS_PERSONALITIES`, `EudoraRes.rc:8007`) | Vorlage |
| `[Persona-<Name>]` | je zusätzliches Konto ein Abschnitt; `<Name>` wie unter *Tools → Personalities*. Das Hauptkonto hat keinen, es benutzt `[Settings]` | `persona.cpp:52` (`"Persona-"`, mit Bindestrich), `:876-911` | Vorlage |
| `[Mappings]` | Zuordnung Dateiendung ↔ Dateityp für Anhänge; gelesen aus der `Eudora.ini`, sonst aus der `DEudora.ini`. Das Paket bringt 124 Zeilen mit ([EINSTELLUNGEN.md, 2.3](../Intern/EINSTELLUNGEN.md#2-beim-einrichten-und-beim-umsteigen-auf-eine-neue-fassung)) | `MIMEMap.cpp:253-268` | Vorlage |
| `[ToolBar-ToolBarManager]` | Zustand der Werkzeugleisten; dazu in dieser Portierung `FloatCx<id>`, `FloatCy<id>` für losgerissene Fenster ([E-84](../Intern/BEFUNDE.md#e-84)) | `mainfrm.cpp:1054` (`SaveBarState("ToolBar")`), `OTShim_Werkzeugleiste.cpp:4336` (`"%s-ToolBarManager"`) | Vorlage |
| weitere `[ToolBar-…]` | Lage der angedockten Leisten; diese Abschnitte legt die MFC-Bibliothek selbst an, ihre Namen stehen nicht im Quelltext dieses Projekts | `mainfrm.cpp:1054` | Vorlage |
| `[Configurations]`, `[Switches]`, `[Miscellaneous]` | Abschnitte **alter** Eudora-Fassungen; findet Eudora sie beim Start, übernimmt es ihren Inhalt nach `[Settings]` | `ConvertIni`, `rs.cpp:1271`, aufgerufen `:1420-1427` | Vorlage |

Die Verzeichnisdienste (LDAP, Ph) lesen ihre Einstellungen aus einer eigenen
Datei neben ihrem Modul, nicht aus der `Eudora.ini`
(`DirectoryServices/LDAP/src/config_init.cpp:239`,
`DirectoryServices/Ph/src/configinit.cpp:82`). Ob Zusatzmodule eigene
Abschnitte in die `Eudora.ini` schreiben, ist **nicht untersucht**.

### Was ein zusätzliches Konto eigens haben kann

Grundsätzlich wird **jeder** Schlüssel zuerst im Abschnitt der aktiven
Persönlichkeit gesucht (Stufe 1 oben). **Eigens gesetzt** werden aber nur
diese — die Liste ist aus dem Quelltext gelesen, nicht vermutet:

**Aus den Kontoeinstellungen** (*Tools → Personalities*, Rechtsklick →
*Properties*), 40 Schlüssel, geschrieben von `SavePersonaInfo`
(`persona.cpp:931-1078`), gelesen von `GetParams` (`persona.cpp:278-490`):

| Gruppe | Schlüssel |
|---|---|
| Konto und Absender | `POPAccount`, `RealName`, `ReturnAddress`, `DomainQualifier`, `Signature`, `Stationery`, `CheckMailByDefault` |
| Abruf | `PopServer`, `LoginName`, `UsesPOP`, `UsesIMAP`, `UseWinSock`, `AuthenticatePassword`, `AuthenticateKerberos`, `AuthenticateAPOP`, `AuthenticateRPA`, `SSLReceiveUse`, `SavePasswordText` |
| POP: was auf dem Server bleibt | `LeaveMailOnServer`, `DeleteMailFromServer`, `LeaveOnServerDays`, `ServerDelete`, `SkipBigMessages`, `BigMessageThreshold` |
| IMAP | `ImapDirectoryPrefix`, `IMAPMinDownload`, `IMAPOmitAttachments`, `IMAPMaxDownloadSize`, `MarkAsDeleted`, `TransferToTrashOnDelete`, `TrashMailboxName`, `IMAPAutoPurgeNever`, `IMAPAutoPurgeAlways`, `IMAPAutoPurgeOnPct`, `IMAPAutoPurgePercent` |
| Versand | `SMTPServer`, `SmtpAuthAllowed`, `UseRelay`, `UseSubmissionPort`, `SSLSendUse` |

**Von Eudora selbst je Konto geschrieben oder gelesen**, ohne Feld im Dialog:

| Schlüssel | wozu | Fundstelle |
|---|---|---|
| `SavePassword` | ob das Kennwort gespeichert wird | `rs.cpp:1238-1252` |
| `AccountDir` | Unterverzeichnis des IMAP-Kontos im Mailverzeichnis | `QCImapMailboxDirector.cpp:205`, `:225-227` |
| `ImapUIDPLUSFound` | ob der IMAP-Server UIDPLUS kann (beim Verbinden ermittelt) | `ImapAccount.cpp:801-818` |
| `ImapScoreJunk` | Junk-Bewertung für dieses IMAP-Konto | `ImapAccount.cpp:858-872` |
| `ImapIgnoreUIDPLUS`, `ImapIgnoreNAMESPACE` | nur gelesen: Fähigkeiten des Servers übergehen | `ImapAccount.cpp:202-218` |

Zusammen **46 Schlüssel**. Bei diesen steht in den Tabellen von
[Abschnitt 3](#3-tools--options) und [Abschnitt 5](#5-eudoraini-schlüssel-ohne-optionsseite)
„`[Settings]` bzw. `[Persona-<Name>]`“, sofern sie dort vorkommen.

**Unklar** (nicht untersucht): ob *Tools → Options* andere Werte zeigt,
während gerade ein zusätzliches Konto aktiv ist — die Seiten lesen über
dieselbe Suche (Stufe 1), schreiben aber in `[Settings]`.

---

## Zum Bestätigen durch Gregor

Was oben nur *Vorlage* ist und am meisten nützt, wenn es einmal am Programm
gesehen ist — zuerst das täglich Gebrauchte und das in der FAQ Gefragte.
Jeweils: Klickweg, was zu sehen sein soll.

| # | Klickweg | richtig ist | warum zuerst |
|---|---|---|---|
| 1 | *Special → Filter Messages* (Strg+J) mit einem Filter, bei dem **nur** *Manual* angehakt ist, über eine markierte Nachricht | der Filter wirkt; ohne *Manual* wirkt er nicht | [FAQ 12](FAQ.md#12-filter-messages-strgj-tut-nichts) beruht nur auf dem Quelltext |
| 2 | *Tools → Options → Sending Mail* → *Secure Sockets when Sending* auf *Required, Alternate Port*, eine Nachricht senden, dann *Last SSL Info* | `TLSv1.3` oder `TLSv1.2` | [FAQ 2](FAQ.md#2-welche-verschlüsselung-und-welchen-port-nehme-ich) und [3](FAQ.md#3-wie-sehe-ich-ob-die-verbindung-wirklich-verschlüsselt-ist): bisher nur die Abrufseite am Programm gesehen |
| 3 | *File → Check Mail* (Strg+M) und *File → Send Queued Messages* (Strg+T) | Post wird geholt bzw. *Out* geleert | täglicher Weg, nirgends als geprüft vermerkt |
| 4 | Nachricht markieren, *Special → Make Address Book Entry…* (Strg+K) | Dialog mit den Adressen der Nachricht; der Kurzname steht danach im Adressbuch | [FAQ 8](FAQ.md#8-wie-lege-ich-einen-kurznamen-an-und-nutze-ihn-beim-schreiben) verweist darauf |
| 5 | Rechtsklick auf ein IMAP-Postfach in der Ordnerliste → *Show Deleted Messages*, dann *Message → Purge Messages* | gelöschte Mails erscheinen wieder in der Liste; nach *Purge* sind sie weg, auch im Webmailer | [FAQ 5](FAQ.md#5-im-imap-posteingang-fehlen-mails-die-der-webmailer-zeigt): bestätigt ist dort nur *UnDelete* |
| 6 | *Edit → Find → Find Messages* (Strg+F), Kriterium *Headers* *contains* `x-persona` | Treffer aus Mails zusätzlicher Konten | [FAQ 16](FAQ.md#16-wie-blende-ich-alle-kopfzeilen-ein-und-wieder-aus): dieser Teil nur am Quelltext |
| 7 | *Message → Reply*, *Reply to All*, *Redirect*; Strg+R | Verfassen-Fenster mit den erwarteten Empfängern | täglicher Weg; bestätigt ist nur *Forward* |
| 8 | *Special → Empty Trash* mit `TidyAttach=0` (Häkchen unter *Attachments* aus) | die Anhang-Dateien der gelöschten Mail bleiben im Anhangverzeichnis | [FAQ 14](FAQ.md#14-werden-anhänge-gelöscht-wenn-ich-die-mail-lösche): bestätigt ist nur der Fall `1` |
| 9 | *Tools → Options → Junk Mail Extras*, *Use Ctrl-J for Junk* an- und wieder abhaken, jeweils *OK*, und die Menüs *Message* und *Special* ansehen | Häkchen an: *Message → Junk* zeigt Strg+J, *Special → Filter Messages* zeigt Strg+Umschalt+L. Häkchen aus: *Special → Filter Messages* zeigt Strg+J, *Junk* kein Kürzel (`mainfrm.cpp:8506-8516`) | [FAQ 12](FAQ.md#12-filter-messages-strgj-tut-nichts), [FAQ 19](FAQ.md#19-welche-einstellungen-sind-anders-als-im-original-eudora--und-warum) |
| 10 | `WholeSummaryLabelColor=0` in die `Eudora.ini` (`[Settings]`, Eudora vorher beenden), neu starten | nur die Spalte *Label* ist farbig | [FAQ 9](FAQ.md#9-wie-markiere-ich-wichtige-mails-farbig) nennt es als Wahl |
| 11 | Menü *Special* ansehen | *Change Password…* fehlt (ab Werk ausgeblendet) | prüft eine Aussage dieser Datei, die sonst niemand trifft |
| 12 | *Tools → Personalities*, Rechtsklick auf ein Konto → *Properties* | dieselben Felder für Verschlüsselung wie unter *Checking Mail* | [FAQ 2](FAQ.md#2-welche-verschlüsselung-und-welchen-port-nehme-ich) und [7](FAQ.md#7-wie-lege-ich-ein-zweites-konto-an) verweisen darauf |
| 13 | Im Verfassen-Fenster auf einer **deutschen** Tastatur Strg+Ä und Strg+Umschalt+Punkt | Strg+Ä fügt die Zwischenablage als Zitat ein, Strg+Umschalt+Punkt hebt die Zitatebene | die Tasten sind nur aus den Tastencodes abgeleitet ([Abschnitt 2](#sonderzeichen-und-einzeltasten)) |

Wer einen Eintrag bestätigt, ändert in der Tabelle oben *Vorlage* in
**bestätigt** mit Datum und Verweis — und streicht die Zeile hier.
