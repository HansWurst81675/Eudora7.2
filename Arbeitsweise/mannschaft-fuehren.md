---
name: mannschaft-fuehren
description: Agenten brauchen ein Symptom im Auftrag, keinen Gebietsauftrag; jeden Ruecklauf selbst nachmessen
metadata:
  type: feedback
---

# Die Mannschaft führen, nicht nur verteilen

**Gregor, mehrfach und zuletzt am 06.09.2026:** *„ich habe dir schon oft gesagt,
du mußt deine mannschaft besser managen! das solltest du dir aufschreiben und
befolgen."*

„Oft" ist das Entscheidende. [Agenten koordinieren](agenten-koordinieren.md)
regelt den **Raum** — wer in welchem Arbeitsbaum sitzt, damit sich niemand
überschreibt. Das funktioniert inzwischen. Was fehlte, ist die **Führung**: ob
der Auftrag etwas hergibt, und ob der Rücklauf stimmt.

## 1. Ein Auftrag ohne konkrete Beobachtung liefert nichts

**Gemessen am 06.09.2026.** Vier Agenten mit einer konkreten Beobachtung im
Auftrag kamen mit einem Befund zurück:

| Agent | Beobachtung im Auftrag | Ergebnis |
|---|---|---|
| SYMBOLE | „im Suchfenster fehlen genau die Symbole der gesperrten Knöpfe" | 24-Bit-Bitmaps ohne Farbtabelle, behoben, Tests rot→grün |
| OEFFNEN | „Doppelklick öffnet nicht, Suchtreffer nicht anklickbar" | hängender Rückzeiger `CSummary::m_FrameWnd`, behoben |
| SPUR | „diese Adressen lassen sich nicht auflösen" | Werkzeug mit 15 Tests |
| VERFASSER | „Strg-N beendet Eudora lautlos" | Ursache des *Schweigens* belegt |

Der **PRÜFER** bekam kein Symptom, sondern ein Gebiet: *„den nie geprüften Code:
Stufe 2/2b, Registerkarten, Bilder, die Werkzeuge"*. Er kam **leer** zurück —
obwohl dort reichlich zu holen wäre. Gregors Urteil: *„der erste hat auch nichts
mehr gefunden, obwohl er jede menge zu tun hätte!"*

**Regel.** In jeden Auftrag gehört mindestens eines davon:

- eine **Beobachtung** („beim Klick auf X passiert Y"), oder
- eine **Messung, die widerlegt werden soll** („ich habe Z gemessen, prüfe das
  nach"), oder
- ein **Muster mit Fundstellen** („`ReleaseBuffer` ohne `GetBuffer` — hier sind
  die 17 Treffer, entscheide je Stelle").

Ein Gebiet allein ist kein Auftrag. Wer nichts findet, hat meist keinen
schlechten Tag, sondern einen schlechten Auftrag bekommen.

## 2. Ein leerer Rücklauf ist mein Fehler, nicht sein Befund

Kommt ein Agent ohne Ergebnis, wird **nicht** „nichts gefunden" ins Protokoll
geschrieben. Entweder ich schärfe den Auftrag mit einer konkreten Beobachtung
nach, oder ich starte ihn nicht wieder. Ein „geprüft, nichts gefunden" in der
Doku ist schlimmer als eine offene Lücke: es sieht wie Deckung aus.

## 3. Jeden Rücklauf nachmessen, auch den guten

**Was gut lief am 06.09.2026:** OEFFNENs Fund habe ich im Quelltext
nachgesehen (die Zuweisung stand tatsächlich im falschen `if`), SYMBOLEs
Farbtiefen selbst aus den Bitmap-Köpfen gelesen (24 gegen 8 Bit), SPURs 15 Tests
selbst laufen lassen.

**Was schieflief:** VERFASSER schrieb, die Spurmarken schreiben „ohne
Ini-Änderung, weil die Maske mit `DEBUG_MASK_TOC_CORRUPT` oder-verknüpft ist".
Das habe ich **ungeprüft weitergegeben**. Es ist falsch — `PutDebugLog` prüft die
Maske und kehrt sonst sofort zurück (`QCUtils/src/debug.cpp:140`). Gregors
Protokoll enthielt nur deshalb Zeilen, weil **er** den Schalter gesetzt hatte.
Ich habe ihm eine Fähigkeit zugesagt, die das Programm nicht hatte.

**Regel.** Eine Zusage eines Agenten wird zur Tatsache erst, wenn ich sie selbst
gemessen habe. Das kostet Minuten. Eine falsche Zusage kostet einen ganzen
Testlauf beim Anwender.

## 4. Ich baue nicht, während ein Agent baut

**Verstoß am 06.09.2026:** `tools/bauen.ps1` lief 51:59 Minuten statt der
üblichen 2:37, weil ich nebenher zweimal MSBuild direkt gestartet habe. Genau
das steht in `AGENTEN.md` unter Regel 2 — von mir selbst geschrieben. Die
Bilanz des Skripts war danach unbrauchbar, weil sie Zeitstempel aus einem
Mischzustand verglich.

## 5. Wer noch läuft, dessen Arbeitsbaum bleibt unberührt

**Was gut lief:** Beim Aufräumen zeigte `wt/symbole` null Commits vor dem
Arbeitszweig — es sah leer aus. Der Agent lief aber noch und hatte nur nichts
committet. Ich habe ihn stehen gelassen. Früher wurde genau so BAUMEISTERs
Arbeit gelöscht.

**Regel.** Vor dem Entfernen eines Arbeitsbaums nicht nur die Commits zählen,
sondern nachsehen, **ob der Agent noch läuft**. Null Commits heißt „noch nichts
gesichert", nicht „nichts zu sichern".

## 6. Beim Debuggen führt einer, nicht zwei

**Gregors Regel, 06.09.2026:** *„wenn wir debuggen, dann soll entweder der eine
oder der andere was ausführen, nicht wir beiden. wenn du sagst, du möchtest es
untersuchen, dann werde ich nichts machen, bis du fertig bist. wir müssen uns
nur absprechen."*

Das heißt: **ansagen**, wer dran ist. Wenn ich messe, sage ich es und melde
mich, wenn ich fertig bin. Zwei Leute, die gleichzeitig dieselbe Fassung
starten, erzeugen Protokolle, die niemand auseinanderhalten kann — und
Messungen, die nichts beweisen.

Dass ich Eudora selbst starten und bedienen kann, war dabei die Erkenntnis des
Tages: Meldungsfenster mit `WM_COMMAND`/`IDOK` schließen, dann `WM_COMMAND` mit
der Befehlskennung an `EudoraMainWindow`. Damit brauche ich Gregor nicht als
Hand am Bildschirm — nur als den, der entscheidet.

## Die Reihenfolge einer Runde

1. **Symptome sammeln** — von Gregor, aus Protokollen, aus eigenen Messungen
2. **Je Symptom einen Auftrag** mit genau diesem Symptom, Kennung aus
   `tools/befunde-einsammeln.pl --naechste`, eigener Arbeitsbaum
3. **Wer nicht bauen muss, baut nicht** — und ich baue erst, wenn alle zurück
   sind
4. **Jeden Rücklauf nachmessen**, bevor ich ihn weitergebe
5. **Zusammenführen, einmal bauen, einmal packen** — eine Nummer je Bau
6. **Lehren in `Arbeitsweise/`**, nicht nur in die Commit-Nachricht

---

## Nachtrag 06.09.2026 — wie oft das schon gesagt wurde

Gregors *„ich habe dir schon oft gesagt"* ist nachgezaehlt: **41 Nachrichten**
in den beiden Sitzungsmitschriften betreffen die Fuehrung der Mannschaft. Das
ist nach dem Sichern von Zwischenstaenden (45) die zweithaeufigste Beschwerde
des Projekts — haeufiger als Doku, Versionen oder Stillstand.

Die Klagen fallen in vier Gruppen, alle woertlich belegt:

| Gruppe | Beleg |
|---|---|
| **Agenten liefern nichts** | *„der eine agent wollte noch readme.md pruefen, er hat gepennt"* (29.08.) · *„warum pennen die beiden immer?"* (29.08.) · *„lektor pennt?"* (05.09.) · *„der erste hat auch nichts mehr gefunden, obwohl er jede menge zu tun haette!"* (06.09.) |
| **Agenten verschwinden** | *„den review agenten gab es aber bereits! wo ist er hin? warum gibt es ihn jetzt nicht mehr?"* (29.08.) · *„wir hatten noch einen agenten, der lessons learned gemacht hat. was ist aus dem geworden?"* (06.09.) |
| **Agenten blockieren sich** | *„dann ueberlege dir, wie du die arbeit der agenten in zukunft koordinieren kannst, ohne dass sie sich gegenseitig blockieren und dinge kaputt machen!"* (05.09.) · *„wieso hast du 24 agenten, die etwas bauen?"* (05.09.) |
| **Die Pruefer pruefen nicht** | *„und fuer solche pruefungen haben wir genau extra agenten, die es feststellen und verhindern sollen. die arbeiten also nicht sauber!"* (05.09.) · *„sowas haette der lektor vor dem commit finden muessen und den commit verhindern!"* (05.09.) |

Die vierte Gruppe ist die, die noch keine Regel hat: **ein Pruefer, der nach dem
Commit liest, ist kein Pruefer.** PRUEFER und LEKTOR muessen an einem Zeitpunkt
haengen, an dem ihr Befund noch etwas verhindern kann — vor dem Commit, vor dem
Packen, vor dem Merge. Ein Prueflauf danach erzeugt nur einen weiteren Befund
in einer Liste, die ohnehin schon lang ist.
