# Einstellungen und Überraschungen

Diese Datei ist für den, der Eudora **einrichtet und betreibt** — nicht für
den, der es baut. Sie beantwortet eine einzige Frage:

> *Was muss ich wissen, das nicht in der Oberfläche steht?*

Gesammelt ist hier, was während der Portierung Zeit gekostet hat: Schalter
ohne Menüpunkt, Regeln, nach denen Eudora eine `Eudora.ini` liest, und
Verhalten, das niemand erwartet und das sich **nicht von selbst meldet**.

**Jeder Eintrag ist belegt** — mit Datei und Zeilennummer im Quelltext oder
mit der Datei, in der die Messung steht. Was sich nicht belegen ließ, steht
nicht hier.

**Diese Datei schreibt nichts doppelt.** Wo `README.md`, `FILTER.md` oder
`ABRUF-PRUEFEN.md` eine Sache schon vollständig erklären, steht hier der
Verweis und nicht die Abschrift — zwei Fassungen derselben Angabe laufen
immer auseinander.

| Wozu | wohin |
|---|---|
| Abschnittsregel, Suchreihenfolge, `LogLevel`, die Abweichungen dieser Portierung | [README.md](README.md), Abschnitte *Einstellungen, die es nur hier gibt* bis *Mehr ins Protokoll schreiben lassen* |
| alle Schlüssel zu Filtern und Junk, mit Vorgabe und Fundstelle | [FILTER.md](FILTER.md), Abschnitt *Die Einstellungen in der `Eudora.ini`* |
| Konto einrichten, TLS, Ports, Fehlermeldungen beim Abruf | [ABRUF-PRUEFEN.md](ABRUF-PRUEFEN.md) |
| was neben der `Eudora.exe` liegen muss | [STARTUMGEBUNG.md](STARTUMGEBUNG.md) |
| die Befunde selbst, mit Messung | [BEFUNDE.md](BEFUNDE.md), [CHANGELOG.md](CHANGELOG.md) |

---

## 1. Fünf Regeln, die für jeden Schlüssel gelten

Wer diese fünf kennt, spart sich die meisten Runden.

**1.1 Der Abschnitt ergibt sich aus der Nummer, nicht aus dem Namen.**
`GetSectionID` (`Eudora71/Eudora/rs.cpp:89-97`) teilt vier Bereiche ein:
bis 10800 `[Settings]`, 10801–10900 `[Debug]`, 10901–11100
`[Window Position]`, ab 11101 wieder `[Settings]`. **Ein Eintrag im falschen
Abschnitt wirkt nicht — ohne jede Meldung.** Die Tabelle, das Beispiel und
die Geschichte dazu stehen in [README.md](README.md), Abschnitt *Wo ein
Schlüssel stehen muss*. Wohin ein einzelner Schlüssel gehört, sagt:

```
perl tools/pruefe-ini-abschnitte.pl --was LogLevel
perl tools/pruefe-ini-abschnitte.pl --tabelle
```

**1.2 Gesucht wird in vier Stufen**, und die erste, die etwas liefert,
gewinnt: Abschnitt der aktiven Persönlichkeit → `Eudora.ini` →
`DEudora.ini` → eingebauter Wert aus `EudoraRes.rc`
(`GetIniString`, `rs.cpp:334-346`). Die vollständige Tabelle steht in
[README.md](README.md).

**1.3 Solange es nur eine Persönlichkeit gibt, heißt deren Abschnitt
wörtlich `[Settings]`** (`persona.cpp:887-903`). Ein dorthin verirrter
`[Debug]`- oder `[Window Position]`-Schlüssel wird deshalb über Stufe 1
gefunden und **scheint zu wirken** — bis eine zweite Persönlichkeit aktiv
wird. Wer so etwas prüft, prüft auf dem gefährlichsten Untergrund.

**1.4 Eudora schreibt Werte selbst zurück**, und zwar in den Abschnitt, der
zur Nummer gehört (`FlushINIFile`, `rs.cpp:1189`, Abschnitt `:1203`,
geschrieben `:1250` und `:1257`). Eine Zeile, die man an der falschen Stelle
einträgt, wird dadurch nicht berichtigt — sie bleibt stehen und wird
ignoriert, während daneben der richtige Eintrag entsteht.

**1.5 Ein Tippfehler im Schlüsselnamen ist von einem fehlenden Eintrag nicht
zu unterscheiden.** Eudora sucht den Namen und nimmt bei Misserfolg die
eingebaute Vorgabe (`rs.cpp:342-346`) — es gibt keine Liste erlaubter Namen,
keine Warnung und keinen Protokolleintrag. Die maßgeblichen Schreibweisen
stehen in `Eudora71/Eudora/EudoraRes.rc` im Format
`IDS_INI_XXX "Name\nVorgabe"`.

