# Weitermachen

> **Der allererste Schritt, verabredet am 31.08.2026 kurz vor dem Abschalten:**
> das ausgetauschte Release auf dem zweiten PC (Win11) probieren.
> Alles Weitere haengt daran. Siehe [AUFGABEN.md](AUFGABEN.md), Abschnitt
> *Ganz zuerst*. Gregors Worte: *„schreib dir das auf, das machen wir
> naechstes mal.“*
>
> Das ZIP auf GitHub hat seit dem Austausch SHA256 `d4719047…`. Die Fassung,
> die Gregor am 31.08. probiert hat (`632c4066…`), war die **alte** ohne die
> E-11-Behebung — deshalb stuerzte sie beim Klick auf *Weiter* ab.

# Hier weitermachen

> ## Stand 31.08.2026, 09:00
>
> **Die Arbeitsliste steht in [AUFGABEN.md](AUFGABEN.md)** â was zu tun ist,
> in welcher Reihenfolge, mit Fundstelle je Punkt und den Auflagen fÃ¼r
> Agenten. Diese Datei hier erklÃ¤rt den Weg dorthin.
>
> **Eudora ruft Mail ab.** 159 Nachrichten von `mx.freenet.de`, TLS 1.3,
> `TLS_AES_256_GCM_SHA384` (Befunde E-1 und E-3). MenÃ¼s, Anordnung und
> Werkzeugleiste stimmen. Von den vier Kriterien in [ZIEL.md](ZIEL.md) sind
> **zwei erfÃ¼llt**, eines fast, eines nicht nachgewiesen.
>
> **Der wichtigste offene Punkt** ist behoben, aber ungeprÃ¼ft: auf einer
> frischen Installation stÃ¼rzte Eudora ab, sobald man *Weiter* im
> Kontoassistenten klickte. Ursache war nicht der Assistent, sondern
> `ReleaseBuffer` ohne `GetBuffer` in `eudora.cpp:3372` â eine VC6-Altlast,
> die bei MFC 14 den referenzgezÃ¤hlten `CStringT` zerstÃ¶rt. Gefunden Ã¼ber
> Gregors `eudora.log`, behoben mit `Truncate`. **Befund E-11.**
>
> Auf der VM fiel das nie auf, weil der Zweig nur bei einer
> **jungfrÃ¤ulichen** Installation betreten wird.

Ãbergabe vom **31.08.2026, vormittags**. Arbeitsstand ist der Branch
`darstellung-und-menue`; auf `main` fehlt alles von diesen zwei Tagen.

**Bekannte LÃ¼cke:** der Agent FREIGABE (Release-Bau) lief noch, als diese Datei
geschrieben wurde. Sein Ergebnis steht hier nicht. Wer weitermacht, sieht
zuerst seinen Branch und seinen Abschnitt in `BEFUNDE.md` an.

Diese Datei ist der Einstieg fÃ¼r die nÃ¤chste Sitzung. Alle Zahlen sind an
`371c1e3` gemessen. An diesem Baum arbeiten mehrere Agenten in eigenen
Worktrees; wer eine Zahl weiterverwendet, misst nach und nennt seinen eigenen
Bezugscommit.

---

## Das Wichtigste zuerst

**Es ist derzeit KEIN Kriterium aus [ZIEL.md](ZIEL.md) erfÃ¼llt.**

| # | Kriterium | Stand am 31.08.2026 |
|---|---|---|
| 0 | das Paket lÃ¤uft ohne Nachinstallieren | **nicht erfÃ¼llt** â Debug-Bau, vier nicht verteilbare Laufzeit-DLLs (S-8) |
| 1 | startet und zeigt sein Hauptfenster | **strittig** â das Fenster erscheint, ist aber nicht bedienbar |
| 2 | die Darstellung ist korrekt | **nicht erfÃ¼llt** â Ursachen behoben (A-1), am Programm nicht nachgesehen |
| 3 | Mailkonto verbinden und Mail abrufen | **nicht geprÃ¼ft** â Abrufpfad abgesichert (P-2), echter Abruf steht aus |

