# Häufige Fragen

Kurze Antworten zum Alltag mit Eudora 7.2. Ausführlich steht die Bedienung in
[ANWENDER.md](ANWENDER.md), die Filter in [FILTER.md](../Intern/FILTER.md).
Jede Antwort sagt, woher sie stammt: **am Programm geprüft** (Gregor hat es
ausprobiert oder es ist am laufenden Programm gemessen) oder **am Quelltext
nachgesehen** (so steht es im Programm; in dieser Portierung hat es noch
niemand angeklickt). Auf eine Frage verweist man mit ihrer Nummer, etwa
*„FAQ 7“*.

**Übersicht**

| Thema | Fragen |
|---|---|
| Neue Fassung, Start | [1](#1-wie-nehme-ich-bei-einer-neuen-fassung-post-konten-und-filter-mit) |
| Abruf und Verschlüsselung | [2](#2-welche-verschlüsselung-und-welchen-port-nehme-ich), [3](#3-wie-sehe-ich-ob-die-verbindung-wirklich-verschlüsselt-ist), [4](#4-es-kommt-ein-zertifikatsdialog-oder-ssl-negotiation-failed--was-tun) |
| IMAP | [5](#5-im-imap-posteingang-fehlen-mails-die-der-webmailer-zeigt) |
| Konten und Adressen | [6](#6-wie-trenne-ich-die-post-verschiedener-konten), [7](#7-wie-lege-ich-ein-zweites-konto-an), [8](#8-wie-lege-ich-einen-kurznamen-an-und-nutze-ihn-beim-schreiben) |
| Markieren und Filtern | [9](#9-wie-markiere-ich-wichtige-mails-farbig), [10](#10-wie-baue-ich-schnell-einen-filter-aus-einer-mail), [11](#11-wie-speichere-ich-einen-filter), [12](#12-filter-messages-strgj-tut-nichts), [13](#13-warum-landet-nichts-automatisch-in-junk--und-was-ich-dabei-nicht-tun-sollte) |
| Mails und Anhänge | [14](#14-werden-anhänge-gelöscht-wenn-ich-die-mail-lösche), [15](#15-kann-ich-eine-mail-als-anhang-weiterleiten), [16](#16-wie-blende-ich-alle-kopfzeilen-ein-und-wieder-aus) |
| Fehlersuche | [17](#17-wie-schreibt-eudora-mehr-ins-protokoll-loglevel), [18](#18-steht-schon-woanders) |
| Einstellungen | [19](#19-welche-einstellungen-sind-anders-als-im-original-eudora--und-warum) |

---

## 1. Wie nehme ich bei einer neuen Fassung Post, Konten und Filter mit?

1. Das neue Paket in ein **neues, leeres** Verzeichnis auspacken — **nicht**
   über die bisherige Installation. Das Paket bringt eine eigene
   `Mailverzeichnis\Eudora.ini` mit, die **keine Konten** kennt; über eine
   bestehende Installation ausgepackt, ersetzt sie Ihre Konten und
   Persönlichkeiten.
2. Eudora beenden und das **ganze** alte Verzeichnis `Mailverzeichnis` in das
   neue kopieren, mit allen Unterverzeichnissen: `attach` (die Anhänge — in
   den Postfächern selbst steht nur ein Verweis), `Embedded` (eingebettete
   Bilder) und die Verzeichnisse der IMAP-Konten. Wer nur die `*.mbx`
   kopiert, hat leere Hüllen.
3. **Nicht** mitkopieren: die alte `eudora.log` und eine eigene Kopie von
   `rootcerts.p7b` im Mailverzeichnis — sie hätte Vorrang vor der
   aktuellen Liste aus dem Paket (siehe [FAQ 4](#4-es-kommt-ein-zertifikatsdialog-oder-ssl-negotiation-failed--was-tun)).
4. Starten mit `Eudora starten.cmd` im neuen Verzeichnis.

*Belegt:* so geht Gregor bei jedem Testpaket vor
([TESTPLAN](../Intern/TESTPLAN.md)); die Vorlage-`Eudora.ini` ist am Paket
1.0.48 nachgemessen, die IMAP-Unterverzeichnisse am Quelltext
([EINSTELLUNGEN.md](../Intern/EINSTELLUNGEN.md), Abschnitt 2).

## 2. Welche Verschlüsselung und welchen Port nehme ich?

Für den **Abruf**: *Tools → Options… → Checking Mail →* **Secure Sockets when
Receiving** → **„Required, Alternate Port“**. Das ist TLS von der ersten
Sekunde an, bei POP3 auf **Port 995**; in der `Eudora.ini` steht dann
`SSLReceiveUse=2`. Für den **Versand** dasselbe unter *Tools → Options… →
Sending Mail →* **Secure Sockets when Sending**, bei SMTP auf **Port 465**.
Für weitere Konten stehen dieselben Felder in den Kontoeinstellungen
(*Tools → Personalities*, Rechtsklick → *Properties*).

| Wert in der `Eudora.ini` | Bedeutung |
|---|---|
| `0` | nie verschlüsseln |
| `1` | falls verfügbar (STARTTLS), sonst **unverschlüsselt** weiter |
| `2` | **erforderlich, eigener Port** — empfohlen |
| `3` | erforderlich (STARTTLS), bricht ab, wenn der Server es nicht kann |

*Am Programm geprüft* am 06.09.2026 an 7.2.0.12 (Port 995, TLSv1.3); Werte
und Felder am Quelltext (`settings.cpp:1975-1978`, `EudoraRes.rc:543`,
`:1848`), Einzelheiten in [ABRUF-PRUEFEN.md](../Intern/ABRUF-PRUEFEN.md).

## 3. Wie sehe ich, ob die Verbindung wirklich verschlüsselt ist?

Mit dem Knopf **„Last SSL Info“**: *Tools → Options… → Checking Mail* (für den
Abruf) oder *Sending Mail* (für den Versand), dazu in den Kontoeinstellungen.
Es ist ein Knopf auf der Einstellungsseite, **kein** Menüpunkt. Dort muss
`TLSv1.3` oder `TLSv1.2` stehen; `TLSv1.0` oder `TLSv1.1` darf nicht
vorkommen.

*Am Programm geprüft* am 06.09.2026 (`TLSv1.3`,
`TLS_AES_256_GCM_SHA384`); die drei Knöpfe am Quelltext
(`EudoraRes.rc:536`, `:1847`, `:2942`).

## 4. Es kommt ein Zertifikatsdialog oder „SSL Negotiation Failed“ — was tun?

* **Ein Dialog mit Zertifikatstext und einem Ablehnungsgrund:** Eudora konnte
  das Zertifikat des Servers nicht bis zu einer bekannten Wurzel
  zurückverfolgen. **OK nimmt das Zertifikat dauerhaft an** — erst den Text
  lesen. Seit Paket 1.0.48 prüft Eudora strenger; wer seitdem einen Dialog
  sieht, den er vorher nicht sah, sieht kein neues Problem, sondern ein
  bisher verschwiegenes.
* **„SSL Negotiation Failed: …“:** der Text hinter dem Doppelpunkt sagt, warum
  die Aushandlung scheiterte.
* **„Server does not support SSL“:** eingestellt ist Wert `3`, der Server
  kann aber kein STARTTLS — auf Wert `2` und Port 995 umstellen
  ([FAQ 2](#2-welche-verschlüsselung-und-welchen-port-nehme-ich)).
* **Die Liste der Wurzelzertifikate** (`rootcerts.p7b`) kommt mit dem Paket
  und liegt neben `Eudora.exe`. **Keine eigene Kopie ins Mailverzeichnis
  legen:** sie hätte Vorrang und würde mit einer neuen Fassung nicht ersetzt
  — warum das gefährlich ist, steht in der [README](../README.md) unter
  *Kompromittierte Zertifikate von eMudhra*.

*Belegt:* die strengere Prüfung hat Gregor am 11.09.2026 bestätigt
([E-82](../Intern/BEFUNDE.md#e-82)); die Meldungen am Quelltext
([ABRUF-PRUEFEN.md](../Intern/ABRUF-PRUEFEN.md), Abschnitt 5).

## 5. Im IMAP-Posteingang fehlen Mails, die der Webmailer zeigt

Eudora blendet Mails aus, die auf dem Server **als gelöscht markiert**, aber
noch nicht entfernt sind; der Webmailer zeigt sie weiter an.

* **Sichtbar machen:** Rechtsklick auf das Postfach in der Ordnerliste →
  *Show Deleted Messages*.
* **Zurückholen:** die Mail markieren → *Message → UnDelete*.
* **Endgültig entfernen:** *Message → Purge Messages* — danach sind sie auch
  auf dem Server weg.

*Am Programm geprüft:* gemessen am 13.10.2026 an Gregors Postfach, das
Zurückholen von Gregor am selben Tag bestätigt (*„undelete hat sie wieder
geholt“*, [E-120](../Intern/BEFUNDE.md#e-120)). Menüs am Quelltext
(`EudoraRes.rc:5777-5778`, `:6162`).

## 6. Wie trenne ich die Post verschiedener Konten?

Eudora nennt ein Konto *Personality* (*Tools → Personalities*). Jede Mail, die
über ein **zusätzliches** Konto ankommt, bekommt beim Abholen die Kopfzeile
`X-Persona: <Kontoname>`. Mails des Hauptkontos (`<Dominant>`) bekommen keine.

So landet die Post eines Kontos in einem eigenen Postfach:

1. *Tools → Filters*, *New*.
2. *Match:* **Incoming**.
3. *Header:* im Auswahlfeld **«Personality»** wählen, daneben **contains** und
   den Kontonamen, wie er unter *Tools → Personalities* steht (ohne `<>`).
4. *Action:* **Transfer To** und das Zielpostfach.
5. Für jedes zusätzliche Konto einen eigenen Filter. Die Post des Hauptkontos
   bleibt in *In*.

Auch die Suche kennt die Kategorie *Personality*.

*Am Quelltext nachgesehen (29.10.2026):* `pop.cpp:710-720` und
`EuImap/src/ImapDownload.cpp:427` schreiben die Kopfzeile, nur für ein Konto
außer dem Hauptkonto; `filtersd.cpp:855-866` wertet «Personality» im Filter
aus. Den Eintrag «Personality» im Filterfenster hat Gregor am 29.10.2026 am
Programm gesehen; den ganzen Weg noch niemand.

## 7. Wie lege ich ein zweites Konto an?

*Tools → Personalities*, in der Liste rechts klicken → *New…*; dann führt der
Assistent durch Name, Adresse, Anmeldename und Server. Danach die
Verschlüsselung für das Konto einstellen
([FAQ 2](#2-welche-verschlüsselung-und-welchen-port-nehme-ich)) und, wenn die
Post getrennt liegen soll, einen Filter anlegen
([FAQ 6](#6-wie-trenne-ich-die-post-verschiedener-konten)).

**Vorsicht beim Löschen:** vor dem Löschen der gerade benutzten
Persönlichkeit auf eine andere wechseln (bekannter Fehler
[E-39](../Intern/BEFUNDE.md#e-39) in der README).

*Belegt:* dass der Assistent ohne Windows-Meldung aufgeht, hat Gregor am
27.10.2026 an 1.0.127 geprüft ([E-160](../Intern/BEFUNDE.md#e-160)); den
Menüpunkt am Quelltext (`EudoraRes.rc:6266`). Ein vollständig neu angelegtes
Konto ist nicht als geprüft vermerkt.

## 8. Wie lege ich einen Kurznamen an und nutze ihn beim Schreiben?

1. *Tools → Address Book* (Strg+L) → **New**.
2. Oben im Feld *Nickname* den Kurznamen eintragen, darunter Name und Adresse,
   dann woanders hinklicken.
3. Beim Schreiben im Feld `To:` den Anfang des Kurznamens tippen — die
   Auswahlbox klappt auf. Mit den Pfeiltasten wählen, mit **Tab** übernehmen.

Eine Adresse aus einer empfangenen Mail übernehmen: Mail markieren, **Strg+K**
— siehe [ANWENDER.md](ANWENDER.md#eine-adresse-ins-adressbuch-aufnehmen).

*Am Programm geprüft:* das Anlegen und die gleich große Auswahlbox hat Gregor
am 21.10.2026 bestätigt ([E-134](../Intern/BEFUNDE.md#e-134),
[E-135](../Intern/BEFUNDE.md#e-135)); die Übernahme mit Tab ist Gregors Weg,
aber nicht eigens als Prüfung vermerkt.

## 9. Wie markiere ich wichtige Mails farbig?

Mit einem **Label**. Es gibt sieben, jedes mit Name und Farbe.

1. *Tools → Options… → Labels*: rechts den **Namen** eintragen, etwa
   `Wichtig` statt `Label 1`; links auf das Farbfeld klicken, um die Farbe zu
   wählen. Der Name erscheint danach im Menü und in der Spalte *Label* der
   Postfachliste.
2. Mail(s) in der Liste markieren, dann *Message → Change → Label →* das
   Label wählen — oder Rechtsklick auf die Mail → *Change Label*. *None*
   nimmt es wieder weg.
3. Nach Label sortieren: auf den Spaltenkopf *Label* klicken, oder
   *Edit → Sort → Sort by Label*.

**Automatisch beim Abholen** — etwa alles vom Finanzamt rot als `Wichtig`:

1. *Tools → Filters*, *New*.
2. *Match:* **Incoming**.
3. *Header:* **From:**, **contains**, und ein Stück der Absenderadresse, etwa
   `finanzamt` oder die Domain der Firma.
4. *Action:* **Make Label** → `Wichtig`. Weitere Aktionen (etwa *Transfer To*)
   lassen sich darunter anhängen.

   Sind die Labels in der Auswahl **ausgegraut**, den Filter löschen und neu
   anlegen — dann lassen sie sich wählen ([E-173](../Intern/BEFUNDE.md#e-173); Ursache
   noch nicht untersucht).

**Bekannte Einschränkung:** wird eine Mail mit Label später zwischen zwei
Ordnern **desselben IMAP-Kontos** verschoben, ist das Label danach weg — Eudora
speichert Labels nur bei sich, nicht auf dem Server
([E-170](../Intern/BEFUNDE.md#e-170); eine Abhilfe kommt erst nach dem Release 7.2.1).

Wie die Zeile aussieht: ab Werk (`WholeSummaryLabelColor=1`) wird die
**Schrift der ganzen Zeile** in der Label-Farbe gezeichnet; der Hintergrund
bleibt weiß und nimmt die Label-Farbe nur an, solange die Zeile ausgewählt ist
und die Liste den Fokus hat (sonst ist die ausgewählte Zeile grau).
Mit `WholeSummaryLabelColor=0` in der `Eudora.ini` ist nur die Spalte *Label*
farbig. Einen farbigen **Hintergrund** für nicht ausgewählte Zeilen kennt
Eudora nicht.

*Am Programm geprüft* von Gregor am 29.10.2026 an Paket 1.0.127: die Labels
(*„labels funktionieren. paßt.“*) und ein Filter auf `From:` mit
*Transfer To*, *Make Label* (Label 6) und *Skip Rest*, der die Mail grün
färbte. Am Quelltext: Menüs `EudoraRes.rc:5745-5756` und `:5943-5954`,
Sortieren `:5633`, Filteraktion `:6089` (ausgeführt in
`filtersd.cpp:1222-1226`), Vorgabe `:11232`; Zeichnen `tocview.cpp:622-641`.

## 10. Wie baue ich schnell einen Filter aus einer Mail?

Mail markieren (oder mehrere), dann *Special → Make Filter* — oder Rechtsklick
auf die Mail → *Make Filter*. Eudora schlägt eine Bedingung auf **From**,
**Any Recipient** oder **Subject** vor und als Aktion *in ein neues Postfach*,
*in ein bestehendes Postfach* oder *löschen*. **Create Filter** legt die Regel
sofort an, **Add Details** legt sie an und öffnet das Filterfenster für
weitere Aktionen (etwa *Make Label*, [FAQ 9](#9-wie-markiere-ich-wichtige-mails-farbig)).

*Am Quelltext nachgesehen* ([FILTER.md](../Intern/FILTER.md#über-make-filter)).

## 11. Wie speichere ich einen Filter?

Es gibt **keinen Speichern-Knopf**. Wer den Reiter *Filters* verlässt oder
Eudora beendet, wird gefragt: *„Save changes to …?“*. **Ja** schreibt die
Filter in die Datei `Filters.pce` im Mailverzeichnis, **Nein** verwirft alle
Änderungen. Eudora legt **keine Sicherung** an — vor größeren Umbauten
`Filters.pce` selbst kopieren.

*Am Quelltext nachgesehen*
([FILTER.md](../Intern/FILTER.md#wann-das-ergebnis-auf-der-platte-landet)).

## 12. *Filter Messages* (Strg+J) tut nichts

Ein Filter läuft beim Lauf von Hand **nur**, wenn bei ihm das Häkchen
**Manual** gesetzt ist — *Incoming* allein reicht dafür nicht. Welche Funktion
Strg+J hat, steht im Menü *Special* neben *Filter Messages*; die Belegung ist
umschaltbar (`CtrlJMapping` in der `Eudora.ini`).

*Am Quelltext nachgesehen*
([FILTER.md](../Intern/FILTER.md#wann-ein-filter-läuft) und
[Das Tastenkürzel ist nicht fest](../Intern/FILTER.md#das-tastenkürzel-ist-nicht-fest)).

## 13. Warum landet nichts automatisch in *Junk* — und was ich dabei nicht tun sollte

Die Junk-Bewertung kommt von Zusatzmodulen, die die Bibliotheken
`MFC71.DLL` und `MSVCP71.dll` brauchen. Fehlen diese auf dem Rechner, behält
**jede** Mail die Junk-Punktzahl **0**, und *Junk* füllt sich nur mit dem, was
Sie selbst als Junk markieren.

**Warnung:** eine Filterregel **«Junk Score» is less than N** trifft dann
**jede** Mail. Mit *Transfer To* verbunden, verschiebt sie das ganze
Postfach. Solche Regeln nur anlegen, wenn die Junk-Bewertung nachweislich
arbeitet.

*Belegt:* gemessen am 28.10.2026 am Prüfstand; Einzelheiten und die Ausnahme
(die Bibliotheken liegen schon auf dem Rechner) in
[FILTER.md](../Intern/FILTER.md#warum-die-junk-bewertung-hier-nicht-arbeitet).

## 14. Werden Anhänge gelöscht, wenn ich die Mail lösche?

Nicht sofort. Eine gelöschte Mail liegt zuerst im Papierkorb (*Trash*); erst
*Special → Empty Trash* entfernt sie endgültig. Die Anhänge liegen als eigene
Dateien im Anhangverzeichnis und werden **nur dann** mit gelöscht, wenn diese
Einstellung an ist:

*Tools → Options… → Attachments →* **„Delete attachments when emptying Trash“**

Ab Werk ist sie **aus** (`TidyAttach=0` in der `Eudora.ini`). Ist sie aus,
bleiben die Anhang-Dateien nach dem Leeren des Papierkorbs liegen.

Auf derselben Seite regelt *„Delete automatic attachments“*, was mit Dateien
geschieht, die Eudora selbst anhängt (*Never*, *After sending message*,
*When message emptied from Trash* — ab Werk das letzte).

*Am Programm geprüft* von Gregor am 29.10.2026 an Paket 1.0.127
(*„funktioniert“*): mit `TidyAttach=1` waren nach *Empty Trash* die fünf
Anhänge der gelöschten Mail aus dem Anhangverzeichnis verschwunden, die
übrigen Dateien blieben (`eudora.log`: *„Emptying Trash“*). Am Quelltext:
`EudoraRes.rc:435-446` (Seite *Attachments*), Vorgaben `:8232`
(`TidyAttach\n0`) und `:8813` (`AutoAttachedDeleteTrash\n1`).

## 15. Kann ich eine Mail als Anhang weiterleiten?

Nein — einen solchen Befehl gibt es in Eudora nicht. Wer eine Mail
unverändert weitergeben will, sichert sie als Datei (*File → Save As…*) und
hängt diese Datei an eine neue Mail an.

*Am Quelltext nachgesehen* ([EINSTELLUNGEN.md](../Intern/EINSTELLUNGEN.md),
Abschnitt 4).

## 16. Wie blende ich alle Kopfzeilen ein und wieder aus?

Mit dem Knopf **„Blah Blah Blah“** in der Leiste des Nachrichtenfensters. Ob
eine Nachricht mit allen Kopfzeilen aufgeht, legt `ShowAllHeaders` in der
`Eudora.ini` fest (ab Werk `0`). Welche Kopfzeilen versteckt sind, steht in
`TabooHeaders` — **Vorsicht:** ein eigener Eintrag dort **ersetzt** die
eingebaute Liste vollständig, er ergänzt sie nicht.

Innerhalb einer geöffneten Mail etwas suchen (auch in den Kopfzeilen, wenn sie
eingeblendet sind): *Edit → Find → Find Text* (Strg+Umschalt+F).

*Am Programm geprüft:* den Knopf hat Gregor am 11.09.2026 an 1.0.46 bestätigt
([E-80](../Intern/BEFUNDE.md#e-80)); die Schlüssel am Quelltext
([EINSTELLUNGEN.md](../Intern/EINSTELLUNGEN.md)).

## 17. Wie schreibt Eudora mehr ins Protokoll (`LogLevel`)?

Eudora protokolliert in `eudora.log` im Mailverzeichnis. Wie viel darin
landet, steuert **ein** Schlüssel in der `Eudora.ini` — im Abschnitt
**`[Debug]`**, nicht `[Settings]`:

```ini
[Debug]
LogLevel=25759
```

`LogLevel` ist keine Stufe, sondern eine **Summe von Schaltern**; `25759` ist
die eingebaute Vorgabe. **Vorsicht:** der Schalter `32` schreibt **alle
gesendeten Bytes** mit — auch Ihr Kennwort. Ihn nur kurz und gezielt
einschalten und das Protokoll danach nicht weitergeben. Die Tabelle aller
Schalter steht in [ANWENDER.md](ANWENDER.md#mehr-ins-protokoll-schreiben-lassen).

*Belegt:* [ANWENDER.md](ANWENDER.md#mehr-ins-protokoll-schreiben-lassen);
den Kennwort-Hinweis zum Schalter `32` nennt auch
[E-120](../Intern/BEFUNDE.md#e-120).

## 18. Steht schon woanders

| Frage | Antwort |
|---|---|
| Warum `Eudora starten.cmd` statt `Eudora.exe`? | [README](../README.md#wo-fange-ich-an) und [ANWENDER.md](ANWENDER.md) |
| Nach dem Herunterladen startet `Eudora.exe` nicht per Doppelklick | [README](../README.md#wenn-windows-den-start-blockiert-mark-of-the-web) |
| Eudora fragt, ob es das Mailverzeichnis einer anderen Installation nehmen soll | [ANWENDER.md](ANWENDER.md) |
| Windows Defender meldet einen Trojaner | [ANWENDER.md](ANWENDER.md) |
| Eine Adresse aus einer Mail ins Adressbuch übernehmen | [ANWENDER.md](ANWENDER.md#eine-adresse-ins-adressbuch-aufnehmen) |
| Eudora fragt beim Start nach dem IMAP-Kennwort | [ANWENDER.md](ANWENDER.md) |
| Alte Mails zeigen `Ã¼` statt `ü` | [ANWENDER.md](ANWENDER.md) |
| Wie melde ich einen Fehler, was gehört hinein? | [ANWENDER.md](ANWENDER.md#einen-fehler-melden) |
| Was ist bekannt kaputt, und was hilft? | [README](../README.md#bekannte-fehler), Tabelle *Bekannte Fehler* |

## 19. Welche Einstellungen sind anders als im Original Eudora — und warum?

Ein paar Vorgaben weichen bewusst vom Original 7.1 ab, vor allem für
**neu angelegte** Mailverzeichnisse: abgeholte Post bleibt auf dem Server,
als Junk Eingestuftes wird nicht auf dem Server gelöscht, Abruf und Versand
laufen verschlüsselt (Port 995 und 465), und Strg+J filtert, statt Post nach
*Junk* zu schieben. Dazu kommen ein paar Schalter, die es im Original nicht
gibt (etwa: kein Filter darf ohne ausdrückliche Erlaubnis Post auf dem Server
löschen).

Die vollständigen Tabellen — Schlüssel, Wert hier, Wert im Original, woher die
Abweichung kommt und **warum** — stehen an einer Stelle:
[EINSTELLUNGEN.md, *Was hier anders eingestellt ist als im Original*](../Intern/EINSTELLUNGEN.md#abweichungen).
Jede Zeile lässt sich zurückdrehen, indem man den Original-Wert in die eigene
`Eudora.ini` schreibt.

*Belegt:* Werte am 29.10.2026 in `tools/DEudora.ini` und `EudoraRes.rc` gegen
das Original (erster Commit des Repos) nachgesehen.
