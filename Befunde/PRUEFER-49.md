# <a id="pruefer-49"></a>PRUEFER-49 — E-119, E-113 und E-77 gegen die Quelle nachgerechnet, 24.10.2026

**Auftrag.** `git log 284d9e15..bcbce2fb -- Eudora71`: die drei Behebungen
von heute — [E-119](../Intern/BEFUNDE.md#e-119) (Bilder als `data:`-Adresse
werden zur Datei unter `Embedded`), [E-113](../Intern/BEFUNDE.md#e-113)
(zu breite Bilder auf den Textbereich verkleinern) und
[E-77](../Intern/BEFUNDE.md#e-77) (IMAP-Ordnernamen mit Umlauten).

**Ergebnis vorweg.**

* **[E-77](../Intern/BEFUNDE.md#e-77) — die Anzeige hält, das Umbenennen
  nicht.** Nach dem Umbenennen eines IMAP-Ordners in einen Namen mit Umlaut
  oder `&` steht der Ordner auf dem Server richtig kodiert, in Eudora aber
  unter dem **unkodierten** Namen. Jeder weitere Zugriff auf diesen Ordner
  geht mit dem falschen Namen an den Server, auch für seine Unterordner, und
  der falsche Name wird in `mboxlist.lst` gespeichert ([K1](#k1)). Dazu
  finden gespeicherte Nachrichten mit Fcc auf einen solchen Ordner ihr Ziel
  nicht mehr. Die Ablage unterbleibt dann ohne Meldung ([K3](#k3)).
* **[E-119](../Intern/BEFUNDE.md#e-119) — hält für das gemessene Bild, hat
  aber drei Lücken.** Die Bilddatei wird von allen Nachrichten geteilt, die
  dasselbe Bild enthalten, und Eudora löscht sie, sobald **eine** davon
  endgültig gelöscht wird ([K5](#k5)). Bilder über rund 48 KB werden
  abgeschnitten, weil der HTML-Leser nur bis 65535 Zeichen zählt
  ([K6](#k6)). Und es trifft jedes Attribut, auch `<a href>`: ein solcher
  Link würde beim Weiterleiten den lokalen Pfad mit dem Windows-Benutzernamen
  an den Empfänger tragen ([K7](#k7)).
* **[E-113](../Intern/BEFUNDE.md#e-113) — hält für das gemessene Bild ohne
  Größenangabe.** Bei Bildern mit **beiden** Maßen im HTML wird nur die
  Metadatei verkleinert, nicht der Rahmen. Das ist genau das Auseinanderlaufen
  aus [E-106](../Intern/BEFUNDE.md#e-106). Im Verfassen-Fenster tritt es nur
  auf, wenn der Textbereich schmaler als 600 Punkte ist ([K9](#k9)).

**Testsuite selbst gefahren: 286 Tests, 286 bestanden** (MSBuild Debug Win32,
`RunTests.cmd` im Arbeitsbaum `Eudora7.2-wt-pruefer`, Rückgabe 0).

**Hält ein Fund das Paket 7.2.0.123 auf?** Keiner bringt einen Datenverlust,
der vorher nicht da war, und keiner betrifft einen Weg, der vorher
funktionierte. Bei [K1](#k1) war das Umbenennen mit Umlaut auch vorher
kaputt: der Server bekam rohe 8-Bit-Bytes. Bei [K5](#k5) kam vorher gar kein
Bild an. Aber **[K1](#k1) und [K3](#k3) gehören vor das Paket in den
Eintrag zu [E-77](../Intern/BEFUNDE.md#e-77)**: der Eintrag sagt, Umbenennen
sei kodiert. Das stimmt nur für den Server, nicht für Eudora selbst.
[K1](#k1) ist eine Behebung in zwei Zeilen.

**Neue E-Kennung: E-145** ([K11](#k11), `Base64Decoder` liest bei Bytes über
127 vor seiner Tabelle, Originalfehler von QUALCOMM). **E-146 bleibt frei.**
Alle anderen Funde gehören zu [E-77](../Intern/BEFUNDE.md#e-77),
[E-113](../Intern/BEFUNDE.md#e-113) oder [E-119](../Intern/BEFUNDE.md#e-119).
Vorher gelaufen: `perl tools/befund-suchen.pl` zu `Base64.cpp`, `g_Decode`,
`GetNextToken`, `DeleteEmbeddedObjects`, `InEmbeddedDir`,
`FindByNamedPath`, `UpdateAfterRename`, `ImapFindByName`, `RenameMailbox`,
`PgSaveUrlImage`, `PgLoadUrlImage` und `E113Seitenbreite`. Zu `Base64.cpp`
gibt es nur [P-1](../Intern/BEFUNDE.md#p-1) (Komponententests), nicht diesen
Fehler.

Gekennzeichnet ist jede Aussage: **gemessen** (Testlauf, Messprogramm,
Prüfstandsdateien von heute), **am Quelltext belegt** (Datei:Zeile),
**Vermutung**. Zeilennummern gelten für `bcbce2fb`.

---

## 1. E-119 — `data:`-Bilder als Datei

### 1a. Lebensdauer von `szE119Datei`

**Sicher, am Quelltext belegt.** `char szE119Datei[kMaxAttributeSize]`
(`PGHTMIMP.CPP:3734`) steht im selben Block wie `pgBlockMove(command,
params->param, …)` (`:3743`). `command` zeigt höchstens bis zum Ende dieses
Blocks auf den Puffer, kopiert wird vorher. `params->param` ist ein festes
Feld mit 1024 Byte (`PGTXR.H:317`), kein Zeiger. Danach liest niemand mehr
den Stapelpuffer.

### 1b. Pufferlängen

**Am Quelltext belegt.** `E119DataNachDatei` gibt FALSE zurück, wenn
`Pfad + 8 >= 511` ist (`:3676`). `"file://" + Pfad` passt damit immer in
`szImageURL[512]` (`resolve_URL`, `:2312`) und in `pg_url_image.URL[512]`.
Abgeschnitten wird nichts. Ein Pfad zwischen 260 und 502 Zeichen besteht
die Prüfung, scheitert dann aber an `fopen`, weil Eudora nicht für lange Pfade
eingerichtet ist (**Vermutung**: kein `longPathAware`-Manifest
nachgesehen). Dann gilt der alte Weg. Der Überlauf von
`filePath[MAX_PATH]` in `PgLoadUrlImage` (`strcpy`, `PgEmbeddedImage.cpp:505`)
wird dadurch nicht erreicht, weil es so eine Datei gar nicht gibt.

### 1c. `resolve_URL` und `<base href>`

**Keine Basis davor, am Quelltext belegt.** `IsURLScheme("file://…")` ist
wahr: `file:` steht in `IDS_URL_SCHEMES` (`EudoraRes.rc:10846`), und
`Text2Html.cpp:264-265` hängt für `file:` kein `//` an. Damit ist `bFullURL`
wahr (`PGHTMIMP.CPP:2317`), und `<base href>` bleibt draußen.
`resolve_URL` entschlüsselt aber `%xx` (`HTMLUtils.cpp`). Ein
`EudoraDir` mit `%` gefolgt von zwei Hexziffern würde verfälscht. Das ist ein
Randfall und kein Fehler von [E-119](../Intern/BEFUNDE.md#e-119), denn jeder `file://`-Weg hat ihn.

### 1d. Dateiname und Inhalt

**Gemessen** an den Prüfstandsdateien von heute (nur gelesen): FNV-1a über
den **Base64-Text** (nicht über die Bytes) ergibt für die beiden Bilder aus
`Testdaten/e119-data-bild.eml` `db1b9f48` (360 Zeichen) und `2eaa4a58`
(1552 Zeichen). Das sind genau die Namen in
`C:\Temp\EBILD\Mailverzeichnis\Embedded`. Die Dateien sind 268 und 1163 Byte
groß, SHA-1 gleich dem mit Perl dekodierten Original. Die Angabe im Eintrag
stimmt.

### 1e. Fehlerfälle

**Am Quelltext belegt** (`PGHTMIMP.CPP:3625-3707`):

| Fall | Verhalten |
|---|---|
| Typ nicht in der Liste (`svg+xml`, `webp`) | FALSE, alter Weg (Kürzung) |
| kein `;base64` | FALSE, alter Weg |
| leere Daten (`…;base64,`) | FALSE. Die Schleife `i + 7 < nLaenge` (`:3652`) findet das Komma erst, wenn mindestens 7 Zeichen folgen. Kürzere Daten zählen also als „kein base64". Harmlos, denn es gibt kein Bild unter 5 Byte. |
| Base64 kaputt | `Decode` zählt Ungültiges, der Rückgabewert wird **nicht** gelesen (`:3686`). Geschrieben wird, was herauskommt, und der Lader scheitert. Grauer Kasten wie vorher, dazu eine Datei, die nichts taugt. |
| kein Schreibrecht | `fopen` NULL, FALSE, alter Weg. Richtig. |
| Platte voll | `fwrite` wird nicht geprüft (`:3694`). Eine **abgeschnittene** Datei bleibt liegen, und weil `FileExistsMT` (`:3679`) künftig wahr ist, wird sie **nie** neu geschrieben ([K8](#k8)). |
| FNV-Kollision zweier Bilder | Das zweite Bild bekommt **ohne Meldung die Datei des ersten** ([K8](#k8)). Bei 32 Bit und n verschiedenen Bildern liegt die Wahrscheinlichkeit bei etwa n²/2³³, für 1000 Bilder also bei rund 1:8600. |

### 1f. Senden einer Weiterleitung mit `file://`

**Der lokale Pfad geht nicht hinaus, am Quelltext belegt, nicht gemessen.**
`PGHTMEXP.CPP:953` ruft für jede `file:`-Adresse `EMBED_SAVE_IMAGE` auf, also
`PgSaveUrlImage`. Dort macht `make_new_part_from_file`
(`PgEmbeddedImage.cpp:1128`) daraus einen eingebetteten Teil mit `cid:`. Im
gesendeten HTML steht dann `cid:…`. `alt` bekommt den Dateinamen
`data-xxxxxxxx.png` (`altstring_schmookerdoodle`), aber keinen Pfad.

**Der Haken steckt eine Zeile tiefer:** `QCMessage::AddPart`
(`MimeStorage.cpp:189-203`) **kopiert die Datei nicht.** Der neue Teil zeigt
auf die gemeinsame `Embedded\data-<FNV>.png`. Daraus folgt [K5](#k5).

### 1g. Wird `Embedded\data-*` aufgeräumt?

**Nein, nicht gezielt, am Quelltext belegt.** Nichts sucht nach `data-*`.
Gelöscht wird eine solche Datei nur über `DeleteEmbeddedObjects`
(`tocdoc.cpp:4839`), und zwar dann, wenn eine Nachricht endgültig gelöscht
wird, die sie als eingebetteten Teil führt. Das ist eher zu viel Aufräumen
als zu wenig ([K5](#k5)). Bilder, die nur angezeigt und nie weitergeleitet
werden, bleiben für immer liegen, je Bild einmal. Weil der Name aus dem
Inhalt kommt, wächst das Verzeichnis nicht mit jedem Öffnen.

### 1h. Was nicht gemessen ist

* Ein Bild über 65535 Zeichen Base64 ([K6](#k6)).
* Speichern, Senden, Löschen und Papierkorb leeren einer Weiterleitung mit
  `data:`-Bild ([K5](#k5)). `Out.mbx` am Prüfstand ist leer, die
  Weiterleitung wurde nie gespeichert.
* Die Lader-Zeile für das lange Bild fehlt im Protokoll. Das räumt der
  Eintrag selbst ein.
* Für `E119DataNachDatei` gibt es keinen Testsuite-Fall. Gemessen ist die
  Funktion nur am laufenden Programm.

---

## 2. E-113 — `E113Deckeln`, `E113Seitenbreite`

### 2a. Laufen Metadatei, `embed` und `pict_frame` gleich?

**Am Quelltext belegt: in zwei von drei Fällen ja, im dritten nicht.**

Die Metadatei (`QCGraphics.cpp:178-184`) und `source_*`
(`PgEmbeddedImage.cpp:608-631`) rechnen mit denselben Eingaben, also
Angabe, echter Dateigröße und `nE113Seite`, und mit derselben Regel. Sie
sind gleich. Von `source_*` gehen sie auf `embed`/`pict_frame` über, aber
**nur in zwei Zweigen**:

1. `embed->width == 0 || embed->height == 0` (`:671`): Es fehlt
   mindestens eine Angabe, `embed` wird aus `source_*` gesetzt, also
   gedeckelt. **Gleich.**
2. Der Zweig aus [E-106](../Intern/BEFUNDE.md#e-106) (`:860-861`) läuft nur, wenn
   `nEchtHoehe > embed->height`, die Datei also höher ist als angegeben.
   Dort wird gedeckelt (`:964`). **Gleich.**
3. **Beide Maße angegeben und die Datei nicht höher**, also der Normalfall
   bei Newslettern (`<img width="600" height="224">` zu einer Datei mit
   600×224): Keiner der beiden Zweige läuft. Die Metadatei ist gedeckelt,
   `embed->width/height` und `pict_frame` behalten die Angabe. **Das läuft
   auseinander** ([K9](#k9)).

Beim Import ist `embed` gleich der Angabe, **gemessen** im Prüfstandsprotokoll
`C:\Temp\EBILD\Mailverzeichnis\eudora.log`, z. B. Zeile 986:
`attr=600x230 embed=600x230`.

**Warum die Messung das nicht zeigt (gemessen, ebenda).** Im Verfassen-Fenster
deckelt [E-89](../Intern/BEFUNDE.md#e-89) jede angegebene Breite schon vorher
auf 600 (`msgutils.cpp:3181`, `E89_MAX_BREITE`). Aus `900×345` in der
Prüfnachricht wurde so `attr=600x230`, und `seite=718` ist größer als 600.
Der Fall 3 tritt im Verfassen-Fenster deshalb nur auf, wenn der Textbereich
**schmaler als 600 Punkte** ist: ein schmales Fenster oder die feste
Zeilenbreite (`PgFixedCompMsgView.cpp:225`, Wortumbruchspalte mal
Zeichenbreite, bei 76 Zeichen etwa 460 Punkte). Gemessen ist nur ein Fenster
mit 771 Punkten.

### 2b. `E113Seitenbreite`: Wo ist `wrap_area` sinnvoll?

**Am Quelltext belegt.** Gerechnet wird genau wie bei `page_width` im
HTML-Import (`PGHTMIMP.CPP:244-248`).

* Verfassen-Fenster: Breite des Fensterbereichs, gemessen `seite=718` bei 771
  Punkten Fensterbreite. Die Deckel-Zeilen stehen im Protokoll **nach**
  `OCC: vor MoveWindow`, die gespeicherte Fenstergröße gilt also schon.
  Eine andere Fensterbreite ist **nicht gemessen**.
* Feste Zeilenbreite: die Seite ist die Wortumbruchspalte, nicht das Fenster
  (`PgFixedCompMsgView.cpp:241-265`). Bilder werden auf etwa 460 Punkte
  verkleinert. Das ist folgerichtig, aber ungewohnt.
* Lesefenster: Am Prüfstand liest Trident, nicht Paige (Protokoll:
  `E-80 trident`). Dort wirkt [E-113](../Intern/BEFUNDE.md#e-113) nicht und muss es auch nicht.
* Vorschau: Paige lädt mit `pg` der Vorschau, die Seite ist die
  Vorschaubreite. **Nicht gemessen.**
* Drucken: Die Bilder sind schon geladen, `PgLoadUrlImage` läuft nicht noch
  einmal. Gedruckt wird in der Bildschirmgröße. **Vermutung.**
* Unter 50 Punkten gilt die Seite als unbekannt (`:454`): kein Deckel statt
  Briefmarke. Richtig.

### 2c. Breiten über 32767

**Am Quelltext belegt.** Mit Deckel ist die Breite höchstens `seite`, und
der Überlauf beim `(short)` (`:631`) kann nicht mehr auftreten. Ohne Deckel
(Seite unbekannt) bleibt der alte Überlauf aus
[PRUEFER-48 K4](PRUEFER-48.md#k4). Bei `E113Deckeln` selbst kann nichts
überlaufen: `Höhe × Seite` liegt bei realen Werten weit unter 2³¹.

### 2d. Weitere Aufrufer von `MetafileFromImage`

**Keine, am Quelltext belegt** (grep über `Eudora71/`). Der einzige
Aufrufer ist `PgEmbeddedImage.cpp:588`. Die Ausweichstrecke über QuickTime
(`QTW_MetafileFromQtImage`, `:654`) bekommt aber **weder [E-112](../Intern/BEFUNDE.md#e-112) noch [E-113](../Intern/BEFUNDE.md#e-113)**.
Sie setzt `source_*` auf die Dateigröße ([K10](#k10)).

### 2e. Was zum Empfänger geht

**Am Quelltext belegt.** `PGHTMEXP.CPP:964-968` schreibt `width`/`height`
aus `embed`. Ein gedeckeltes Bild geht also mit der **Fensterbreite des
Absenders** hinaus (`width="718"`). Das tat [E-89](../Intern/BEFUNDE.md#e-89)
mit 600 schon vorher. Ein Hinweis, kein Fehler ([K10](#k10)).

---

## 3. E-77 — modifiziertes UTF-7

### 3a. RFC 3501 5.1.3 gegen den Code

**Gemessen** mit einem eigenen Messprogramm, das
`Tests/generated/imapmailbox_e77.inc` einbindet, also die von `Extract.ps1`
aus `ImapMailbox.cpp:7011-7129` geschnittene echte Quelle (`cl`, Win32):

| Eingabe | Ergebnis | Urteil |
|---|---|---|
| `&APw-` | `ü` | richtig |
| `&APwA9gDk-` | `üöä` | richtig |
| `&-&-` | `&&` | richtig |
| `&IKw-` | `€` (0x80) | richtig |
| `&2D3eAA-` (U+1F600, Surrogatpaar) | FALSE, Name bleibt roh | richtig (nicht in 1252) |
| `&2D0-` (einzelnes Surrogat) | FALSE | richtig |
| `&ZeVnLIqe-` (CJK) | FALSE | richtig |
| `&APw` (ohne `-`) | FALSE | richtig |
| `&APx-` (Füllbits ≠ 0) | `ü` | nachsichtig, RFC 2152 verlangt 0 |
| `&AGE-` (`a` kodiert, RFC verbietet das) | `a` | nachsichtig |
| `&APw-&APY-` (zwei Abschnitte hintereinander, RFC verbietet das) | `üö` | nachsichtig |
| `A&AAk-B` (Tab) | `A\tB` | richtig, aber ein Steuerzeichen im Anzeigenamen |
| `&AAA-` (U+0000) | ok, **Länge 0** | leerer Anzeigename ([K4](#k4)) |
| `&AC8-` (`/` kodiert) | `/` | ein Trenner im Anzeigenamen ([K4](#k4)) |

Kodieren: `Entwürfe → Entw&APw-rfe`, Tab `→ &AAk-`, DEL `→ &AH8-`,
`0x80 → &IKw-`, `0x81 → &AIE-`, `üöä → &APwA9gDk-`. Das alles ist richtig,
und Base64 steht ohne Füllzeichen wie verlangt. **Rundlauf über alle
Einzelbytes 0x01–0xFF: 255 gut, 0 schlecht.**

Grenzfälle beim Kodieren (gemessen):

* `Entw&APw-rfe` (der **rohe** Name) wird zu `Entw&-APw-rfe`. Das ist
  **doppelt kodiert** ([K4](#k4)).
* 300 Umlaute am Stück ergeben FALSE (Puffer 256 WCHAR). Der Wrapper
  `E77ImapNameFuerServer` gibt dann den **Eingang roh** zurück, und an den
  Server gehen 8-Bit-Bytes ([K4](#k4)).

### 3b. Wo der Anzeigename als Schlüssel dient

**Am Quelltext belegt.** Dekodiert wird an genau einer Stelle,
`FormulateFriendlyImapName` (`ImapMailbox.cpp:7148`). Aufgerufen wird sie
nur in `QCImapMailboxDirector.cpp:605` beim Lesen von `mboxlist.lst`.
`m_szImapName` bleibt roh.

| Verwender | Schlüssel | Folge |
|---|---|---|
| Filter (`controls.cpp:335`, `filtersd.cpp:3237`, `:3313`) | Pfad (`m_MailboxPath`), der Text wird neu aus `BuildNamedPath` gebildet | **hält** |
| Liste „Zuletzt benutzt" (`QCMailboxDirector.cpp:1566`) | Pfad | **hält** |
| `[Open Windows]` (`mainfrm.cpp:2513`) | Pfad | **hält** |
| IMAP-Papierkorb (`ModifyAcctDlgs.cpp:788`, `ImapAccount.cpp:1317`) | Servername | **hält**, aber das Kontofenster zeigt den Namen roh |
| Doppelnamen beim Anlegen (`newmbox.cpp:102`) | Anzeigename gegen Eingabe | **jetzt richtig** (vorher roh gegen Umlaut) |
| `ImapFindByName` mit Kontonamen (`QCImapMailboxDirector.cpp:120`, `:342`, `:384`, `:441`, `ImapAccountMgr.cpp:1453`) | Kontoebene, nicht dekodiert | **hält** |
| Fcc in gespeicherten Nachrichten (`compmsgd.cpp:3629` schreibt `BuildNamedPath`, `sendmail.cpp:384` sucht `FindByNamedPath`) | **Anzeigename** | **bricht** für vorher gespeicherte Nachrichten ([K3](#k3)) |
| Ziel beim Junk-Kürzen (`tocdoc.cpp:4080`, INI) | Anzeigename | bricht genauso, falls dort ein IMAP-Ordner mit Umlaut steht ([K3](#k3)) |
| `FilterReportView.cpp:402` | Anzeigename aus der eigenen Liste, gebildet in derselben Sitzung | **hält** |
| Prüfung nach dem Löschen (`QCImapMailboxDirector.cpp:1789`) | vergleicht `GetImapName()` mit `GetName()`, das passte schon vorher nur auf oberster Ebene | jetzt gar nicht mehr. Bedeutungslos, denn die Prüfung schlug vorher schon kaum an. |
| Menü *Transfer*, Ordnerbaum | Anzeige | `&` aus `&-` wird zur Zugriffstaste, ein Maskieren als `&&` gibt es nicht ([K4](#k4)) |

**Gegenvermutung „ein Ordner wird nicht mehr gefunden" — für Fcc
bestätigt** ([K3](#k3)). Alles, was über den Pfad oder den Servernamen geht,
findet weiter.

### 3c. Umbenennen

**Am Quelltext belegt.** Der Umbenennen-Dialog und die Bearbeitung im
Ordnerbaum (`mboxtree.cpp:1725`) zeigen den Anzeigenamen, also den
dekodierten. Getippt wird die neue Fassung im Klartext.

* `CImapAccount::RenameMailbox` kodiert für den **Server** richtig
  (`ImapAccount.cpp:3026`, `:3037`, `:3043`), **außer für INBOX**: Der Zweig
  `:2998`/`:3013` nimmt den Namen roh ([K2](#k2)).
* Danach setzt `QCMailboxDirector::UpdateAfterRename`
  (`QCImapMailboxDirector.cpp:2475`) den **Namen in Eudora** aus demselben
  ungekodierten Text: `szNewFullImapName = pNewName` bzw.
  `+= pNewName` (`:2516`, `:2522`), dann `SetImapName` (`:2526`). Die
  Unterordner übernehmen diesen Vorsatz (`:3020`), und alles wird in
  `mboxlist.lst` geschrieben (`:2564`). Eudora und der Server führen den
  Ordner danach unter **zwei verschiedenen Namen** ([K1](#k1)).
* **Doppelt kodiert** wird ein Name, der bereits `&` enthält, dann, wenn der
  Anzeigename roh geblieben war (nicht in 1252 darstellbar, z. B. ein
  Emoji-Ordner `&2D3eAA-`) und der Benutzer ihn umbenennt. Gemessen am
  Beispiel `Entw&APw-rfe → Entw&-APw-rfe` ([K4](#k4)). Ein getipptes `&`
  wird richtig zu `&-`.

### 3d. Was nicht gemessen ist

* Anlegen und Umbenennen am Server. Der Eintrag nennt das selbst, der
  Prüfserver kennt `CREATE` und `RENAME` nicht. [K1](#k1) wäre dort sofort
  sichtbar geworden.
* Fcc auf einen Umlaut-Ordner über das Update hinweg.

---

## Funde

### <a id="k1"></a>K1 — E-77: Nach dem Umbenennen führt Eudora den Ordner unter einem anderen Namen als der Server

**Am Quelltext belegt, nicht gemessen.** `UpdateAfterRename`
(`QCImapMailboxDirector.cpp:2516`, `:2522`) bildet `m_szImapName` aus der
**ungekodierten** Eingabe. An den Server geht über
`CImapRenameMailboxAction` die kodierte Fassung (`ImapAccount.cpp:3026-3043`).
Nennt man `Test` in `Entwürfe` um, heißt der Ordner danach auf dem Server
`INBOX/Entw&APw-rfe`, in Eudora aber `INBOX/Entwürfe` mit rohem 0xFC. Dieser
Name steht in `mboxlist.lst` und wird bei jedem Öffnen, Abgleichen und
Übertragen an den Server geschickt. Der Server kennt ihn nicht. Unterordner
erben den falschen Vorsatz (`:3020`). Ein Abgleich, der die Ordnerliste neu
holt, ist im Weg nicht vorgesehen (`ImapActionQueue.cpp:2834`). Wann
der Fehler heilt, ist **nicht untersucht** (**Vermutung**: erst beim
nächsten Abholen der Ordnerliste vom Server).

Dasselbe gilt für ein `&` im neuen Namen: In Eudora steht `Tom & Jerry`, auf
dem Server `Tom &- Jerry`.

**Keine Verschlechterung gegenüber 7.2.0.120:** Vorher ging der rohe Name
auch an den Server, und dort scheiterte das Umbenennen. Aber
**[E-77](../Intern/BEFUNDE.md#e-77) darf Umbenennen nicht als behoben
führen.**

**Behebung (ungemessen):** in `UpdateAfterRename` beide Zeilen auf
`E77ImapNameFuerServer(pNewName)` umstellen. Der Anzeigename (`SetName`, `:2506`) bleibt der getippte. Gegenprobe: am Prüfserver `RENAME` nachrüsten,
umbenennen, dann `mboxlist.lst` und den nächsten `SELECT` im Protokoll lesen.
**Wichtig (Funktion).**

### <a id="k2"></a>K2 — E-77: Umbenennen von INBOX wird nicht kodiert

**Am Quelltext belegt.** `ImapAccount.cpp:2998` und `:3013` übernehmen
`szNewImapName` ohne `E77ImapNameFuerServer`. Von den vier Stellen, an denen
der Servername entsteht, ist eine vergessen. INBOX umbenennen ist selten.
Mit [K1](#k1) zusammen beheben. **Gering.**

### <a id="k3"></a>K3 — E-77: Gespeicherte Fcc-Ziele auf Umlaut-Ordner gehen ohne Meldung verloren

**Am Quelltext belegt, nicht gemessen.** Fcc steht als **benannter Pfad** in
der Bcc-Zeile der gespeicherten Nachricht: `"\x83\" + BuildNamedPath(…)`
(`compmsgd.cpp:3629-3630`). Beim Senden sucht `sendmail.cpp:384`
`FindByNamedPath`, und das vergleicht Glied für Glied mit `GetName()`
(`QCMailboxDirector.cpp:956-991`). Eine Nachricht, die vor 7.2.0.123 mit Fcc
auf `Entw&APw-rfe` gespeichert wurde (Out, Warteschlange, Briefpapier), trägt
den rohen Namen. Jetzt heißt der Ordner `Entwürfe`, `FindByNamedPath` gibt
NULL, und `if (pCommand != NULL)` überspringt die Ablage **ohne Meldung**.
Gesendet wird trotzdem, es fehlt nur die Kopie im Ordner.

Ebenso wirkt es bei `IDS_INI_JUNK_TRIM_MAILBOX` (`tocdoc.cpp:4080`), falls
dort ein IMAP-Ordner mit Umlaut eingetragen ist.

**Behebung (ungemessen):** in `FindByNamedPath` nach einem Fehlschlag das
Glied mit `E77ImapNameZurAnzeige` dekodieren und noch einmal suchen. Das ist
eine Zeile je Suchstelle. Ein alter roher Name wird so gefunden, ein neuer
dekodierter ändert sich nicht. **Mittel (Funktion, alte Daten).**

### <a id="k4"></a>K4 — E-77: Grenzfälle der Kodierung

**Gemessen** (Messprogramm, Abschnitt 3a):

* `&AAA-` ergibt einen **leeren** Anzeigenamen, weil das Nullbyte die
  CString abschneidet. Vorschlag: Zeichen unter U+0020 als nicht darstellbar
  behandeln (FALSE, Name bleibt roh).
* `&AC8-`/`&AFw-` ergeben `/` bzw. `\` im Anzeigenamen. `\` würde
  `FindByNamedPath` zerlegen (`QCMailboxDirector.cpp:970`). Ein Server, der
  sich an die RFC hält, schickt das nie, weil druckbares ASCII nicht kodiert
  wird.
* Nachsichtig bei nicht kanonischen Formen (Füllbits, kodiertes ASCII, zwei
  Abschnitte hintereinander). Für die Anzeige harmlos.
* **Doppelte Kodierung** beim Umbenennen eines roh gebliebenen Namens:
  `Entw&APw-rfe → Entw&-APw-rfe`.
* Mehr als 256 Nicht-ASCII-Zeichen am Stück: Das Kodieren scheitert, und
  `E77ImapNameFuerServer` schickt den **rohen** Eingang. Besser wäre
  Ablehnen.
* `&` im Anzeigenamen wird im Menü zur Zugriffstaste (**am Quelltext
  belegt**: kein `&&` in `QCMailboxDirector.cpp`, `DynamicMailboxMenu.cpp`,
  `mboxtree.cpp`, `QCMailboxTreeCtrl.cpp`). Vorher wurde `&-` genauso falsch
  gezeigt.

**Gering.** Für keinen dieser Fälle gibt es einen Testsuite-Fall.

### <a id="k5"></a>K5 — E-119: Die Bilddatei ist geteilt, endgültiges Löschen einer Nachricht löscht sie für alle

**Am Quelltext belegt bis `DeleteEmbeddedObjects`, die letzte Stufe ist
Vermutung.** Die Kette:

1. `E119DataNachDatei` legt **eine** Datei je Bildinhalt an
   (`Embedded\data-<FNV>.<endung>`) und nimmt sie beim nächsten Mal wieder
   (`PGHTMIMP.CPP:3679`).
2. Beim Speichern einer Antwort oder Weiterleitung macht
   `make_new_part_from_file` daraus einen Teil, und `QCMessage::AddPart`
   (`MimeStorage.cpp:189-203`) trägt die **vorhandene** Datei ein, ohne
   Kopie.
3. Beim endgültigen Löschen (`tocdoc.cpp:2809` `if (Purging)` → `:2932`)
   und beim Leeren des Papierkorbs (`:3935`) löscht
   `DeleteEmbeddedObjects` jede Datei der Nachricht, die `InEmbeddedDir`
   meldet (`:4839-4870`). `data-*` liegt in `Embedded`.

Folge: Man leitet dasselbe Newsletter-Bild zweimal weiter oder antwortet und
leitet weiter. Wird eine der beiden Kopien endgültig gelöscht, verliert die
andere ihr Bild, ob Entwurf, Nachricht in der Warteschlange oder gesendete
Kopie. Öffnet man die Originalnachricht noch einmal, entsteht die Datei neu
und alle sind „geheilt". Ohne das Original bleibt das Bild weg. Was ein
Entwurf in der Warteschlange ohne seine Datei **beim Senden** tut, ist
**nicht untersucht**.

**Zum Vergleich, gemessen in `C:\Temp\EBILD\Mailverzeichnis\In.mbx`:**
Eudora legt sonst **jedem** eingebetteten Teil eine eigene Datei an
(`gross-330x327.png`, `gross-330x3271.png`, `gross-330x3272.png` für
dasselbe Bild in drei Nachrichten). Teilen ist dort bewusst vermieden.

**Behebung (ungemessen):** in `PgSaveUrlImage` eine `file://`-Adresse unter
`Embedded\data-` wie eine `cid:` behandeln und über `NewPart` kopieren.
Dann gehört jeder Nachricht ihre eigene Kopie. Messbar am Prüfstand:
weiterleiten, speichern, zweimal; eine Kopie über `Trash` endgültig löschen,
die andere öffnen. **Wichtig (Daten), hält das Paket nicht auf**, weil vorher
gar kein Bild ankam.

### <a id="k6"></a>K6 — E-119: Bilder über rund 48 KB kommen abgeschnitten an

**Am Quelltext belegt, Zählerüberlauf gemessen.** `GetNextToken` zählt die
Länge in `pg_short_t` (`unsigned short`, `CPUDEFS.H:487`;
`PGHTMIMP.CPP:1130`, `:1149`). Nach 70000 Zeichen steht er bei **4464**
(Messprogramm). `E119DataNachDatei` bekommt dann nur `Länge mod 65536`
Zeichen, dekodiert einen Anfang des Bildes und legt ihn unter dem Hash dieses
Anfangs ab. 65535 Zeichen Base64 sind etwa 48 KB Bild. Newsletter-Fotos sind
oft größer.

Keine Verschlechterung, denn vorher wurde auf 1023 Zeichen gekürzt. Aber die
Behebung reicht nicht so weit, wie der Eintrag nahelegt.

**Behebung (ungemessen):** in `ProcessAttributes` für den `data:`-Fall die
Länge selbst bestimmen. `command` zeigt in `attribute_ptr`, das Ende ist
das schließende Anführungszeichen bzw. das nächste Leerzeichen; dieselbe
Regel wie `GetNextToken`, aber in `long`. Ein Prüffall mit einem Bild von
50 KB gehört in `Testdaten/`. **Mittel.**

### <a id="k7"></a>K7 — E-119: Wirkt auf jedes Attribut, ein `<a href="data:image/…">` trägt den lokalen Pfad hinaus

**Am Quelltext belegt, nicht gemessen.** Der Aufruf steht in
`ProcessAttributes` vor jeder Unterscheidung nach Attribut oder Tag
(`PGHTMIMP.CPP:3733-3738`). Ein `href` geht unverändert in den Link
(`:3414-3449`) und wird beim Antworten oder Weiterleiten als `href`
geschrieben (`PGHTMEXP.CPP:349-363`). Anders als bei `<img>` gibt es dort
**keine** Umwandlung in `cid:`. Der Empfänger bekäme
`href="file://C:\Users\<Name>\…\Embedded\data-xxxxxxxx.png"`. Das ist ein
toter Link mit dem Windows-Benutzernamen darin. Selten, denn
`data:image/` in `href` kommt kaum vor (Phishing nimmt `data:text/html`, und
das fängt die Typliste ab).

**Behebung (ungemessen):** nur für `item_id == image_url_attribute` aufrufen.
`item_id` ist an der Stelle schon bekannt (`:3722`). Für `background` usw.
gilt dann wieder der alte Weg. **Mittel (Datenschutz), selten.**

### <a id="k8"></a>K8 — E-119: abgeschnittene Datei bleibt für immer, Kollision zeigt das falsche Bild

**Am Quelltext belegt.** `fwrite` wird nicht geprüft (`:3694`). Eine halbe
Datei (Platte voll) wird wegen `FileExistsMT` (`:3679`) nie ersetzt. Bei
einer FNV-32-Kollision zeigt das zweite Bild ohne Meldung das erste.
Vorschlag: in eine Temp-Datei schreiben, die Länge prüfen, dann
umbenennen, und die Bytelänge in den Namen aufnehmen
(`data-<FNV>-<Länge>.png`). Damit wird eine Kollision praktisch unmöglich.
**Gering.**

### <a id="k9"></a>K9 — E-113: Bei vollständiger Größenangabe wird nur die Metadatei verkleinert, nicht der Rahmen

**Am Quelltext belegt, nicht gemessen** (Abschnitt 2a, Fall 3). Gemalt wird
z. B. in 460×172, Rahmen und Zeilenhöhe bleiben 600×224. Das Bild hängt
oben, darunter bleibt eine leere Fläche von 52 Punkten, und der Rahmen ragt
rechts über den Textbereich hinaus, samt waagerechtem Rollbalken. Das ist
das Muster aus [E-106](../Intern/BEFUNDE.md#e-106), vor dem der Kommentar in
`E113Deckeln` selbst warnt. Im Verfassen-Fenster nur bei einem Textbereich
unter 600 Punkten (schmales Fenster, feste Zeilenbreite). In Paige-Ansichten
ohne [E-89](../Intern/BEFUNDE.md#e-89) (Lesen mit Paige statt Trident,
Vorschau) schon ab einer Angabe, die breiter ist als die Seite.

**Behebung (ungemessen):** die Bedingung des Rahmenzweigs (`:860-861`)
erweitern um `|| (nE113Seite > 0 && embed->width > nE113Seite)`. Der Zweig
rechnet dann über `E112Zielrechteck` + `E113Deckeln` genau das, was auch die
Metadatei bekam. Prüfung am Prüfstand: `Testdaten/e113-breites-bild.eml`
mit festem Zeilenumbruch oder einem Verfassen-Fenster unter 650 Punkten
Breite; die Zeilen `E-112 Metadatei … gemalt=` und `E-106 …` bzw.
`E-103 Nachtrag …` müssen dasselbe Maß nennen. **Wichtig (Darstellung).**

### <a id="k10"></a>K10 — E-113: QuickTime-Weg ohne Deckel; gedeckelte Größe geht zum Empfänger

**Am Quelltext belegt.** `QTW_MetafileFromQtImage` (`:654`) setzt
`source_*` auf die Dateigröße, ohne [E-112](../Intern/BEFUNDE.md#e-112) und ohne [E-113](../Intern/BEFUNDE.md#e-113). Das gilt nur für
Formate, die SECImage nicht kann, und nur bei installiertem QuickTime.
`PGHTMEXP.CPP:964-968` schreibt die gedeckelte Größe ins gesendete HTML, also
die Fensterbreite des Absenders. Variante B (neu rechnen beim Ziehen am
Fenster) ist laut Eintrag ausdrücklich nicht gebaut. **Gering / Hinweis.**

### <a id="k11"></a>K11 — E-145 (neu): `Base64Decoder` liest bei Bytes über 127 vor seiner Tabelle

**Am Quelltext belegt, Vorzeichen gemessen. Originalfehler von QUALCOMM.**
`Base64Decoder::Decode(const char* In, …)` indiziert `g_Decode[*In]`
(`Eudora/Base64.cpp:166`). `char` ist vorzeichenbehaftet: `Eudora.vcxproj`
setzt weder `/J` noch `CharUnsigned`, und das Messprogramm liefert für 0xE4
den Index **−28**. Ein Byte ab 0x80 im Base64-Text liest also bis zu 128
Byte **vor** `g_Decode`. Was dort steht (vermutlich `g_Encode`, ASCII-Werte
über 63), wird als 6-Bit-Wert verarbeitet, statt als ungültig gezählt zu
werden. Folge: falsch dekodierte Bytes statt übersprungener. Ein Absturz ist
nicht zu erwarten, denn es sind statische Daten im selben Abschnitt
(**Vermutung**).

Betroffen ist jeder Base64-Weg, Anhänge eingeschlossen. Mit
[E-119](../Intern/BEFUNDE.md#e-119) kommt ein neuer Weg hinzu, auf dem
fremde Bytes aus einem HTML-Attribut ankommen.

**Behebung:** `g_Decode[(unsigned char)*In]`, eine Zeile. Prüffall in
`Tests/` mit `"QQ\xE4=="`: Das Byte muss als ungültig zählen, die Ausgabe
`A` bleiben. **Gering.** Kennung **E-145** ist hiermit vergeben, aber noch
nicht in `Intern/BEFUNDE.md` eingetragen; das gehört nicht zu meinem
Auftrag.

---

## Gegenvermutungen, die ich aufgestellt habe

| Gegenvermutung | Ergebnis |
|---|---|
| `szE119Datei` ist beim `pgBlockMove` schon ungültig | **widerlegt**: selber Block (`PGHTMIMP.CPP:3734`/`:3743`) |
| Ein langer Pfad wird in `URL[512]` abgeschnitten | **widerlegt**: Schranke `+8 >= 511` (`:3676`) |
| `<base href>` wird vor `file://` gehängt | **widerlegt**: `file:` ist ein URL-Schema (`EudoraRes.rc:10846`) |
| Der lokale Pfad geht beim Senden eines `<img>` zum Empfänger | **widerlegt am Quelltext**: `file:` wird zu `cid:` (`PGHTMEXP.CPP:953`) |
| … und bei `<a href>` | **bestätigt am Quelltext** ([K7](#k7)) |
| Die geteilte Datei ist sicher, weil nichts in `Embedded` löscht | **widerlegt**: `DeleteEmbeddedObjects` ([K5](#k5)) |
| Jedes beliebig große `data:`-Bild kommt jetzt an | **widerlegt**: Zähler `unsigned short` ([K6](#k6)) |
| Die abgelegten Dateien weichen vom Original ab | **widerlegt, gemessen**: SHA-1 gleich, FNV-Namen nachgerechnet |
| Metadatei und Zeilenumbruch laufen bei [E-113](../Intern/BEFUNDE.md#e-113) immer gleich | **widerlegt am Quelltext** für vollständige Angaben ([K9](#k9)) |
| Die Messung hätte [K9](#k9) zeigen müssen | **widerlegt, gemessen**: [E-89](../Intern/BEFUNDE.md#e-89) deckelt vorher auf 600, die Seite war 718 |
| Es gibt weitere Aufrufer von `MetafileFromImage` ohne Grenze | **widerlegt**: nur einer; der QuickTime-Weg ist eine andere Funktion ([K10](#k10)) |
| `E113Seitenbreite` misst etwas anderes als `page_width` | **widerlegt**: gleiche Rechnung (`PGHTMIMP.CPP:244-248`) |
| Der Decoder verliert ein Zeichen aus 1252 im Rundlauf | **widerlegt, gemessen**: 255/255 |
| Surrogatpaare ergeben Unsinn | **widerlegt, gemessen**: FALSE, Name bleibt roh |
| Ein Ordner, dessen Name sich durch die Dekodierung ändert, wird nicht mehr gefunden | **bestätigt** für Fcc und Junk-Ziel ([K3](#k3)), **widerlegt** für Filter, „Zuletzt benutzt", `[Open Windows]`, Papierkorb |
| Umbenennen bildet den Servernamen richtig | **für den Server bestätigt, für Eudora widerlegt** ([K1](#k1)), INBOX gar nicht ([K2](#k2)) |
| Ein Name mit `&` wird doppelt kodiert | **bestätigt, gemessen**, aber nur bei roh gebliebenen Namen ([K4](#k4)) |
| Der Anzeigename landet als lokales Verzeichnis | **widerlegt**: das Verzeichnis kommt aus `pImapName` (`ImapAccount.cpp:2717`, `MakeSuitableMailboxName`) |

## Was gelaufen ist

* `Eudora71/Tests/RunTests.cmd` im Arbeitsbaum `Eudora7.2-wt-pruefer`
  (MSBuild Debug Win32): **286 Tests, 286 bestanden**, Rückgabe 0. Keine
  Gegenprobe im Quelltext, denn die Auflage lautet „keine
  Quelltextänderung". Die Gegenproben laufen im Messprogramm.
* Messprogramm im Scratch-Verzeichnis (`cl`, Win32), das die geschnittene
  `imapmailbox_e77.inc` einbindet, dazu Zählerüberlauf und Vorzeichen von
  `char`. Nichts davon liegt im Repo.
* Gelesen, nichts verändert: `C:\Temp\EBILD\Mailverzeichnis\eudora.log`,
  `In.mbx`, `Out.mbx`, `Embedded\data-*` (SHA-1). `Testdaten/e119-data-bild.eml`
  mit Perl dekodiert und FNV-1a nachgerechnet.
* Kein Eudora gestartet, kein Fenster, Eudora nicht gebaut.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| [K1](#k1) | [E-77](../Intern/BEFUNDE.md#e-77): Nach dem Umbenennen (Umlaut, `&`) führt Eudora den Ordner unter einem anderen Namen als der Server; Zugriffe gehen ins Leere | wichtig (Funktion) | nein, vorher scheiterte schon das Umbenennen; **Eintrag berichtigen**, Behebung zwei Zeilen |
| [K5](#k5) | [E-119](../Intern/BEFUNDE.md#e-119): Die geteilte Bilddatei wird beim endgültigen Löschen **einer** Nachricht für alle gelöscht | wichtig (Daten) | nein, vorher kein Bild |
| [K9](#k9) | [E-113](../Intern/BEFUNDE.md#e-113): Bei vollständiger Angabe läuft der Rahmen auseinander (Muster [E-106](../Intern/BEFUNDE.md#e-106)), im Verfassen-Fenster erst unter 600 Punkten | wichtig (Darstellung) | nein |
| [K3](#k3) | [E-77](../Intern/BEFUNDE.md#e-77): Fcc aus vorher gespeicherten Nachrichten auf Umlaut-Ordner fällt ohne Meldung aus | mittel | nein; im Eintrag nennen |
| [K6](#k6) | [E-119](../Intern/BEFUNDE.md#e-119): Bilder über ~48 KB abgeschnitten (`unsigned short`) | mittel | nein |
| [K7](#k7) | [E-119](../Intern/BEFUNDE.md#e-119): `<a href="data:image/…">` trägt den lokalen Pfad zum Empfänger | mittel (Datenschutz), selten | nein |
| [K2](#k2) | [E-77](../Intern/BEFUNDE.md#e-77): INBOX-Umbenennen nicht kodiert | gering | nein |
| [K4](#k4) | [E-77](../Intern/BEFUNDE.md#e-77): Grenzfälle (U+0000 leer, doppelte Kodierung roher Namen, Rückfall auf rohe Bytes, `&` im Menü) | gering | nein |
| [K8](#k8) | [E-119](../Intern/BEFUNDE.md#e-119): halbe Datei bleibt für immer, FNV-Kollision zeigt das falsche Bild | gering | nein |
| [K10](#k10) | [E-113](../Intern/BEFUNDE.md#e-113): QuickTime-Weg ohne Deckel; Absender-Fensterbreite geht zum Empfänger | gering / Hinweis | nein |
| [K11](#k11) | **E-145 (neu)**: `Base64Decoder` liest bei Bytes über 127 vor der Tabelle | gering, Original | nein |

**Vergeben: E-145. Frei: E-146.** Eingetragen in `Intern/BEFUNDE.md` ist
nichts.