Eudora startet und lÃ¤uft bis in die Fenstererzeugung, ohne abzustÃ¼rzen â zum
ersten Mal seit Beginn der Portierung. Das ist ein **Meilenstein, kein
erfÃ¼lltes Kriterium**. FÃ¼r die beiden sichtbaren MÃ¤ngel (tote MenÃ¼leiste,
leere KnÃ¶pfe und Ã¼berlagerte Bereiche) sind die Ursachen am 31.08.2026 belegt
**und im Quelltext behoben** â M-1 und A-1. **Nachgesehen hat das niemand am
laufenden Programm**, es war keine Sitzung mit Bildschirm erlaubt. Bis dahin
bleiben Kriterium 1 und 2 offen.

Der Dateiname `Eudora72-1.0.2-lauffaehig.zip` behauptet mehr, als die Fassung
kann. Er bleibt stehen, weil das Paket unter diesem Namen samt PrÃ¼fsumme
verÃ¶ffentlicht ist; kÃ¼nftige Pakete heiÃen nach ihrem tatsÃ¤chlichen Stand.
Paket 1.0.3 ist vorbereitet und **nicht verÃ¶ffentlicht** â vorgeschlagener
Name `Eudora72-1.0.3-vorabfassung.zip`, siehe [Releases/PAKETE.md](Releases/PAKETE.md).

---

## Was am 30.08. passiert ist

### Behoben

**S-1 â Paket 1.0.1 startete nicht.** Drei Ursachen: die sieben vorgebauten
Fremd-DLLs von 2006 lagen als *Debug*-Fassungen bei (nicht verteilbare
VS2003-Debug-Laufzeit); es fehlte eine `Eudora.ini` (Abbruch in
`eudora.cpp:3542`); und die WerbeflÃ¤che stÃ¼rzte ab.

**S-2 â der Absturz war die WerbeflÃ¤che.** `CAdWazooWnd::OnCreate`
([AdWazooWnd.cpp:108](Eudora71/Eudora/AdWazooWnd.cpp:108)) legt die Werbeansicht
mit `CRect(0,0,0,0)` an; die Textmaschine Paige bekommt eine Umbruchbreite von
null und dreht sich in einer Endlosrekursion fest. Gemessen: 1689 Stapelrahmen,
davon 1613 im Zyklus. Die Werbeleiste wurde in
[WazooBarMgr.cpp:155](Eudora71/Eudora/WazooBarMgr.cpp:155) **bedingungslos**
angelegt; sie hÃ¤ngt jetzt an `QCSharewareManager::IsBoxBuild()`, dazu der
Ãbersetzungsschalter `BUILD_BOX_OR_SITE_R_VERSION`. Damit entfallen Werbung,
Registrierung und EinfÃ¼hrungsdialog.

**S-4 â Zusicherung im Adressbuch-Wazoo.** Eine Registerkarte kann *aktiv* sein,
ohne je *angezeigt* worden zu sein. QUALCOMM beschreibt genau das in
`WazooBar.cpp:346` und fÃ¤ngt es beim Aktivieren ab, an den beiden
Deaktivierungsstellen aber nicht. In der Schwesterklasse `CFiltersWazooWnd` ist
dieselbe Zusicherung bereits auskommentiert (`FiltersWazooWnd.cpp:109`).

**S-7 â die Wurzel aller CRLF-Probleme.** Gemessen am 30.08.2026: 4616 von 5563 verfolgten Dateien lagen
im Arbeitsverzeichnis als CRLF vor, wÃ¤hrend im Commit LF steht â Folge eines
Auscheckens mit `core.autocrlf=true`. Git sah nicht hinein, solange niemand die
Datei anfasste; danach sprang die *ganze* Datei als geÃ¤ndert heraus. Das ist
einmalig bereinigt.

> **Nach jedem frischen Klon, alle vier Schritte:**
> ```bash
> git config core.autocrlf false
> sh tools/hooks-einrichten.sh
> perl tools/zeilenenden-angleichen.pl --aendern
> git ls-files -z | xargs -0 -n 400 git add --
> ```
> Keiner davon ist wahlfrei. Ohne den Hook treten zwei Fehlerklassen lautlos
> wieder auf.

Dazu die Berichtigung: die frÃ¼here Vermutung âmit `autocrlf=true` geklont" war
**richtig** und wurde damals zu Unrecht als widerlegt abgehakt â `git config`
sagte zum PrÃ¼fzeitpunkt schon `false`, die Einstellung war inzwischen geÃ¤ndert
worden, die Folgen des Auscheckens blieben.