---

## 2. Beim Einrichten und beim Umsteigen auf eine neue Fassung

Hier liegt der meiste verlorene Aufwand — nicht in den Schaltern, sondern im
Kopieren.

**2.1 Das *ganze* Mailverzeichnis übernehmen, nicht nur die `*.mbx`.**
Anhänge stehen bei Eudora **nicht** in der `.mbx`; dort steht nur eine Zeile
`Attachment Converted: "<pfad>"`. Die Dateien selbst liegen in `attach`,
eingebettete Bilder in `Embedded`. Wer nur die Postfächer kopiert, kopiert
leere Hüllen. Beleg und fertiges Werkzeug:
`tools/mailverzeichnis-uebernehmen.ps1` (Kopf der Datei, Zeilen 10–30); es
kopiert alle Unterverzeichnisse ohne Auswahl und **zählt am Ende Quelle gegen
Ziel nach**.

**2.2 IMAP-Konten liegen in eigenen Unterverzeichnissen — wer nur die oberste
Ebene kopiert, verliert sie.** Jedes IMAP-Konto bekommt unter dem
Mailverzeichnis ein eigenes Verzeichnis
(`CImapAccountMgr::AddAccountFromPersonality`,
`Eudora71/EuImap/src/ImapAccountMgr.cpp:543-558`, angelegt in
`CImapAccount::InitializeDir`, `Eudora71/EuImap/src/ImapAccount.cpp:892-911`).
**Den Namen merkt sich die `Eudora.ini`** unter dem Schlüssel `AccountDir`
(`Eudora71/Eudora/EudoraRes.rc:10439`), geschrieben in den Abschnitt der
**Persönlichkeit** — nicht in den, der zur Nummer gehört
(`QCImapMailboxDirector.cpp:214-236`, `WriteProfileString` auf `:227`). Daraus
folgt die Tücke: die `Eudora.ini` allein sieht vollständig aus und nennt ein
Verzeichnis, das es nicht gibt. IMAP tut dann gar nichts.

**2.3 Das Paket bringt eine eigene `Mailverzeichnis\Eudora.ini` mit.** Sie ist
nicht leer, aber sie kennt **keine Konten**: nachgemessen am Paket
**1.0.48** enthält sie 128 Zeilen — `[Settings]` mit `NC=1`
und `Code=NC`, dazu `[Mappings]` mit den 124 Dateizuordnungen von QUALCOMM
(Original: `InstallersForEudora/Eudora7.1/Data/INIfiles/eudora.ini`). Wer ein
Paket **über** eine bestehende Installation auspackt, ersetzt damit seine
Konten, Persönlichkeiten und offenen Fenster durch diese Vorlage.

> **Die sichere Richtung ist die andere:** Paket in ein **neues, leeres**
> Verzeichnis auspacken und das alte `Mailverzeichnis` dorthin kopieren — so
> steht es auch in [README.md](README.md) unter *Herunterladen und starten*.

