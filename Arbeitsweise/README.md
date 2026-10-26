# Arbeitsweise

Regeln und Lehren aus der Portierungsarbeit an diesem Projekt — geschrieben von und
für den Assistenten, der daran arbeitet.

## Warum das hier liegt

Diese Dateien sind das Gedächtnis des Assistenten zwischen den Sitzungen. Ihr
Original liegt unter `C:\Users\Gregor\.claude\projects\…\memory\` und wird dort
automatisch geladen. Dieses Verzeichnis ist eine **Kopie im Repository**, aus zwei
Gründen:

- Das Gedächtnisverzeichnis ist nicht versioniert. Es überlebt keine Neuinstallation
  und lässt sich nicht mit anderen teilen.
- Wer nachvollziehen will, warum im Projekt etwas so und nicht anders gemacht wird,
  findet die Begründung hier statt in einem verstreuten Gesprächsverlauf.

Beide Fassungen können auseinanderlaufen. Maßgeblich für die Arbeit des Assistenten
ist das Gedächtnisverzeichnis; maßgeblich für das Nachlesen ist diese Kopie.

## Woher die Regeln stammen

Der größte Teil geht auf konkrete Fehlgriffe zurück, nicht auf allgemeine Vorsätze.
Ein Agent hat dafuer beide Sitzungsmitschriften ausgewertet - beim ersten Mal
7,6 MB, beim zweiten Mal am 06.09.2026 die vollen 34 MB Gespraechsverlauf
— und die wiederkehrenden Muster herausgezogen. Jede Regel nennt in ihrem
Abschnitt **Why** den belegten Anlass mit Datum.

Der teuerste einzelne Fehler war dabei nicht ein falscher Codeeingriff, sondern
**1 Stunde 46 Minuten Stillstand** am 28.08.2026 — in einer Zeit, die ausdrücklich
für unbeaufsichtigtes Arbeiten freigegeben war.

## Wo man anfaengt

[LEHREN-AUS-DEM-CHAT.md](LEHREN-AUS-DEM-CHAT.md) fasst die wiederkehrenden
Fehler nach Haeufigkeit zusammen, jeweils mit einem woertlichen Beleg und der
Regel, die daraus folgt. Die Datei ist am 06.09.2026 aus beiden vollstaendigen
Sitzungsmitschriften (34 MB, 474 Nachrichten von Gregor) entstanden. Wer nur
eine Datei liest, liest diese.

## Die Regeln

| Datei | Worum es geht |
|---|---|
| [CHRONIST-2026-10-12](CHRONIST-2026-10-12.md) | CHRONIST-Lauf vom 12.10.2026 - vier Nachtraege zu bestehenden Lehren, fertig zum Einsetzen ins Gedaechtnis; dazu warum sie nicht direkt in den Lehren stehen |
| [CHRONIST-2026-10-13](CHRONIST-2026-10-13.md) | CHRONIST-Lauf vom 13.10.2026 - acht Nachträge zu bestehenden Lehren aus Release 1.0.83/1.0.84 und Gregors Testlauf an 1.0.84; keine neue Lehre |
| [CHRONIST-2026-10-13b](CHRONIST-2026-10-13b.md) | CHRONIST-Lauf 13.10.2026 (zweiter): zwei neue Lehren (Commit-Schranken auf einmal, Funktionsbug vor Buchführung), drei Nachträge, neues Werkzeug tools/commit-bereit.pl |
| [CHRONIST-2026-10-13c](CHRONIST-2026-10-13c.md) | CHRONIST-Lauf 13.10.2026 (dritter): neue Lehre quelle-muss-im-bau-stehen mit Werkzeug tools/wer-baut.pl, Nachträge zu messung-muss-den-weg-treffen (F2) und erlaubnis-nicht-hineinlesen („ok“ auf Entweder-oder) |
| [CHRONIST-2026-10-13d](CHRONIST-2026-10-13d.md) | CHRONIST-Lauf 13.10.2026 (vierter): neue Lehre fund-ganz-abhaken mit Werkzeug tools/fund-punkte.pl (N1 nur in einer Richtung behoben), Nachträge zu erlaubnis-nicht-hineinlesen (Rollen in Fragen ausschreiben) und einwurf-ist-ein-messwert (neue Zeit mit dem Fund melden) |
| [CHRONIST-2026-10-13e](CHRONIST-2026-10-13e.md) | CHRONIST-Lauf 13.10.2026 (fünfter): keine neue Lehre, sieben Nachträge (Messfenster hat gewirkt, Startliste machte Nachstellläufe wertlos, Paket aus Bin\Debug, „schlimmer“ ungemessen verneint, Übergabe nur im Chat, Abschaltmeldung ungeprüft, „für morgen“ war heute machbar); Werkzeuge stapel-lesen.ps1 gesichert, testlauf.ps1 zeigt die Startliste |
| [CHRONIST-2026-10-14](CHRONIST-2026-10-14.md) | CHRONIST-Lauf 14.10.2026: keine neue Lehre, sechs Nachträge (Rückstrich und Perl-Fallen, lmos.dat wieder am falschen Ort, Gregors Postfächer, unbeantwortete Frage, Release im Vordergrund, Abschalten); Schranke pruefe-rueckstrich.pl gebaut, testlauf.ps1 nennt Altlasten |
| [CHRONIST-2026-10-15](CHRONIST-2026-10-15.md) | CHRONIST-Lauf 15.10.2026: neue Lehre erst-nachstellen-dann-ausliefern (E-121, sechs Pakete) mit Schranke pruefe-nachgestellt.pl; fünf Nachträge (Freigabe vom Vortag fest im Skript, Kennung nur im Namensraum, Zitat als Urteil gelesen, überzählige DLL im Paket, unbeantwortete Warum-Frage); testlauf.ps1 verlangt das Tagesdatum |
| [CHRONIST-2026-10-21](CHRONIST-2026-10-21.md) | CHRONIST-Lauf 21.10.2026 (E-134 Adressbuch): zwei neue Lehren mit Schranken - original-ist-eine-messung (pruefe-original-belegt.pl) und jeder-start-ins-protokoll (pruefe-startwege.pl); fünf Nachträge; 15 Eudora-Starts ohne eine Zeile im Protokoll |
| [CHRONIST-2026-10-21b](CHRONIST-2026-10-21b.md) | CHRONIST-Lauf 21.10.2026 nachmittags (E-135 Vervollständigungsbox): eine neue Lehre mit Schranke - messziel-am-merkmal-erkennen (pruefe-messziel.pl); drei Nachträge; die Gegenprobe der eigenen Schranke vom Vormittag ergab grün, aber nicht durch sie: der installierte pre-commit ist vom 20.10. und kennt sie nicht |
| [CHRONIST-2026-10-21c](CHRONIST-2026-10-21c.md) | CHRONIST-Lauf 21.10.2026 abends (Issue 102, Release 1.0.120, Register fuer Meldungen von aussen): zwei neue Lehren mit Schranken - tor-gehoert-zum-schritt und verweis-erst-nach-dem-merge (pruefe-aussenverweise.pl); vier Nachtraege; zwei weitere Werkzeuge aus eigenen Funden: pruefe-haken-aktuell.pl und die Sackgasse in pruefe-branch.pl |
| [CHRONIST-2026-10-22](CHRONIST-2026-10-22.md) | CHRONIST-Lauf 22.10.2026 (Aufraeumtag, Umzug nach Intern/ und Doku/): fuenf neue Lehren - aussenwirkung-ist-der-massstab, liste-aus-einer-quelle, einstufung-ist-keine-auskunft, gemergt-heisst-nicht-auf-main, rueckfrage-ist-keine-messung; neun Nachtraege; der 19. Fall von text-nicht-durch-schichten-schicken traf diesmal eine Schranke selbst |
| [CHRONIST-2026-10-23](CHRONIST-2026-10-23.md) | CHRONIST-Lauf 23.10.2026 - zwei neue Lehren (test-prueft-den-ausstieg, befund-gegen-die-quelle-lesen), Rueckstrich-Faelle 19 bis 21, und was Gregors Einwuerfe an diesem Tag gefunden haben |
| [CHRONIST-2026-10-25](CHRONIST-2026-10-25.md) | CHRONIST-Lauf 25.10.2026 über den 23.10. nachmittags bis 25.10. abends - eine neue Lehre (gekuerzte-ausgabe-ist-kein-ergebnis), zehn Nachträge, und warum der CHRONIST selbst zwei Tage lang als \"aktuell\" galt (rollen-faellig.pl:140) |
| [CHRONIST-2026-10-25b](CHRONIST-2026-10-25b.md) | CHRONIST-Lauf 25.10.2026 über 18:08-19:56 MEZ - eine neue Lehre (einschraenkung-im-pr-ist-kein-ja), dreizehn Nachträge; zwei Lehren in derselben Stunde gebrochen, in der sie entstanden |
| [CHRONIST-2026-10-26](CHRONIST-2026-10-26.md) | CHRONIST-Lauf 26.10.2026 über 25.10. 19:56 MEZ bis 26.10. 07:18 MEZ - keine neue Lehre, neun Nachträge, eine Entscheidungsnotiz; E-137-Test las die falsche Funktion, Ansage-Regel 17 Minuten nach ihrer Spiegelung wieder gebrochen |
| [abschalten-ist-ein-termin](abschalten-ist-ein-termin.md) | Wenn Gregor das Abschalten ankuendigt, ist das eine Frist - sichern hat Vorrang vor jeder laufenden Arbeit |
| [agent-vor-dem-ende-nicht-starten](agent-vor-dem-ende-nicht-starten.md) | Ein Agent, der beim Sitzungsende noch laeuft, verliert seine ganze Arbeit - vor einer angekuendigten Pause keinen mehr starten |
| [agenten-benennen](agenten-benennen.md) | Jedem Agenten einen kurzen deutschen Namen geben und den Stand als Tabelle zeigen |
| [agenten-koordinieren](agenten-koordinieren.md) | Fünf Kollisionsarten paralleler Agenten und das Verfahren gegen jede; die Zuteilung ist meine Aufgabe, nicht die der Agenten |
| [agenten-trennen-worktrees](agenten-trennen-worktrees.md) | Parallele Agenten teilen sich Arbeitsverzeichnis und git-Index — mit Worktrees trennen, sonst mit Pfadangabe committen |
| [anforderung-gehoert-in-den-massstab](anforderung-gehoert-in-den-massstab.md) | Eine Anforderung, die nur in der Umsetzung steht, ist keine; sie gehoert nach ZIEL.md und braucht eine Schranke, die beide Seiten gegeneinander haelt |
| [anweisungen-abarbeiten](anweisungen-abarbeiten.md) | Gregors Nachrichten sind Arbeitsaufträge — Material sofort auswerten, Absprachen festhalten, nichts Neues erfinden |
| [anwenderdatei-nicht-erschlagen](anwenderdatei-nicht-erschlagen.md) | Eine Datei, die es beim Anwender oder im Original schon gibt, wird gelesen und ergaenzt - nie neu geschrieben und ins Paket gelegt |
| [anzeige-ist-kein-zustand](anzeige-ist-kein-zustand.md) | Ein Text aus der Oberflaeche ist eine Behauptung des Programms ueber sich selbst - E-83 suchte drei Tage ein Startproblem, das es nie gab |
| [arbeitsbaum-braucht-eigenes-gegenstueck](arbeitsbaum-braucht-eigenes-gegenstueck.md) | Ein Arbeitsbaum-Zweig ohne eigenen Upstream hebt die Trennung auf, fuer die es Arbeitsbaeume gibt - und die fertige Ursachenerklaerung war falsch |
| [assert-ist-im-release-nichts](assert-ist-im-release-nichts.md) | ASSERT und VERIFY sind im Release-Bau weg; bei \"es passiert nichts\" zuerst auf dem betroffenen Weg nach ASSERT(0) und VERIFY( suchen |
| [auftrag-darf-nicht-loeschen](auftrag-darf-nicht-loeschen.md) | Ein Auftrag, der die Arbeit des Beauftragten verwirft, ist ein eigener Fehler - zwei von zwei Auftraegen trugen reset --hard |
| [auftrag-vor-selbstbetrachtung](auftrag-vor-selbstbetrachtung.md) | Sachfrage zuerst beantworten; Selbstkritik gehoert in eine Lehre-Datei, nicht in die Antwort |
| [ausbleiben-ist-kein-befund](ausbleiben-ist-kein-befund.md) | Eine Messung, die nichts ausgibt, hat nichts gemessen - am 20.10.2026 blieb die Spurmarke zu E-132 aus zwei verschiedenen Gruenden stumm (zwei Pfade in einer Registry-Zeichenkette, dann ein Protokoll, das noch gar nicht offen war), und dieselbe Fehldeutung lief am selben Abend noch zweimal |
| [ausloeser-an-den-anfang](ausloeser-an-den-anfang.md) | Eine Schranke am Ende der Arbeit beantwortet eine Frage, die am Anfang gestellt werden musste - rollen-faellig.pl hing nur am Paketbau |
| [ausreisser-ist-der-befund](ausreisser-ist-der-befund.md) | Was in der eigenen Messausgabe steht und nicht ins Ergebnis passt, ist der Befund - nicht das Rauschen, das man wegerklaert |
| [aussenwirkung-ist-der-massstab](aussenwirkung-ist-der-massstab.md) | 43 Schranken meldeten gruen, waehrend in der Wurzel 21 Dateien mit 25.532 Zeilen lagen und README.md allein 1266 - am 22.10.2026 hat Gregor an einem Tag viermal gesehen, was keine Schranke sieht: das gerenderte Dokument |
| [befund-gegen-die-quelle-lesen](befund-gegen-die-quelle-lesen.md) | Widerlegt wird der Prueferbericht, nicht die Zusammenfassung in BEFUNDE.md - aus "Block 4a ist tot" war "der Kern ist tot" geworden, und daran haette eine Auslieferung gehangen |
| [befund-in-klartext](befund-in-klartext.md) | Gregor versteht die Befundzeilen in BEFUNDE.md nicht mehr - jede braucht vorn drei Saetze Klartext (was der Anwender merkte, Stand, was noch fehlt), die Herleitung dahinter |
| [bestand-vor-neuer-suche](bestand-vor-neuer-suche.md) | Bevor etwas neu gesucht wird, wird der Bestand gelesen - die Antwort auf E-85 stand 14 Tage fertig in BEFUNDE.md, mit Zeilennummern und Handlungsanweisung |
| [chat-knapp-halten](chat-knapp-halten.md) | Antworten im Chat kurz halten; Messdetails gehören in BEFUNDE.md, nicht in die Konsole |
| [commit-auf-einmal-pruefen](commit-auf-einmal-pruefen.md) | Vor dem ersten Commit nach einem Versionssprung oder Urteilswechsel alle Schranken auf einmal fahren (tools/commit-bereit.pl) - der Haken zeigt je Anlauf nur den ersten Mangel |
| [commit-auf-extra-branch-und-pushen](commit-auf-extra-branch-und-pushen.md) | Zwischenstaende regelmaessig auf einem eigenen Branch committen und pushen, nicht erst am Ende |
| [datenformat-aendern-heisst-alle-leser-messen](datenformat-aendern-heisst-alle-leser-messen.md) | Wer das Format einer gemeinsam gelesenen Datei aendert, misst JEDEN Leser dagegen - sonst melden die blind gewordenen weiter gruen |
| [daueraufgaben-brauchen-einen-takt](daueraufgaben-brauchen-einen-takt.md) | Lektor, Pruefer und Chronist laufen nach einem festen Auslaeser; wenn Gregor nach ihnen fragen muss, ist die Rolle nicht eingerichtet |
| [doku-bei-jedem-commit-mitziehen](doku-bei-jedem-commit-mitziehen.md) | README.md und PORTIERUNG.md gehoeren in denselben Commit wie die Aenderung, nicht nachtraeglich auf Zuruf |
| [doku-parallel-nicht-hinterher](doku-parallel-nicht-hinterher.md) | Ein Wert, der in mehreren MDs steht, wird im selben Arbeitsschritt ueberall berichtigt; doku-pruefen.pl haelt sie gegeneinander |
| [dummy-statt-weglassen](dummy-statt-weglassen.md) | Nicht benutzte Funktionen, Methoden und Klassen als Dummy implementieren, statt sie auszubauen |
| [eigene-schleife-verschluckt-nichts](eigene-schleife-verschluckt-nichts.md) | Eine eigene Nachrichtenschleife darf WM_QUIT nicht entnehmen, ohne sie zurückzustellen — und nicht ohne Zeitschranke warten |
| [eine-stelle-dann-verlinken](eine-stelle-dann-verlinken.md) | Gregor 26.10.2026 - jede Information in den MD-Dateien nur an EINER Stelle, andere MDs verlinken dorthin; keine Widersprueche |
| [eingebaute-messung-auslesen](eingebaute-messung-auslesen.md) | Eine Spurmarke, die niemand ausliest, ist keine Messung - der Moment des Auslesens gehoert an das naechste Paket |
| [einigkeit-ist-kein-beweis](einigkeit-ist-kein-beweis.md) | Dokumente gegeneinander zu prüfen findet nur Widersprüche; der Maßstab muss von außen kommen |
| [einschraenkung-im-pr-ist-kein-ja](einschraenkung-im-pr-ist-kein-ja.md) | Eine bekannte falsche Aussage im PR-Text offenzulegen ist keine Zustimmung Gregors, sie auf main zu bringen; aufgeschoben wird ein Fund nur mit seinem Ja zu genau diesem Fund |
| [einstufung-ist-keine-auskunft](einstufung-ist-keine-auskunft.md) | \"teilweise, Wirkung belegt\" sagt nicht, was noch zu tun ist - am 22.10.2026 nannten 23 von 40 offenen Befunden nur ihre Einstufung, acht davon mit einem einzigen Wort |
| [einwurf-ist-ein-messwert](einwurf-ist-ein-messwert.md) | 54 Prozent von Gregors Nachrichten kamen mitten in den laufenden Zug - das misst fehlenden Zwischenstand, nicht Beteiligung |
| [entscheidung-e148-release-7-2-0-123](entscheidung-e148-release-7-2-0-123.md) | Gregor 25.10.2026 - E-148 (eMudhra-Wurzeln) wird mit dem Release 7.2.1.<n> veroeffentlicht, nach seinem lokalen Test; 7.2.0.123 ist nur Testpaket |
| [entscheidung-kritische-nicht-release-blocker](entscheidung-kritische-nicht-release-blocker.md) | Gregor 23.10.2026 - die sechs offenen \"kritischen\" Befunde E-122, E-123, E-124, E-126, E-129, E-136 halten 7.2.1.0 NICHT auf (\"unkritisch, randfaelle\"); noch nicht im Repo eingetragen |
| [entscheidung-marke-v7-2-1](entscheidung-marke-v7-2-1.md) | Die GitHub-Marke fuer Releases heisst v7.2.1.<n> (z. B. v7.2.1.123), nicht v1.0.<n> - entschieden, nicht wieder fragen |
| [entscheidung-message-id-kein-befund](entscheidung-message-id-kein-befund.md) | Gregor 25.10.2026 - die Message-ID-Frage (HermesMail-Faden, RFC 5322) bekommt keinen Befund; zwei Randfälle in AssignMessageId stehen nur hier, dazu ein ungeprüfter Puffer-Hinweis |
| [entscheidung-rootcerts-logzeile](entscheidung-rootcerts-logzeile.md) | Gregor 25.10.2026 - Eudora schreibt eine Zeile in eudora.log, aus welchem Verzeichnis rootcerts.p7b geladen wurde (Mailverzeichnis vor Programmverzeichnis) |
| [entscheidung-vor-7-2-1-beheben](entscheidung-vor-7-2-1-beheben.md) | Gregor 25.10.2026 - vor 7.2.1 beheben E-137, E-142 (Hinweis), E-146; in die README als bekannte Fehler E-144, E-143, E-139, E-136, AN-1 (IMAP-Endung) |
| [erfolg-aus-anwendersicht](erfolg-aus-anwendersicht.md) | Erfolg wird daran gemessen, was Gregor danach tun kann; kein Crash ist keine Verbesserung |
| [erfolgsmeldung-aus-dem-ergebnis](erfolgsmeldung-aus-dem-ergebnis.md) | Ein Skript darf Erfolg nur melden, wenn es das Ergebnis gemessen hat - mein Perl-Einzeiler schrieb 'eingefuegt', ohne etwas einzufuegen |
| [erlaubnis-nicht-hineinlesen](erlaubnis-nicht-hineinlesen.md) | Eine Aussage Gregors über SEIN Vorgehen ist keine Erlaubnis für mein Vorgehen; keine Regel selbst lockern |
| [erst-nachstellen-dann-ausliefern](erst-nachstellen-dann-ausliefern.md) | Ein Paket, das Gregors Fehler beheben soll, braucht vorher am eigenen Prüfstand: alter Stand rot, neuer grün - E-121 brauchte sechs Pakete, das erste nachgestellte hielt beim ersten Anlauf |
| [erst-pruefen-dann-anweisen](erst-pruefen-dann-anweisen.md) | Keine Handlungsanweisung an Gregor geben, ohne sie vorher selbst durchgeführt und gemessen zu haben |
| [extrakt-ist-nicht-das-programm](extrakt-ist-nicht-das-programm.md) | Ein ausgeschnittener Pruefstand misst die Regel, nicht ihre Verwendung - Lebenslauf, Aufrufstellen und Uebersetzbarkeit bleiben ungeprueft; am 19.10.2026 dreimal an einem Tag |
| [fehlerbild-ist-ein-messfenster](fehlerbild-ist-ein-messfenster.md) | Solange Gregors Fehlermeldung offen steht, ist der Fehlerzustand messbar - erst messen (Log, Stapel des laufenden Prozesses), dann schließen lassen |
| [fehlerklassen-abstellen](fehlerklassen-abstellen.md) | Wiederholte Fehler mit Werkzeug und Schranke abstellen, nicht einzeln nachbessern — Vorsatz allein hält nicht |
| [fertig-heisst-fertig](fertig-heisst-fertig.md) | Wenn ich 'fertig' sage, muss Gregor mergen, loeschen und ein Release haben koennen - ohne dass etwas nachkommt |
| [fertige-fassung-bereitstellen](fertige-fassung-bereitstellen.md) | Ist eine neue Fassung fertig, erst eigene Tests, dann als Verzeichnis neben Gregors letztem Release-Verzeichnis bereitstellen |
| [fund-ganz-abhaken](fund-ganz-abhaken.md) | Vor der Behebung eines Fundes seine Punkte als Liste abhaken (tools/fund-punkte.pl): N1 wurde nur in einer Richtung behoben, obwohl PRÜFER-23 die Gegenrichtung im selben Abschnitt nannte |
| [funktion-bringt-ihre-vorbedingung-mit](funktion-bringt-ihre-vorbedingung-mit.md) | Wer eine bewaehrte Funktion in einen neuen Weg einbaut, uebernimmt ihre Vorbedingungen und Nebenwirkungen - ISOTranslate nullt ein Byte hinter dem Bereich |
| [funktionsbug-vor-buchfuehrung](funktionsbug-vor-buchfuehrung.md) | Wartet Gregor auf eine Behebung, läuft sie im Vordergrund zuerst; Buchführung (Doku, Aufräumen, Merges der Rollen) geht in den Hintergrund oder danach |
| [gegenprobe-einmal-beim-bau](gegenprobe-einmal-beim-bau.md) | Die rote Gegenprobe (Test ohne Fix muss rot werden) gehoert einmal zum BAU eines Tests; im laufenden Betrieb genuegt gruen |
| [gegenprobe-umdrehen](gegenprobe-umdrehen.md) | Nicht pruefen, ob der gewuenschte Zustand erscheint, sondern ob der umgekehrte Wert durchkommt; Gregors Technik vom 07.09.2026 |
| [gekuerzte-ausgabe-ist-kein-ergebnis](gekuerzte-ausgabe-ist-kein-ergebnis.md) | Was ich mit head, tail, cut oder grep aus meiner eigenen Ausgabe herausschneide, kann ich nicht als 'nicht vorhanden' oder 'erfolgreich' melden - am 24./25.10.2026 wurde so aus einer aufgeschriebenen Entscheidung 'nichts vereinbart' und aus einer Commit-Abweisung ein Erfolg |
| [gemeinsame-dateien-gegen-alles-messen](gemeinsame-dateien-gegen-alles-messen.md) | Änderungen an gemeinsam benutzten Dateien gegen die ganze Solution messen, nicht nur gegen das eigene Projekt |
| [gemergt-heisst-nicht-auf-main](gemergt-heisst-nicht-auf-main.md) | GitHub zeigte PR #134 und #135 beide als merged, und main enthielt den Inhalt von #135 trotzdem nicht - der Zweig war von #134 abgezweigt statt von main, 13 Minuten lang stand ein Paket als geliefert da, das nirgends angekommen war |
| [haengende-kommandos-abbrechen](haengende-kommandos-abbrechen.md) | Hängende Kommandos früh erkennen, abbrechen und anders lösen statt Zeitlimits auslaufen zu lassen |
| [jeder-start-ins-protokoll](jeder-start-ins-protokoll.md) | Eine Schranke, die im Werkzeug sitzt, prüft nur die, die das Werkzeug benutzen - am 21.10.2026 liefen 15 Eudora-Starts an testlauf.ps1 vorbei, 0 Zeilen in TESTLAEUFE.md |
| [kein-paket-mit-offenem-datenverlust](kein-paket-mit-offenem-datenverlust.md) | Kein Paket ausliefern, solange ein bekannter Weg offen ist, auf dem der Anwender Daten verliert |
| [keine-tastendruecke-verschicken](keine-tastendruecke-verschicken.md) | SendKeys geht an das Fenster im Vordergrund, nicht an mein Zielfenster - am 08.09.2026 habe ich damit Gregors Explorer-Fenster geschlossen |
| [kuerzel-im-chat-uebersetzen](kuerzel-im-chat-uebersetzen.md) | Fundkürzel der Prüfer (F1, N1, L-38.4 …) nie allein im Chat – immer was passiert, wann, mit welcher Folge |
| [lauffaehiges-ergebnis-liefern](lauffaehiges-ergebnis-liefern.md) | Ziel ist eine einsetzbare Eudora-Version, nicht ein Zwischenstand — pragmatisch priorisieren, mit Prüfanleitung übergeben |
| [lehren-anwenden-nicht-nur-schreiben](lehren-anwenden-nicht-nur-schreiben.md) | Eine aufgeschriebene Lehre ohne Ausloeser und Werkzeug wirkt nicht - jede Lehre braucht einen Moment, in dem sie geprueft wird |
| [liste-aus-einer-quelle](liste-aus-einer-quelle.md) | Wer dieselbe Liste zweimal von Hand fuehrt, fuehrt sie einmal falsch - die Liste \"Noch offen\" im CHANGELOG nannte am 22.10.2026 fuenf Befunde als offen, die in ihrer EIGENEN Statusspalte \"behoben\" sagten, und zehn offene fehlten ganz |
| [main-muss-immer-baubar-sein](main-muss-immer-baubar-sein.md) | main trägt immer einen Stand, der fehlerfrei baut und aus dem sich jederzeit ein Release erstellen lässt |
| [mannschaft-fuehren](mannschaft-fuehren.md) | Agenten brauchen ein Symptom im Auftrag, keinen Gebietsauftrag; jeden Ruecklauf selbst nachmessen |
| [messung-muss-den-weg-treffen](messung-muss-den-weg-treffen.md) | Ein Gegentest im falschen Betriebsmodus oder an einem Stand ohne die Aenderung beweist nichts; erst pruefen, ob der geprueste Weg ueberhaupt gelaufen ist |
| [messziel-am-merkmal-erkennen](messziel-am-merkmal-erkennen.md) | Ein Messziel wird an einem Merkmal der Sache erkannt, nicht an einer Eigenschaft, die viele teilen - am 21.10.2026 traf die Suche nach der Fensterklasse #32770 den Kontenassistenten (453x341, ueber sechs Schritte unveraendert) statt der Vervollstaendigungsbox, und das sah aus wie 'kein Fehler' |
| [nichts-auf-gregors-bildschirm-starten](nichts-auf-gregors-bildschirm-starten.md) | Kein Programm mit Fenstern auf Gregors Sitzung starten, ohne vorher zu fragen — auch nicht durch Agenten |
| [nie-benutzt-ist-nicht-geprueft](nie-benutzt-ist-nicht-geprueft.md) | Was niemand je angeklickt hat, gilt nicht als geprueft - E-97 lag 15 Fassungen und ein veroeffentlichtes Release lang im Speichern-Dialog |
| [nie-direkt-auf-main](nie-direkt-auf-main.md) | Jede Änderung geht über einen eigenen Zweig; auf main wird nur gemergt, und Gregor merged |
| [nie-stillstehen](nie-stillstehen.md) | Leerlauf ist der teuerste Fehler dieses Projekts — im Hintergrund bauen, weiterarbeiten, ungefragt melden |
| [nummer-erst-beim-schnueren](nummer-erst-beim-schnueren.md) | Ein Paketeintrag heisst "gebaut", bevor es ein Paket gibt - 1.0.107, .108 und .109 mussten alle drei nachtraeglich in "nie geschnuert" umgeschrieben werden |
| [nur-offene-entscheidungen-auf-gregors-liste](nur-offene-entscheidungen-auf-gregors-liste.md) | Auf Gregors Liste kommt ein Punkt nur, wenn ein Satz IHN nennt und die Entscheidung noch offen ist - sonst ist es meine Arbeit |
| [nur-testplan-zaehlt](nur-testplan-zaehlt.md) | Gregor testet nur noch, was in Intern/TESTPLAN.md im Repo steht; Testanweisungen im Chat zählen nicht |
| [original-ist-eine-messung](original-ist-eine-messung.md) | „Originalfehler\" ist eine Aussage über ein Verhalten, nicht über Quelltext - in einer Portierung ist die unveränderte Quelle gerade der Ort, an dem Verhalten lautlos umkippt |
| [paket-gegen-den-bau-messen](paket-gegen-den-bau-messen.md) | Was im Paket liegt, ist nicht automatisch das, was ich gebaut habe - jede Datei im Paket gegen das Bauverzeichnis messen, bevor Gregor sie bekommt |
| [pakete-sammeln](pakete-sammeln.md) | Kein Testpaket für eine einzelne Behebung anbieten; Gregor testet mehrere Sachen zusammen in einem Bau |
| [pruefen-statt-vermuten](pruefen-statt-vermuten.md) | Vorhandene Quellen oeffnen, bevor ich eine Ursache vermute - und Vermutungen nie als Tatsache aussprechen |
| [pruefstand-kann-blind-sein](pruefstand-kann-blind-sein.md) | Ein kaputter und ein gruener Pruefstand melden im Alltag dasselbe, naemlich nichts - die Pruefinstanz braucht ihre eigene Schranke |
| [pruefstand-nicht-bequemer-als-die-wirklichkeit](pruefstand-nicht-bequemer-als-die-wirklichkeit.md) | Ein Pruefstand, der bequemer gebaut ist als die Wirklichkeit, misst den Fehler weg - C:\\Temp\\E132 ist sein eigener 8.3-Kurzname, deshalb meldeten alle drei Messungen zu E-132 gruen, waehrend Eudora beim Anwender sein EIGENES Mailverzeichnis fuer fremd hielt |
| [pruefumfang-nicht-von-hand](pruefumfang-nicht-von-hand.md) | Prueflisten und Agentenauftraege holen ihren Umfang aus der Quelle; was von Hand aufgezaehlt wird, prueft genau das nicht, woran niemand gedacht hat |
| [pruefung-legt-nichts-ab](pruefung-legt-nichts-ab.md) | Eine Pruefung, die zum Messen etwas Ausfuehrbares auspackt, misst am Ende den Virenscanner mit - am 20.10.2026 zog Defender die von unserer eigenen Schranke ausgepackte Eudora.exe ein, und die Schranke meldete danach eine falsche Fassung fuer ein richtiges Paket |
| [quelldateien-nur-byte-erhaltend-aendern](quelldateien-nur-byte-erhaltend-aendern.md) | Eudora-Quellen sind Latin-1 mit gemischten Zeilenenden - nur byte-erhaltend aendern, nie mit dem Edit-Werkzeug |
| [quelle-muss-im-bau-stehen](quelle-muss-im-bau-stehen.md) | Vor dem Ändern einer Quelldatei prüfen, ob ein Projekt der Mappe sie überhaupt baut (tools/wer-baut.pl) - die F1-Behebung saß in PGEMBED.C, Paige32.dll wird nicht aus dem Quelltext gebaut |
| [reihenfolge-nach-1083](reihenfolge-nach-1083.md) | Gregors Reihenfolge der Befunde - Stand 14.10.2026: nach PR e-112-skalierung zuerst E-105, dann E-118, E-113, E-77 |
| [release-erst-nach-gregors-test](release-erst-nach-gregors-test.md) | Ein GitHub-Release entsteht erst, nachdem Gregor die Fassung lokal geprüft und für gut befunden hat |
| [review-sieht-nur-den-diff](review-sieht-nur-den-diff.md) | Ein Diff-Review kann eine veraltete unveraenderte Datei nicht sehen; vor dem Merge wird der Bestand geprueft, nicht die Aenderung |
| [rollenzuweisung-pruefen](rollenzuweisung-pruefen.md) | Einer falschen Rollenzuweisung im Auftrag folgen, statt sie zu benennen - und die Rolle stand in keiner nachschlagbaren Quelle |
| [rueckfrage-ist-keine-messung](rueckfrage-ist-keine-messung.md) | Gregor zu \"S-3b\": \"ist es die s-bahn?\" - und als ich IHN nach der Bedeutung der vier unklaren Nummernkreise fragte: \"wie kann ich dir sagen, ob wir es abhaken koennen, wenn nicht mal du mir sagen kannst, was es ist?\" Die Antwort stand in den einfuehrenden Commits |
| [schranke-gegentesten](schranke-gegentesten.md) | Jede neue Schranke gegen den echten Fehler fahren und gegen den erlaubten Fall; eine stumme Pruefung und ein Fehlalarm sind derselbe Schaden |
| [schranke-gehoert-in-den-haken](schranke-gehoert-in-den-haken.md) | Eine Schranke, die nur läuft wenn ich daran denke, ist keine Schranke; und eine, die zu oft umsonst warnt, wird entwaffnet |
| [schranke-liest-nur-code](schranke-liest-nur-code.md) | Eine Schranke, die Quelltext mit Regex prueft, muss Kommentare und Protokolltexte vorher wegwerfen und ihren Bereich am Rumpfende abschliessen - sonst liest sie ihre eigene Begruendung |
| [schranke-teilt-nicht-die-annahme](schranke-teilt-nicht-die-annahme.md) | Eine Schranke, die ihren Umfang aus derselben Annahme nimmt wie das Werkzeug, das sie pruefen soll, prueft nichts |
| [stand-22-10-2026-abend](stand-22-10-2026-abend.md) | Was am Abend des 22.10.2026 nach dem letzten Merge offen blieb und NICHT im Repo steht - vier Berichtigungen, ein Sicherheitspunkt, das E-124-Ergebnis |
| [stand-23-10-2026-abend](stand-23-10-2026-abend.md) | Was am 23.10.2026 beim Abschalten offen blieb und in KEINER Repo-Datei steht - die fertige Berichtigung des Testplan-Kopfes, der Zweigname, und was Gregor als naechstes erwartet |
| [stand-23-10-2026-spaet](stand-23-10-2026-spaet.md) | Stand beim Abschalten am 23.10.2026 spaet - PR 156 offen, BILDBREITE (E-116) mitten in der Arbeit abgebrochen, Regressionstest-Rueckstand ist der erste Schritt |
| [stand-24-10-2026-spaet](stand-24-10-2026-spaet.md) | Stand beim Abschalten am 24.10.2026 spaet - PRUEFER-50 nur als Zwischenstand gesichert, E-148 als naechstes, angleichen.sh will \"main\" |
| [stand-25-10-2026-abend](stand-25-10-2026-abend.md) | Uebergabe 25.10.2026 spaet - RC1_vorbereiten als PR gemeldet; morgen zuerst CHRONIST, dann E-142-Hinweis, E-146, Logzeile, E-132-Pruefstandsfall, LEKTOR-61-Funde, Testpaket 7.2.0.123 |
| [teilweise-ersetzte-header](teilweise-ersetzte-header.md) | Include-Wächter wirken pro Datei — wer nur einen Teil eines Headers ersetzt, darf den Wächter nicht setzen |
| [test-prueft-den-ausstieg](test-prueft-den-ausstieg.md) | Ein Regressionstest, der nur die neue Meldung sucht und nicht den Ausstieg, laesst den ganzen Fehler zurueck - 277 von 277 gruen mit vollstaendig wiederhergestelltem Befund |
| [testdaten-muessen-durchkommen](testdaten-muessen-durchkommen.md) | Ein Testdatum muss nicht nur den Fehler treffen, sondern jede Schranke auf dem Weg zur Messstelle ueberleben - 550 Spam message rejected |
| [tests-vor-jedem-commit-laufen-lassen](tests-vor-jedem-commit-laufen-lassen.md) | Unit- und Komponententests gehoeren zu jedem Commit - Ergebnis mitteilen, auch wenn es rot ist |
| [testschritt-nennt-den-ort](testschritt-nennt-den-ort.md) | Eine Testanweisung an Gregor nennt jedes Postfach so, dass es nur eines gibt (lokal oder IMAP, Lage im Baum) - zweimal am 23.10.2026 hat ein ungenauer Schritt seinen Lauf entwertet |
| [text-nicht-durch-schichten-schicken](text-nicht-durch-schichten-schicken.md) | Ersetzungstext mit Backslashes oder Anfuehrungszeichen nie inline durch Bash/PowerShell nach Perl reichen; in eine Datei schreiben und ueber Zeilenanker einsetzen |
| [tor-gehoert-zum-schritt](tor-gehoert-zum-schritt.md) | Jede Schranke gehoert zu genau EINEM Schritt und sagt ueber die anderen nichts - am 21.10.2026 hielt die Abweisung von paket-bereit.pl (Schranke vor dem BAUEN) das Veroeffentlichen von 1.0.120 auf, obwohl das Paket seit Stunden fertig war und release-veroeffentlichen.ps1 in WERKZEUGE.md Zeile 123 stand |
| [ueberall-heisst-ueberall](ueberall-heisst-ueberall.md) | Wenn Gregor den Umfang absolut nennt, wird er nicht aus Geschmack gekuerzt - die Sparversion anbieten, nicht heimlich liefern |
| [unterschied-im-selben-bild](unterschied-im-selben-bild.md) | Was im selben Bild richtig ist, schliesst jede gemeinsame Ursache aus - der Unterschied ist der Befund |
| [ursache-nur-gemessen-behaupten](ursache-nur-gemessen-behaupten.md) | Eine Ursache, die ich nicht gemessen habe, gehoert nicht in einen Bericht - zeitliche Naehe ist keine Messung; am 19.10.2026 zweimal behauptet, beide Male war der Beschuldigte unschuldig |
| [vereinbartes-vor-neuem](vereinbartes-vor-neuem.md) | Was mit Gregor als Voraussetzung vereinbart ist (z. B. Regressionstest-Rueckstand vor 7.2.1.0), kommt vor jedem neuen Thema - nicht erst, wenn er danach fragt |
| [version-eindeutig-machen](version-eindeutig-machen.md) | Jede Fassung, die Gregor in die Hand bekommt, muss sich selbst benennen koennen - Nummer, Commit, Bauzeit, sichtbar im Programm |
| [verweis-erst-nach-dem-merge](verweis-erst-nach-dem-merge.md) | Was nach aussen geht, wird gegen den SERVERSTAND gemessen, nicht gegen den Arbeitsbaum - am 21.10.2026 um 21:33 ging ein Beitrag an Issue 102 mit einem Verweis auf blob/main/MELDUNGEN-VON-AUSSEN.md hinaus, die Datei kam erst um 21:36:59 mit dem Merge an, und es war das zweite Mal |
| [verwerfen-nur-mit-zaehler](verwerfen-nur-mit-zaehler.md) | Ein verwerfender Befehl wirkt auf seinen ganzen Umfang, nicht auf das gemeinte Ziel - vier Selbstverschuldungen in einer Stunde, jede mit einem Wert vorher oder nachher zu fangen |
| [vor-dem-code-die-pruefberichte](vor-dem-code-die-pruefberichte.md) | Vor der ersten Zeile an einer Stelle nachsehen, wer sie schon geprueft hat - befund-suchen.pl sieht nur 182 von 591 Kennungen, die Antwort auf E-101 lag in den uebrigen |
| [was-lauffaehig-heisst](was-lauffaehig-heisst.md) | Gregors drei Kriterien für „lauffähig" — und dass ein erscheinendes, aber unbedienbares Fenster keines davon erfüllt |
| [werkzeug-vor-eigenbau](werkzeug-vor-eigenbau.md) | Vor dem eigenen Dreizeiler in tools/WERKZEUGE.md nachsehen; und ein fertiges Werkzeug, das niemand aufruft, wirkt so wenig wie eine Lehre, die nur Text ist |
| [widerlegte-vermutungen-aufschreiben](widerlegte-vermutungen-aufschreiben.md) | Jede widerlegte Vermutung mit ihrer Messung in die Befunddatei; das Ausschlussverfahren fuehrt zur Zeile |
| [wissen-gehoert-in-dateien](wissen-gehoert-in-dateien.md) | Befunde und Erkenntnisse gehören in Dateien im Repo, nicht nur in den Chat — sonst überleben sie kein Abschalten |
| [zeilenenden-nach-jedem-schreibzugriff-messen](zeilenenden-nach-jedem-schreibzugriff-messen.md) | Nach jedem Skript, das Dateien schreibt, die CR-Anzahl gegen HEAD messen - der Fehler ist lautlos |
| [zurueckgestellte-befunde](zurueckgestellte-befunde.md) | Gefundene, belegte Maengel, die Gregor bewusst spaeter angehen will - nicht von selbst anfassen |
| [zwei-werte-in-eine-ausgabe](zwei-werte-in-eine-ausgabe.md) | Zwei Werte, deren Widerspruch geklaert werden soll, gehoeren in denselben Aufruf - zwei Protokollzeilen lassen die Erklaerung 'zu verschiedenen Zeitpunkten' immer offen |
| [zweig-vorher-abstimmen](zweig-vorher-abstimmen.md) | Einen Zweig erst anlegen, wenn Gregor den Namen bestaetigt hat; ein nicht vereinbarter Zweig wird geloescht |
| [zweigname-heisst-vorheriger-fertig](zweigname-heisst-vorheriger-fertig.md) | Einen neuen Zweignamen vorzuschlagen ist die Behauptung, der vorherige sei vollständig — erst git status leer und gepusht |
| [zwischendateien-ins-scratchpad](zwischendateien-ins-scratchpad.md) | Zwischendateien (Sicherungskopien, Ersatztexte, Messausgaben, Agentenauftraege) nie nach $TEMP, sondern ins Scratchpad der Sitzung |

`MEMORY.md` ist das Inhaltsverzeichnis, das der Assistent zu Sitzungsbeginn lädt.

## Eine bekannte Schwäche

Diese Dateien werden am Sitzungsende aus dem Gedächtnis geschrieben, ohne Gegenprüfung
am Mitschnitt. Genau so ist eine falsche Begründung in
[wissen-gehoert-in-dateien](wissen-gehoert-in-dateien.md) entstanden: ein
Schuldeingeständnis, das sich beim Nachmessen als sachlich falsch erwies. Wenn diese
Regeln denselben Rang wie Code haben sollen, bräuchten sie dieselbe Prüfung wie die
übrige Dokumentation — einen zweiten Durchgang, der jede zitierte Tatsache belegt.

**Schranke:** keine — diese Datei ist das Inhaltsverzeichnis des Verzeichnisses,
nicht selbst eine Lehre. Die Schranken stehen bei den einzelnen Lehren; dass
jede eine hat, prueft `tools/lehren-schranken.pl` vor jedem Commit.