## Was am 31.08. dazugekommen ist

### Behoben

**S-8 â Paket 1.0.2 startete gar nicht: `0xc000007b`.** Die vier
VS2022-Debug-Laufzeiten (`mfc140d.dll`, `msvcp140d.dll`, `vcruntime140d.dll`,
`ucrtbased.dll`) fehlten im Programmverzeichnis. `Eudora.exe` ist **x86**; zwei
Fallen fÃ¼hren beim Nachlegen zur falschen Bitness: DLL-Sammelseiten liefern
hÃ¤ufig x64, und der 32-Bit-Systemordner heiÃt ausgerechnet `SysWOW64`. Werkzeug
dagegen: `tools/laufzeit-holen.ps1`, prÃ¼ft jede Datei einzeln auf x86 nach.
**Nicht gelÃ¶st:** diese vier DLLs dÃ¼rfen nicht weiterverteilt werden â daraus
ist Kriterium 0 entstanden.

**M-1 â die MenÃ¼s. Ursache belegt und behoben.** `SECToolBarManager` setzte
`m_bMainFrameEnabled` im Konstruktor auf `TRUE`
([OTShim_Werkzeugleiste.cpp:3480](Eudora71/OTShim/OTShim_Werkzeugleiste.cpp:3480)
und `:3506`). `CMainFrame::OnNcHitTest`
([mainfrm.cpp:8662](Eudora71/Eudora/mainfrm.cpp:8662)) liefert bei
`IsMainFrameEnabled() == TRUE` **immer `HTERROR`** â damit war die *gesamte*
NichtklientenflÃ¤che tot: MenÃ¼leiste, Titelzeile, FensterknÃ¶pfe, Rahmenkanten.
Die Stingray-Kopfdatei (`tbarmgr.h:79-80`) beschreibt `TRUE` als âHauptfenster
freigegeben" und hat den Autor der Ersatzschicht in die Irre gefÃ¼hrt; Eudora
liest den Wert an allen fÃ¼nf Stellen andersherum. Belege in
[BEFUND-MENUE.md](Eudora71/OTShim/BEFUND-MENUE.md).

> **UNGEPRÃFT am laufenden Programm.** Offener Widerspruch: M-1 ist vom
> INI-Zustand unabhÃ¤ngig, Gregor sagt aber, die MenÃ¼s hÃ¤tten *zwischendurch*
> funktioniert. Verdacht (UNGEPRÃFT): der funktionierende Bau lag vor
> `91716bb`, dem Commit, der `= TRUE` eingefÃ¼hrt hat. Die vier Fragen, die das
> ohne Debugger entscheiden, stehen in `BEFUND-MENUE.md`, Abschnitt 3.

**A-1 â das Erscheinungsbild. FÃ¼nf Punkte umgesetzt.** Die leeren
Werkzeugleisten-KnÃ¶pfe: `SECStdBtn::DrawDisabled` lieÃ vor dem `BitBlt` die
Hintergrundfarbe auf `clrBtnFace` und die Textfarbe unverÃ¤ndert stehen â das
Muster wurde damit unsichtbar. Auf einer frisch gestarteten Eudora sind acht
der fÃ¼nfzehn KnÃ¶pfe gesperrt, was zu âmehrere leer, andere da" passt. Die
Andockrechnung war **doppelt verriegelt**: `SECDockBar` reichte
`OnSizeParent`/`CalcFixedLayout` unverÃ¤ndert an MFC durch (jede Wazoo-Leiste
bekam 32767 als Wunschbreite), *und* `DockControlBarEx` verwarf zusÃ¤tzlich
`nCol` und `nRow`. Beides ist behoben, `m_fPctWidth` wird jetzt ausgewertet.
Offen bleiben die Splitter und `FloatControlBarInMDIChild`.

> **UNGEPRÃFT am laufenden Programm.** Woran Gregor auf einem Bildschirmfoto
> sÃ¤he, dass es geklappt hat, steht in
> [BEFUND-ANSICHT.md](Eudora71/OTShim/BEFUND-ANSICHT.md), letzter Abschnitt.

