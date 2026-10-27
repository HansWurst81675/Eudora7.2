# Testplan für Gregor — Quellstand 7.2.0.127 / `VERSION` 1.0.127, Stand 27.10.2026

> **Testpaket 7.2.0.127** (Paket 1.0.127) — Kurztest direkt hierunter. Das
> Paket 1.0.126 bitte **nicht** testen: es wurde geschnürt, dann fand der
> PRÜFER eine Nebenwirkung (V6), und 1.0.127 ersetzt es. Das
> Testpaket 7.2.0.125 ist überholt (U1 nein, U2 bis U4 gehen in V2, V3 und V5
> auf), die Testpakete 7.2.0.124 und 7.2.0.123 sind abgeschlossen; alle
> Ergebnisse stehen weiter unten. Veröffentlicht ist `v1.0.120`. Nach deinem Test und deinem Ja
> wird das Release **7.2.1.<n>** gebaut.

## Was jetzt zu testen ist — Testpaket 7.2.0.127 (Kurztest)

> Das Paket kommt nach `C:\Users\Gregor\Eudora72-1.0.127-release`, neben dein
> 1.0.125. Geprüft wird nur, was sich gegenüber 7.2.0.125 geändert hat, dazu
> U2 bis U4 aus 7.2.0.125, die noch offen waren (jetzt V2, V3 und V5).

**Vorbereitung:** den Inhalt von `C:\Users\Gregor\Eudora72-1.0.125-release\Mailverzeichnis`
nach `C:\Users\Gregor\Eudora72-1.0.127-release\Mailverzeichnis` kopieren, **ohne**
`eudora.log`. Dann **nur** mit `Eudora starten.cmd` im neuen Verzeichnis
starten. In der Titelzeile muss **7.2.0.127** und **Paket 1.0.127** stehen.

**Oder mit leerem Stand** (Gregor, 27.10.2026: außerhalb der VM, Mail frisch abrufen): das ZIP
`Releases\Eudora72-1.0.127-release.zip` aus der VM mitnehmen (es liegt nicht auf GitHub;
SHA-256 `fe72349f19b2503b9266d752e2e20407024bb892ab972eaad1430d3f870f2a2f`), auspacken und das
mitgelieferte `Mailverzeichnis` **behalten** — darin steht die `Eudora.ini` mit `LogLevel=58527`,
ohne sie bleibt das Protokoll leer und ich kann ein „nein“ nicht auswerten. Konto einrichten,
Mail abrufen, dann V1 bis V6. Für V6 ein Postfach nehmen, das nach dem Start nicht offen ist
(etwa `Trash`; `Junk` gibt es in einem frischen Stand nicht immer).

