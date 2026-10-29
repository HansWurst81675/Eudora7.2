# Häufige Fragen

Kurze Antworten zum Alltag mit Eudora 7.2. Ausführlich steht die Bedienung in
[ANWENDER.md](ANWENDER.md), die Filter in [FILTER.md](../Intern/FILTER.md).
Jede Antwort sagt, woher sie stammt: **am Programm geprüft** oder **am
Quelltext nachgesehen** (dann gilt sie für das Original-Eudora, in dieser
Portierung hat sie noch niemand angeklickt).

## Wie trenne ich die Post verschiedener Konten?

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
aus. Am Programm noch nicht geprüft.

## Wie markiere ich wichtige Mails farbig?

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

**Bekannte Einschränkung:** wird eine Mail mit Label später zwischen zwei
Ordnern **desselben IMAP-Kontos** verschoben, ist das Label danach weg — Eudora
speichert Labels nur bei sich, nicht auf dem Server
([E-170](../Intern/BEFUNDE.md#e-170); eine Abhilfe kommt erst nach dem Release 7.2.1).

*Am Quelltext nachgesehen (29.10.2026):* Aktion *Make Label* in
`EudoraRes.rc:6089`, ausgeführt in `filtersd.cpp:1222-1226`. **Am Programm
geprüft** von Gregor am 29.10.2026 an Paket 1.0.127: ein Filter auf
`From:` mit *Transfer To*, *Make Label* (Label 6) und *Skip Rest* färbte die
Mail grün.

Wie die Zeile aussieht: ab Werk (`WholeSummaryLabelColor=1`) wird die
**Schrift der ganzen Zeile** in der Label-Farbe gezeichnet; der Hintergrund
bleibt weiß und nimmt die Label-Farbe nur an, solange die Zeile ausgewählt ist
und die Liste den Fokus hat (sonst ist die ausgewählte Zeile grau).
Mit `WholeSummaryLabelColor=0` in der `Eudora.ini` ist nur die Spalte *Label*
farbig. Einen farbigen **Hintergrund** für nicht ausgewählte Zeilen kennt
Eudora nicht.

*Am Quelltext nachgesehen (29.10.2026):* Menüs `EudoraRes.rc:5745-5756`
und `:5943-5954`, Sortieren `:5633`, Vorgabe `:11232`; Zeichnen `tocview.cpp:622-641`. Die
Einstellungsseite hat Gregor am 29.10.2026 am Programm gesehen. **Am Programm
geprüft** von Gregor am 29.10.2026 an Paket 1.0.127: *„labels funktionieren.
paßt.“*

## Werden Anhänge gelöscht, wenn ich die Mail lösche?

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

*Am Quelltext nachgesehen (29.10.2026):* `EudoraRes.rc:435-446` (Seite
*Attachments*), Vorgaben `EudoraRes.rc:8232` (`TidyAttach\n0`) und `:8813`
(`AutoAttachedDeleteTrash\n1`). **Am Programm geprüft** von Gregor am
29.10.2026 an Paket 1.0.127 (*„funktioniert“*): mit `TidyAttach=1` waren nach
*Empty Trash* die fünf Anhänge der gelöschten Mail aus dem Anhangverzeichnis
verschwunden, die übrigen Dateien blieben (gegen Gregors Sicherung des
Verzeichnisses verglichen; `eudora.log`: *„Emptying Trash“*).