**P-2 â der Abrufpfad ist abgesichert.** Vier Nullzeiger im Abrufpfad behoben,
darunter der **Funktionszeiger `fnConnInfo`**: schlug das Laden fehl, war die
Fehlermeldung leer. Gefunden mit `tools/suche-zeiger.pl`. Drei neue Tests, 105
grÃ¼n (vorher 102). Kriterium 3 ist damit *vorbereitet*, nicht erfÃ¼llt.

**B-2 â die BrÃ¼cke hÃ¤ngt in der Solution.** `VC71Bruecke` ist in
`Eudora71/Eudora.sln` eingetragen, mit der **echten** GUID â die in B-1 und in
`VC71Bruecke/BEFUND.md` Abschnitt 6 genannte war falsch, das Projekt wÃ¤re
stillschweigend nicht gebaut worden. Paket 1.0.3 ist vorbereitet und
**nicht verÃ¶ffentlicht**. Neu: `tools/paket-pruefen.ps1`, `tools/paket-bauen.ps1`.
**Berichtigung:** Paket 1.0.2 ist **gemischt** (Release-Fremdmodule,
Debug-`Eudora.exe`), nicht durchgehend Release â die frÃ¼here Angabe war falsch.

**W-1 â die Werkzeuge in Ordnung gebracht.** PR-1 bis PR-4 und PR-6 bis PR-8
behoben. Die Schranke `tools/pruefe-bytes.pl` hat jetzt eine Testsammlung
(`tools/pruefe-bytes-tests.pl`, 23 FÃ¤lle, alle grÃ¼n);
`tools/rekursion-suchen.pl` ist gelÃ¶scht. Es gilt: **4616 von 5563** vom
30.08.2026; die Grundgesamtheit wÃ¤chst und lag am 31.08. bei 5589. Offen bleibt
PR-5, die Beschreibung des Zeitstempels.

**Produktversion 7.2.0.3** statt 7.1.0.9, sichtbar im Splash und unter
*Hilfe â Ãber Eudora*. Es gibt **drei getrennte ZÃ¤hlungen** â Produkt
`7.2.0.x`, Paket `1.0.x`, QCSSL `1.0.x`. Tabelle in
[Releases/PAKETE.md](Releases/PAKETE.md).

**ZIEL.md hat ein Kriterium 0 bekommen:** das Paket muss ohne Nachinstallieren
laufen. âzip runterladen, entpacken, starten - lÃ¤uft."

### Offen

**Kein Kriterium ist erfÃ¼llt.** FÃ¼r Kriterium 1 und 2 sind die Ursachen belegt
und im Quelltext behoben, aber **niemand hat das laufende Programm gesehen** â
die Agenten durften kein Fenster Ã¶ffnen. Der nÃ¤chste Schritt ist deshalb ein
Start mit Bildschirmfoto, nicht die nÃ¤chste Analyse.

**Kriterium 0** braucht einen Release-Bau; der Release-Zweig scheitert
weiterhin an einer fehlenden `Imap.lib`.

**Kriterium 3** ist nie ausprobiert worden. Anleitung:
[ABRUF-PRUEFEN.md](ABRUF-PRUEFEN.md). Dort als UNGEPRÃFT markiert: ob
`mx.freenet.de` Ã¼berhaupt der POP3-Server ist.

Der vollstÃ¤ndige PrÃ¼fbericht vom 30.08. abends steht in
[PRUEFBERICHT.md](PRUEFBERICHT.md); was davon behoben ist, sagt Befund W-1.

## Werkzeuge

Die vollstÃ¤ndige Liste steht in [README.md](README.md), Abschnitt âWerkzeuge".
Neu am 31.08.2026:

