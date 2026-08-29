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
Ein Agent hat dafür beide Sitzungsmitschriften ausgewertet — 7,6 MB Gesprächsverlauf
— und die wiederkehrenden Muster herausgezogen. Jede Regel nennt in ihrem
Abschnitt **Why** den belegten Anlass mit Datum.

Der teuerste einzelne Fehler war dabei nicht ein falscher Codeeingriff, sondern
**1 Stunde 46 Minuten Stillstand** am 28.08.2026 — in einer Zeit, die ausdrücklich
für unbeaufsichtigtes Arbeiten freigegeben war.

## Die Regeln

| Datei | Worum es geht |
|---|---|
| [nie-stillstehen](nie-stillstehen.md) | Lange Läufe in den Hintergrund, währenddessen weiterarbeiten |
| [anweisungen-abarbeiten](anweisungen-abarbeiten.md) | Material sofort auswerten; eine wiederholte Frage ist ein Alarmzeichen |
| [lauffaehiges-ergebnis-liefern](lauffaehiges-ergebnis-liefern.md) | Ziel ist eine einsetzbare Fassung, nicht ein Teilschritt |
| [pruefen-statt-vermuten](pruefen-statt-vermuten.md) | Zahlen nur nennen, wenn gemessen — auch Selbstvorwürfe |
| [fehlerklassen-abstellen](fehlerklassen-abstellen.md) | Beim zweiten Auftreten ein Werkzeug bauen, nicht einzeln nachbessern |
| [wissen-gehoert-in-dateien](wissen-gehoert-in-dateien.md) | Befunde und Absprachen in Dateien, nicht in den Chat |
| [commit-auf-extra-branch-und-pushen](commit-auf-extra-branch-und-pushen.md) | Zwischenstände laufend sichern |
| [doku-bei-jedem-commit-mitziehen](doku-bei-jedem-commit-mitziehen.md) | Doku gehört in denselben Commit wie der Code |
| [quelldateien-nur-byte-erhaltend-aendern](quelldateien-nur-byte-erhaltend-aendern.md) | Latin-1 mit gemischten Zeilenenden — nur mit `tools/aendere-zeile.pl` |
| [zeilenenden-nach-jedem-schreibzugriff-messen](zeilenenden-nach-jedem-schreibzugriff-messen.md) | CR-Anzahl gegen HEAD prüfen; der Fehler ist lautlos |
| [haengende-kommandos-abbrechen](haengende-kommandos-abbrechen.md) | Früh abbrechen statt Zeitlimits auslaufen lassen |
| [tests-vor-jedem-commit-laufen-lassen](tests-vor-jedem-commit-laufen-lassen.md) | Ergebnis in die Commit-Nachricht |
| [dummy-statt-weglassen](dummy-statt-weglassen.md) | Unbenutzte Funktionen als leeren Rumpf, nicht ausbauen |
| [agenten-benennen](agenten-benennen.md) | Kurze deutsche Namen und eine Statustabelle |
| [zurueckgestellte-befunde](zurueckgestellte-befunde.md) | Belegte Mängel, die bewusst später angegangen werden |

`MEMORY.md` ist das Inhaltsverzeichnis, das der Assistent zu Sitzungsbeginn lädt.

## Eine bekannte Schwäche

Diese Dateien werden am Sitzungsende aus dem Gedächtnis geschrieben, ohne Gegenprüfung
am Mitschnitt. Genau so ist eine falsche Begründung in
[wissen-gehoert-in-dateien](wissen-gehoert-in-dateien.md) entstanden: ein
Schuldeingeständnis, das sich beim Nachmessen als sachlich falsch erwies. Wenn diese
Regeln denselben Rang wie Code haben sollen, bräuchten sie dieselbe Prüfung wie die
übrige Dokumentation — einen zweiten Durchgang, der jede zitierte Tatsache belegt.
