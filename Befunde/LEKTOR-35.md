# <a id="lektor-35"></a>LEKTOR-35 — Doku nach 7.2.0.90 (E-118 Teil 2, E-121, E-122)

Lauf am 14.10.2026 auf `wt/lektor`, nach dem Merge von `origin/e-118_HTML_header`
(`d7439ee6`, schnell vorgespult). Anlass: 7.2.0.90 baut [E-118](../Intern/BEFUNDE.md#e-118) Teil 2
(eingebettete Bilder beim Hochladen) und [E-121](../Intern/BEFUNDE.md#e-121) (Datenverlust beim
Verschieben in einen IMAP-Ordner) ein und schreibt [E-122](../Intern/BEFUNDE.md#e-122) auf.
[E-118](../Intern/BEFUNDE.md#e-118) ist von Gregor an 1.0.89 bestätigt (waipu.tv-Mail), bei der
SoftMaker-Mail fehlten an 1.0.89 die eingebetteten Bilder.

**Umfang aus der Quelle:** `git ls-files '*.md'` ohne `Befunde/` und `Arbeitsweise/`
= 41 Dateien. **Maßstab:** `Eudora71/Version.h` = 7.2.0.90, `VERSION` = 1.0.90,
Urteile in `BEFUNDE.md`, `tools/ZWEIGE.md`.

`perl tools/doku-pruefen.pl`: kein Widerspruch (27 Dateien; zur Kenntnis wie in
[L-34.9](LEKTOR-34.md#l-34.9): `WERKZEUGE.md`, `ZWEIGE.md`, `pruefdaten/LIESMICH.md` nennen 7.2.0.90 nicht –
keine gibt eine ältere Fassung als aktuell aus). `perl tools/offene-befunde.pl` vor
dem Lauf: **FEHLEN [E-121](../Intern/BEFUNDE.md#e-121), [E-122](../Intern/BEFUNDE.md#e-122); ZU VIEL [E-118](../Intern/BEFUNDE.md#e-118)** ([L-35.1](#l-35.1)), danach deckend.
`perl tools/commit-bereit.pl`: 29 Schranken, keine weist ab.

## Berichtigt

### <a id="l-35.1"></a>L-35.1 — E-118 galt als erledigt, E-121 und E-122 fehlten in der offenen Liste

Das erste Fettwort des Urteils von [E-118](../Intern/BEFUNDE.md#e-118) war *„BESTÄTIGT von Gregor am
14.10.2026 an 1.0.89:“*; `offene-befunde.pl` wertet nur dieses und zählte
[E-118](../Intern/BEFUNDE.md#e-118) damit als erledigt – obwohl Teil 2 (eingebettete Bilder) erst in
7.2.0.90 steckt und nicht bestätigt ist. Neuer Anfang:
*„**Teilweise offen: Teil 2 (eingebettete Bilder, SoftMaker-Mail) eingebaut in 7.2.0.90,
von Gregor noch nicht bestätigt.** **Teil 1 BESTÄTIGT von Gregor am 14.10.2026 an
1.0.89:**“*. Danach `offene-befunde.pl -schreiben` und `befunde-verlinken.pl
--verlinken` (das Schreiben setzt die Kennungen ohne Link, siehe [L-35.8](#l-35.8)).
Die Liste in `WEITERMACHEN.md` nennt jetzt [E-122](../Intern/BEFUNDE.md#e-122), [E-121](../Intern/BEFUNDE.md#e-121) und [E-118](../Intern/BEFUNDE.md#e-118).

### <a id="l-35.2"></a>L-35.2 — „E-118 bestätigt“ ohne Teil 2, „noch nicht getestet“ nach Gregors Test

| Datei, Stelle | stand | jetzt |
|---|---|---|
| `ZIEL.md`, Maßstab 7.2.1.0, Zeile [E-118](../Intern/BEFUNDE.md#e-118) | *„eingebaut in 7.2.0.89, von Gregor … bestätigt“* | dazu *„Teil 2, eingebettete Bilder, eingebaut in 7.2.0.90, noch nicht bestätigt“* |
| `TESTPLAN.md` C5, Zeile [E-118](../Intern/BEFUNDE.md#e-118) (✅) | nur *„bestätigt 14.10.2026 an 1.0.89“*, obwohl der Handgriff „Bilder“ verlangt | dazu *„(waipu.tv-Mail). **Nicht bestanden** bei der SoftMaker-Mail … Teil 2, zu prüfen an 1.0.90“* |
| `README.md`, bekannte Fehler, [E-118](../Intern/BEFUNDE.md#e-118) | *„von Gregor noch nicht bestätigt“* | *„von Gregor am 14.10.2026 an 1.0.89 bestätigt“*; Satz zu Teil 2 mit *„am IMAP-Prüfserver gemessen, von Gregor noch nicht bestätigt“* |
| `WEITERMACHEN.md`, Zeile *Paket 1.0.89* | *„von Gregor noch nicht getestet“* | getestet am 14.10.2026, [E-118](../Intern/BEFUNDE.md#e-118) bestätigt, SoftMaker-Bilder fehlten, [E-105](../Intern/BEFUNDE.md#e-105) noch nicht geprüft |
| `Releases/PAKETE.md`, 1.0.89 | keine Zeile zu Gregors Test | Zeile *„Gregors Test, 14.10.2026“* wie bei 1.0.86/1.0.87 |
| `AUFGABEN.md`, Zeile [E-118](../Intern/BEFUNDE.md#e-118) | *„neu, 13.10.2026 … Test zuerst, dann Bau“* | dazu *„Stand 14.10.2026: eingebaut in 7.2.0.89, bestätigt; Teil 2 in 7.2.0.90, nicht bestätigt“* |
| `Testdaten/README.md`, `e118-html-in-imap-ordner.eml` | *„eingebaut in 7.2.0.89, am IMAP-Prüfserver gemessen“* | dazu *„von Gregor am 14.10.2026 an 1.0.89 bestätigt“* |

Die Zeile zu `e118-eingebettetes-bild.eml` in `Testdaten/README.md` stand schon richtig.
[E-121](../Intern/BEFUNDE.md#e-121) steht in `ZIEL.md` als erster Punkt unter *„Post wird verfälscht“* – aufgenommen.

### <a id="l-35.3"></a>L-35.3 — falsches IMAP-Ordnerpräfix war nirgends dokumentiert

Gesucht in allen `.md` nach *„Location Prefix“*, `imap.gmx.net` als Präfix: kein
Treffer (nur `CHANGELOG.md:2731`, `imap.gmx.net:993` als Serveradresse). Nachgetragen
bei [E-120](../Intern/BEFUNDE.md#e-120) (*„anderer Fall, kein Programmfehler“*), mit den Fundstellen der
Feldbeschriftungen `EudoraRes.rc:1516` (`IDD_ACCOUNT_PROP_ADVANCED`, *„Location
Prefix:“*) und `:1462` (`IDD_LOCATION_PREFIX`, *„IMAP Mailbox Location Prefix“*).
Fassung und Herkunft des Eintrags sind als nicht notiert vermerkt. Nebenbei: vor
*„**Von Gregor bestätigt**“* fehlte der Satzpunkt.

### <a id="l-35.4"></a>L-35.4 — `WERKZEUGE.md` kannte die neuen Schalter des Prüfservers nicht

`tools/imap-pruefserver.pl` hat seit `d7439ee6` `--gruss-verzoegerung <s>` und
`--append-ablehnen`; die Zeile in `tools/WERKZEUGE.md` nannte nur `--ablage`. Ergänzt.

### <a id="l-35.5"></a>L-35.5 — `ZWEIGE.md`: Zweck von `e-118_HTML_header` ohne Teil 2 und E-121

Der Zweig trägt seit 7.2.0.90 [E-118](../Intern/BEFUNDE.md#e-118) Teil 2, [E-121](../Intern/BEFUNDE.md#e-121) und den aufgeschriebenen
[E-122](../Intern/BEFUNDE.md#e-122); die Zeile nannte nur `Content-Type: text/html`. Ergänzt.

## Offen — mit Ermessen, nicht berichtigt

### <a id="l-35.6"></a>L-35.6 — `BEFUNDE.md` verweist auf `Befunde/PRUEFER-27.md`, das auf dem Zweig fehlt

[E-118](../Intern/BEFUNDE.md#e-118) und [E-122](../Intern/BEFUNDE.md#e-122) verlinken `Befunde/PRUEFER-27.md`. Die Datei liegt nur auf
`origin/wt/pruefer` (`59cf4cde`, `21fb57dd`), nicht auf `e-118_HTML_header` – der Link ist
dort tot und wäre es nach dem Merge auf `main` auch. Vor dem PR `origin/wt/pruefer`
in `e-118_HTML_header` mergen. Keine Schranke meldet tote Dateilinks
(`befunde-verlinken.pl` prüft nur Kennungen, `doku-pruefen.pl` nur Fassungen).

### <a id="l-35.7"></a>L-35.7 — PRÜFER hat die E-121-Behebung nicht gesehen

`perl tools/rollen-faellig.pl`: **PRÜFER fällig** (12 Dateien seit `b23f46e`, darunter
`ImapActionQueue.cpp`, `ImapAppend.cpp`, `tocdoc.cpp`). PRÜFER-27 rechnete 7.2.0.89
nach; die Datenverlust-Behebung [E-121](../Intern/BEFUNDE.md#e-121) (Quelle erst nach dem Hochladen
entfernen, `SetDeleteEmbedded(FALSE)`) und Teil 2 von [E-118](../Intern/BEFUNDE.md#e-118) hat kein PRÜFER
gelesen. Vor dem Paket 1.0.90 an Gregor den PRÜFER laufen lassen
(`Arbeitsweise/kein-paket-mit-offenem-datenverlust.md`). **CHRONIST** ebenfalls fällig (21 Dateien).

### <a id="l-35.8"></a>L-35.8 — `offene-befunde.pl -schreiben` nimmt die Links aus der Liste

Nach `-schreiben` standen in `WEITERMACHEN.md` alle 33 Kennungen ohne Link
(`**E-122**` statt `**[E-122](BEFUNDE.md#e-122)**`); `befunde-verlinken.pl` hätte den Commit
abgewiesen. Erst `befunde-verlinken.pl --verlinken` stellte sie wieder her. Jeder,
der die Liste nachzieht, braucht also zwei Aufrufe. Vorschlag: `offene-befunde.pl`
schreibt die Kennung gleich als Link. Werkzeug nicht geändert.

### <a id="l-35.9"></a>L-35.9 — 20 von 62 Testläufen am 14.10.2026 mussten abgeschossen werden

`tools/TESTLAEUFE.md`: am 14.10.2026 meldet `testlauf.ps1` bei 20 von 62 Starts
*„ABER: musste abgeschossen werden. Schliesszeit 30.3 s.“*, auch an 7.2.0.90
(`final2` Lauf 1–3, `final3` Lauf 1–3, `final4` Lauf 1) und an der Gegenprobe 7.2.0.88
(`gp88v`, `gp88x`). Ein Lauf heißt *„[E-121](../Intern/BEFUNDE.md#e-121) welcher Dialog blockiert“* –
ein Ergebnis dazu steht nirgends. [E-121](../Intern/BEFUNDE.md#e-121) Nebenbefund (a) (Abgleichsaufgabe
bleibt bis zum Beenden liegen) könnte es erklären, ist aber nicht mit dem
Abschießen verknüpft. `Arbeitsweise/ausreisser-ist-der-befund.md`: aufschreiben,
woran das Beenden hängt, bevor 1.0.90 zu Gregor geht.

### <a id="l-35.10"></a>L-35.10 — E-118: zwei Sätze im Urteil passen nicht mehr

Am Ende der Zelle steht noch *„**Nicht gemessen:** der Kopf der hochgeladenen
Nachricht auf dem Server (Rohform)“* – am Prüfserver ist er seit dem 14.10.2026 mit
`--ablage` byte-genau gemessen (weiter vorn in derselben Zelle). Und *„**Kein
Datenverlust im Text**“* gilt nur für 7.2.0.86 und älter: 1.0.89 verlor Text hinter
`</x-html>` (PRÜFER-27 F1) und die eingebetteten Bilder. Beides ist Wortlaut im
Befund, deshalb nicht selbst umgeschrieben.

### <a id="l-35.11"></a>L-35.11 — TESTPLAN hat keinen Schritt für 1.0.90 (Vorschlag)

Neuer Abschnitt **C6 · Paket 1.0.90 — [E-118](../Intern/BEFUNDE.md#e-118) Teil 2, [E-121](../Intern/BEFUNDE.md#e-121), [E-105](../Intern/BEFUNDE.md#e-105)**, sobald ein
Testverzeichnis bereitsteht (`Releases/1.0.90/TESTEN.txt` gibt es noch nicht):

| | Befund | Paket | Handgriff |
|---|---|---|---|
| ☐ | [E-118](../Intern/BEFUNDE.md#e-118) Teil 2 | 1.0.90 | eine HTML-Mail mit eingebetteten Bildern (etwa den SoftMaker-Newsletter) aus „In“ in einen IMAP-Ordner verschieben, den Ordner öffnen, die Mail anklicken — **die Bilder sind da**, Text und Fußzeile vollständig. Vor 1.0.90 verschobene Mails bleiben auf dem Server ohne Bilder |
| ☐ | [E-121](../Intern/BEFUNDE.md#e-121) | 1.0.90 | beim selben Verschieben hinsehen: die Mail darf aus dem Posteingang **erst verschwinden, wenn sie im IMAP-Ordner steht**; ist sie in keinem der beiden Ordner, ist das ein Datenverlust — sofort melden, `eudora.log` sichern |
| ☐ | [E-105](../Intern/BEFUNDE.md#e-105) | 1.0.90 | aus C5 übernommen, falls an 1.0.89 nicht mehr geprüft |

Hinweis wie in C5: das Mailverzeichnis aus dem letzten Testverzeichnis vorher
hineinkopieren, Eudora dabei geschlossen. Bekannt und nicht behoben:
[E-122](../Intern/BEFUNDE.md#e-122) (Eingangsdatum im IMAP-Ordner um die Zeitzone verschoben).
[E-121](../Intern/BEFUNDE.md#e-121) ist ein Wettlauf und an Gregors Konto kaum zu erzwingen — ein
bestandener Lauf bestätigt nur, dass der Normalfall nicht schadet.

### <a id="l-35.12"></a>L-35.12 — `imap-pruefserver.pl --append-ablehnen` antwortet ohne CR

`tools/imap-pruefserver.pl:284-285`: `print $h "$antwort` + echter Zeilenumbruch +
`";` – die Antwort endet auf LF, nicht auf CRLF wie die übrigen Antworten
(`\r\n`). Vermutlich ein `\r\n`, das auf dem Weg durch eine Schicht zum Umbruch
wurde (`Arbeitsweise/text-nicht-durch-schichten-schicken.md`). Eudora hat die
Ablehnung laut [E-121](../Intern/BEFUNDE.md#e-121) Messung (3) trotzdem gelesen; ein strenger Client
täte es nicht. Werkzeug nicht geändert (außerhalb der LEKTOR-Rolle).