| Werkzeug | wozu |
|---|---|
| `tools/laufzeit-holen.ps1` | holt die vier Debug-Laufzeiten aus `SysWOW64` und prÃ¼ft jede einzeln auf x86 nach. Befund S-8. |
| `tools/paket-pruefen.ps1` | prÃ¼ft ein ausgepacktes Paket, **bevor** es jemand startet. Das MaÃ fÃ¼r Kriterium 0. |
| `tools/paket-bauen.ps1` | stellt ein Paket aus dem Quellbaum zusammen. VerÃ¶ffentlicht nichts. Braucht `-AusBauverzeichnis`, wenn ein frischer Bau Ã¼bernommen werden soll. |
| `tools/suche-zeiger.pl` | findet Zeiger, die geprÃ¼ft und danach auÃerhalb des Blocks dereferenziert werden. Damit wurde P-2 gefunden. |
| `tools/pruefe-bytes-tests.pl` | 23 TestfÃ¤lle fÃ¼r die Schranke. **Wer `pruefe-bytes.pl` anfasst, lÃ¤sst sie laufen.** |
| `tools/dateiendungen.pl` | gemeinsame Liste der Dateiarten, die als Text gelten. |

`tools/rekursion-suchen.pl` ist am 31.08.2026 gelÃ¶scht worden â Befund W-1: es
bildete jede Kante mit der umgebenden Klasse und konnte klassenÃ¼bergreifende
Zyklen strukturell nicht finden, auch den aus S-2 nicht, fÃ¼r den es gebaut war.

`tools/pruefe-bytes.pl` wurde zweimal berichtigt: die erste Fassung verglich die
bloÃe CR-Anzahl und schlug schon beim *HinzufÃ¼gen* von Zeilen an, die zweite
verglich Zeileninhalte und schlug bei Leerzeilen grundlos an. Seit dem
31.08.2026 wertet Regel 2 den eigentlichen Unterschied aus
(`git diff --cached -U0`) und paart entfernte mit hinzugefÃ¼gten Zeilen innerhalb
eines Blocks â Umwandlungen fallen in beide Richtungen auf, ErgÃ¤nzungen und
LÃ¶schungen laufen durch. **Die alte CR-Anzahl-Regel steht in mehreren Ã¤lteren
Texten noch; wer sie liest, glaubt das Falsche.**

---

## Bau-Kennung in der Titelleiste

Der Fenstertitel trÃ¤gt jetzt Paketversion, Commit und Herkunftsverzeichnis:

```
Eudora - [In]   [1.0.3+371c1e3 - Eudora72-1.0.3]
```

Ein **Sternchen** hinter dem Commit heiÃt: beim Bau lagen ungesicherte
Ãnderungen vor, der Bau ist nicht reproduzierbar. Die Version steht in der
Datei `VERSION`.

