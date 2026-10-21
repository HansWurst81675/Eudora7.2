---
name: chronist-2026-10-21b
description: "CHRONIST-Lauf 21.10.2026 nachmittags (E-135 Vervollständigungsbox): eine neue Lehre mit Schranke - messziel-am-merkmal-erkennen (pruefe-messziel.pl); drei Nachträge; die Gegenprobe der eigenen Schranke vom Vormittag ergab grün, aber nicht durch sie: der installierte pre-commit ist vom 20.10. und kennt sie nicht"
metadata:
  node_type: memory
  type: feedback
  originSessionId: f84046f7-9e13-4423-b96c-e79a574a4d3f
  modified: 2026-10-21T11:54:31.215Z
---

Schranke: keine — dies ist der Bericht eines CHRONIST-Laufs, keine Lehre. Jede neue oder ergänzte Lehre trägt ihre eigene Schranke-Zeile.

# CHRONIST, zweiter Lauf vom 21.10.2026 (Arbeitspaket E-135)

## Quelle

Der Gesprächsverlauf stand wieder nicht zur Verfügung. Ausgewertet wurde:

| Quelle | Umfang |
|---|---|
| Commit `f6d525dc` (7.2.0.120, E-135) | 16 Dateien, Commit-Nachricht mit Messreihe und Gregors Satz |
| `BEFUNDE.md`, Eintrag [E-135](../BEFUNDE.md#e-135) | eine Zeile, ~5 kB |
| `CHANGELOG.md`, Abschnitt 7.2.0.120 | 58 Zeilen |
| `tools/messen-e135.ps1`, `tools/messen-k9.ps1` | 127 und 82 Zeilen, **neu im Repo** |
| [PRÜFER-43 K9](../Befunde/PRUEFER-43.md#k9) | der vorhergesagte Fall samt Vorbedingung |
| `C:\Temp\E135-box`, `C:\Temp\E135-gruen` | 2 Prüfstände, `NNdbase.txt` mit je 5 Kurznamen — nur gelesen |
| `tools/TESTLAEUFE.md` | 282 Zeilen, 5 davon vom 21.10. nachmittags |
| `.git/hooks/pre-commit` im Hauptbaum | 22313 Bytes, **vom 20.10.2026 12:55** |

Die beiden Messskripte waren diesmal die ergiebigste Quelle: sie tragen den
Messaufbau, und an ihnen ist nachzählbar, was gemessen wurde **und was
nicht**.

## Ergebnis

| Kandidat | am Bestand geprüft | Lehre | Schranke |
|---|---|---|---|
| Die erste Messung maß das falsche Fenster | **bestätigt**, und zwar aus der Quelle selbst: `messen-e135.ps1:93-95` trägt den Grund als Kommentar — *„Nach Klasse allein zu suchen trifft den Kontenassistenten (gemessen 21.10.2026: 453x341, unveraendert ueber alle Schritte - und nicht die Box)."* Gegenüber der echten Box: `100×62, 84×46, 68×30, 52×14, 36×14, 20×14`. **Keine** der beiden Nachbarlehren deckt das ab: `ausbleiben-ist-kein-befund` setzt voraus, dass die Messung **nichts** ausgibt (hier sechs saubere Zeilen), `messung-muss-den-weg-treffen` fragt nach dem **Weg** (der lief) | **neu:** [messziel-am-merkmal-erkennen](messziel-am-merkmal-erkennen.md) | **gebaut:** `tools/pruefe-messziel.pl`, pre-commit 14i. Gegenprobe: `--selbsttest` 12 Fälle; Bestand 26 Dateien 0 Treffer; die in `messen-e135.ps1` **wiederhergestellte historische Fehlzeile** → Rückgabe 1 mit Zeilennummer |
| Eine Vorhersage des Prüfberichts hat sich nicht bestätigt | **anders als gedacht.** Nachgezählt am Skript: `messen-k9.ps1` klickt rechts an `y = 10, 26, 42, 58, 74` — bei den **fünf** Kurznamen in `C:\Temp\E135-box` sind das fünf **verschiedene** Einträge. K9 nennt als Vorbedingung *erst* einen Rechtsklick in den **leeren Bereich unter** die Einträge, *dann* einen zweiten auf **dasselbe** Element. Beide Teile fehlen. Die Vorhersage ist also **nicht widerlegt, sondern nicht gemessen** | [messung-muss-den-weg-treffen](messung-muss-den-weg-treffen.md), **Fall 11** | keine gebaut; die Vorbedingung steht in Prosa im Prüfbericht, das liest kein Werkzeug. Statt dessen **Wortlaut in `BEFUNDE.md` berichtigt** (siehe unten) |
| Wurde diesmal `testlauf.ps1` benutzt? | **ja, lückenlos — aber nicht wegen der Schranke.** 2 Prüfstände, 5 messbare Starts, **5** Zeilen in `tools/TESTLAEUFE.md` (278–282), `pruefe-startwege.pl --tag 2026-10-21` meldet *0 ohne Zeile*. **Der Haken, in dem die Schranke sitzt, ist aber nie gelaufen:** `.git/hooks/pre-commit` ist vom 20.10. 12:55 und enthält `pruefe-startwege` **0**-mal | [jeder-start-ins-protokoll](jeder-start-ins-protokoll.md), Nachtrag | keine neue; die Verschärfung ist eine Messung: `grep -c <werkzeug> .git/hooks/pre-commit` nach jedem Schrankenbau |
| Zwei Messskripte liegen jetzt im Repo | **bestätigt** — und der Eintrag fehlte. `git show f6d525dc --stat`: `tools/WERKZEUGE.md` **nicht** angefasst. Gemessen mit der Probe aus `WERKZEUGE.md` selbst: 3 Dateien ohne Eintrag (`messen-e135.ps1`, `messen-k9.ps1`, `patches/`). Alle drei plus `pruefe-messziel.pl` eingetragen, Probe läuft jetzt leer | [werkzeug-vor-eigenbau](werkzeug-vor-eigenbau.md), Nachtrag | keine gebaut; der Nachtrag nennt den Dreizeiler, der es im `pre-commit` prüfen würde — gehört in die Hand des PRÜFERs, weil er den Umfang von `tools/` festlegt |

## Die Gegenprobe zu meiner eigenen Schranke vom Vormittag

Die Frage lautete: hat `tools/pruefe-startwege.pl` gewirkt? Die ehrliche
Antwort ist **nein — sie konnte nicht**.

```
installierter Haken  .git/hooks/pre-commit   20.10.2026 12:55, 22313 Bytes
darin "pruefe-startwege"                     0 Treffer
darin "pruefe-original-belegt"               0 Treffer
```

`sh tools/hooks-einrichten.sh` ist seit dem Merge nicht gelaufen. Der Commit
`f6d525dc` ist an 14g **und** 14h vorbeigegangen. Dass die fünf Starts des
Nachmittags im Protokoll stehen, liegt am Gebrauch von `tools/testlauf.ps1`
selbst — zeitliche Nähe ist keine Messung
([[ursache-nur-gemessen-behaupten]]); belegt ist nur, dass die Schranke es
**nicht gewesen sein kann**.

Dazu die zweite Hälfte: die **15** unprotokollierten Starts vom Vormittag
sind aus jeder Zählung verschwunden, weil ihre Prüfstände gelöscht wurden.
Die Schranke meldet den Tag grün, an dem sie ihren Mangel gefunden hat.

Daraus die Verschärfung im Nachtrag: **eine Schranke zählt erst ab dem Lauf,
in dem sie im Haken steht**, und wer sie baut, misst im selben Arbeitsschritt
nach, dass sie dort angekommen ist. Ein Befehl: `grep -c <werkzeug>
.git/hooks/pre-commit`.

## Was in `BEFUNDE.md` berichtigt wurde

[E-135](../BEFUNDE.md#e-135) sagte über K9: *„**Am laufenden Programm nicht
nachstellbar**"*. Das behauptet, der Versuch sei gelaufen. Gelaufen ist ein
anderer Versuch. Neuer Wortlaut, ohne das Urteil zu ändern:

> **Nicht gemessen — die Vorbedingung wurde im Messlauf nicht hergestellt**
> … K9 nennt als Vorbedingung aber *erst* einen Rechtsklick in den **leeren
> Bereich unter** die Einträge und *dann* einen zweiten auf **dasselbe**
> Element — das Skript tut weder das eine noch das andere … Die Vorhersage
> ist damit **weder bestätigt noch widerlegt**.

Was richtig war und richtig bleibt: die Zeile `DoSelectItem(tvhit.hItem,
TRUE)` steht als **Sicherung, nicht als gemessene Behebung** — in der
Commit-Nachricht, im `CHANGELOG` und im Befund
([[widerlegte-vermutungen-aufschreiben]]).

## Was dieser Lauf selbst falsch gemacht hat

**Der erste Selbsttest der neuen Schranke meldete 10 von 12 — durchgefallen
waren genau die beiden Fälle mit dem echten Fehler.** Die Zeile, die
PowerShell-Kommentare wegwirft (`s/#.*$//`), fraß die Fensterklasse
`'#32770'` selbst auf. Die Schranke war blind für den Fall, für den sie
gebaut ist; dasselbe Muster wie `pruefe-beenden.pl` am 08.09.
([[schranke-liest-nur-code]]). Behoben mit einem Rückblick auf ein
Leerzeichen, der Grund steht als Kommentar an der Stelle. Gefunden hat es nur
der Selbsttest — eine Schranke ohne Gegenprobe wäre hier **stumm im Bestand
grün** gewesen.

## Offen, nicht Sache des CHRONIST

1. **`sh tools/hooks-einrichten.sh` im Hauptbaum** — jetzt mit 14i. Stand
   heute gemessen: 14g ist grün (5 Starts, 5 Zeilen), 14h prüft nur den
   **Zuwachs** an `BEFUNDE.md` und meldet bei einem Commit ohne Befundzeile
   *„Nichts zu pruefen"*, Rückgabe 0 — das Einrichten blockiert also keinen
   laufenden Commit. Dies ist derselbe Punkt wie Nr. 1 im Bericht vom
   Vormittag; er ist **zum zweiten Mal** offen.
2. **Der `PreToolUse`-Haken** auf Befehle, die `Eudora.exe` starten, ohne
   `testlauf.ps1` zu nennen, bleibt der haltbarere Platz für dieselbe Frage
   ([[ausloeser-an-den-anfang]]). Änderung an Gregors `settings.json`,
   gehört ihm vorgelegt.
3. **Offen in E-135 selbst, aufgeschrieben und nicht gemessen:**
   `MoveWindow` erwartet Koordinaten im Klientenbereich des Elternfensters;
   `ReCalcACListBoxPos` und `DoACListBox` rechnen mit `ScreenToClient` um,
   `InitList` nicht. Ob das ein zweiter Fehler ist, steht im Befund als
   offene Frage — richtig so.
4. **K9 ist weiterhin ungemessen.** Wer ihn messen will, braucht zwei Zeilen
   mehr in `messen-k9.ps1`: einen Rechtsklick unterhalb des letzten Eintrags,
   dann einen zweiten auf **dasselbe** Element, und vor dem entscheidenden
   Klick die Ausgabe von Karette (`TVGN_CARET`) und `TVIS_SELECTED` in
   **einer** Zeile ([[zwei-werte-in-eine-ausgabe]]). Die Schwäche steht jetzt
   in `tools/WERKZEUGE.md` beim Skript.
5. **`tools/WERKZEUGE.md` trägt im Kopf noch den Stand *„zuletzt geprüft
   gegen 7.2.0.70 … der Quellstand ist inzwischen 7.2.0.110"*.** Der
   Quellstand ist 7.2.0.120. Das ist eine Zeile für den LEKTOR; ich habe nur
   die vier fehlenden Einträge ergänzt, nicht die Kopfzeile fortgeschrieben.
