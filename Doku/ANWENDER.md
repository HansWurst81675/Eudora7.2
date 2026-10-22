# Was Eudora 7.2 kann und was nicht

Zurück zum [Einstieg](../README.md).

## Was es nicht kann

* **Kein fertiges Installationsprogramm.** Es gibt ein ZIP, sonst nichts.
* **LDAP, Ph, S/MIME und die Suche über den Verzeichnisdienst fallen aus —
  das eigene Adressbuch nicht.** Diese Teile brauchen
  `MFC71.DLL` und `MSVCP71.dll` von 2003, und Microsoft hat sie nie zur
  Weitergabe freigegeben. Der Start ist davon nicht betroffen (Befund
  [**E-47**](../BEFUNDE.md#e-47)). **Nicht gemeint ist das eigene Adressbuch**
  (*Tools → Address Book*, die Kurznamen-Leiste): es ist in `Eudora.exe`
  übersetzt — `nickdoc.cpp`, `nicktree.cpp`, `nickpage.cpp` und
  `NicknamesWazooWnd.cpp` stehen in `Eudora71/Eudora/Eudora.vcxproj` —,
  braucht kein `MFC71.DLL` und arbeitet; in 1.0.119 und 1.0.120 sind zwei
  Fehler darin behoben und von Gregor bestätigt
  ([E-134](../BEFUNDE.md#e-134), [E-135](../BEFUNDE.md#e-135)). `EudoraBk.dll`
  klingt nach Adressbuch, ist aber der Protokollanbieter *„EudoraBk
  Protocol"* des Verzeichnisdienstes
  (`DirectoryServices/DirectoryServicesUI/inc/RegisterComponentImpl.h:67`).
* **Eine Filterregel verträgt bloßes Ansehen wieder.** Eine Regel der Form
  *„Junk Score is less than N"* wurde unbrauchbar, sobald man sie im
  Filterfenster anklickte ([**E-67**](../BEFUNDE.md#e-67)); die Korrektur steht seit
  7.2.0.43 im Code und ist seit 17.10.2026 am laufenden Programm gemessen. Das Filtern selbst arbeitet korrekt — dass
  ein Lauf über ein ganzes Postfach *alle* Nachrichten verschob ([**E-64**](../BEFUNDE.md#e-64)),
  ist behoben und am 10.09.2026 bestätigt. Was Filter können und wo ihre
  Grenzen liegen, steht in [FILTER.md](../FILTER.md).
* **HTML-Nachrichten werden beim Lesen inzwischen richtig dargestellt**
  ([**E-86**](../BEFUNDE.md#e-86), behoben in 7.2.0.55): MSHTML lief ohne `X-UA-Compatible` im
  IE-7-Modus von 2006. Im **Verfassenfenster** bleibt die Darstellung schlicht
  — siehe *Wo die Grenzen liegen* weiter unten.
* **IMAP-Postfachnamen mit Umlauten stehen roh da** ([**E-77**](../BEFUNDE.md#e-77), offen):
  `Entw&APw-rfe` statt *Entwürfe*. IMAP selbst läuft — von Gregor am
  10.09.2026 bestätigt: *„imap: funktioniert"*, `imap.gmx.net:993`.
* **Das neueste Release ist `v1.0.120`** (veröffentlicht am 21.10.2026 um 19:07:37 UTC, Marke auf `30feeae2`, ZIP `Eudora72-1.0.120-release.zip`, 9.381.870 Byte, SHA-256 `26fde414…3af6a6a1`): es trägt drei Fassungen — die Vervollständigungsbox im `To:`-Feld schrumpft nicht mehr ([E-135](../BEFUNDE.md#e-135)), der Kurzname eines neuen Adressbucheintrags kommt an ([E-134](../BEFUNDE.md#e-134)), und eine fehlgeschlagene Rückfrage übernimmt nicht mehr das fremde Verzeichnis ([E-132](../BEFUNDE.md#e-132)). Davor `v1.0.117` (07:56:56 UTC, Marke `f546b004`): Eudora fragt, bevor es das Mailverzeichnis einer fremden Installation übernimmt — auf allen Startwegen und auch bei einer kopierten Sicherung ohne `Eudora.ini`. Davor `v1.0.113` (20.10.2026 um 13:01
  ohne `Eudora.ini`. Davor erschienen `v1.0.113` und `v1.0.112` am 20.10.2026
  sowie `v1.0.101` am 17.10.2026 — alle drei überholt.
  IMAP-Ordner verliert keine Mail mehr**, auch gesendete und mehrere auf einmal –
  bis auf einen seltenen, vermuteten Fall bei gesendeter Post (siehe *Auf einen Blick*)
  ([E-121](../BEFUNDE.md#e-121)); HTML-Mails und eingebettete Bilder kommen dort vollständig an
  ([E-118](../BEFUNDE.md#e-118)); sauberes Beenden ([E-83](../BEFUNDE.md#e-83)); der Filterfehler
  [E-67](../BEFUNDE.md#e-67) gemessen; von Gregor an 1.0.101 bestätigt. Bekannte Fehler: siehe
  *Auf einen Blick* oben. Sonst wie `v1.0.87`:
* **`v1.0.87`** (veröffentlicht am 14.10.2026 um 05:46
  Uhr UTC, bis 17.10.2026 das Release auf GitHub,
  https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.87) — Bilder in
  der angegebenen Größe ([E-112](../BEFUNDE.md#e-112) mit [E-103](../BEFUNDE.md#e-103)),
  Ctrl+F bei aktivem IMAP-Postfach ([E-115](../BEFUNDE.md#e-115)) und `&amp;` in
  Bildadressen ([E-117](../BEFUNDE.md#e-117)); alle von Gregor vorher an 1.0.86 und
  1.0.87 bestätigt. Das Mailverzeichnis im ZIP ist leer (nur die Vorgabe-`Eudora.ini`):
  ein vorhandenes Mailverzeichnis hineinkopieren. Sonst wie `v1.0.84`:
* **`v1.0.84`** (veröffentlicht am 12.10.2026 um 12:59
  Uhr UTC) — **[E-94](../BEFUNDE.md#e-94) behoben**: Betreffs werden nicht
  mehr mitten im Wort umbrochen; von Gregor vorher an seinem Postfach geprüft
  (Bildschirmfoto). Sonst wie `v1.0.83`:
* **`v1.0.83`** (veröffentlicht am 12.10.2026 um 11:18 Uhr UTC) — **von Gregor
  vorher am laufenden Programm geprüft**, über IMAP an seinem Postfach: *„gekürzt mit endung reicht"*. Neu
  darin: **Anhänge behalten Endung und Namen** ([AN-1](../BEFUNDE.md#an-1), über POP und IMAP gemessen)
  und, übersetzt, aber damals am Programm nicht gemessen (seit 13.10.2026 von Gregor an 1.0.84 bestätigt), [**AN-2**](../BEFUNDE.md#an-2) (kein Quelltext einer
  Webseite mehr im Werbefenster). Das Release davor war **`v1.0.72`** (17.09.2026,
  von Gregor geprüft: *„kein crash"*). **Seit `v1.0.72` im Download enthalten**
  sind damit: Zeichensalat
  beim IMAP-Abruf (7.2.0.52), das Beenden mit hängender Aufgabe (7.2.0.53), die
  HTML-Darstellung beim Lesen (7.2.0.55), der Formatverlust beim Weiterleiten
  (7.2.0.56), sich überlagernde Bilder im Verfassenfenster (7.2.0.58),
  Fragezeichen statt Emoji (7.2.0.59), **Inhaltsverlust beim Weiterleiten**
  einer bereits weitergeleiteten Nachricht (7.2.0.59, [**E-93**](../BEFUNDE.md#e-93) — es gingen
  17.889 statt 105.125 Byte hinaus), die **Bildgrößen im Verfassenfenster**
  (7.2.0.62, [**E-96**](../BEFUNDE.md#e-96); der Notbehelf davor ist mit 7.2.0.63 wieder weg), der
  **Absturz beim Speichern einer Nachricht** (7.2.0.64, [**E-97**](../BEFUNDE.md#e-97), von Gregor an
  1.0.64 bestätigt), der **Datenverlust beim Senden eines gesicherten
  Entwurfs** (7.2.0.64, [**E-99**](../BEFUNDE.md#e-99)), dieselbe Absturzstelle an drei weiteren
  Stellen (7.2.0.65, [**E-100**](../BEFUNDE.md#e-100)), die **unbrauchbare gespeicherte Datei**
  (7.2.0.66 und 7.2.0.69, [**E-101**](../BEFUNDE.md#e-101) — ohne `Content-Type`-Zeile und mit Eudoras
  internem Marker `<x-html>`; ohne *Kopfzeilen einschließen* fehlte der
  `Content-Type` zunächst ganz; **seit 13.10.2026 wieder offen**, siehe unten),
  **Bilder, die über dem Text lagen** (7.2.0.67,
  [**E-103**](../BEFUNDE.md#e-103) — **an 1.0.84 von Gregor widerlegt**, der Rückfall kommt aus
  [E-112](../BEFUNDE.md#e-112), siehe unten), **zusammengeklebte Kopfzeilen in der gespeicherten Datei**
  (7.2.0.67 für die verfasste, 7.2.0.68 für die empfangene Nachricht,
  [**E-104**](../BEFUNDE.md#e-104)), **Bilder, die größer sind als im HTML angegeben und deshalb über
  dem Text liegen** (7.2.0.68, [**E-106**](../BEFUNDE.md#e-106) — **von Gregor am 17.09.2026 an 1.0.69
  bestätigt**) und der **Absturz beim Antworten auf eine geöffnete Nachricht**
  ([**E-107**](../BEFUNDE.md#e-107) war die falsche Erklärung und ist widerlegt; [**E-108**](../BEFUNDE.md#e-108) in 7.2.0.72
  entfernt den Stilweg, der ihn ausgelöst hat — **von Gregor am 17.09.2026 an
  1.0.72 bestätigt**: *„kein crash"*, und sein Protokoll läuft über die bisher
  tödliche Stelle hinaus bis `Logging shutdown`, ohne `Exception.log`).
  **`1.0.71` darf nicht benutzt werden**: diese Fassung stürzt beim Antworten
  ab, ist nie veröffentlicht worden und liegt nur noch als Paket in Gregors
  Testverzeichnis.
  > **Berichtigt am 17.09.2026 (LEKTOR, [L-13.1](../Befunde/LEKTOR-13.md#l-13.1)).** Bis hierher stand hier
  > *„das neueste Release ist `v1.0.50`"* und darunter eine Warnung, das
  > veröffentlichte Paket stürze beim Speichern ab. Beides war überholt:
  > `gh release list` nennt `v1.0.64` als *Latest*, und genau dort ist [E-97](../BEFUNDE.md#e-97)
  > behoben. Die Warnung hätte Anwender von einem Download abgehalten, der
  > den gewarnten Fehler nicht mehr hat.
* **Wer noch `v1.0.50` oder älter benutzt: *File → Save As* beendet Eudora
  sofort** ([**E-97**](../BEFUNDE.md#e-97)): der Windows-Dateidialog ruft
  `CSaveAsDialog::OnTypeChange` auf, bevor der Dialog fertig aufgebaut ist,
  und ein ungeprüfter `GetParent()` liefert dort `NULL`. Der Fehler steckt in
  **jeder** Fassung von 1.0.49 bis 1.0.63.
  Behoben in **7.2.0.64** und im Release **`v1.0.64`**; wer ein älteres Paket benutzt,
  speichert Nachrichten bis dahin besser nicht.
* **Im Dialog *Speichern unter* fehlen zwei Optionen** ([**E-98**](../BEFUNDE.md#e-98), offen):
  *Kopfzeilen einschließen* und *Absätze raten* sind nicht wählbar. Windows 10
  öffnet den modernen Dateidialog, und der zeigt Eudoras Dialogvorlage von 1996
  nicht mehr an. Es gilt, was zuletzt in der `Eudora.ini` stand. Das ist **kein
  Rückschritt durch die Behebung von [E-97](../BEFUNDE.md#e-97)** — die Kästchen fehlen seit der
  Portierung, es kam nur niemand so weit, weil das Programm vorher abbrach.
* **Beim Antworten und Weiterleiten fehlten Bilder im Verfassenfenster**
  ([**E-110**](../BEFUNDE.md#e-110), behoben in 7.2.0.75, von Gregor bestätigt): `resolve_URL` warf
  jede Prozent-Sequenz weg, statt sie zu entschlüsseln — aus
  `en%20aktuellen%20Verlust.png` wurde `enaktuellenVerlust.png`, der Server
  antwortete 404, und Eudora zeichnete einen grauen Kasten. Zehn von zwanzig
  Bildern. **Dabei wurde [E-112](../BEFUNDE.md#e-112) sichtbar** (**wieder offen**): die Bilder erscheinen
  in Originalgröße statt in der angegebenen — eine Regression der
  E-106-Behebung. **Der Versuch in 7.2.0.76 wirkt nicht** — von Gregor am
  18.09.2026 am laufenden Programm widerlegt, mit Bildschirmfoto; seither
  liegt der Text sogar wieder auf den Bildern. **Behoben in 7.2.0.85, veröffentlicht mit
  `v1.0.87`, von Gregor am 13.10.2026 am Testverzeichnis 1.0.86 bestätigt:** die Bilder werden in der
  angegebenen Größe gezeichnet, ohne Angabe in Dateigröße ([E-103](../BEFUNDE.md#e-103), ebenfalls
  bestätigt) — am
  laufenden Programm gemessen, auch für dieselbe Bildadresse in zwei Größen und
  für ein Bild mit nur der Breite; dass ein breites Bild ohne Höhe beim Antworten
  nicht mehr zum Strich wird (und ein hohes ohne Breite nicht zum senkrechten), ist behoben
  und gemessen. Erst mit
  dieser Behebung wird [**E-116**](../BEFUNDE.md#e-116) sichtbar (offen): eine Angabe wie
  `width="35px"` wird als 3508 gelesen. **Behoben in 7.2.0.87, veröffentlicht als `v1.0.87`, am laufenden
  Programm gemessen, von Gregor an 1.0.87 bestätigt (14.10.2026):** [**E-117**](../BEFUNDE.md#e-117) — Bilder
  mit `&amp;` in der Adresse kamen beim Antworten und Weiterleiten als 1×1-Pixel
  an und blieben eine leere Fläche. **Weiter offen ist
  [E-113](../BEFUNDE.md#e-113):** ein Bild, dessen angegebene Breite größer ist als das Fenster,
  läuft rechts hinaus.
* **Die Betreffzeile wird mitten im Wort umbrochen** ([**E-94**](../BEFUNDE.md#e-94), in `v1.0.83`
  noch enthalten, **behoben in 7.2.0.84**): beim **Empfang** werden Betreffs
  wie `Toner bestel len` oder `Wochenend e!` angezeigt, wenn der Absender
  (etwa der web.de-Webmailer) einen langen Betreff in mehrere kodierte Wörter
  zerlegt und dazwischen faltet. Eudora ließ die Faltung stehen, statt sie
  nach RFC 2047 wegzulassen; über POP zeigte die Postfachliste sogar nur die
  erste Zeile. Der frühere Verdacht auf `Encode2047` beim Senden ist widerlegt
  — Eudora hatte diese Nachrichten gar nicht gesendet. **Kein Datenverlust.**
* **Versteckter Vorschautext wird mitgelesen** ([**E-105**](../BEFUNDE.md#e-105), im Download `v1.0.87` offen; Behebung in 7.2.0.88 eingebaut, ausgeliefert mit `v1.0.101`, von Gregor noch nicht bestätigt): In manchen
  Werbemails steht über dem Inhalt eine lange Reihe `? ? ? ?`. Absender
  füllen damit die Vorschauzeile und verbergen sie per CSS `display:none` —
  Eudoras HTML-Anzeige (Paige) kennt keine CSS-Eigenschaften und zeigt den
  Bereich deshalb an. Nur Darstellung, kein Datenverlust. Aus demselben Grund
  stehen in manchen Newslettern Bilder doppelt da (Desktop- und
  Handyfassung, eine davon per `display:none` verborgen; zweiter Fall,
  von Gregor am 13.10.2026 an 1.0.86 gemeldet).
* **Eine HTML-Mail, in ein IMAP-Postfach verschoben, erscheint dort als
  HTML-Quelltext** ([**E-118**](../BEFUNDE.md#e-118), im Download `v1.0.87` offen; Behebung in 7.2.0.89 eingebaut, am IMAP-Prüfserver gemessen, ausgeliefert mit `v1.0.101`, Teil 1 von Gregor am 14.10.2026 an 1.0.89 bestätigt, Teil 2 am 14.10.2026 an 1.0.90): beim Hochladen
  verwirft Eudora die `Content-*`-Köpfe und schreibt keinen oder nur
  `text/plain` als Inhaltstyp, nie `text/html`. Originalfehler von QUALCOMM.
  Eingebettete Bilder gingen dabei ganz verloren; das holt 7.2.0.90 nach (am IMAP-Prüfserver gemessen, von Gregor am 14.10.2026 an 1.0.90 bestätigt).
* **Eine Nachricht, die in einen IMAP-Ordner verschoben wird, kann spurlos
  verschwinden** ([**E-121**](../BEFUNDE.md#e-121), Datenverlust, in `v1.0.87` offen, **in `v1.0.101` behoben, von Gregor am 17.10.2026 bestätigt**; zwei Reste abgetrennt als [E-126](../BEFUNDE.md#e-126) (offen) und [E-127](../BEFUNDE.md#e-127) (offen);
  Behebung in 7.2.0.90 eingebaut, am IMAP-Prüfserver gemessen, ausgeliefert mit `v1.0.101`;
  gegen die Doppelanzeige danach sechs Anläufe bis 7.2.0.96, der letzte an 1.0.96
  von Gregor bestätigt; in 7.2.0.97 gesendete Post wieder hochgeladen, und entfernt
  wird nur noch die Nachricht, die tatsächlich verschoben wurde, an 1.0.99 von Gregor
  bestätigt (16.10.2026); der Verlust eingebetteter Bilder nach einem Neustart ist
  abgetrennt als [E-123](../BEFUNDE.md#e-123) (offen);
  in 7.2.0.100 mehrere gesendete Mails in einer Übertragung ([PRÜFER-31](../Befunde/PRUEFER-31.md)),
  am Prüfstand gemessen, an 1.0.100 von Gregor getestet (16.10.2026);
  in 7.2.0.101 bekommt gesendete Post beim Verschieben eine eigene Kennung, und eine
  Kopie, deren Hochladen scheiterte, wird sofort entfernt ([PRÜFER-32](../Befunde/PRUEFER-32.md)),
  am Prüfstand gemessen, an 1.0.101 von Gregor bestätigt (17.10.2026)):
  ein Abgleich des Zielordners verwarf die lokale Kopie, bevor sie hochgeladen war.
  Selten, aber still. Originalfehler von QUALCOMM.
* **Eine beim Start schon fertige IMAP-Aufgabe blieb manchmal stehen** ([E-83](../BEFUNDE.md#e-83), zweite Ursache):
  sie belegte ihren Ordner, das Verschieben dorthin wartete ewig, und beim Beenden kam
  *„You currently have 1 task(s) running“*. Behoben in 7.2.0.98, am IMAP-Prüfstand gemessen
  (vorher 12 von 12 Läufen hängend, danach 10 von 10 durch), an 1.0.99 von Gregor sauber
  beendet (16.10.2026; der Wettlauf selbst trat in seinem Lauf nicht auf), ausgeliefert mit `v1.0.101`.
* **Bilder, die als `data:`-Adresse im HTML stecken, erscheinen beim Antworten
  und Weiterleiten als grauer Kasten** ([**E-119**](../BEFUNDE.md#e-119), offen, am Protokoll belegt):
  der Lader sucht eine Datei, das Bild steht aber base64-kodiert in der
  Adresse selbst.
* **Anhänge werden unter abgeschnittenem Namen gespeichert, die Endung fehlt**
  ([**AN-1**](../BEFUNDE.md#an-1)): aus `Angebot Nr 4711 fuer die Stadtwerke Musterstadt 2025.pdf`
  wird `Angebot Nr 4711 fuer die Stadtwerke`. **Es liegt nicht an der Länge** —
  ein Name mit 76 Zeichen kommt vollständig an, solange er in *einer* Zeile
  steht. Elf getrennte Ursachen (B5.1 bis B5.11), alle aus Eudora 7.1: eine
  Faltung beendete die Zeichenkette in Anführungszeichen, die Marke des
  Zerlegers war 256 Byte groß, zwei Puffer liefen über, `filename=""` wurde zum
  Wert `=`, **RFC 2231** — die Form, in der lange Namen heute übertragen
  werden — kannte der Baum gar nicht (dann nahm Eudora ersatzweise den
  **Betreff**, 31 Zeichen ohne Endung), lange Namen wurden von hinten gekappt,
  und die Zuordnung MIME-Typ → Endung scheiterte an einem einzigen
  Registry-Eintrag ganz. **Behoben bis auf einen Teil:** über POP am laufenden
  Programm gemessen, alle sechs Prüffälle heil seit 7.2.0.81 (auch an 7.2.0.82
  und 7.2.0.83, Testsuite 185/185); über IMAP von Gregor mit Paket 1.0.83 an
  seinem Postfach getestet und bestätigt. **Offen bleibt [B5.7](../AUFGABEN.md#b5.7):** über IMAP
  wird keine Endung aus dem MIME-Typ nachgetragen, wenn der Name keine hat.
  Durchlauf in [AUFGABEN.md](../AUFGABEN.md), **B5**.
* **Beim Start erschien der Quelltext einer Webseite in einem Fenster**
  ([**AN-2**](../BEFUNDE.md#an-2), **behoben, von Gregor an 1.0.84 am 13.10.2026 bestätigt**):
  JavaScript, CSS und JSON als Text. Angezeigt wird HTML von **Paige**, nicht
  von einem Browser, und Paige kannte kein Element, dessen Inhalt kein Text
  ist: `<script>` war unbekannt, `<style>` bekannt aber unbehandelt — das traf
  auch jeden Newsletter mit eingebettetem CSS. Seit 7.2.0.80 wird beides
  unterdrückt. Die frühere Erklärung, Eudora starte ohne `[Settings] Mode` in
  der **Werbe-Betriebsart**, ist **widerlegt**: dieser Bau startet mit
  `Mode=2` (ohne Werbung), und auch mit `Mode=0` holte 1.0.84 nichts. Die
  Werbe-Betriebsart wird nach Gregors Entscheidung nicht weiter verfolgt
  ([AUFGABEN.md](../AUFGABEN.md), **B6**).
* **Eine gespeicherte HTML-Nachricht zeigt in anderen Programmen falsche
  Umlaute** ([**E-101**](../BEFUNDE.md#e-101), **wieder offen** seit 13.10.2026, an 1.0.84 gemeldet):
  die Datei aus *File → Save As* sagt im `<meta>` UTF-8, enthält aber
  Windows-1252. Jedes Programm, das sie als HTML liest, folgt dem `<meta>` und
  zeigt statt der Umlaute Ersatzzeichen.
* **Ein gelöstes angedocktes Fenster hinterlässt eine leere Fläche**
  ([**E-114**](../BEFUNDE.md#e-114), offen, an 1.0.84 gemeldet): wird etwa das Filterfenster
  angedockt und wieder gelöst, bleibt an seiner alten Stelle ein weißer
  Bereich stehen.
* **Ctrl+F (*Find Messages*) meldet „Encountered an improper argument"**
  ([**E-115**](../BEFUNDE.md#e-115), an 1.0.84 gemeldet), und im Reiter *Mailboxes* ist kein
  Postfach angehakt — wenn ein IMAP-Postfach aktiv ist. **Behoben in 7.2.0.86,
  veröffentlicht mit `v1.0.87`, von Gregor am 13.10.2026 an 1.0.86 bestätigt**
  (vorläufig: der Fehler trat vorher nur sporadisch auf). In `v1.0.84` und
  älter noch enthalten; kein Datenverlust.
* **Nur 32 Bit.** Eine 64-Bit-Fassung ist nicht in Arbeit.

Die vollständige Liste der offenen Punkte steht in [CHANGELOG.md](../CHANGELOG.md)
unter *Noch offen*.


## Für Anwender

### Herunterladen und starten

1. [Neuestes Release](https://github.com/HansWurst81675/Eudora7.2/releases/latest)
   herunterladen, ZIP auspacken — an eine Stelle, an der man schreiben darf,
   also **nicht** nach `C:\Program Files`.
2. **`Eudora starten.cmd`** doppelklicken. Beim ersten Start fragt Eudora nach
   den Zugangsdaten des Mailkontos.
3. Die Titelzeile nennt die Fassung, zum Beispiel
   `Eudora 7.2.0.72 / Paket 1.0.72` — diese Angabe gehört in jeden
   Fehlerbericht.

Das Postfach liegt im Unterverzeichnis `Mailverzeichnis` **neben** dem
Programm. Wer eine neue Fassung auspackt, kopiert dieses Verzeichnis herüber
und behält damit Mails, Konten und Filter.

> **Prüfsummen** zu jedem Paket stehen in
> [Releases/PAKETE.md](../Releases/PAKETE.md), zusammen mit dem Commit, aus dem
> es gebaut wurde.

### Post automatisch einsortieren

Wie ein Filter entsteht, wann er läuft, was seine fünf Aktionen tun, wo die
Regeln gespeichert werden und was es mit der Junk-Punktzahl auf sich hat:
[FILTER.md](../FILTER.md). Dort steht auch, warum diese Punktzahl hier bei
jeder eingehenden Nachricht **0** bleibt.

### Was nicht in der Oberfläche steht

Schalter ohne Menüpunkt, die Regeln für die `Eudora.ini` und das
Verhalten, das sich nicht von selbst meldet — gesammelt und belegt in
[EINSTELLUNGEN.md](../EINSTELLUNGEN.md). Dort steht auch, was beim Umstieg
auf eine neue Fassung mitkopiert werden muss.

### Beim Start wird nach dem IMAP-Kennwort gefragt: das Fenster schließen

Wer ein **IMAP**-Postfach benutzt und beim Beenden ein IMAP-Postfachfenster
offen stehen lässt, wird beim **nächsten Start** nach dem Kennwort gefragt —
auch dann, wenn bei dieser Persönlichkeit *Check mail* **abgewählt** ist.

**Was hilft:** das IMAP-Postfachfenster **vor dem Beenden schließen**. Dann
steht beim nächsten Start nichts wieder herzustellen, und es wird nichts
gefragt. Wer das Fenster offen behalten will, lässt statt dessen das Kennwort
speichern.

**Warum das so ist.** Eudora merkt sich beim Beenden alle offenen Fenster im
Abschnitt `[Open Windows]` der `Eudora.ini`, jedes als eigene Zeile
`OpenWindow<n>=…` (`CMainFrame::SaveOpenWindows`, `mainfrm.cpp:2504`). Beim
Start öffnet es sie wieder (`CMainFrame::LoadOpenWindows`, `mainfrm.cpp:2307`;
gelesen `:2337`, geöffnet `:2403`). Ein IMAP-Postfach zu öffnen heißt aber,
sich anzumelden — und die Anmeldung fragt nach, sobald kein Kennwort
gespeichert ist. Die Kette ist durchgehend nachgesehen:

`CTocDoc::Display` (`tocdoc.cpp:3424`) → `OpenOnDisplay` (`:3451`) →
`CImapMailbox::OpenMailbox` (`EuImap/src/ImapMailbox.cpp:817`) → `GetLogin`
(`:825` bzw. `:700`) → `CImapAccount::Login`
(`EuImap/src/ImapAccount.cpp:3763`) → Kennwortdialog (`:3824`).

**Warum *Check mail* nichts daran ändert.** Das Häkchen setzt den Schlüssel
`CheckMailByDefault` (`EudoraRes.rc:10791`, Schaltfläche `:2926`). Gelesen
wird er an zwei Stellen, und keine davon hat mit dem Öffnen von Fenstern zu
tun: `CPersonality::GetParams` (`persona.cpp:271`, `:333`) holt ihn, um das
Häkchen im Dialog anzuzeigen, und `CPersonality::CheckMailList`
(`persona.cpp:675`, Schlüssel `:683`) stellt daraus die Liste der Konten
zusammen, die beim **Mailabruf** drankommen (`GetMail`, `GetMail.cpp:82`,
`:112`). Das Wiederherstellen der Fenster fragt diese Liste nicht — die
beiden Wege haben keine gemeinsame Stelle.

Das ist **kein Fehler dieser Portierung**, sondern Verhalten des Originals;
es hat deshalb keine Befundnummer. Verwandt: bei IMAP fragt auch ein
**Filterlauf** nach dem Kennwort, aus einem anderen Grund — siehe
[FILTER.md](../FILTER.md), Abschnitt *Was überrascht*.

### Windows Defender meldet Eudora als Trojaner

**Was man sieht.** Das Eudora-Fenster ist plötzlich weg – ohne Fehlermeldung,
ohne Absturzdialog, und im Mailverzeichnis liegt **keine** `Exception.log`.
Das sieht aus wie ein Absturz, ist aber keiner: **Microsoft Defender hat
Eudora beendet.** In *Windows-Sicherheit → Viren- & Bedrohungsschutz →
Schutzverlauf* steht dann eine Meldung wie **`Trojan:Win32/Bearfoos.A!ml`**
mit `Eudora.exe` als betroffenem Element. Danach lässt sich die Datei nicht
mehr starten oder kopieren.

**Was das ist.** Das Kürzel `!ml` heißt: die Einstufung stammt aus Defenders
**maschinellem Lernverfahren**, nicht aus der Signatur einer bekannten
Schadsoftware. Defender schickt eine unbekannte, **unsignierte** Programmdatei
an die Microsoft-Cloud, bewertet sie dort und verteilt bei einem negativen
Urteil eine Signatur für genau diese Datei. Jede Fassung dieses Projekts ist
eine neue, unsignierte Datei – das Urteil kann bei jeder Fassung neu fallen.
Am 16.10.2026 traf es das Testpaket 1.0.98 ([E-124](../BEFUNDE.md#e-124)); das
veröffentlichte `v1.0.87` und die Pakete 1.0.96 und 1.0.97 waren sauber,
1.0.99 (derselbe Quelltext wie 1.0.98, neu gebaut) ebenfalls. Wir halten
das für einen **Fehlalarm**: die Datei ist aus dem Quelltext in diesem Repo
gebaut, und der Unterschied zur sauberen Vorfassung sind rund 60 Zeilen im
Aufgabenverwalter ohne jeden neuen Systemaufruf.

**Was Sie tun können.**

1. **Prüfen, ob es Defender war:** im Schutzverlauf nachsehen, oder in einer
   PowerShell `Get-MpThreatDetection` – dort steht die Uhrzeit und der Pfad
   der `Eudora.exe`.
2. **Ihre Post ist nicht betroffen.** Defender beendet nur das Programm; das
   Mailverzeichnis bleibt, wie es war. Was Eudora vor dem Beenden schon
   geschrieben hatte, ist da.
3. **Eine andere Fassung nehmen** – die nächste Fassung ist eine neue Datei
   und wird neu bewertet –, **oder** die Datei im Schutzverlauf selbst
   **zulassen**, wenn Sie der Herkunft vertrauen. Das ist Ihre Entscheidung;
   wir empfehlen nicht, Defender abzuschalten.
4. **Den Fehlalarm melden:** <https://www.microsoft.com/wdsi/filesubmission>,
   Kategorie *Incorrectly detected as malware*. Microsoft nimmt solche
   Signaturen meist binnen weniger Tage zurück.

**Was wir dagegen tun.** `tools/paket-pruefen.ps1` lässt seit 7.2.0.99
Defender über jede EXE und DLL eines Pakets laufen und weist bei einem Fund
ab; kein Paket geht mehr hinaus, das Defender **in diesem Moment** schon
beanstandet. Ganz ausschließen lässt es sich nicht, weil die Cloud mitunter
erst nach dem ersten Start urteilt. Dauerhaft hilft nur eine Code-Signatur
mit einem Zertifikat – die gibt es für dieses Projekt bisher nicht.

### Einen Fehler melden

Fehler gehören in die
[Issues](https://github.com/HansWurst81675/Eudora7.2/issues) dieses Repos.
Damit ein Bericht verwertbar ist, gehören drei Dinge hinein:

1. **Die Bau-Kennung aus der Titelzeile** — sie nennt Fassung, Paketnummer und
   den Commit, aus dem gebaut wurde, in der Form
   `Eudora 7.2.0.<n> / Paket 1.0.<n>`. Ohne sie ist nicht zu sagen, welcher Stand
   gemeint ist. Ein Sternchen hinter dem Commit heißt: beim Bau lagen
   ungesicherte Änderungen vor, dieser Bau ist nicht reproduzierbar.
2. **Was Sie getan haben und was statt dessen geschah** — der Weg im Menü, der
   Tastendruck, der Dialog.
3. **Nach einem Absturz:** die Datei `Mailverzeichnis\Exception.log` neben dem
   Programm. Eudora schreibt sie von selbst, ohne dass etwas eingeschaltet
   werden muss. Sie enthält seit 7.2.0.13 die Ladeadressen aller Module, und
   `perl tools/absturz-auswerten.pl` macht daraus ohne Visual Studio
   Funktionsnamen. Wie das gelesen wird, steht in
   [Befunde/SPUR.md](../Befunde/SPUR.md).

Bevor Sie schreiben: die bekannten offenen Punkte stehen in
[CHANGELOG.md](../CHANGELOG.md) unter *Noch offen*.

## Einstellungen, die es nur hier gibt

Diese Portierung weicht an einigen Stellen **bewusst** vom Original ab — und
jede Abweichung lässt sich zurückdrehen.

**Die vollständige Liste steht in [EINSTELLUNGEN.md](../EINSTELLUNGEN.md)**, mit
Schlüssel, Abschnitt, Vorgabe hier, Vorgabe im Original und Fundstelle im
Quelltext. Dort und nur dort — bis zum 14.09.2026 standen dieselben Schlüssel
in **zwei** Tabellen, hier und dort, und zwölf davon in beiden. Zwei Listen
mit denselben Werten laufen zwangsläufig auseinander; Gregor hat es bemerkt
und entschieden: *„nur in einstellungen, nicht in readme"*.

Was ein Anwender beim **ersten Start** wissen muss, steht weiter unten unter
*Ein Mailverzeichnis übernehmen* und *Mehr ins Protokoll schreiben lassen*.

## Wie Eudora gestartet werden kann — und warum das zählt

**Es gibt mehr Wege als den Doppelklick auf `Eudora.exe`.** Jedes Mal muss
Eudora sein Mailverzeichnis finden, und jedes Mal kann es dabei über die
Registry im Verzeichnis einer **fremden** Installation landen
([E-132](../BEFUNDE.md#e-132)).

| Weg | was dabei passiert |
|---|---|
| **`Eudora starten.cmd`** doppelklicken | der vorgesehene Weg: das Mailverzeichnis wird als Argument übergeben, Eudora muss nicht suchen |
| Doppelklick auf **`Eudora.exe`** | Eudora sucht sich das Mailverzeichnis selbst |
| Klick auf einen **`mailto:`-Link** | Windows startet Eudora und übergibt die Adresse |
| Doppelklick auf eine **Postfachdatei** (`.mbx`) | Eudora startet und soll das Postfach öffnen |
| Doppelklick auf **Briefpapier** (`.sta`) | Eudora startet und legt eine Nachricht damit an |
| Eine Datei **auf Eudora ziehen** | Eudora startet und hängt sie an |

**Nur der erste Weg kommt ohne Suche aus.** Bei allen anderen greift seit
7.2.0.114 eine Rückfrage, bevor ein fremdes Verzeichnis übernommen wird —
**seit 7.2.0.116 auf allen Wegen.** Bis 7.2.0.115 kam sie nur beim Doppelklick
auf `Eudora.exe`; auf den vier anderen war das Programmverzeichnis intern noch
nicht gesetzt, und die Prüfung stieg wortlos mit *nicht fremd* aus. Im
Protokoll stand dann

```
E-132 Startverzeichnis: … eigenes="" fremd=0
```

— eine Zeile, die wie eine Entwarnung aussieht und keine war. Gefunden hat das
der Agent PRÜFER beim Nachrechnen, nicht ein Testlauf: über einen
`mailto:`-Link muss man erst einmal kommen.

**Wenn gefragt wird, ist die Vorgabe *Nein*** — ein eigenes Verzeichnis neben
dem Programm. Wer die Meldung wegdrückt, beschädigt nichts. Die Antwort wird
gemerkt (in der `DEudora.ini` neben der EXE); wie man sie wieder loswird,
steht im Dialog.

## Was in einen Fehlerbericht gehört — *Help → About Eudora*

**Seit 7.2.0.114 nennt der Über-Dialog alle Pfade, nach denen bei einem Fehler
als erstes gefragt wird**, und ein Knopf legt sie auf die Zwischenablage.

*Help → About Eudora* → **Copy info** → in das Ticket oder Issue einfügen.
Herauskommt ein Block wie dieser:

```
Version 7.2.0.114R - Paid Mode
Not Registered in This Mode
Data: C:\Users\Name\Eudora72-1.0.114-release\Mailverzeichnis
Application: C:\Users\Name\Eudora72-1.0.114-release
INI: C:\Users\Name\Eudora72-1.0.114-release\Mailverzeichnis\Eudora.ini
Default INI: C:\Users\Name\Eudora72-1.0.114-release\DEudora.ini
Log: C:\Users\Name\Eudora72-1.0.114-release\Mailverzeichnis\eudora.log  (LogLevel=25759, keine E-nn-Marken)
Mail folder from: command line
```

| Zeile | warum sie gebraucht wird |
|---|---|
| **Version** | ohne sie ist kein Urteil zuzuordnen — *„behoben"* stand hier schon einen Tag lang da, während das ausgelieferte Paket den Fehler noch hatte |
| **Data** | das Mailverzeichnis: dort liegen Postfächer, Anhänge und das Protokoll |
| **Application** | das Programmverzeichnis — bei uns **nicht** dasselbe wie *Data* |
| **INI** | **welche** `Eudora.ini` wirklich gelesen wird. In unseren Paketen liegt sie in `Mailverzeichnis\`, nicht neben der EXE. Genau diese Abweichung öffnet den Weg von [E-132](../BEFUNDE.md#e-132) |
| **Default INI** | die `DEudora.ini`. Dort stehen `DataFolder` und `UseAppData` — die Stufen 3 und 4 der Verzeichnissuche |
| **Log** | wohin das Protokoll geschrieben wird **und ob es überhaupt etwas enthält**. Steht dort *„keine E-nn-Marken"*, fehlt `DEBUG_MASK_MISC` (32768) im `LogLevel`, und keine einzige Spurmarke wird geschrieben — siehe den nächsten Abschnitt |
| **Mail folder from** | **woher** Eudora das Mailverzeichnis hat: Befehlszeile, Umgebungsvariable, `DEudora.ini`, Registry oder Application Data. Diese eine Zeile hat am 20.10.2026 Stunden gekostet, weil sie fehlte ([E-132](../BEFUNDE.md#e-132)) |

**Die Angaben werden aus dem Dialog genommen, nicht aus dem Programminneren.**
Der kopierte Block kann also nichts behaupten, was auf dem Bildschirm nicht
genauso dasteht.

**Eine Warnung zum Mitschicken:** die Pfade enthalten deinen
Windows-Benutzernamen. Wer das nicht veröffentlichen will, ersetzt ihn vor dem
Einfügen — die Angaben bleiben auch dann brauchbar.

## Mehr ins Protokoll schreiben lassen

Eudora führt ein Protokoll in `eudora.log` im Mailverzeichnis. **Wie viel
darin landet, steuert ein einziger Schlüssel** — ohne Neubau, ohne
Codeänderung:

```ini
[Debug]
LogLevel=25759
```

> **`[Debug]`, nicht `[Settings]`.** `LogLevel` trägt die Nummer 10802 und
> fällt damit in den Bereich, den `GetSectionID` dem Abschnitt `[Debug]`
> zuweist — siehe [EINSTELLUNGEN.md](../EINSTELLUNGEN.md), Regel 1.1. Der
> Abschnitt *Wo ein Schlüssel stehen muss*, auf den hier bis zum 21.10.2026
> verwiesen wurde, steht seit dem 14.09.2026 nicht mehr in dieser Datei.
> Bis zum 11.09.2026 stand hier
> `[Settings]`; das war falsch. Dasselbe gilt für die beiden Nachbarn
> `LogFileName` (10801) und `LogFileSize` (10803).

`LogLevel` ist keine Stufe von 0 bis 5, sondern eine **Summe von Schaltern**.
Jeder Bereich hat seinen Wert; addiert wird, was man sehen will. Die
eingebaute Vorgabe ist **25759**, und sie enthält bereits die meisten
Bereiche.

| Wert | Bereich | in 25759 |
|---:|---|:---:|
| 1 | allgemeine Protokollzeilen | an |
| 2 | Empfang einer Nachricht | an |
| 4 | Wählverbindung | an |
| 8 | Dialogmeldungen | an |
| 16 | Fortschrittsanzeigen | an |
| 32 | **alle gesendeten Bytes** | aus |
| 64 | **alle empfangenen Bytes** | aus |
| 128 | Prüfung auf beschädigte Inhaltsverzeichnisse | an |
| 256 | Zusatzmodule, Grundzüge | aus |
| 512 | Zusatzmodule, ausführlich | aus |
| 1024 | **Filteraktionen** | an |
| 2048 | fehlgeschlagene `ASSERT`/`VERIFY` | aus |
| 4096 | Abspiellisten | aus |
| 8192 | *Leave mail on server* | an |
| 16384 | Suche und Suchindex | an |
| 32768 | **Spurmarken dieser Portierung** | **aus** |
| 65536 | **Anhangnamen** (Zeilen `ANHANG`, Befund [AN-1](../BEFUNDE.md#an-1)) | **aus** |

Belegt in `Eudora71/QCUtils/public/inc/debug.h:14-44`; gelesen wird der
Schlüssel in `eudora.cpp:1192`, ausgewertet in `debug.cpp:140-146`.

### Die Spurmarken einschalten

Diese Portierung schreibt an Stellen, an denen ein Befund untersucht wurde,
Zeilen der Form `E-44 …`, `E-64 …`, `E-70 …`. Sie hängen alle am Schalter
**32768** und sind deshalb **standardmäßig aus**. Einschalten heißt: den
Wert addieren.

```ini
[Debug]
LogLevel=58527
```

58527 ist 25759 + 32768. Eudora muss beim Ändern geschlossen sein, sonst
überschreibt es die Datei beim Beenden.

> **Warum das hier steht.** Bis zum 10.09.2026 waren diese Marken fest
> eingeschaltet — sie hingen zusätzlich am Schalter 128, und der ist in der
> Vorgabe an. Das machte das Protokoll unlesbar und zwang dazu, jede Marke
> nach Gebrauch von Hand wieder auszubauen. Gregors Hinweis darauf hat das
> abgestellt: *„damit kann man im bedarfsfall mehr logs zu debug zwecken
> rausschreiben, ohne den code zu ändern."*

### Wenn etwas nicht tut, was es soll

Der schnellste Weg zu einer belastbaren Aussage:

1. Eudora beenden.
2. `eudora.log` im Mailverzeichnis löschen — dann steht darin nur der
   nächste Lauf.
3. `LogLevel=58527` eintragen.
4. Eudora starten, **genau die eine Sache tun**, um die es geht, beenden.
5. `eudora.log` ansehen. Die Zeilen tragen die Befundnummer am Anfang.

Für Filterläufe lohnt zusätzlich Schalter **1024** (in der Vorgabe schon an):
er schreibt zu jeder Regel, die greift, eine Zeile
`Filter "…" matches "…"`.

**Was ein volles Protokoll kostet:** die Schalter 32 und 64 schreiben jedes
gesendete und empfangene Byte mit, also auch Ihre Zugangsdaten und den
vollständigen Text jeder Mail. Sie sind aus gutem Grund aus. Wer sie
einschaltet, sollte die Datei danach löschen und sie niemandem schicken.