Anlass: Gregor konnte eine Beobachtung (âdie MenÃ¼s funktionierten
zwischendurch") keinem Bau zuordnen â die EXE trug keine Kennung. Derselbe
Fehler war zwei Tage zuvor schon bei der `QCSSL.dll` passiert.

---

## Wie man Eudora startet

**Zuerst die Debug-Laufzeiten dazulegen** â ohne sie bricht der Start mit
`0xc000007b` ab, noch bevor ein Fenster erscheint (Befund S-8):

```powershell
powershell -ExecutionPolicy Bypass -File tools\laufzeit-holen.ps1 -Ziel "C:\Pfad\zu\Eudora"
```

Dann:

```bash
Eudora.exe "<Pfad zu einem Mailverzeichnis>"
```

Das Mailverzeichnis **muss eine `Eudora.ini` enthalten**, sonst bricht Eudora in
`eudora.cpp:3542` ab. Vorlage:
`InstallersForEudora/Eudora7.1/Data/INIfiles/eudora.ini`.

Beim ersten Start erscheinen drei bis vier Dialoge âSUPERASSERT Assertion
Failure" â auf *Ignore Once* klicken. Das sind Debug-Zusicherungen, keine
Fehler; sie erscheinen nur, weil bisher nur der Debug-Bau lÃ¤uft (der
Release-Zweig scheitert an einer fehlenden `Imap.lib`).

**Wichtig:** Gregor testet auf derselben Windows-Sitzung. Kein Programm mit
Fenstern ohne Absprache starten â auch nicht durch Agenten. Beim AufrÃ¤umen von
Prozessen **immer nach Pfad filtern**, sonst schieÃt man seine laufende Sitzung
mit ab.

---

## Konto einrichten ohne MenÃ¼

Solange nicht am laufenden Programm bestÃ¤tigt ist, dass die MenÃ¼s mit der
Behebung aus M-1 wieder aufgehen, geht es nur Ã¼ber die `Eudora.ini` im
Mailverzeichnis, Abschnitt `[Settings]`:

```ini
POPAccount=benutzername@pop.anbieter.de
LoginName=benutzername
RealName=Name
ReturnAddress=adresse@anbieter.de
SMTPServer=smtp.anbieter.de
SmtpAuthAllowed=1
SSLReceiveUse=2
SSLPOPAlternatePort=995
SSLSendUse=2
SSLSMTPAlternatePort=465
```

`SSLReceiveUse`/`SSLSendUse` sind der Index der Auswahlliste aus
[settings.cpp:1978](Eudora71/Eudora/settings.cpp:1978): 0 nie, 1 falls verfÃ¼gbar
(STARTTLS), 2 erforderlich mit eigenem Port, 3 erforderlich (STARTTLS).

Das Passwort landet als `SavePasswordText` **Base64-kodiert, nicht
verschlÃ¼sselt** in derselben Datei ([password.cpp:544](Eudora71/Eudora/password.cpp:544)).

---

## Was die Agenten bearbeitet haben

Alle haben in eigenen Worktrees gearbeitet. Die Ergebnisse vom 30.08. abends
und vom 31.08. frÃ¼h sind **zusammengefÃ¼hrt** und stehen im Baum; ihre
Abschnitte stehen am Ende von `BEFUNDE.md`.

| Agent | Auftrag | Ablage | Stand |
|---|---|---|---|
| BRÃCKE | eigene `msvcr71.dll` als Weiterleitung auf `msvcrt.dll` | `Eudora71/VC71Bruecke/BEFUND.md`, `BEFUNDE.md` `## B-1`, `## B-2` | zusammengefÃ¼hrt; Projekt hÃ¤ngt in der Solution, Paket 1.0.3 vorbereitet |
| MENUE | Befund S-5, warum sich MenÃ¼s nicht Ã¶ffnen lassen | `Eudora71/OTShim/BEFUND-MENUE.md`, `BEFUNDE.md` `## M-1` | zusammengefÃ¼hrt; Ursache behoben, am Programm nicht nachgesehen |
| ANSICHT | Befund S-6, das Erscheinungsbild | `Eudora71/OTShim/BEFUND-ANSICHT.md`, `BEFUNDE.md` `## A-1` | zusammengefÃ¼hrt; fÃ¼nf Punkte umgesetzt, am Programm nicht nachgesehen |
| POSTBOTE | Kriterium 3 vorbereiten | `ABRUF-PRUEFEN.md`, `BEFUNDE.md` `## P-1`, `## P-2` | zusammengefÃ¼hrt; vier Nullzeiger behoben, Tests 105 grÃ¼n |
| WERKZEUG | Befunde PR-1 bis PR-8 abarbeiten | `BEFUNDE.md` `## W-1` | zusammengefÃ¼hrt; PR-5 bleibt offen |
| PRÃFER | Richtigkeit der Werkzeuge, CodeÃ¤nderungen und Zahlen | `PRUEFBERICHT.md` `## PR-1` | abgeschlossen (30.08. abends) |
| LEKTOR | AktualitÃ¤t aller MD-Dateien | `LEKTORAT.md` | zweiter Durchgang 31.08. |
| FREIGABE | Release-Bau | â | **lief beim Schreiben dieser Datei noch.** Sein Ergebnis fehlt hier zwangslÃ¤ufig; zuerst seinen Branch und seinen Abschnitt in `BEFUNDE.md` ansehen |

**Zuerst diese Dateien lesen** â dort steht, wie weit jeder gekommen ist und was
der nÃ¤chste Schritt wÃ¤re.

---

## NÃ¤chste Schritte, nach Wichtigkeit

1. **Einmal starten und ein Bildschirmfoto machen.** Das ist jetzt der erste
   Schritt, nicht mehr die Analyse. FÃ¼r M-1 und A-1 sind die Ursachen belegt
   und behoben, nachgesehen hat es niemand â die Agenten durften kein Fenster
   Ã¶ffnen. Zu vergleichen sind die Merkmale aus [ZIEL.md](ZIEL.md), âWoran sich
   Kriterium 2 misst". Woran man den Erfolg erkennt, steht in
   [BEFUND-ANSICHT.md](Eudora71/OTShim/BEFUND-ANSICHT.md), letzter Abschnitt.
2. **Kriterium 0: das Paket ohne Nachinstallieren.** Gregors neueste Vorgabe.
   Weg: Release-Bau, vorzugsweise statisch (`/MT` + MFC statisch). Blocker ist
   die fehlende `Imap.lib` im Release-Zweig. MaÃ ist `tools/paket-pruefen.ps1`
   gegen das ausgepackte Paket auf einem Rechner ohne Visual Studio: null
   Fehler. Siehe Befund S-8 und `ZIEL.md`.
3. **Mail abrufen (Kriterium 3).** Nie getestet. Der Abrufpfad ist seit P-2
   gegen die vier bekannten Nullzeiger abgesichert, die Anleitung steht in
   [ABRUF-PRUEFEN.md](ABRUF-PRUEFEN.md). Zugleich der erste echte Test der
   neuen TLS-Schicht: die ausgelieferte QCSSL 1.0.1 ist nie gegen einen echten
   Server gelaufen, nur eine Ã¤ltere Fassung war es.
4. **Erscheinungsbild, zweite Runde.** Nach dem Bildschirmfoto: die Splitter
   (`SECDockBar::AddSplitter` wird nie gerufen) und
   `SECMDIFrameWnd::FloatControlBarInMDIChild`. Reihenfolge und Ansatz in
   `BEFUND-ANSICHT.md`.
5. **Paket 1.0.3 verÃ¶ffentlichen** â vorbereitet, aber bewusst NICHT
   verÃ¶ffentlicht. Vorgeschlagener Name `Eudora72-1.0.3-vorabfassung.zip`.
   Einzelheiten und Bauweg in [Releases/PAKETE.md](Releases/PAKETE.md).
6. **PR-5** â der Zeitstempel in der Bau-Kennung ist der Zeitpunkt der letzten
   Commit- oder SauberkeitsÃ¤nderung, nicht der Bauzeitpunkt. Das Verhalten ist
   richtig, nur die Beschreibung stimmt nicht. Ein Wort im Kommentar.

---

## ZurÃ¼ckgestellt â nicht von selbst aufgreifen

`tools/patches/zertifikatspruefung-verschaerfen.patch` (HostnamensprÃ¼fung und
Umgang mit `X509_V_ERR_CERT_UNTRUSTED` in QCSSL) ist vorbereitet, aber **nicht
angewendet**. Gregor hat entschieden, das spÃ¤ter anzugehen. Nicht ohne sein
Wort anwenden.

---

## Fallen im Arbeitsverzeichnis

- **Quelldateien sind Latin-1 mit gemischten Zeilenenden.** Nur byte-erhaltend
  Ã¤ndern: `tools/aendere-zeile.pl`, `tools/ersetze-bereich.pl`. Niemals `sed`
  ohne `-b`, nicht das Edit-Werkzeug auf bestehende Quellen.
- **`grep -c $'\r'` misst Zeilenenden NICHT zuverlÃ¤ssig** â es zÃ¤hlt in Git Bash
  schlicht alle Zeilen. Immer mit Perl und `:raw` messen.
- **Einzelprojekt-Bauten brauchen `/p:BuildProjectReferences=false`**, sonst
  scheitern sie am Projekt `OT501`.
- **`$(SolutionDir)` zeigt beim Einzelprojekt-Bau auf das Projektverzeichnis**,
  nicht auf die Solution. `$(ProjectDir)..\..` benutzen.
- **`perl` ist im MSBuild-Pfad nicht vorhanden.** Es liegt unter
  `C:\Program Files\Git\usr\bin\perl.exe`.
- **`&` muss in `.vcxproj` als `&amp;` geschrieben werden** â sonst lÃ¤dt MSBuild
  die Projektdatei nicht mehr.
- **Es kann systemweit nur einen OutputDebugString-MithÃ¶rer geben**
  (`DBWIN_BUFFER`). Zwei gleichzeitig, und beide bekommen nichts.
- **Include-WÃ¤chter sind alles-oder-nichts.** Wer nur einen Teil eines
  Stingray-Headers ersetzt, darf den WÃ¤chter nicht setzen. Steht ausfÃ¼hrlich in
  `Eudora71/OTShim/PLAN.md`.