| Nr. | Was | Wo | Was zu tun ist | Was herauskommen muss |
|---|---|---|---|---|
| V1 | [E-137](BEFUNDE.md#e-137) | lokal, eine Mail aus `In` geöffnet | das Filterfenster öffnen (*Tools → Filters*) und abdocken, so dass es **schwebt**; erst in die Mail klicken, dann auf die **Titelzeile** des Filterfensters klicken, dann **Strg+W** | nur das Filterfenster verschwindet, die Mail bleibt offen |
| V2 | [E-137](BEFUNDE.md#e-137) | wie V1 | Filterfenster wieder öffnen (schwebend); erst in die Mail klicken, dann auf den **Rand** des Filterfensters klicken, dann **Strg+W** | wie V1 |
| V3 | [E-137](BEFUNDE.md#e-137) | wie V1 | Filterfenster wieder öffnen und **andocken**; erst in die Mail klicken, dann auf eine **Beschriftung** im Filterfenster (etwa „Match“), dann **Strg+W** | wie V1 |
| V4 | [E-160](BEFUNDE.md#e-160) | lokal | *Tools → Personalities* öffnen (Register *Persona*), in die Liste rechtsklicken → *New...* | der Assistent für die neue Persönlichkeit erscheint **ohne** vorherige Windows-Meldung „kein E-Mail-Programm zugeordnet“; danach den Assistenten schließen, ohne etwas anzulegen |
| V5 | [E-156](BEFUNDE.md#e-156) | – | während des ganzen Tests | kein Absturz; danach zähle ich im Windows-Ereignisprotokoll, es müssen **null** Abstürze aus `Eudora72-1.0.127-release` sein |
| V6 | [E-137](BEFUNDE.md#e-137) (Gegenprobe, [PRÜFER-62](../Befunde/PRUEFER-62.md) K1) | lokal | die Leiste *Mailboxes* öffnen (*Tools → Mailboxes*), dort ein lokales Postfach **doppelklicken**, das gerade **nicht** offen ist (etwa `Junk`; ist es offen, vorher schließen), gleich danach **Strg+W** | das eben geöffnete Postfach geht zu, die Leiste *Mailboxes* bleibt stehen |

Geht V1, V2, V3 oder V6 schief, genügt mir die Nummer und *nein*, etwa *„V2 nein“*: Ich lese dann in deiner
`eudora.log` die Zeilen `E-137 Strg-W angekommen`.

### <a id="ergebnis-7-2-0-127"></a>Ergebnis am Testpaket 7.2.0.127

| Nr. | Ergebnis (Gregor) | Datum | Bemerkung |
|---|---|---|---|
| V1 | **ja** (aus dem Protokoll) | 27.10.2026 | Gregor testete außerhalb der VM mit leerem Stand und frisch abgerufener Post und sagte: *„du kannst die ergebnisse jetzt übernehmen.“* Sein `eudora.log` (geteilter Ordner `test_0.127`), Sitzung 16:37: zweimal `E-137 Strg-W angekommen: leiste-mit-fokus=nein zuletzt-angeklickte-leiste=ja fokus=ListBox mdi-gewechselt=nein`, danach `Wazoo-Leiste wird versteckt`. Das ist der Weg aus V1/V2: Fokus in der Postfachliste, Klick auf den schwebenden Rahmen, die Leiste wird versteckt. Ob ein Klick auf die Titelzeile oder auf den Rand ging, zeigt die Zeile nicht |
| V2 | **ja** (aus dem Protokoll) | 27.10.2026 | wie V1, dieselben zwei Zeilen |
| V3 | **ja** (aus dem Protokoll) | 27.10.2026 | `E-137 Strg-W angekommen: leiste-mit-fokus=ja … fokus=Button`, danach `Wazoo-Leiste wird versteckt`: Klick auf das Gruppenfeld „Match“ der Leiste, dann Strg+W |
| V4 | — | | im Protokoll nicht ablesbar ([E-160](BEFUNDE.md#e-160) schreibt keine Zeile); Gregors Urteil fehlt |
| V5 | — | | kein `Exception`-Eintrag im Protokoll. Microsoft Defender nahm die `Eudora.exe` um 16:47 in Quarantäne, danach erschien „Error Loading Resource DLL (EudoraRes.dll)“; das ist der bekannte Fehlalarm [E-124](BEFUNDE.md#e-124), kein Absturz von Eudora. Das Windows-Ereignisprotokoll liegt auf Gregors Rechner draußen und ist nicht gezählt |
| V6 | — | | Sitzung 16:49: sieben Mal `mdi-gewechselt=ja` ohne `Wazoo-Leiste wird versteckt`, Strg+W schloss also jedes Mal ein Fenster statt einer Leiste. Ob ein Doppelklick in *Mailboxes* vorausging, zeigt das Protokoll nicht; Gregors Urteil fehlt |

**Nebenbei, kein Testpunkt:** Strg+K auf die Mail „test am mich“ (von `markus.bakus@gmx.de` an `Markus.Bakus@gmx.de`) brachte *„Eudora could not find any usable addresses … except maybe your own address“*. Das ist das Verhalten des Originals: Eudora nimmt die eigene Adresse vorher heraus (`namenick.cpp:1763-1764`, *Include yourself* = aus); bei einer Mail eines anderen Absenders kommt der Dialog.

## Kurztest 7.2.0.125 — überholt durch 7.2.0.127

> Das Paket kommt nach `C:\Users\Gregor\Eudora72-1.0.125-release`, neben dein
> 1.0.124. Geprüft wird nur, was sich gegenüber 7.2.0.124 geändert hat.

**Vorbereitung:** den Inhalt von `C:\Users\Gregor\Eudora72-1.0.124-release\Mailverzeichnis`
nach `C:\Users\Gregor\Eudora72-1.0.125-release\Mailverzeichnis` kopieren, **ohne**
`eudora.log`. Dann **nur** mit `Eudora starten.cmd` im neuen Verzeichnis
starten. In der Titelzeile muss **7.2.0.125** und **Paket 1.0.125** stehen.

| Nr. | Was | Wo | Was zu tun ist | Was herauskommen muss |
|---|---|---|---|---|
| U1 | [E-137](BEFUNDE.md#e-137) | lokal, eine Mail aus `In` geöffnet | das Filterfenster öffnen (*Tools → Filters*) und abdocken, so dass es **schwebt**; erst in die Mail klicken, dann auf die **Titelzeile** des Filterfensters klicken, dann **Strg+W** | nur das Filterfenster verschwindet, die Mail bleibt offen |
| U2 | [E-137](BEFUNDE.md#e-137) | wie U1 | Filterfenster wieder öffnen (schwebend); erst in die Mail klicken, dann auf den **Rand** des Filterfensters klicken, dann **Strg+W** | wie U1 |
| U3 | [E-137](BEFUNDE.md#e-137) | wie U1 | Filterfenster wieder öffnen und **andocken**; erst in die Mail klicken, dann auf eine **Beschriftung** im Filterfenster (etwa „Match“), dann **Strg+W** | wie U1 |
| U4 | [E-156](BEFUNDE.md#e-156) | – | während des ganzen Tests | kein Absturz; danach zähle ich im Windows-Ereignisprotokoll, es müssen **null** Abstürze aus `Eudora72-1.0.125-release` sein |

### <a id="ergebnis-7-2-0-125"></a>Ergebnis am Testpaket 7.2.0.125

| Nr. | Ergebnis (Gregor) | Datum | Bemerkung |
|---|---|---|---|
| U1 | **nein** | 26.10.2026 | Gregor: *„E-137, T1 FAILED“* (gemeint ist U1). Im Protokoll nach dem Klick auf den Rahmen keine E-137-Zeile; neuer Anlauf für 7.2.0.126 ([E-137](BEFUNDE.md#e-137)). Nebenbei gefunden: [E-160](BEFUNDE.md#e-160) (Windows-Meldung bei *Persona* → *Neu*) |
| U2 | — | | nicht getestet, geht in V2 an 7.2.0.127 auf |
| U3 | — | | nicht getestet, geht in V3 an 7.2.0.127 auf |
| U4 | — | | nicht getestet, geht in V5 an 7.2.0.127 auf |

## Kurztest 7.2.0.124 — abgeschlossen

> Das Paket kommt nach `C:\Users\Gregor\Eudora72-1.0.124-release`, neben dein
> 1.0.123. Geprüft wird nur, was sich gegenüber 7.2.0.123 geändert hat; alles
> andere hast du an 7.2.0.123 bestätigt (Ergebnistabelle unten).

**Vorbereitung:** den Inhalt von `C:\Users\Gregor\Eudora72-1.0.123-release\Mailverzeichnis`
nach `C:\Users\Gregor\Eudora72-1.0.124-release\Mailverzeichnis` kopieren, **ohne**
`eudora.log`. Dann **nur** mit `Eudora starten.cmd` im neuen Verzeichnis
starten. In der Titelzeile muss **7.2.0.124** und **Paket 1.0.124** stehen.

| Nr. | Was | Wo | Was zu tun ist | Was herauskommen muss |
|---|---|---|---|---|
| T1 | [E-137](BEFUNDE.md#e-137) | lokal, eine Mail aus `In` geöffnet | das Filterfenster öffnen (*Tools → Filters*), auf eine **Beschriftung** darin klicken (etwa „Match“), dann **Strg+W** — einmal angedockt, einmal schwebend (abgedockt) | nur das Filterfenster verschwindet, die Mail bleibt offen |
| T2 | [E-119](BEFUNDE.md#e-119) | lokal | auf die Polizeitag-Mail antworten (das große grüne Bild von heute) | das Bild erscheint vollständig, keine Fläche mit Streifen |
| T3 | [E-158](BEFUNDE.md#e-158) | lokal | eine **Text**mail (etwa *„mail an mich“*) an dich selbst weiterleiten und abrufen | am Ende der angekommenen Mail steht **kein** `</x-html>` |
| T4 | [E-142](BEFUNDE.md#e-142) | **IMAP** *Gelöscht* | einen Entwurf anlegen (*Message → New Message*, an dich selbst, *File → Save*, Fenster schließen — er liegt in `Out`), in *Gelöscht* ziehen, dann zurück nach `Out` ziehen | die Rückfrage kommt, **No** ist vorgewählt; **Enter** drücken: nichts passiert. Entwurf danach löschen |
| T5 | [E-156](BEFUNDE.md#e-156) | – | während des ganzen Tests | kein Absturz; danach zähle ich im Windows-Ereignisprotokoll, es müssen **null** Abstürze aus `Eudora72-1.0.124-release` sein |
| T6 | [E-142](BEFUNDE.md#e-142), Entscheidung 12 | **IMAP** *Gelöscht* | den Entwurf aus T4 (liegt noch in *Gelöscht*) **öffnen**, dann *Message → Send Again* | es öffnet sich eine neue Mail mit Empfänger, Betreff und Text des Entwurfs; *Send* schickt sie ab, sie kommt bei dir an. Danach den Entwurf in *Gelöscht* löschen |

### <a id="ergebnis-7-2-0-124"></a>Ergebnis am Testpaket 7.2.0.124

| Nr. | Ergebnis (Gregor) | Datum | Bemerkung |
|---|---|---|---|
| T1 | **ja** im zweiten Durchgang, **nein** im ersten | 26.10.2026 | Zweiter Durchgang: Gregor *„E-137, T1 PASSED“*; Protokoll sechsmal `E-137 Strg-W: Wazoo-Leiste wird versteckt`. Erster Durchgang: Gregor: *„FAILED: CTRL-W schließt nicht filter fenster“*, geklickt *„mal oben, mal seitlich“* (Titelzeile und Rand des schwebenden Fensters). Klicks **in** die Leiste wirkten (Protokoll dreimal `E-137 Strg-W`). Ursache und Behebung: [E-137](BEFUNDE.md#e-137), dritter Teil |
| T2 | **ja** | 26.10.2026 | Gregors Bild: Antwort auf die Polizeitag-Mail, das große grüne Bild steht vollständig, keine Streifen. Protokoll: `E-119 data-Bild als Datei: …data-8e094058.jpg laenge=201951` — mehr als 65.535 Zeichen, an 7.2.0.123 wurde genau dort abgeschnitten ([E-119](BEFUNDE.md#e-119)). Im selben Bild die bekannte Meldung zur Rechtschreibprüfung ([E-139](BEFUNDE.md#e-139)) |
| T3 | **ja** | 26.10.2026 | Gregor: *„E-158: PASS“* — die weitergeleitete Textmail endet ohne `</x-html>` ([E-158](BEFUNDE.md#e-158)) |
| T4 | **nein** | 26.10.2026 | Gregor: neue Mail angelegt, nach IMAP *Gelöscht* verschoben, zurück nach `Out` — statt der Rückfrage kam *„Messages can't be transferred to the Out mailbox“* (Gregors Bild). Gemessen in Gregors `eudora.log` an 1.0.124 (26.10.2026): neuer Entwurf gespeichert (Programmzeit 14:12, `E-88 … Fassung=EDITOR`), nach IMAP *Gelöscht* hochgeladen (14:30, `E-121 Hochgeladen: ergebnis=1 neue-uid=15`), danach den Ordner geöffnet und die Nachricht vom Server neu geladen (14:50, `1 message(s) left to download`), dann das Zurückziehen nach `Out` abgelehnt (15:01, `E-125 Xfer nach Out abgelehnt: quelle=Gelöscht (<Dominant>)`) — Eudora hielt sie nicht mehr für einen Entwurf, die E-142-Rückfrage kam deshalb nicht. Nichts ging verloren, das Original liegt weiter in *Gelöscht*. Vermutung, nicht gemessen: beim Neuladen vom Server geht die Entwurfsmarke verloren; an 1.0.123 (TESTPLAN N3) kam die Rückfrage, vermutlich weil die Nachricht noch nicht neu geladen war. Entschieden: Entscheidungen 12 und 13 in [WEITERMACHEN](WEITERMACHEN.md) — die Ablehnung bleibt, Entwürfe bleiben in `Out` ([E-142](BEFUNDE.md#e-142)) |
| T5 | **ja** | 26.10.2026 | Gregors Test an 1.0.124 abgeschlossen (eudora.log bis 20:11, drei Programmläufe); Windows-Ereignisprotokoll (Anwendung, Ereignis 1000) ab 13:00: **0** Abstürze aus `Eudora72-1.0.124-release`; im Protokoll keine Zeile `Ausnahme` |
| T6 | **nein** | 26.10.2026 | Gregor am 26.10.2026 an 1.0.124: *„message -> send again liefert eine leere mail.“* (Gregors Bild: neue Mail ohne Empfänger, Betreff und Text, nur der Absender). Die Bedingung aus Entscheidung 12 ist damit **nicht** erfüllt: ein aus IMAP neu geladener Entwurf lässt sich weder nach `Out` ziehen noch per *Send Again* verschicken. Das Original liegt weiter im IMAP-Ordner. |

## Testpaket 7.2.0.123 — abgeschlossen am 26.10.2026

**Starten mit `Eudora starten.cmd`** im neuen Verzeichnis — **einzige Ausnahme ist
Teil 0 A**, dort wird `Eudora.exe` doppelgeklickt. In der
Titelzeile muss **7.2.0.123** und **Paket 1.0.123** stehen — sonst läuft
ein anderes Paket.

**Wo:** Jeder Schritt sagt, in welchem Postfach. *Lokal* heißt die Postfächer
oben in der Liste (`In`, `Out`, `Trash`); *IMAP* heißt die Ordner unter
deinem GMX-Konto.

**Was du mir zurückgibst:** je Zeile *ja* oder *nein* (bei *nein* ein Satz,
was stattdessen kam). Ich trage es unten in die
[Ergebnistabelle](#ergebnis-7-2-0-123) und in die Buchführung ein; das
`eudora.log` lese ich danach selbst (wie vereinbart nur lesen).

### Teil 0 — Reihenfolge und Vorbereitung (bitte genau in dieser Reihenfolge)

**A. Zuerst M1 — bevor das neue Paket irgendwie anders gestartet wurde.** Der
Starttest braucht eine *fremde* Installation, und das ist dein 1.0.122. Wird
das neue Paket vorher über `Eudora starten.cmd` gestartet, merkt sich Eudora
das neue Verzeichnis, und die Rückfrage aus M1 kommt zu Recht nicht mehr.

1. Dein **1.0.122** einmal mit seinem `Eudora starten.cmd` starten und mit
   *File → Exit* beenden. Danach steht es als zuletzt benutzte Installation in
   der Registry.
2. Im Explorer das **Änderungsdatum** von
   `C:\Users\Gregor\Eudora72-1.0.122-release\Mailverzeichnis\Eudora.ini` notieren.
3. Im neuen Verzeichnis `C:\Users\Gregor\Eudora72-1.0.123-release` die
   **`Eudora.exe` doppelklicken** und [M1](#m1-e132) Schritt 1 bis 4 fahren.
   Für Schritt 3 und 4 („fremde `Eudora.ini` unverändert“): das Änderungsdatum
   aus 2. muss gleich bleiben.
4. Nach Schritt 4 läuft Eudora mit einem eigenen, leeren Mailverzeichnis und
   öffnet deshalb den Assistenten für ein neues Konto: mit *Abbrechen*
   schließen, dann *File → Exit*.

**B. Deine Daten in das neue Paket.** Der Inhalt von
`C:\Users\Gregor\Eudora72-1.0.122-release\Mailverzeichnis` in
`C:\Users\Gregor\Eudora72-1.0.123-release\Mailverzeichnis` kopieren
(überschreiben). **Zwei Ausnahmen, beide nicht mitkopieren:** `eudora.log` —
sonst ist das Protokoll aus M1 Schritt 4 überschrieben, und das alte enthält
selbst `E-132`-Zeilen, die wie ein Nachweis aussehen; und, falls vorhanden,
`rootcerts.p7b` — sonst prüft K3 die alte Zertifikatsliste statt der neuen
([E-148](BEFUNDE.md#e-148)).

**C. Ab jetzt nur noch mit `Eudora starten.cmd`** im neuen Verzeichnis, dann
Teil 1 und Teil 2 in beliebiger Reihenfolge.

### Teil 1 — die neun Kriterien aus ZIEL.md, kurz

| Nr. | Kriterium | Was zu tun ist | Was herauskommen muss |
|---|---|---|---|
| K0/K1 | startet, Hauptfenster | `Eudora starten.cmd` doppelklicken | Hauptfenster, Titelzeile mit 7.2.0.123 / Paket 1.0.123 |
| K2 | Darstellung | ein paar Nachrichten in `In` (lokal) öffnen, darunter eine HTML-Mail mit Bildern | richtig dargestellt, **keine** Meldung *„Encountered an improper argument"* |
| K3 | Abruf | bei GMX und bei freenet Mail abrufen | Abruf geht, **kein** Zertifikatsfehler (das prüft zugleich die neue Zertifikatsliste, [E-148](BEFUNDE.md#e-148)) |
| K4 | keine Abstürze | während des ganzen Tests | Eudora bleibt stehen |
| K5 | schreiben und senden | eine Mail an dich selbst schreiben und senden | kommt an |
| K6 | weiterleiten | die angekommene Mail weiterleiten | geht |
| K7 | beenden | *File → Exit* | Eudora schließt sauber |
| K8 | offene Fenster | zwei Postfächer öffnen, Menü *Window* | beide stehen dort und lassen sich wählen |

### Teil 2 — was neu ist und nur du am Programm prüfen kannst

| Nr. | Befund | Wo | Was zu tun ist | Was herauskommen muss |
|---|---|---|---|---|
| N1 | [E-137](BEFUNDE.md#e-137) Strg+W | lokal, `In` offen | mit **Strg+L** das Adressbuch öffnen, **angedockt**, hineinklicken, dann **Strg+W** | nur das Adressbuch verschwindet, Eudora bleibt offen; ein zweites Strg+W schließt `In` |
| N1b | [E-137](BEFUNDE.md#e-137), *File → Close* | lokal, `In` offen | Adressbuch mit Strg+L öffnen (angedockt), hineinklicken, dann *File → Close* | wie N1: nur das Adressbuch verschwindet (so am 25.10.2026 entschieden, *„a) ist ok.“*) |
| N2 | [E-137](BEFUNDE.md#e-137), schwebend | wie N1 | das Adressbuch aus dem Rahmen ziehen (schwebend), hineinklicken, **Strg+W** | nur das Adressbuch verschwindet |
| N3 | [E-142](BEFUNDE.md#e-142) Hinweis | lokal `Out` und **IMAP** `Gelöscht` (der Papierkorb unter deinem GMX-Konto, nicht das lokale `Trash`) | einen Entwurf anlegen (*Message → New Message*, an dich selbst, Betreff `N3`, *File → Save*, Fenster schließen — er liegt in `Out`), in den IMAP-Ordner `Gelöscht` ziehen, dann von dort **zurück** nach `Out` ziehen | eine Rückfrage *„Moving or copying a draft from an IMAP mailbox to Out may give an empty message …“*. **No** drücken: nichts passiert, keine weitere Meldung. **Nicht Yes** — dann entsteht in `Out` die bekannte leere Nachricht. Danach den Entwurf in `Gelöscht` löschen |
| N4 | [E-77](BEFUNDE.md#e-77) Umlaute | IMAP | die Ordnerliste unter dem GMX-Konto ansehen | *Entwürfe*, *Gelöscht* mit Umlauten, nicht `Entw&APw-rfe` |
| N5 | [E-77](BEFUNDE.md#e-77)/[E-146](BEFUNDE.md#e-146) Umbenennen | IMAP | einen Testordner `Test-ä` anlegen, in `Test-ö` umbenennen, öffnen; im GMX-Webmailer nachsehen; dann in Eudora löschen | heißt in Eudora und im Webmailer `Test-ö`, lässt sich öffnen, keine Fehlermeldung |
| N6 | [E-113](BEFUNDE.md#e-113) breite Bilder | lokal | auf eine Nachricht mit einem sehr breiten Bild antworten | das Bild passt im Antwortfenster in die Breite, unverzerrt |
| N7 | [E-119](BEFUNDE.md#e-119) Bilder im HTML | lokal | falls du eine Mail hast, deren Bilder direkt im HTML stecken (manche Newsletter): antworten | Bild statt grauem Kasten. Hast du keine, schreib *keine Mail dafür* — der Prüfstand hat es gemessen |

### Teil 3 — die Handfälle aus Teil M

| Nr. | Fall | Was zu tun ist |
|---|---|---|
| M1 | [E-132](BEFUNDE.md#e-132), Schritt 1–4 | **schon in Teil 0 A erledigt** — dort steht die Vorbereitung; nur Schritt 1 bis 4 (Schritt 5 geht nicht, entschieden am 25.10.2026) |
| M3 | [E-125](BEFUNDE.md#e-125) | wie in [M3](#m3-e125) beschrieben |

### <a id="ergebnis-7-2-0-123"></a>Ergebnis am Testpaket 7.2.0.123 — je Kriterium

*Ausgefüllt am 26.10.2026 nach deiner Rückmeldung. Ohne diese Tabelle gäbe es kein
Release 7.2.1 (ZIEL.md: „Ein Release ohne dokumentierte Ergebnisse gibt es
nicht").*

| Nr. | Ergebnis (Gregor) | Datum | Bemerkung |
|---|---|---|---|
| K0/K1 | **ja** | 26.10.2026 | Titelzeile *„Eudora 7.2.0.123 / Paket 1.0.123+82372232 2026-10-26 08:50 - Eudora72-1.0.123-release“* (Gregors Bild) |
| K2 | **ja** | 26.10.2026 | Gregor: *„keine meldung“*; im `eudora.log` keine Zeile `Ausnahme …`, daneben Marken derselben Klasse (`E-137 Strg-W`, `rootcerts.p7b geladen aus:`) — die leere Spur zählt also |
| K3 | **ja**, mit Bemerkung | 26.10.2026 | GMX über IMAP sofort; freenet über POP: der erste Versuch zu `194.97.208.37:995` hing über eine Minute ohne jede Protokollzeile, bis Gregor ihn stoppte; der zweite über `194.97.208.36:995` kam in 19 s durch. Kein Zertifikatsfehler. Ursache des Hängens nicht gemessen |
| K4 | **nein** | 26.10.2026 | Windows verzeichnete um 10:05 einen Absturz von `Eudora72-1.0.123-release\Eudora.exe` in `ucrtbased.dll` (von Gregor nicht bemerkt); Ursache Debug-Fassungen im Paket ([E-156](BEFUNDE.md#e-156)), behoben für 7.2.0.124 |
| K5 | **ja**, mit Befund | 26.10.2026 | Gregor: *„k5: PASSED, am ende der mail steht aber: </x-html>“* — betrifft die weitergeleitete Mail, nicht diese: siehe K6 und [E-158](BEFUNDE.md#e-158) |
| K6 | **nein** | 26.10.2026 | die weitergeleitete Mail endet mit sichtbarem `</x-html>` (Gregors Bild); Ursache [E-158](BEFUNDE.md#e-158), behoben für 7.2.0.124 |
| K7 | **ja** | 26.10.2026 | Gregor: *„läßt sich beenden“*; Protokoll endet mit `Logging shutdown` |
| K8 | **ja** | 26.10.2026 | Gregor: *„K8: PASSED“* |
| N1 | **ja**, mit Bemerkung | 26.10.2026 | Gregor: *„e-137 PASSED“*; Protokoll dreimal `E-137 Strg-W`. Einmal griff Strg+W im schwebenden (abgedockten) Filterfenster nicht (keine E-137-Zeile), von Gregor nachgestellt: Mail auswählen, dann ins schwebende Filterfenster klicken, Strg+W schließt das Mailfenster — der zweite Teil von [E-137](BEFUNDE.md#e-137); die Behebung ist in 7.2.0.124 eingebaut, am Programm noch nicht gemessen (Kurztest T1) |
| N1b | **ja** | 26.10.2026 | Gregor: *„e-137 PASSED“* |
| N2 | **ja** | 26.10.2026 | Gregor: *„e-137 PASSED“* |
| N3 | **ja** | 26.10.2026 | Rückfrage mit dem neuen Text aus dem IMAP-Ordner *Gelöscht* (Gregors Bild), *No* gedrückt; Protokoll `E-142 Hinweis Entwurf aus IMAP nach Out: quelle=Gelöscht (<Dominant>) antwort=nein`, danach kein *„No messages were transferred!“*. Vorgewählt ist *Yes* |
| N4 | **ja** | 26.10.2026 | *Entwürfe* und *Gelöscht* mit Umlauten (Gregors Bild); Protokoll `E-77 Ordnername: server="Entw&APw-rfe"` |
| N5 | **ja** | 26.10.2026 | Gregor: *„E-146: PASSED“*, *„E-77 PASSED“*; zweiter Durchlauf mit `Temp1_öüß_20261026_1052` (anlegen, Mail hinein und heraus, löschen) im Protokoll ohne Fehler. Einmal meldete ein älterer Ordner `Temp2_ÖÄÜß_b` beim Abgleich *„unknown folder“* — nicht nachgestellt |
| N6 | **ja** | 26.10.2026 | Gregor: *„E-113 passed“*; Protokoll: `E-113 Deckel: seite=477 vorher=600x80 nachher=477x64` und vier weitere, Seitenverhältnis erhalten |
| N7 | **nein** | 26.10.2026 | beim Antworten erschien ein großes `data:`-Bild als grüne Fläche mit Streifen (Gregors Bild); Ursache gefunden ([E-119](BEFUNDE.md#e-119) zweiter Teil, 16-Bit-Zähler), behoben für 7.2.0.124 |
| M1 | **ja** | 26.10.2026 | Schritt 1 Rückfrage (Bild), 2 *No* vorgewählt (Bild), 3 *Cancel*: die genannte fremde `Eudora.ini` (`C:\Temp\E67`, siehe Bemerkung unten) unverändert seit 08:57:34, Gregors 1.0.122 ebenfalls; 4 Protokoll `E-132 Startverzeichnis: gefunden="…Eudora72-1.0.122-release\Mailverzeichnis" … fremd=1` und `eigenes gewaehlt="…Eudora72-1.0.123-release\Mailverzeichnis"` |
| M3 | **ja** | 26.10.2026 | Hinweis erschien (Gregors Bild), kein *„No messages were transferred!“*, Protokoll `E-125 Xfer nach Out abgelehnt: quelle=In ziel=Out kopie=0 einzeln=0`; Schritt 4 (Entwurf über das lokale `Trash` zurück nach `Out`) laut Gregor *„sollte passen“*, im Protokoll ab 11:15 keine `E-125`-Zeile |
| Protokoll | — | | von mir gelesen: aus M1 die Zeilen `E-132 Startverzeichnis: … fremd=1` und `E-132 Startverzeichnis: eigenes gewaehlt=…`; **keine** Zeile `Ausnahme in Fensterbotschaft` oder `Ausnahme ausserhalb einer Fensterbotschaft`; dafür `rootcerts.p7b geladen aus: C:\Users\Gregor\Eudora72-1.0.123-release\rootcerts.p7b (vorhanden)` (das **Programm**verzeichnis), `E-137 Strg-W` aus N1/N1b/N2 und `E-142 Hinweis … antwort=nein` aus N3 |

**Beim Test gefunden (26.10.2026):** Die erste M1-Rückfrage nannte `C:\Temp\E67\Mailverzeichnis`, einen meiner Prüfstände. Jeder Eudora-Start schreibt `HKCU\Software\Qualcomm\Eudora\CommandLine\Current`, auch die Starts des Prüfstands auf Gregors Rechner; mein letzter Start um 08:57 hatte den Eintrag auf `C:\Temp\E67` gesetzt. Seit 7.2.0.114 fragt Eudora vorher; Hermes 7.1 oder ein Eudora vor 7.2.0.114 würde per Doppelklick still in diesem Prüfstand arbeiten. Der Prüfstand muss den Eintrag sichern und zurückschreiben ([E-157](BEFUNDE.md#e-157), seit 26.10.2026 im Prüfstand behoben).

**Die Abschnitte direkt hierunter sind Nachschlagewerk, kein Auftrag.**
[C10](#c10) (die Auswahlbox) und [C9](#c9) (das Adressbuch) hast du am
21.10.2026 bestätigt. [C8](#c8) ist derselbe Starttest wie [M1](#m1-e132)
und wird dort geführt.

### <a id="c10"></a>Die Auswahlbox im `To:`-Feld — bleibt sie gleich groß?

**Worum es geht.** Du hast es am 21.10.2026 an 1.0.119 gemeldet, während du dein
Ziel für diesen Weg beschrieben hast: *„das Fenster wird bei jeder Änderung
(z.B. nächster Eintrag) kleiner!"* Die Box verlor bei jedem Cursor-Schritt
16 Pixel in Höhe und Breite und war nach fünf Schritten nicht mehr zu sehen
(gemessen: `100 × 62`, `84 × 46`, `68 × 30`, `52 × 14`, `36 × 14`, `20 × 14`).
Behoben in 7.2.0.120, siehe [E-135](BEFUNDE.md#e-135).

**Vorbereitung** — die Box erscheint nur, wenn mehrere Kurznamen **mit
demselben Anfang** im Adressbuch stehen. Über *Tools → Address Book* und
**New** drei Stück anlegen, zum Beispiel `hans`, `hanna`, `hannes` (oder in
`NNdbase.txt` nachsehen, ob du schon welche hast).

**Was zu tun ist** — eine Minute, kein Netz nötig:

1. Eine neue Nachricht öffnen (*Message → New Message*).
2. Im Feld *To:* die ersten zwei Buchstaben tippen, also `ha`. Die Auswahlbox
   klappt auf.
3. Mit **Cursor runter** fünfmal durch die Liste gehen, Schritt für Schritt.

**Was passieren soll.** Die Box behält bei jedem Schritt **dieselbe Größe** —
gemessen konstant `108 × 70` Bildpunkte über sechs Schritte. Sie darf nicht
schrumpfen, und nach fünf Schritten muss noch alles lesbar sein.

**Dein eigentliches Ziel, bitte mitprüfen** — du hast es so beschrieben:
*„dann mit tab wird der eintrag übernommen, die mail adresse erscheint im To:
feld."* Also: den gewünschten Namen ansteuern, **Tab** drücken, und im Feld
*To:* muss die Mailadresse stehen.

**Was ich NICHT gemessen habe:** ob sich ein Hermes 7.1 ebenso verhielt — der
Quelltext dieser Datei ist seit dem ersten Commit unverändert, aber das belegt
nichts über das Verhalten. Und: `InitList` rechnet die Position ohne
`ScreenToClient` um, die beiden anderen Stellen mit. Ob das ein zweiter Fehler
ist, steht offen. Wenn die Box an der **falschen Stelle** steht statt unter dem
Feld, bitte melden — das wäre dieser zweite Fall.

### <a id="c9"></a>Das Adressbuch — kommt ein neuer Kurzname an?

**Worum es geht.** Du hast es am 21.10.2026 gemeldet: *„adressbuch übernimmt
nichts."* Im Formular stand `hans`, im Baum weiter `Untitled`. Und dazu
*„es war 1x nicht richtig, 1x richtig gespeichert, jetzt wieder falsch."*
Behoben in 7.2.0.119, siehe [E-134](BEFUNDE.md#e-134).

**Was zu tun ist** — eine Minute:

1. *Tools → Address Book* öffnen.
2. Auf **New** klicken. Im Baum erscheint ein Eintrag `Untitled`, **und er ist
   jetzt ausgewählt** (vorher war das Adressbuch selbst ausgewählt).
3. Oben im Feld *Nickname* den Text ersetzen durch `hans`.
4. Irgendwo anders hinklicken, damit das Feld den Fokus verliert.

**Was passieren soll.** Der Baum zeigt **`hans`**, nicht mehr `Untitled`.

**Und die Gegenprobe, die den Fehler erst sichtbar gemacht hat:** Eudora
beenden, dann in deinem Mailverzeichnis die Datei `NNdbase.txt` öffnen. Dort
muss `alias hans` stehen. An 1.0.118 stand dort dreimal `alias Untitled`.

**Bitte auch das probieren**, denn hier habe ich nur den einen Weg gemessen:
einen **vorhandenen** Eintrag anklicken und umbenennen — das ging vorher schon
und darf nicht kaputtgegangen sein. Und einen Namen eingeben, den es **schon
gibt**: dann soll die bekannte Meldung kommen und der alte Name stehenbleiben.

**Was ich NICHT gemessen habe:** ob `Untitled` auch dann angenommen wird, wenn
du den Namen über *Einfügen* aus der Zwischenablage setzt statt ihn zu tippen.
Der Weg geht durch dieselbe Stelle, aber gemessen ist er nicht.

### <a id="c8"></a>Der Starttest — nimmt sich Eudora ein fremdes Mailverzeichnis?

**Worum es geht.** Startest du `Eudora.exe` **direkt** (Doppelklick) statt über
`Eudora starten.cmd`, sucht Eudora sich das Mailverzeichnis selbst — und findet
über die Registry das Verzeichnis, mit dem **zuletzt irgendeine** Eudora
gestartet wurde. Bisher nahm es das wortlos und schrieb hinein. Genau das hat
der Melder aus [Issue #102](https://github.com/HansWurst81675/Eudora7.2/issues/102)
erlebt; danach startete seine Hermes 7.1 nicht mehr
([E-131](BEFUNDE.md#e-131)). Ab 1.0.114 **fragt** Eudora vorher — seit **1.0.115** nur noch dann, wenn das Verzeichnis wirklich fremd ist (in 1.0.114 kam die Frage bei **jedem** Start, auch über das eigene Verzeichnis; Gregor hat das am 21.10.2026 gemeldet), seit **1.0.116** auf **allen** Startwegen und mit gemerkter Antwort, und seit **1.0.117** auch dann, wenn im fremden Ordner **keine** `Eudora.ini` liegt — der Fall einer kopierten Sicherung.

**Vorbereitung.** Testverzeichnis `C:\Users\Gregor\Eudora72-1.0.117-release`, am 21.10.2026 bereitgestellt. *(Bis zum 21.10.2026 stand hier `Eudora72-1.0.115-release` mit dem Zusatz „das Paket ist noch nicht geschnürt" — 1.0.115, 1.0.116 und 1.0.117 liegen alle drei bei dir, [LEKTOR-46](../Befunde/LEKTOR-46.md#l-46.5).)*
Dein bisheriges `Eudora72-1.0.113-release` **stehen lassen** — es ist in diesem
Test die „fremde Installation". Notier dir vorher Datum und Uhrzeit von
`Eudora72-1.0.113-release\Mailverzeichnis\Eudora.ini`; daran siehst du am Ende,
ob etwas hineingeschrieben wurde.

**Schritt 1 — ein Mal mit 1.0.113 starten und beenden.** Ganz normal über
`Eudora starten.cmd`. Damit zeigt die Registry auf dessen Mailverzeichnis;
nur so ist es nachher das „fremde".

**Schritt 2 — in 1.0.117 die `Eudora.exe` doppelklicken.** **Nicht**
`Eudora starten.cmd`.

*So ist es richtig:* es kommt ein Fenster **Eudora 7.2** mit der Meldung
*„Eudora found an existing mail folder that belongs to another installation"*
und dem Pfad deines 1.0.113-Verzeichnisses, dazu drei Schaltflächen:

| Taste | was passiert |
|---|---|
| **Yes** | das fremde Verzeichnis wird benutzt — **und beschrieben** |
| **No** | Eudora legt sich ein eigenes `Mailverzeichnis` neben dem Programm an (**Vorgabe**, so dass ein unbedachtes Enter nichts beschädigt) |
| **Cancel** | Eudora beendet sich, ohne irgendetwas anzufassen |

**Bitte „No" drücken.**

*Danach prüfen:* Eudora läuft mit einem leeren eigenen Postfach, und
`Eudora72-1.0.113-release\Mailverzeichnis\Eudora.ini` hat **noch denselben
Zeitstempel wie vorher**.

*Wenn gar kein Fenster kommt und Eudora einfach startet, bitte melden* — dann
greift die Rückfrage nicht. In dem Fall hilft die Zeile aus dem Protokoll:

```
grep "E-132" "C:\Users\Gregor\Eudora72-1.0.117-release\Mailverzeichnis\eudora.log"
```

Dort muss `E-132 Startverzeichnis: … fremd=1` stehen. Steht da `fremd=0`,
hat Eudora das Verzeichnis als sein eigenes angesehen — auch das bitte melden,
mit der ganzen Zeile.

*Voraussetzung:* keine. Geht offline, dauert zwei Minuten.

**Was dieser Test NICHT prüft:** ob eine daneben installierte **Hermes 7.1**
danach wieder startet. Dafür fehlt uns Hermes; der Melder aus Issue #102 ist
ausdrücklich darum gebeten worden.

**Bei uns schon gemessen** (20.10.2026, Prüfstand, nicht bei dir): *No* →
eigenes Verzeichnis, fremde `Eudora.ini` unverändert. *Yes* → fremdes
Verzeichnis, dessen `Eudora.ini` ändert sich nach fünfzehn Sekunden. *Cancel* →
Programm endet, nichts angefasst.

### <a id="c7"></a>C7 · Paket 1.0.112 — was am 20.10.2026 schon bestätigt wurde

Testverzeichnis `C:\Users\Gregor\Eudora72-1.0.112-release`, starten mit
`Eudora starten.cmd`. Das Mailverzeichnis im Paket ist **leer** — deine
Postfächer liegen in `C:\Users\Gregor\Eudora72-Postfaecher-gesichert` und
müssen bei **geschlossenem** Eudora hineinkopiert werden.
Unter *Help → About Eudora* muss **7.2.0.112** stehen.

**Schritt 1 — eine Nachricht als Datei speichern.** **Erledigt:** am 20.10.2026 an 1.0.110 von dir bestätigt (*„habe die .txt nach .html umbenannt und im chrome geöffnet. wird korrekt dargestellt."*).
Eine empfangene HTML-Nachricht mit Umlauten und `€` über *File → Save As*
sichern, die Datei danach in Thunderbird oder im Browser öffnen.
*So ist es richtig:* die Zeichen stimmen. Hat die Nachricht einen **Anhang**,
ist der in der gespeicherten Datei noch ein Anhang.
*Wenn stattdessen ein Block aus `--grenze`, Kopfzeilen und wirrem Text
dasteht, bitte melden:* dann ist der Anhang aus der Datei nicht mehr zu holen.
*Voraussetzung:* keine. Geht offline.

**Wichtig zur Endung.** Eudora bietet im Dialog nur `.txt` an und hängt `.txt`
an, **auch wenn der Inhalt HTML ist** — der Dateityp ändert kein einziges Byte
(gemessen, siehe [E-101](BEFUNDE.md#e-101): `.eml` und `.txt` sind
byte-identisch). Zum Prüfen die Datei also in `.html` umbenennen und im Browser
öffnen, oder in `.eml` umbenennen und in Thunderbird. Dass der Anwender darauf
keinen Hinweis bekommt, ist als [E-128](BEFUNDE.md#e-128) aufgenommen —
**kein neuer Fehler, nicht noch einmal melden.**

**Schritt 2 — Beenden, während noch etwas hochgeladen wird.** **Erledigt:** am 20.10.2026 an **1.0.111** auf beiden Wegen von dir bestätigt (2a: 6015 ms, 2b: 4015 ms, Warteschlange danach leer).
**Voraussetzung: der IMAP-Server muss erreichbar sein.** Ist er es nicht,
entsteht aus dem Verschieben nie ein Hochladen, und Eudora schließt sofort —
das ist **richtig so** und kein Fehler (*offline kein Warten*, seit
7.2.0.103). Am 20.10.2026 hat ein Testlauf gegen einen nicht auflösbaren
`imap.gmx.net` genau das gezeigt; im Protokoll stand `uebertragungen=0`.

**Zweimal durchführen — die Herkunft der Nachrichten macht den Unterschied:**

**2a — aus einem lokalen Postfach.** Mehrere Nachrichten aus `In` in einen
IMAP-Ordner verschieben und **sofort** *File → Exit*.

**2b — innerhalb des IMAP-Kontos.** Mehrere Nachrichten aus `Inbox
(<Dominant>)` in einen anderen IMAP-Ordner verschieben und **sofort**
*File → Exit*. Dieser Weg lief bis 7.2.0.110 an der Wache **vorbei**: gezählt
wurden nur Übertragungen aus einem **lokalen** Postfach. Gregors Lauf vom
20.10.2026 zeigte `eintraege=1` bei `uebertragungen=0` — ein Eintrag in der
Warteschlange, gezählt als null. Behoben in 7.2.0.113.

*So ist es richtig (beide Male):* das Fenster verschwindet **nicht**, solange die
Übertragung läuft. Dauert es länger als fünf Minuten, steht
*„Quit cancelled: …"* in der Statuszeile und Eudora bleibt offen.
Danach **noch einmal** *File → Exit*: es wartet wieder.
*Wenn das Fenster verschwindet, der Prozess aber weiterläuft, bitte melden.*
*Was sonst passieren kann:* eine halb übertragene Nachricht verliert ihre
eingebetteten Bilder.

### Nicht von Gregor zu testen: die Meldungsflut beim Filtern

[E-69](BEFUNDE.md#e-69) stand bis zum 20.10.2026 als Schritt 1 in diesem Plan,
mit der Anweisung *„ein IMAP-Postfach filtern, während der Server nicht
erreichbar ist"*. **Die Anweisung ist falsch.** Scheitert schon der
Verbindungsaufbau, zeigt Eudora **einen** Dialog (*„The IMAP command has
failed … host not found (11001)"*) und kommt nie bis zu den einzelnen
Nachrichten — [E-69](BEFUNDE.md#e-69) greift aber erst dort. Gemessen am
20.10.2026 an Gregors Lauf: **null** [`E-69`](BEFUNDE.md#e-69)-Spurmarken im Protokoll, *Task
Errors* leer. Er hat zweimal richtig gemessen und zweimal nichts gefunden,
weil der Handgriff nicht zum Befund passte.

Der nachgestellte Weg ist ein anderer: `In` öffnen, alles auswählen, `In.mbx`
von außen sperren (wie ein Virenscanner) und *Special → Filter Messages* —
`tools/messen-e69.ps1`, so am 17.10.2026 an 7.2.0.106 gemessen.
**Das stelle ich am Prüfstand selbst nach, bevor es wieder in diese Liste
kommt** ([erst-nachstellen-dann-ausliefern](../Arbeitsweise/erst-nachstellen-dann-ausliefern.md)).
Dasselbe gilt für die Gegenprobe zu [R1](../Befunde/PRUEFER-38.md), die ohne
einen ersten Filterlauf gar nichts aussagt.
### Was bekannt ist — bitte nicht als neuen Fehler melden

Steht an **einer** Stelle: in der [README unter „Bekannte Fehler“](../README.md#bekannte-fehler).
Bis zum 26.10.2026 stand hier eine eigene Liste; sie nannte drei Fehler als
bekannt, die im Testpaket 7.2.0.123 behoben sind (LEKTOR-70, L-70.1).

### Wie dein Urteil zählt

Mit der **Paketnummer** — der des Pakets, das du wirklich gestartet hast:
*„Starttest an `<Paketnummer>` in Ordnung"* oder *„Starttest an
`<Paketnummer>` gescheitert, es kam keine Rückfrage"*. Ohne die Nummer
ist das Urteil wertlos — einmal stand „behoben“ einen Tag lang da, während
das ausgelieferte Paket den Fehler noch hatte.

Eigene Tests dieser Fassung: siehe [Releases/PRUEFBERICHT.md](../Releases/PRUEFBERICHT.md) — dort je Test mit Bau und Zeit; die Zahl steht nur dort. Die Zahl stand hier bis zum 25.10.2026 von Hand und war vier Mal veraltet ([L-51.16](../Befunde/LEKTOR-51.md)); sie gehört aus `tools/pruefbericht.pl` erzeugt, nicht von Hand gepflegt.

---

## Buchführung — was wann an welchem Paket bestätigt wurde

**Stand 23.10.2026: an 1.0.122 [E-125](BEFUNDE.md#e-125) bestätigt** (Ablehnung; die Gegenprobe am Prüfstand, [Testbericht](TESTBERICHT-E125.md)). [C8](#c8) wird als [M1](#m1-e132) geführt. **Stand 21.10.2026, nachmittags. [C9](#c9) ist durch: Gregor hat 1.0.119 getestet und [E-134](BEFUNDE.md#e-134) bestätigt** (*„ja, e-134 eintragen"*) — sein Bildschirmfoto zeigt `hans`, `markus` und `freenet` mit Adressen im Baum. **[C10](#c10) ist ebenfalls durch: Gregor hat 1.0.120 getestet und [E-135](BEFUNDE.md#e-135) bestätigt** (*„beim cursor up/down bleibt die größe der box gleich. klasse!"*) — die Vervollständigungsbox im `To:`-Feld behält ihre Größe. **Offen zu testen bleibt [C8](#c8)** (der Starttest). Das Paket 1.0.119 liegt seit dem 21.10.2026 um 13:07 in `C:\Users\Gregor\Eudora72-1.0.119-release`; diese Zeile unverändert. Geschnürt und bei Gregor stehen 1.0.115 bis 1.0.118 (1.0.116 ist von ihm getestet, 1.0.117 und 1.0.118 nicht); 1.0.114 war bei ihm und ist an seinem eigenen Fund gescheitert. Veröffentlicht ist 1.0.120 als `v1.0.120` (21.10.2026, 19:07:37 UTC) — es trägt 1.0.118, 1.0.119 und 1.0.120; davor 1.0.117 als `v1.0.117` (07:56:56 UTC); an 1.0.117 selbst hat Gregor nichts am laufenden Programm gemessen, davor an 1.0.113 ebenfalls nichts. Davor Paket 1.0.112** (veröffentlicht als `v1.0.112`; an **1.0.110** bestätigt: eine gespeicherte Nachricht wird in Chrome richtig dargestellt — an **1.0.111** bestätigt: der Beenden-Weg auf beiden Wegen, 6015 ms aus dem lokalen Postfach und 4015 ms innerhalb des IMAP-Kontos — an **1.0.112** selbst ist **nichts am laufenden Programm gemessen**, es nimmt nur den Hochladezähler aus [PRÜFER-39](../Befunde/PRUEFER-39.md) N1 zurück). Davor: (Teil A, C1, C2, [E-83](BEFUNDE.md#e-83), [E-85](BEFUNDE.md#e-85), [E-93](BEFUNDE.md#e-93) erledigt; [E-101](BEFUNDE.md#e-101) durchgefallen; [E-95](BEFUNDE.md#e-95)/[E-96](BEFUNDE.md#e-96) am 14.10. an 1.0.87 bestätigt; [C4](#c4) erledigt: [E-112](BEFUNDE.md#e-112), [E-103](BEFUNDE.md#e-103), [E-115](BEFUNDE.md#e-115) an 1.0.86, [E-117](BEFUNDE.md#e-117) an 1.0.87 bestätigt); 1.0.85 bis 1.0.87 liegen bei Gregor, 1.0.87 ist als `v1.0.87` veröffentlicht; getestet wurde an 1.0.84, 1.0.86 und 1.0.87; **Paket 1.0.111 ([E-69](BEFUNDE.md#e-69) Meldungsflut und die Prüfpunkte am Beenden-Weg zu [E-123](BEFUNDE.md#e-123); Prüfschritte in [C6](#c6); dazu [E-101](BEFUNDE.md#e-101) dritter Teil — F1, F3 und F4 aus [PRÜFER-37](../Befunde/PRUEFER-37.md) behoben, die Regression gegenüber 1.0.106 ist weg) — 1.0.107, 1.0.108 und 1.0.109 wurden übersetzt, aber NIE GESCHNÜRT, ihr Inhalt steckt in 1.0.110;** davor **Paket 1.0.106 ([E-69](BEFUNDE.md#e-69) und [E-123](BEFUNDE.md#e-123)) bei Gregor, nicht getestet;** davor Paket 1.0.104 ([E-123](BEFUNDE.md#e-123) Beenden wartet), **ersetzt durch 1.0.106, nie getestet;** davor **Paket 1.0.101 (gesendete Post nach IMAP, von Gregor bestätigt, veröffentlicht als `v1.0.101`);** davor **Paket 1.0.100 ([PRÜFER-31](../Befunde/PRUEFER-31.md) F1: zwei gesendete Mails auf einmal nach IMAP) von Gregor am 16.10.2026 getestet (eine gesendete und zwei Mails aus `In` hochgeladen, sauber beendet; zwei gesendete auf einmal nicht geprüft), kein Release wegen [PRÜFER-32](../Befunde/PRUEFER-32.md);** davor **Paket 1.0.99 (Neubau von 1.0.98, [E-124](BEFUNDE.md#e-124); [E-121](BEFUNDE.md#e-121) gesendete Post wieder hochgeladen und nur noch die verschobene Nachricht entfernt, [E-83](BEFUNDE.md#e-83) zweite Ursache) von Gregor am 16.10.2026 bestätigt; 1.0.97 und 1.0.98 nicht testen;** Paket 1.0.96 ([E-121](BEFUNDE.md#e-121) Kollision Kennung/Server-UID, an 1.0.95 gefunden) an 1.0.96 bestätigt; [E-118](BEFUNDE.md#e-118) Teil 1 an 1.0.89, Teil 2 an 1.0.90 bestätigt; offen: [C5](#c5) zum Testverzeichnis 1.0.89 ([E-105](BEFUNDE.md#e-105))**

Was hier steht, ist aus dem Baum gemessen, nicht erinnert: die Maskenbits aus
`QCUtils/public/inc/debug.h`, die vorhandenen Spurmarken aus den Quelltexten
(`git ls-files … | grep '"E-nn'`), die Urteilszeilen aus `BEFUNDE.md`.

**Wichtig vorweg:** für **[E-49](BEFUNDE.md#e-49) bis [E-63](BEFUNDE.md#e-63)** gibt es **keine** Spurmarken im
Protokoll. Nachgezählt: Marken existieren zu [E-27](BEFUNDE.md#e-27), [E-33](BEFUNDE.md#e-33), [E-34](BEFUNDE.md#e-34), [E-35](BEFUNDE.md#e-35), [E-37](BEFUNDE.md#e-37),
[E-40](BEFUNDE.md#e-40) bis [E-46](BEFUNDE.md#e-46), [E-64](BEFUNDE.md#e-64), [E-66](BEFUNDE.md#e-66), [E-68](BEFUNDE.md#e-68) bis [E-70](BEFUNDE.md#e-70), [E-72](BEFUNDE.md#e-72), [E-73](BEFUNDE.md#e-73), [E-76](BEFUNDE.md#e-76), [E-78](BEFUNDE.md#e-78) bis [E-80](BEFUNDE.md#e-80),
[E-83](BEFUNDE.md#e-83), [E-86](BEFUNDE.md#e-86) bis [E-89](BEFUNDE.md#e-89), [E-95](BEFUNDE.md#e-95), [E-97](BEFUNDE.md#e-97), [E-101](BEFUNDE.md#e-101), [E-103](BEFUNDE.md#e-103), [E-104](BEFUNDE.md#e-104), [E-106](BEFUNDE.md#e-106), [E-110](BEFUNDE.md#e-110) — **zu
keinem der vierzehn**. Teil A ist also reine Augenprüfung. Das Protokoll hilft
nur bei Teil B und C.

---

## 0. Vorbereitung

In die `Eudora.ini` deines Testverzeichnisses, Gruppe **`[Debug]`** —
**nicht** `[Settings]`. Eudora ordnet jeden Schlüssel allein nach seiner
Nummer zu (`rs.cpp:89`, `GetSectionID`); `LogLevel` ist 10802 und liegt damit
zwischen 10800 und 10900.

```ini
[Debug]
LogLevel=124063
```

| Wert | was dazukommt |
|---|---|
| `25759` | die Vorgabe |
| `58527` | **+ 32768** = `DEBUG_MASK_MISC` — **alle `E-nn`-Marken** |
| `124063` | **+ 65536** = `DEBUG_MASK_ATTACH` — die **`ANHANG`**-Marken ([AN-1](BEFUNDE.md#an-1)) |
| `128159` | **+ 4096** = `DEBUG_MASK_PLIST` — der Werbeweg; seit dem 13.10.2026 **nicht mehr nötig** (siehe C2) |

Geschrieben wird nach **`eudora.log`** im Eudora-Verzeichnis. Die Einstellung
wirkt beim **nächsten Start**.

**Welche Eingabeaufforderung.** Alle `grep`-Zeilen unten setzen **Git Bash**
voraus. In `cmd` heißt es `findstr`, in der PowerShell `Select-String`:

| Git Bash | cmd | PowerShell |
|---|---|---|
| `grep ANHANG eudora.log` | `findstr ANHANG eudora.log` | `Select-String ANHANG eudora.log` |
| `grep "E-78\|E-70" eudora.log` | `findstr "E-78 E-70" eudora.log` | `Select-String "E-78\|E-70" eudora.log` |
| `ls attach` | `dir attach` | `Get-ChildItem attach` |

`perl` gibt es nur dort, wo es im Pfad steht — in `cmd` meist nicht, in Git
Bash schon.

**Vorher wegsichern:** `copy eudora.log eudora.log.vorher` — dann ist später
klar, welche Zeilen aus diesem Durchgang stammen.

---

## Teil A — Die vierzehn aus 7.2.0.26 bis 7.2.0.30 (Augenprüfung)

**Alle vierzehn sind seit dem 13.10.2026 von Gregor an 1.0.84 bestätigt** —
die Urteile mit Zitat stehen in `BEFUNDE.md`. Bis dahin standen sie dort als
„von Gregor noch nicht bestätigt"; der Plan bleibt als Anleitung für einen
späteren Rückfalltest stehen.
Acht davon siehst du sofort, sechs merkst du nur, wenn etwas hängt.

### Sichtbar — hier entscheidet dein Auge

| | Befund | Handgriff | richtig ist |
|---|---|---|---|
| ✅ | [**E-49**](BEFUNDE.md#e-49) (A-4) | Maus auf die Kante zwischen linkem Bereich und Nachrichtenliste | Zeiger wird zum **Größenzeiger** |
| ✅ | [**E-49**](BEFUNDE.md#e-49) | nach rechts ziehen | linker Bereich wird **breiter**, Nachrichtenbereich gibt nach |
| ✅ | [**E-49**](BEFUNDE.md#e-49) | weiter als 180 Pixel ziehen | geht — das war deine eigentliche Bitte |
| ✅ | [**E-49**](BEFUNDE.md#e-49) | Eudora beenden und neu starten | die Breite ist **noch da** (landet im `[ToolBar…]`-Abschnitt der `Eudora.ini`) |
| ✅ | [**E-52**](BEFUNDE.md#e-52) | nach dem Verbreitern noch einmal am Balken ziehen | Balken ist **weiter greifbar**, Karten stehen **nicht doppelt** |
| ✅ | [**E-54**](BEFUNDE.md#e-54) | beim Ziehen **nach rechts** hinsehen | der **Ziehrahmen ist sichtbar** — man zieht nicht ins Blinde |
| ✅ | [**E-55**](BEFUNDE.md#e-55) | unter die Werkzeugleiste sehen | **kein** acht Pixel hoher leerer Streifen |
| ✅ | [**E-50**](BEFUNDE.md#e-50) (1) | ein Fenster öffnen, in ein anderes wechseln | die Karte des **verlassenen** Fensters ist **nicht mehr eingedrückt** |
| ✅ | [**E-50**](BEFUNDE.md#e-50) (2) | Hauptfenster in der Größe ziehen | der Kartenstreifen wird **richtig** gezeichnet |
| ✅ | [**E-50**](BEFUNDE.md#e-50) (3) | Fenster öffnen und schließen | die Karten sind **nicht weg** |
| ✅ | [**E-53**](BEFUNDE.md#e-53) | ein Fenster schließen | an der Stelle der Karte bleibt **kein Strich** stehen |
| ✅ | [**E-58**](BEFUNDE.md#e-58) | in den **rechten Rand** des Kartenstreifens klicken, wo nichts steht | es öffnet sich **kein Browser** |
| ✅ | [**E-63**](BEFUNDE.md#e-63) | mit der Maus über die **letzte** Registerkarte fahren | ein **Kurzhinweis** erscheint, wie bei den anderen |
| ✅ | [**E-56**](BEFUNDE.md#e-56) | *Show MDI task bar* **abschalten** | der Kartenstreifen **verschwindet** |

### Nicht sichtbar — nur „ist etwas passiert?"

Diese sechs sind PRÜFER-Funde im selben Code. Du kannst sie nicht gezielt
auslösen; sie gelten als durchgelaufen, wenn beim Obigen **nichts** abstürzt
und **nichts** hängenbleibt.

| | Befund | was es war |
|---|---|---|
| ✅ | [**E-57**](BEFUNDE.md#e-57) | `IsTabLabelTruncated` legte bei **jeder Mausbewegung** eine `CPaintDC` an |
| ✅ | [**E-59**](BEFUNDE.md#e-59) | `m_cxTab` wurde **nur in `OnPaint`** gesetzt |
| ✅ | [**E-60**](BEFUNDE.md#e-60) | ein Trennbalken konnte **während des Ziehens gelöscht** werden |
| ✅ | [**E-61**](BEFUNDE.md#e-61) | `Splitter::Track` **verschluckte `WM_QUIT`** |
| ✅ | [**E-62**](BEFUNDE.md#e-62) | **sieben** Nachrichtenschleifen verschluckten `WM_QUIT`, zwei mit Hängegefahr |

**Die Probe auf [E-61](BEFUNDE.md#e-61)/[E-62](BEFUNDE.md#e-62):** nach dem Ziehen **Alt+F4** drücken. Eudora muss
sich beenden. Bleibt es stehen, ist einer der beiden wieder da.

---

## Teil B — Was das Protokoll beisteuern kann

Zu den vierzehn selbst: **nichts**. Aber im selben Bereich liegen Marken, die
den Rahmen belegen:

```
grep "E-78\|E-70\|E-66\|E-76\|E-44\|E-43" eudora.log
```

| Marke | sagt |
|---|---|
| [`E-78`](BEFUNDE.md#e-78) | je Leiste Kennung, Andockseite, Sichtbarkeit und Stil — **vor und nach** `SetDockState` |
| [`E-70`](BEFUNDE.md#e-70) | `gesichert:` und `geladen:` je Leiste mit `cx`/`cy` **vorher und nachher**. Damit ist nachweisbar, ob deine gezogene Breite wirklich in die INI geht und zurückkommt |
| [`E-44`](BEFUNDE.md#e-44) | *„für N Leiste(n) war keine Lage gespeichert"* — erscheint, wenn der `[ToolBar…]`-Abschnitt fehlt |
| [`E-43`](BEFUNDE.md#e-43) | `SaveCustomInfo` mit dem INI-Abschnitt, in den geschrieben wird |
| [`E-66`](BEFUNDE.md#e-66) | Ziehen am Greifrand: Zeigerwechsel, Streifenlage, Bewegung, `Anwenden` mit Maßen |
| [`E-76`](BEFUNDE.md#e-76) | Größenänderung einer schwebenden Leiste mit Maßen vorher/nachher |

**Zahlen statt Augenmaß** für die Breite aus Schritt 3:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tools\leisten-messen.ps1 -Pfadfilter 'C:\Users\Gregor\Eudora72-1.0.84-release'
```

Einmal **vor** dem Ziehen, einmal **danach**. Der `-Pfadfilter` ist Pflicht,
sonst misst das Werkzeug auch dein echtes Eudora.

---

## Teil C — Die frischen Behebungen

### C1 · AN-1 — Anhangnamen (`LogLevel=124063`)

```
perl tools\anhang-pruefdaten.pl --pop
```

Konto in `[Settings]`: `POPAccount=pruef@127.0.0.1`, `LoginName=pruef`,
`POPPort=11110`, `SSLReceiveUse=0`, Kennwort beliebig. Abrufen, dann:

```
grep ANHANG eudora.log
dir attach
```

| | muss sein |
|---|---|
| ✅ | **alle sechs** Dateien mit **vollem Namen und `.pdf`** |
| ✅ | im Log je Nachricht eine Zeile `ANHANG Datei: WIRD GESCHRIEBEN ALS` |

**Schon an 7.2.0.84 gemessen, 12.10.2026:** Fälle 00–05 in `C:\Temp\E94-nachher` unverändert heil, alle sechs mit vollem Namen und `.pdf` (CHANGELOG 7.2.0.84). Für dich nur eine Gegenprobe, kein offener Punkt.

### C2 · AN-2 — kein JavaScript mehr in der Anzeige

**Erledigt am 13.10.2026:** von Gregor an 1.0.84 bestätigt. Bis dahin stand
hier, eine **frische** `Eudora.ini` bringe das Werbefenster zurück — das ist
**widerlegt**: dieser Bau startet mit `Mode=2` (Pro, ohne Werbung), und auch
mit `Mode=0` kam an 1.0.84 kein Abruf ([AN-2](BEFUNDE.md#an-2),
[L-27.4](../Befunde/LEKTOR-27.md#l-27.4)). Geprüft wird nur noch der Newsletter.

| | muss sein |
|---|---|
| — | **entfällt** (Gregor 13.10.2026): das Werbefenster kommt in diesem Bau nicht mehr, siehe [AN-2](BEFUNDE.md#an-2) |
| ✅ | dasselbe bei einem HTML-Newsletter: **kein** CSS im Nachrichtentext |

*(Der Werbeweg ist an diesem Bau nicht auslösbar; die frühere Zeile zu
`LogLevel=128159` und `grep "PLIST\|E-7"` entfällt mit ihm.)*

### C3 · Die sechs, die auf dein Urteil warteten — alle beurteilt

**Stand 13.10.2026:** [E-85](BEFUNDE.md#e-85) und [E-93](BEFUNDE.md#e-93) bestätigt, [E-83](BEFUNDE.md#e-83) nachgemessen,
[E-101](BEFUNDE.md#e-101) durchgefallen (wieder offen). **[E-95](BEFUNDE.md#e-95) und [E-96](BEFUNDE.md#e-96) am 14.10.2026 an 1.0.87 bestätigt.**

**Berichtigt am 12.10.2026 (LEKTOR, [L-18.5](../Befunde/LEKTOR-26.md#l-18.5)):** hier standen *fünf*. `BEFUNDE.md` führt
**fünfzehn** Behebungen als „von Gregor noch nicht bestätigt" — vierzehn davon
in Teil A, und eine, die in keinem Teil dieses Plans vorkam: [**E-101**](BEFUNDE.md#e-101), die
unbrauchbare gespeicherte Datei. Ausgerechnet die aus der Datenverlustklasse.

| | Befund | Handgriff |
|---|---|---|
| ❌ | [**E-101**](BEFUNDE.md#e-101) | eine **weitergeleitete** Nachricht über *File → Save As* sichern und die `.eml` in einem anderen Programm öffnen — sie muss lesbar sein (`Content-Type`, `MIME-Version`, kein `<x-html>`) |
| ✅ | [**E-85**](BEFUNDE.md#e-85) | eine Nachricht mit Umlauten **über IMAP** abrufen — Umlaute richtig? |
| ✅ | [**E-83**](BEFUNDE.md#e-83) | Eudora normal beenden — es endet wirklich, kein Prozess bleibt |
| ✅ | [**E-93**](BEFUNDE.md#e-93) | eine **bereits weitergeleitete** Nachricht noch einmal weiterleiten — Inhalt vollständig? |
| ✅ | [**E-95**](BEFUNDE.md#e-95) | die **Doctolib**- und die **FairToner**-Nachricht je beantworten und weiterleiten — kein Bild abgeschnitten oder gequetscht, Text frei ([L-33.4](../Befunde/LEKTOR-33.md#l-33.4)) — **bestätigt 14.10.2026 an 1.0.87** |
| ✅ | [**E-96**](BEFUNDE.md#e-96) | dasselbe mit mehreren Bildern hintereinander — **bestätigt 14.10.2026 an 1.0.87** |

**[E-97](BEFUNDE.md#e-97) und [E-99](BEFUNDE.md#e-99) gehören nicht hierher** — die hast du am 17.09.2026 schon
bestätigt (*„gespeichert. funktioniert."* / *„ja, kein datenverlust!"*).

### <a id="c4"></a>C4 · Die Pakete 1.0.85 bis 1.0.87 — alle bestätigt

**Stand 14.10.2026 ([LEKTOR-32](../Befunde/LEKTOR-32.md#lektor-32)).** 1.0.85, 1.0.86 und 1.0.87 liegen als
Testverzeichnis bei dir; alle vier Befunde sind bestätigt, [E-117](BEFUNDE.md#e-117) am 14.10.2026 an 1.0.87.
1.0.87 ist am 14.10.2026 als `v1.0.87` veröffentlicht.

| | Befund | Paket | Handgriff |
|---|---|---|---|
| ✅ | [**E-112**](BEFUNDE.md#e-112) | 1.0.86 | die Kleinanzeigen-Nachricht weiterleiten — das Logo steht **über** „Deine Anzeige wird weniger gesehen“, nicht darauf, und in der angegebenen Größe (*„paßt dagegen“*) |
| ✅ | [**E-103**](BEFUNDE.md#e-103) | 1.0.86 | dieselbe Prüfung — kein Bild auf dem Text |
| ✅ | [**E-115**](BEFUNDE.md#e-115) | 1.0.86 | ein IMAP-Postfach öffnen, dann Ctrl+F — keine Meldung „Encountered an improper argument“ (*„tritt bisher nicht mehr auf“*; vorläufig, der Fehler war sporadisch) |
| ✅ | [**E-117**](BEFUNDE.md#e-117) | 1.0.87 | die eBay-Nachricht (Synology, „Der Countdown läuft!“) weiterleiten oder beantworten — unter der Überschrift steht das **Foto**, keine leere Fläche (bestätigt 14.10.2026, Bildschirmfoto, *„so?“*). Mit `LogLevel=58527` (wie bei dir eingestellt) nennt die Spurmarke `E-110 Laden: src=…` die Adresse mit `&`, nicht mit `&amp;` |

### <a id="c5"></a>C5 · Paket 1.0.89 — E-118 und E-105

**Stand 14.10.2026 ([LEKTOR-34](../Befunde/LEKTOR-34.md#lektor-34)).** Testverzeichnis
`C:\Users\Gregor\Eudora72-1.0.89-release`, die Anleitung liegt dort als `TESTEN.txt`.
1.0.88 wurde nicht ausgeliefert (*„nein, 0.88 teste ich nicht zusätzlich, deine tests
sollten reichen“*); [E-105](BEFUNDE.md#e-105) wird deshalb an 1.0.89 geprüft.
**Vorher:** das Mailverzeichnis aus 1.0.87 hineinkopieren, Eudora dabei geschlossen —
das Mailverzeichnis im Paket ist leer.

| | Befund | Paket | Handgriff |
|---|---|---|---|
| ✅ | [**E-118**](BEFUNDE.md#e-118) | 1.0.89 | eine HTML-Mail (etwa einen Newsletter) aus „In“ in einen IMAP-Ordner verschieben, den Ordner öffnen, die Mail anklicken — sie erscheint normal (Bilder, Formatierung, Umlaute richtig), **kein** `<head>… <body …>` als Text. Mails, die schon **vor** 1.0.89 verschoben wurden, bleiben auf dem Server falsch und erscheinen auch in 1.0.89 als Quelltext — **bestätigt 14.10.2026 an 1.0.89** (waipu.tv-Mail). **Nicht bestanden** bei der SoftMaker-Mail: die eingebetteten Bilder fehlten (*„hier fehlt der inhalt“*) – das ist [E-118](BEFUNDE.md#e-118) Teil 2, zu prüfen an 1.0.90 |
| ☑ | [**E-105**](BEFUNDE.md#e-105) | 1.0.120 | einen freenet-Newsletter beantworten oder weiterleiten — jedes Bild und jeder Absatz genau einmal, keine Zeile `? ? ? ?` über dem Inhalt |

Bekannt und nicht behoben, also kein neuer Fehler: [E-119](BEFUNDE.md#e-119) (`data:`-Bilder als
grauer Kasten), [E-113](BEFUNDE.md#e-113) (Bilder breiter als das Fenster), [E-116](BEFUNDE.md#e-116)
(`width="35px"` mit Einheit).

---

### <a id="c6"></a>C6 · Paket 1.0.110 — E-69, der Beenden-Weg und eine bekannte Regression

**Stand 20.10.2026 ([LEKTOR-44](../Befunde/LEKTOR-44.md#lektor-44)).** Quellstand
**7.2.0.114**, Zweig `e-132-fremdes-mailverzeichnis`, **241 Tests / 241
bestanden** — **noch nicht als Paket geschnürt.** Veröffentlicht ist
**1.0.113** (`v1.0.113`, 20.10.2026, 13:01:36 UTC); davor am selben Tag
`v1.0.112`. Bis zum 20.10.2026 stand hier *„Quellstand 7.2.0.110, Zweig
`e-69-meldungsflut`, 229 Tests"* — vier Fassungen alt, und die Zeile darüber
sagte trotzdem *Stand 20.10.2026*.

**1.0.107, 1.0.108 und 1.0.109 gibt es nicht als Paket** — sie wurden
übersetzt und wieder verworfen; ihr Inhalt steckt vollständig in 1.0.110. Du
hast am 19.10.2026 alle alten Testverzeichnisse gelöscht (*„alles weg!"*) —
**1.0.110 ist das erste Paket, das du danach bekommst.** Wenn dir jemand
1.0.107, 1.0.108 oder 1.0.109 zum Testen nennt, ist das falsch.

| | Schritt | wird geprüft |
|---|---|---|
| ☐ | **Schritt 1** — Nachricht als Datei speichern | [E-101](BEFUNDE.md#e-101), dritter Teil ([F1](../Befunde/PRUEFER-37.md), F3, F4) |
| ☐ | **Schritt 2** — beenden während einer Übertragung (**Server muss erreichbar sein**) | [E-123](BEFUNDE.md#e-123), der Beenden-Weg und [R4](../Befunde/PRUEFER-38.md) |
| — | ~~filtern bei totem Server~~ — **zurückgezogen am 20.10.2026**, der Handgriff trifft [E-69](BEFUNDE.md#e-69) nicht | steht oben unter *Nicht von Gregor zu testen* |

**Was jeder Schritt im Einzelnen verlangt und woran man sieht, dass er
geglückt ist, steht ganz oben in diesem Dokument** — dort im Klartext, ohne
Befundnummern. Hier stehen nur die Haken und die Zuordnung zu den Befunden.
**[E-123](BEFUNDE.md#e-123) selbst bleibt offen.** Was hier geprüft wird, sind
die Prüfpunkte am Beenden-Weg. Nach einem Absturz, einem Eingriff von Defender,
einem Stromausfall oder einem erzwungenen Herunterfahren können eingebettete
Bilder weiter fehlen.

**Die Regression aus [PRÜFER-37](../Befunde/PRUEFER-37.md) ist behoben** (Nachtrag
19.10.2026, auf Gregors Wort *„f1 und f3/f4 erst beheben, dann 0.111 releasen"*):
F1, F3 und F4 stecken ebenfalls in 1.0.110. Eine Nachricht in `windows-1251`,
`koi8-r` oder `iso-8859-2` behält beim Speichern ihre richtige Angabe, und eine
echte mehrteilige Nachricht wird nicht mehr zu `text/plain` gemacht. Der
Handgriff dazu steht oben in der Tabelle.

---

## Teil M — Manuelle Fälle, die **vor dem Release 7.2.1** zu fahren sind

**Einmal vor 7.2.1, nicht vor jedem Release.** Gregor am 23.10.2026: *„handtest für 7.2.1, ist nicht so kritisch, um sie jedes mal auszuführen."* Bis dahin stand hier *„vor jedem Release"* ([L-53.21](../Befunde/LEKTOR-53.md#l-53.21)).

Diese Fälle gehören zu **kritischen** Befunden (Stufe `kritisch` in
[BEFUNDE.md](BEFUNDE.md)), lassen sich aber nicht automatisch fahren. Der
automatische Satz läuft über `tools/pruefstand-lauf.ps1`; was hier steht,
bleibt von Hand.

Gregor am 22.10.2026: *„manche muß man wohl manuell testen, diese werden dann
als solche markiert und vor 7.2.1.0 release ausgeführt."*

### <a id="m1-e132"></a>M1 — E-132: Eudora darf kein fremdes Mailverzeichnis stillschweigend übernehmen

**Warum manuell.** Am 22.10.2026 in den automatischen Satz aufgenommen und
wieder herausgenommen: der Weg lässt sich nur mit `-OhneArgument` erreichen
(nur dann sucht Eudora sich das Verzeichnis selbst), und dann steht die
Rückfrage als **Dialog** und wartet. Ohne Antwort kommt kein Hauptfenster
zustande — `testlauf.ps1` meldete *„Kein Hauptfenster innerhalb von 25 s.
ABER: musste abgeschossen werden."* — und ohne gewähltes Verzeichnis wird
auch kein Protokoll geschrieben. Ein dauerhaft roter Fall, den alle
ignorieren lernen, ist schlimmer als keiner.

**Vorbereitung.** Zwei Verzeichnisse: das zu prüfende Paket, und daneben eine
zweite Installation mit **eigener** `Eudora.ini` im Mailverzeichnis (bei mir
`C:\Temp\E132` und `C:\Temp\E131`). Die zweite einmal starten und beenden,
damit sie in der Registry unter
`HKCU\Software\Qualcomm\Eudora\CommandLine\Current` steht.

| Schritt | Was zu tun ist | Was herauskommen muss |
|---|---|---|
| 1 | **`Eudora.exe` doppelklicken** — nicht `Eudora starten.cmd`, denn das übergibt das Verzeichnis und schneidet den Weg ab | Eine Rückfrage erscheint: *„Eudora found an existing mail folder that belongs to another installation"* mit drei Knöpfen **Yes**, **No**, **Cancel** |
| 2 | Die Vorauswahl ansehen, **ohne** zu klicken | **No** ist vorgewählt (= eigenes Verzeichnis anlegen). Ein unbedachtes Enter darf nichts an der fremden Installation ändern |
| 3 | **Cancel** wählen | Das Programm endet. Die fremde `Eudora.ini` ist **unverändert** (SHA256 vorher/nachher vergleichen) |
| 4 | Wieder **`Eudora.exe` doppelklicken**, diesmal **No** wählen | Eudora startet mit einem eigenen Mailverzeichnis neben dem Programm. Im Protokoll stehen `E-132 Startverzeichnis: … fremd=1` und danach `E-132 Startverzeichnis: eigenes gewaehlt="…"`. Die fremde `Eudora.ini` ist **unverändert** |

**Hier endet der Handtest (Gregor, 25.10.2026: *„ich teste nur bis schritt 4. schritt 5 geht nicht."*).** Den früheren Schritt 5 (*Yes* wählen) gibt es so nicht: Schritt 4 **merkt sich** die Antwort — Eudora schreibt `E132Abgelehnt=<Verzeichnis>` in die `DEudora.ini` neben dem Programm (`eudora.cpp`, `StartEudoraWithDefaultLocation`), und jeder weitere Start liest sie und fragt **nicht** mehr (dieselbe Funktion, Protokoll: `E-132 Startverzeichnis: gemerkte Antwort Nein`). Der Weg *Yes* und das Wiederholen der Rückfrage werden ein **automatischer Prüfstandsfall**, der die gemerkte Antwort zwischen den Schritten zurücksetzt (Zweig `RC1_vorbereiten`). Die alte Gegenprobe mit `Eudora starten.cmd` (keine Rückfrage) prüft jeder gewöhnliche Prüfstandslauf ohnehin bei jedem Start.

**Wenn Schritt 2 oder 3 anders ausgeht, ist der Schaden aus
[Issue #102](https://github.com/HansWurst81675/Eudora7.2/issues/102) zurück**
— dort hat genau dieser Weg die vorhandene Installation eines Fremden
unbrauchbar gemacht.

### <a id="m2-e14"></a>M2 — E-14: der Suchindex darf nicht bei jedem Start neu angelegt werden

> **Deaktiviert am 23.10.2026, nicht gelöscht.** Gregor: *„suchindex test: wenn es nicht mehr aufgetreten ist, dann kann man es deaktivieren, den test aber nicht löschen."* Der Fehler ([E-14](BEFUNDE.md#e-14)) ist gemessen und erledigt und seither nicht mehr aufgetreten. Dieser Fall wird vor 7.2.1 **nicht** gefahren; die Schritte bleiben stehen, damit er wieder eingeschaltet werden kann, falls der Suchindex erneut bei jedem Start neu angelegt wird.

**Warum manuell.** Am 22.10.2026 stand dieser Fall kurz im automatischen
Satz und war **Vakuum-Grün**: PRÜFER hat nachgemessen, dass im Protokoll des
Laufs keine einzige Zeile mit der Maske `16384` (`DEBUG_MASK_SEARCH`,
`Eudora71/QCUtils/public/inc/debug.h:34`) steht. Das Suchsystem lief in dem
Lauf überhaupt nicht — die erwartete Meldung konnte also nie erscheinen, und
„sie fehlt" wurde als Bestanden gelesen. Dazu kommt, was der Befund selbst
sagt: er *„lässt sich nur am **zweiten** Start eines gewachsenen
Mailverzeichnisses messen"*, und der Prüfstand macht einen Start.

**Vorbereitung.** Ein Mailverzeichnis, in dem schon Post liegt und in dem
die Suche einmal benutzt wurde (damit ein X1-Index existiert). In der
`Eudora.ini` muss `LogLevel` die Maske **16384** enthalten, sonst schreibt
das Suchsystem gar nichts ins Protokoll.

| Schritt | Was zu tun ist | Was herauskommen muss |
|---|---|---|
| 1 | Eudora starten, eine Nachrichtensuche ausführen, beenden | Im `eudora.log` stehen Zeilen mit der Maske `16384` — **wenn nicht, ist die Messung ungültig**, dann stimmt `LogLevel` nicht |
| 2 | Eudora **ein zweites Mal** starten | Im Protokoll des **zweiten** Starts steht **kein** `Erasing X1 indices` |
| 3 | Suche erneut ausführen | Die Treffer sind sofort da, ohne dass der Index neu aufgebaut wird |
| 4 | **Positivprobe:** Index-Dateien von Hand löschen, starten | Jetzt **muss** `Erasing X1 indices` erscheinen — sonst misst Schritt 2 wieder nichts |

**Schritt 4 ist der wichtigere.** Ohne ihn weiß niemand, ob Schritt 2 grün
war, weil alles stimmt, oder weil die Stelle gar nicht erreicht wurde.

### <a id="m3-e125"></a>M3 — E-125: Ziehen nach `Out` muss abgelehnt werden

**Warum manuell.** Das Ziehen selbst — mit der Maus zwischen zwei
Postfachfenstern — kann der Prüfstand nicht auslösen. Er nimmt das Menü
*Transfer*, und das landet in derselben Prüfung (`CTocDoc::Xfer`,
`tocdoc.cpp:2753`). Seit dem 23.10.2026 fährt `tools/messen-e125.ps1` beide
Richtungen in einem Lauf (Regressionsfälle `E-125a` bis `c` in
`tools/pruefstand-faelle.txt`); gegen 7.2.0.120 werden `E-125b` und `E-125c` rot; die Gegenprobe `E-125a` bleibt dort grün, denn das Verschieben eines Entwurfs ging auch vorher. Am Quelltext
prüfen die Testfälle in `Eudora71/Tests/TestE125.cpp` die Stelle und die
Ressource (gegengetestet: gegen den alten Stand fallen beide um, bei einer zu
weiten Bedingung `if (ToOut)` fällt der erste mit der Begründung *„trifft
jetzt AUCH verfasste Nachrichten"*). Von Hand bleibt der Fall, weil nur du
das echte Ziehen mit der Maus machst.

**Vorbereitung.** Ein Konto mit Post im Eingang und ein `Out`-Postfach.
In der `Eudora.ini` muss `LogLevel` die Maske **32768** (`DEBUG_MASK_MISC`)
enthalten, sonst fehlt die Spurmarke.

| Schritt | Was zu tun ist | Was herauskommen muss |
|---|---|---|
| 1 | Eine **empfangene** Nachricht aus `In` (oder einem IMAP-Ordner) nach `Out` ziehen | Der Hinweis *„Messages can't be transferred to the Out mailbox. To send this message again, open it and choose Message > Send Again."* mit **einem** Knopf (OK). **Kein** *„Transfer anyway?"* |
| 2 | OK drücken, dann `Out` ansehen | `Out` enthält **keine** neue Nachricht. Es erscheint **kein** *„No messages were transferred!"* |
| 3 | Ins `eudora.log` sehen | Eine Zeile `E-125 Xfer nach Out abgelehnt: quelle=… ziel=Out kopie=0 einzeln=…` |
| 4a | **Gegenprobe vorbereiten.** *Message → New Message*, im Feld *To:* deine eigene Adresse, Betreff `E-125 Gegenprobe`. Dann *File → Save* und das Fenster schließen | Der Entwurf steht in `Out` |
| 4b | Den Entwurf aus `Out` in das **lokale** Postfach `Trash` ziehen — das oberste in der Liste, **nicht** das `Trash` unter deinem IMAP-Konto | Der Entwurf steht in `Trash`, `Out` ist ihn los |
| 4c | **Gegenprobe:** den Entwurf aus `Trash` zurück nach `Out` ziehen | Das muss **gehen**: kein Hinweis, der Entwurf steht wieder in `Out`, und im `eudora.log` kommt **keine** neue `E-125`-Zeile dazu |
| 4d | Den Entwurf in `Out` löschen | damit er beim nächsten Senden nicht hinausgeht |

**Schritt 4 ist der wichtigere.** Ohne ihn ist nicht zu unterscheiden, ob die
Ablehnung den richtigen Fall trifft oder einfach jedes Ziehen nach `Out`
abwürgt — und damit das Senden kaputtmacht. Bis zum 23.10.2026 stand er hier
als ein einziger Satz, *„eine selbst verfasste, noch nicht gesendete Nachricht
(Entwurf) nach `Out` ziehen"* — ohne zu sagen, dass so ein Entwurf immer in
`Out` liegt und erst herausgeschoben werden muss. Gregor hat ihn deshalb als
nicht durchführbar abgelehnt.

**Was nicht ins Paket gehört, aber hierher:** ein Entwurf aus einem
**IMAP**-Ordner nach `Out` ergibt dort eine **leere** Nachricht und die
Meldung *„No messages were transferred!"* ([E-142](BEFUNDE.md#e-142), von
Gregor am 23.10.2026 genau so gesehen). Deshalb in 4b das **lokale** `Trash`. Seit 7.2.0.123 fragt Eudora bei diesem Weg vorher nach (Teil 2, N3).

## Teil D — Wie dein Urteil ins Repo kommt

Ein Urteil zählt nur mit **Paketnummer**. Ohne sie ist es wertlos — das ist
die Lehre aus [**E-85**](BEFUNDE.md#e-85): dort stand „behoben" einen Tag lang da, während das
damals ausgelieferte Paket den Fehler noch hatte. Welches das war, steht in
`BEFUNDE.md` unter [E-85](BEFUNDE.md#e-85); hier steht die Nummer bewusst nicht, damit dieser
Satz nicht eines Tages als Standangabe gelesen wird.

Es genügt eine Zeile je Befund, etwa:

```
1.0.84: E-49 ja (auch ueber 180 und nach Neustart), E-50 ja, E-52 nein -
        Balken wieder weg nach dem zweiten Ziehen
```

Daraus trage ich die Urteilszeilen in `BEFUNDE.md` nach und ziehe die
Überschriften in `AUFGABEN.md`, `WEITERMACHEN.md` und `CHANGELOG.md` mit.

**Ein „nein" ist genauso wertvoll wie ein „ja"** — es ist der einzige Weg,
wie ein Rückfall überhaupt auffällt.