**2.4 Erst ab Paket 1.0.46 bringt das ZIP eine eigene Wurzelebene mit.**
Gemessen an den abgelegten Paketen: **1.0.40** und **1.0.44** legen
`Eudora.exe`, `Mailverzeichnis\` und rund 150 weitere Einträge **direkt**
auf die oberste Ebene, **1.0.46** und alles danach in ein eigenes
Verzeichnis `Eudora72-1.0.<n>-release\`. Genau daran ist am 10.09.2026
eine `Eudora.ini` verlorengegangen
([Arbeitsweise/anwenderdatei-nicht-erschlagen.md](Arbeitsweise/anwenderdatei-nicht-erschlagen.md),
Nachtrag). Wer ein **älteres** Paket auspackt, prüft vorher die oberste Ebene:

```
unzip -l <paket>.zip | awk '{print $4}' | cut -d/ -f1 | sort -u | head
```

**2.5 `DEudora.ini` wirkt nur auf Konten, die *neu entstehen*.** Sie liegt
neben der `Eudora.exe` und wird in `GetDefaultIniSetting` (`rs.cpp:357-385`)
gelesen — an einem bestehenden Konto ändert sie nichts mehr, weil dessen Wert
schon in der `Eudora.ini` steht. Was diese Portierung dort vorgibt und warum,
steht kommentiert in `tools/DEudora.ini` und in [README.md](README.md) unter
*Vorgaben für neu angelegte Konten*.

---

## 3. Schalter ohne Menüpunkt

Nur das, was anderswo **nicht** schon vollständig steht. Die Spalte *Vorgabe*
ist der eingebaute Wert aus `Eudora71/Eudora/EudoraRes.rc`.

| Schlüssel | Abschnitt | Vorgabe | Fundstelle | wozu |
|---|---|---|---|---|
| `LogFileName` | `[Debug]` | `eudora.log` | `EudoraRes.rc:8440` | Name der Protokolldatei im Mailverzeichnis |
| `LogLevel` | `[Debug]` | `25759` | `EudoraRes.rc:8441` | **keine Stufe, sondern eine Summe von Schaltern.** Die einzelnen Bits und der Wert `58527` für die Spurmarken stehen in [README.md](README.md), Abschnitt *Mehr ins Protokoll schreiben lassen* |
| `LogFileSize` | `[Debug]` | `10000` | `EudoraRes.rc:8442` | ab welcher Größe das Protokoll umgebrochen wird |
| `ShowAllHeaders` | `[Settings]` | `0` | `EudoraRes.rc:8667` | Anfangszustand des Knopfes *Blah Blah Blah* beim Öffnen einer Nachricht (`ReadMessageFrame.cpp:497-498`) |
| `MaxConcurrentTasks` | `[Settings]` | `10` | `EudoraRes.rc:8634` | wie viele Aufgaben gleichzeitig laufen dürfen (`QCTaskManager.cpp:93`). Sind so viele aktiv, wartet die nächste in der Warteschlange (`:376`); `0` heißt *ohne Grenze* |
| `MessageStyleSheet` | `[Settings]` | siehe `EudoraRes.rc:8130` | `EudoraRes.rc:8130` | Stylesheet der Nachrichtenansicht. **Liegt eine `read.css` im Eudora-Verzeichnis, ersetzt sie das Stylesheet vollständig** (`TridentView.cpp:1300`, Rückfall auf die INI erst `:1323`) — die hier ergänzte Regel für die Kopfzeilen entfällt dann, siehe [README.md](README.md) |
| `TabooHeaders` | `[Settings]` | Liste, `EudoraRes.rc:9996` | `EudoraRes.rc:9996` | welche Kopfzeilen *Blah Blah Blah* versteckt. **Ein Eintrag in der `Eudora.ini` ersetzt die Liste vollständig, er ergänzt sie nicht** — wer etwas hinzufügen will, schreibt die ganze Liste hin. Was diese Portierung ergänzt hat, steht in [README.md](README.md); nachrechnen lässt es sich mit `perl tools/taboo-rechnen.pl` |
| `FloatCx<id>`, `FloatCy<id>` | `[ToolBar]` | *kein Eintrag* | `OTShim_Werkzeugleiste.cpp`, `SECToolBarManager::GroessenSichern` | **gibt es im Original nicht.** Merken sich Breite und Höhe eines **losgerissenen** Fensters, je Leisten-Kennung, damit sie den Neustart überlebt (**E-84**). Ohne Eintrag gilt die Anfangsgröße. `<id>` ist die Kennung der Leiste, dieselbe wie bei `DockVertCx` und `DockHorzCy` daneben. **Keine Ressourcennummer** — der Schlüssel wird unmittelbar über `WriteProfileString` geschrieben, die Nummernregel aus Abschnitt 1 gilt für ihn also nicht. Wer eine Größe loswerden will, löscht die Zeile; sie wird beim nächsten Beenden neu geschrieben |
| `FilterMayDeleteFromServer` | `[Settings]` | `0` | `filtersd.cpp:1133` | **gibt es im Original nicht.** Erst mit `1` darf eine Filteraktion Post auf dem Server löschen (Befund **E-73**). Der Abschnitt steht hier fest im Quelltext, nicht in der Nummernregel |

Schon vollständig anderswo, deshalb hier nur der Zeiger:

* **Filter und Junk** — rund 40 Schlüssel mit Vorgabe, Abschnitt und
  Fundstelle, darunter `UseMyFilterWindowPosition`, `CtrlJMapping`,
  `DeleteFetchedJunk` und `MinScoreToJunk`: [FILTER.md](FILTER.md).
* **`SSLSendUse` / `SSLReceiveUse`**, die Bedeutung der Werte 0–3 und die
  zugehörigen Ports: [ABRUF-PRUEFEN.md](ABRUF-PRUEFEN.md).
* **Die Abweichungen dieser Portierung vom Original** — eine Tabelle mit
  *hier* und *Original* nebeneinander: [README.md](README.md).

---

## 4. Überraschungen

Verhalten, das belegt ist und trotzdem niemand erwartet. Keines davon meldet
sich von selbst.

**4.1 Die Junk-Punktzahl bleibt bei jeder eingehenden Nachricht `0`.** Die
Bewertung kommt nicht von Eudora, sondern von Zusatzmodulen; ist keines
geladen, kehrt `CallJunkTranslators` sofort zurück
(`Trnslate.cpp:4952-4957`), und ein fehlgeschlagenes Modul meldet sich nicht
(`Trnslate.cpp:3150-3157`). Damit ist jede Regel *„Junk Score is greater than
N"* wirkungslos — und, gefährlicher, *„Junk Score is less than N"* trifft für
jedes N ≥ 1 **jede** Nachricht. Ausführlich, mit allen Folgen:
[FILTER.md](FILTER.md), Abschnitt *Junk: die Werte, die Schwelle, und was hier
davon übrig ist*.

**4.2 Vor dem Stöbern im Filterfenster `Filters.pce` sichern.** Eine Regel
*„Junk Score is less than N"* wird durch **bloßes Ansehen** unbrauchbar und
verwandelt sich in *„matches regexp N"* (Befund **E-67**, offen, belegt an
`filtersv.cpp:1210` und `:1222`). Die Datei liegt im Mailverzeichnis.

**4.3 Beim Start wird nach dem IMAP-Kennwort gefragt**, wenn beim Beenden ein
IMAP-Postfachfenster offen stand — auch dann, wenn *Check mail* abgewählt ist.
Eudora stellt die Fenster aus dem Abschnitt `[Open Windows]` wieder her, und
ein IMAP-Postfach zu öffnen heißt, sich anzumelden. Was hilft und warum
*Check mail* nichts daran ändert: [README.md](README.md), Abschnitt *Beim
Start wird nach dem IMAP-Kennwort gefragt*.

**4.4 Auch ein Filterlauf auf einem IMAP-Postfach fragt nach dem Kennwort**,
selbst wenn nur lokal sortiert werden soll. Das ist Verhalten des Originals;
der Autor hat die Stelle selbst als unfertig gekennzeichnet
(`EuImap/src/ImapMailbox.cpp:5388`). Siehe [FILTER.md](FILTER.md), Abschnitt
*Was überrascht*.

**4.5 Die Kurznamen-/Verzeichnisdienst-Leiste meldet beim Öffnen einen
Fehler** — *„Directory Services unavailable during this session due to
unsuccessful initialization"*. Ursache ist keine Einstellung: die fünf
Fremd-DLLs brauchen `MFC71.DLL` und `MSVCP71.dll`, die Microsoft nie als
Redistributable veröffentlicht hat (Befund **E-47**, offen). Die Leiste bleibt
damit unbenutzbar; alles andere läuft weiter.

**4.6 IMAP-Postfachnamen mit Umlauten werden roh angezeigt** — `Entw&APw-rfe`
statt *Entwürfe*. Modifiziertes UTF-7 nach RFC 3501, 5.1.3, das Eudora nicht
dekodiert (Befund **E-77**, offen, [CHANGELOG.md](CHANGELOG.md) unter *Noch
offen*).

**4.7 Eine IMAP-Aufgabe kann in der Warteschlange stehenbleiben** — *„Waiting
in the task queue to be started …"*, und beim Beenden warnt Eudora dann
*„You currently have 1 task(s) running"*. Nebenbefund ohne Nummer, am
11.09.2026 an Paket 1.0.48 gemeldet; drei Ursachen sind bereits ausgeschlossen
([CHANGELOG.md](CHANGELOG.md) unter *Noch offen*). `MaxConcurrentTasks` ist
**nicht** die Ursache, aber der Schalter, der bestimmt, wie viele Aufgaben
überhaupt gleichzeitig laufen dürfen.

---

## Wenn hier etwas fehlt

Dann fehlt es, weil kein Beleg dafür gefunden wurde — nicht, weil es
unwichtig wäre. Wer einen Schalter oder eine Überraschung nachweisen kann,
trägt sie mit Fundstelle hier ein. Ohne Beleg gehört nichts in diese Datei;
eine Angabe, der man nicht trauen kann, ist schlimmer als keine.

Die Abschnittsangaben in dieser Datei prüft
`perl tools/pruefe-ini-abschnitte.pl` bei jedem Commit gegen `resource.h` —
eine falsche Zeile hier fällt damit auf, bevor sie jemand liest.
