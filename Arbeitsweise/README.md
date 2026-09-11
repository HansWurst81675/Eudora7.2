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
| [abschalten-ist-ein-termin](abschalten-ist-ein-termin.md) | Wenn Gregor das Abschalten ankuendigt, ist das eine Frist - sichern hat Vorrang vor jeder laufenden Arbeit |
| [agenten-benennen](agenten-benennen.md) | Jedem Agenten einen kurzen deutschen Namen geben und den Stand als Tabelle zeigen |
| [agenten-koordinieren](agenten-koordinieren.md) | Fünf Kollisionsarten paralleler Agenten und das Verfahren gegen jede; die Zuteilung ist meine Aufgabe, nicht die der Agenten |
| [agenten-trennen-worktrees](agenten-trennen-worktrees.md) | Parallele Agenten teilen sich Arbeitsverzeichnis und git-Index — mit Worktrees trennen, sonst mit Pfadangabe committen |
| [anforderung-gehoert-in-den-massstab](anforderung-gehoert-in-den-massstab.md) | Eine Anforderung, die nur in der Umsetzung steht, ist keine; sie gehoert nach ZIEL.md und braucht eine Schranke, die beide Seiten gegeneinander haelt |
| [anweisungen-abarbeiten](anweisungen-abarbeiten.md) | Gregors Nachrichten sind Arbeitsaufträge — Material sofort auswerten, Absprachen festhalten, nichts Neues erfinden |
| [anwenderdatei-nicht-erschlagen](anwenderdatei-nicht-erschlagen.md) | Eine Datei, die es beim Anwender oder im Original schon gibt, wird gelesen und ergaenzt - nie neu geschrieben und ins Paket gelegt |
| [assert-ist-im-release-nichts](assert-ist-im-release-nichts.md) | ASSERT und VERIFY sind im Release-Bau weg; bei \"es passiert nichts\" zuerst auf dem betroffenen Weg nach ASSERT(0) und VERIFY( suchen |
| [auftrag-vor-selbstbetrachtung](auftrag-vor-selbstbetrachtung.md) | Sachfrage zuerst beantworten; Selbstkritik gehoert in eine Lehre-Datei, nicht in die Antwort |
| [ausreisser-ist-der-befund](ausreisser-ist-der-befund.md) | Was in der eigenen Messausgabe steht und nicht ins Ergebnis passt, ist der Befund - nicht das Rauschen, das man wegerklaert |
| [commit-auf-extra-branch-und-pushen](commit-auf-extra-branch-und-pushen.md) | Zwischenstaende regelmaessig auf einem eigenen Branch committen und pushen, nicht erst am Ende |
| [daueraufgaben-brauchen-einen-takt](daueraufgaben-brauchen-einen-takt.md) | Lektor, Pruefer und Chronist laufen nach einem festen Auslaeser; wenn Gregor nach ihnen fragen muss, ist die Rolle nicht eingerichtet |
| [doku-bei-jedem-commit-mitziehen](doku-bei-jedem-commit-mitziehen.md) | README.md und PORTIERUNG.md gehoeren in denselben Commit wie die Aenderung, nicht nachtraeglich auf Zuruf |
| [doku-parallel-nicht-hinterher](doku-parallel-nicht-hinterher.md) | Ein Wert, der in mehreren MDs steht, wird im selben Arbeitsschritt ueberall berichtigt; doku-pruefen.pl haelt sie gegeneinander |
| [dummy-statt-weglassen](dummy-statt-weglassen.md) | Nicht benutzte Funktionen, Methoden und Klassen als Dummy implementieren, statt sie auszubauen |
| [eigene-schleife-verschluckt-nichts](eigene-schleife-verschluckt-nichts.md) | Eine eigene Nachrichtenschleife darf WM_QUIT nicht entnehmen, ohne sie zurückzustellen — und nicht ohne Zeitschranke warten |
| [eingebaute-messung-auslesen](eingebaute-messung-auslesen.md) | Eine Spurmarke, die niemand ausliest, ist keine Messung - der Moment des Auslesens gehoert an das naechste Paket |
| [erfolg-aus-anwendersicht](erfolg-aus-anwendersicht.md) | Erfolg wird daran gemessen, was Gregor danach tun kann; kein Crash ist keine Verbesserung |
| [erlaubnis-nicht-hineinlesen](erlaubnis-nicht-hineinlesen.md) | Eine Aussage Gregors über SEIN Vorgehen ist keine Erlaubnis für mein Vorgehen; keine Regel selbst lockern |
| [erst-pruefen-dann-anweisen](erst-pruefen-dann-anweisen.md) | Keine Handlungsanweisung an Gregor geben, ohne sie vorher selbst durchgeführt und gemessen zu haben |
| [fehlerklassen-abstellen](fehlerklassen-abstellen.md) | Wiederholte Fehler mit Werkzeug und Schranke abstellen, nicht einzeln nachbessern — Vorsatz allein hält nicht |
| [fertig-heisst-fertig](fertig-heisst-fertig.md) | Wenn ich 'fertig' sage, muss Gregor mergen, loeschen und ein Release haben koennen - ohne dass etwas nachkommt |
| [gegenprobe-umdrehen](gegenprobe-umdrehen.md) | Nicht pruefen, ob der gewuenschte Zustand erscheint, sondern ob der umgekehrte Wert durchkommt; Gregors Technik vom 07.09.2026 |
| [gemeinsame-dateien-gegen-alles-messen](gemeinsame-dateien-gegen-alles-messen.md) | Änderungen an gemeinsam benutzten Dateien gegen die ganze Solution messen, nicht nur gegen das eigene Projekt |
| [haengende-kommandos-abbrechen](haengende-kommandos-abbrechen.md) | Hängende Kommandos früh erkennen, abbrechen und anders lösen statt Zeitlimits auslaufen zu lassen |
| [kein-paket-mit-offenem-datenverlust](kein-paket-mit-offenem-datenverlust.md) | Kein Paket ausliefern, solange ein bekannter Weg offen ist, auf dem der Anwender Daten verliert |
| [keine-tastendruecke-verschicken](keine-tastendruecke-verschicken.md) | SendKeys geht an das Fenster im Vordergrund, nicht an mein Zielfenster - am 08.09.2026 habe ich damit Gregors Explorer-Fenster geschlossen |
| [lauffaehiges-ergebnis-liefern](lauffaehiges-ergebnis-liefern.md) | Ziel ist eine einsetzbare Eudora-Version, nicht ein Zwischenstand — pragmatisch priorisieren, mit Prüfanleitung übergeben |
| [lehren-anwenden-nicht-nur-schreiben](lehren-anwenden-nicht-nur-schreiben.md) | Eine aufgeschriebene Lehre ohne Ausloeser und Werkzeug wirkt nicht - jede Lehre braucht einen Moment, in dem sie geprueft wird |
| [main-muss-immer-baubar-sein](main-muss-immer-baubar-sein.md) | main trägt immer einen Stand, der fehlerfrei baut und aus dem sich jederzeit ein Release erstellen lässt |
| [mannschaft-fuehren](mannschaft-fuehren.md) | Agenten brauchen ein Symptom im Auftrag, keinen Gebietsauftrag; jeden Ruecklauf selbst nachmessen |
| [messung-muss-den-weg-treffen](messung-muss-den-weg-treffen.md) | Ein Gegentest im falschen Betriebsmodus oder an einem Stand ohne die Aenderung beweist nichts; erst pruefen, ob der geprueste Weg ueberhaupt gelaufen ist |
| [nichts-auf-gregors-bildschirm-starten](nichts-auf-gregors-bildschirm-starten.md) | Kein Programm mit Fenstern auf Gregors Sitzung starten, ohne vorher zu fragen — auch nicht durch Agenten |
| [nie-direkt-auf-main](nie-direkt-auf-main.md) | Jede Änderung geht über einen eigenen Zweig; auf main wird nur gemergt, und Gregor merged |
| [nie-stillstehen](nie-stillstehen.md) | Leerlauf ist der teuerste Fehler dieses Projekts — im Hintergrund bauen, weiterarbeiten, ungefragt melden |
| [paket-gegen-den-bau-messen](paket-gegen-den-bau-messen.md) | Was im Paket liegt, ist nicht automatisch das, was ich gebaut habe - jede Datei im Paket gegen das Bauverzeichnis messen, bevor Gregor sie bekommt |
| [pruefen-statt-vermuten](pruefen-statt-vermuten.md) | Vorhandene Quellen oeffnen, bevor ich eine Ursache vermute - und Vermutungen nie als Tatsache aussprechen |
| [pruefumfang-nicht-von-hand](pruefumfang-nicht-von-hand.md) | Prueflisten und Agentenauftraege holen ihren Umfang aus der Quelle; was von Hand aufgezaehlt wird, prueft genau das nicht, woran niemand gedacht hat |
| [quelldateien-nur-byte-erhaltend-aendern](quelldateien-nur-byte-erhaltend-aendern.md) | Eudora-Quellen sind Latin-1 mit gemischten Zeilenenden - nur byte-erhaltend aendern, nie mit dem Edit-Werkzeug |
| [release-erst-nach-gregors-test](release-erst-nach-gregors-test.md) | Ein GitHub-Release entsteht erst, nachdem Gregor die Fassung lokal geprüft und für gut befunden hat |
| [review-sieht-nur-den-diff](review-sieht-nur-den-diff.md) | Ein Diff-Review kann eine veraltete unveraenderte Datei nicht sehen; vor dem Merge wird der Bestand geprueft, nicht die Aenderung |
| [schranke-gegentesten](schranke-gegentesten.md) | Jede neue Schranke gegen den echten Fehler fahren und gegen den erlaubten Fall; eine stumme Pruefung und ein Fehlalarm sind derselbe Schaden |
| [schranke-liest-nur-code](schranke-liest-nur-code.md) | Eine Schranke, die Quelltext mit Regex prueft, muss Kommentare und Protokolltexte vorher wegwerfen und ihren Bereich am Rumpfende abschliessen - sonst liest sie ihre eigene Begruendung |
| [teilweise-ersetzte-header](teilweise-ersetzte-header.md) | Include-Wächter wirken pro Datei — wer nur einen Teil eines Headers ersetzt, darf den Wächter nicht setzen |
| [tests-vor-jedem-commit-laufen-lassen](tests-vor-jedem-commit-laufen-lassen.md) | Unit- und Komponententests gehoeren zu jedem Commit - Ergebnis mitteilen, auch wenn es rot ist |
| [text-nicht-durch-schichten-schicken](text-nicht-durch-schichten-schicken.md) | Ersetzungstext mit Backslashes oder Anfuehrungszeichen nie inline durch Bash/PowerShell nach Perl reichen; in eine Datei schreiben und ueber Zeilenanker einsetzen |
| [version-eindeutig-machen](version-eindeutig-machen.md) | Jede Fassung, die Gregor in die Hand bekommt, muss sich selbst benennen koennen - Nummer, Commit, Bauzeit, sichtbar im Programm |
| [was-lauffaehig-heisst](was-lauffaehig-heisst.md) | Gregors drei Kriterien für „lauffähig" — und dass ein erscheinendes, aber unbedienbares Fenster keines davon erfüllt |
| [werkzeug-vor-eigenbau](werkzeug-vor-eigenbau.md) | Vor dem eigenen Dreizeiler in tools/WERKZEUGE.md nachsehen; und ein fertiges Werkzeug, das niemand aufruft, wirkt so wenig wie eine Lehre, die nur Text ist |
| [widerlegte-vermutungen-aufschreiben](widerlegte-vermutungen-aufschreiben.md) | Jede widerlegte Vermutung mit ihrer Messung in die Befunddatei; das Ausschlussverfahren fuehrt zur Zeile |
| [wissen-gehoert-in-dateien](wissen-gehoert-in-dateien.md) | Befunde und Erkenntnisse gehören in Dateien im Repo, nicht nur in den Chat — sonst überleben sie kein Abschalten |
| [zeilenenden-nach-jedem-schreibzugriff-messen](zeilenenden-nach-jedem-schreibzugriff-messen.md) | Nach jedem Skript, das Dateien schreibt, die CR-Anzahl gegen HEAD messen - der Fehler ist lautlos |
| [zurueckgestellte-befunde](zurueckgestellte-befunde.md) | Gefundene, belegte Maengel, die Gregor bewusst spaeter angehen will - nicht von selbst anfassen |
| [zwei-werte-in-eine-ausgabe](zwei-werte-in-eine-ausgabe.md) | Zwei Werte, deren Widerspruch geklaert werden soll, gehoeren in denselben Aufruf - zwei Protokollzeilen lassen die Erklaerung 'zu verschiedenen Zeitpunkten' immer offen |
| [zweig-vorher-abstimmen](zweig-vorher-abstimmen.md) | Einen Zweig erst anlegen, wenn Gregor den Namen bestaetigt hat; ein nicht vereinbarter Zweig wird geloescht |

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
