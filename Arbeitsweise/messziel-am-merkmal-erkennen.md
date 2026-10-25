---
name: messziel-am-merkmal-erkennen
description: "Ein Messziel wird an einem Merkmal der Sache erkannt, nicht an einer Eigenschaft, die viele teilen - am 21.10.2026 traf die Suche nach der Fensterklasse #32770 den Kontenassistenten (453x341, ueber sechs Schritte unveraendert) statt der Vervollstaendigungsbox, und das sah aus wie 'kein Fehler'"
metadata:
  node_type: memory
  type: feedback
  originSessionId: f84046f7-9e13-4423-b96c-e79a574a4d3f
  modified: 2026-10-21T11:48:29.565Z
---

Schranke: tools/pruefe-messziel.pl (über alle `tools/*.ps1`) — flaggt eine Stelle, die **ein** Fenster allein nach einer mehrdeutigen Klasse (`#32770`, `Edit`, `ListBox`, …) auswählt, ohne ein unterscheidendes Merkmal. Gegenprobe in beide Richtungen: `--selbsttest` 12 Fälle (10 → 12 nach einem eigenen Fehler, siehe unten); gegen den Bestand 26 Dateien, 0 Treffer; gegen die **historische Fehlzeile**, in `tools/messen-e135.ps1` wiederhergestellt, Rückgabe 1 mit Zeilennummer.

# Das Messziel wird an einem Merkmal der Sache erkannt

**Regel.** Ein Messskript sucht sein Ziel nicht an einer Eigenschaft, die
viele Dinge teilen — Fensterklasse, Programmname, Dateiendung, Sichtbarkeit —,
sondern an einem Merkmal **der Sache selbst**: was nur dieses Ding hat, oder
was es tut. Sonst misst es irgendetwas, gibt plausible Zahlen aus und sieht
aus wie ein Ergebnis.

## Was passiert ist (21.10.2026, [E-135](../BEFUNDE.md#e-135))

Gregor: *„das Fenster wird bei jeder Änderung (z.B. nächster Eintrag)
kleiner!"* Zu messen war die Höhe der Vervollständigungsbox über sechs
Cursor-Schritte. Der erste Messlauf suchte die Box nach ihrer **Fensterklasse**:

```powershell
$box = AlleFenster $pp | Where-Object { $_.Vis -and $_.Klasse -eq '#32770' } |
       Select-Object -First 1
```

`#32770` ist die Klasse **jedes** Windows-Dialogs. Gefunden wurde der
**Kontenassistent**:

| Schritt | gemessen (falsches Fenster) | gemessen (die Box) |
|---|---|---|
| 0 | 453 × 341 | 100 × 62 |
| 1 | 453 × 341 | 84 × 46 |
| 2 | 453 × 341 | 68 × 30 |
| 3 | 453 × 341 | 52 × 14 |
| 4 | 453 × 341 | 36 × 14 |
| 5 | 453 × 341 | 20 × 14 |

Sechs saubere Zeilen, eine konstante Größe — **das Bild eines behobenen
Fehlers**, an einer Fassung, in der der Fehler voll da war. Erst die Suche
nach einem Merkmal der Sache — *ein Dialog, der eine `SysListView32`
enthält* — traf die Box, und dann stand der Fehler sofort im Protokoll: 8
Pixel Verlust je Aufruf, zwei Aufrufe je Cursor-Schritt.

Die Behebung im Skript ist die Regel in Code
(`tools/messen-e135.ps1:93-108`): **über alle** Kandidaten laufen, und erst
das Kind entscheidet. Jeder Kandidat wird mit Größe und Kinderzahl ausgegeben,
damit sichtbar bleibt, wogegen entschieden wurde.

## Warum die benachbarten Lehren nicht gereicht haben

- [[ausbleiben-ist-kein-befund]]: dort gibt die Messung **nichts** aus. Hier
  gab sie sechs vollständige Zeilen aus — die Positivprobe wäre grün gewesen.
- [[messung-muss-den-weg-treffen]]: dort läuft der geprüfte **Weg** nicht.
  Hier lief der Weg (die Box war offen, die Tasten kamen an); getroffen wurde
  das falsche **Objekt**.
- [[pruefstand-kann-blind-sein]] ist eine Ebene höher: dort ist der Prüfstand
  kaputt. Hier war er in Ordnung und zeigte auf das Falsche.

Dieselbe Regel steht im Projekt längst — eine Ebene tiefer. `CLAUDE.md`:
*„Prozesse immer nach Pfad filtern."* Der Name `Eudora.exe` ist
`#32770` für Prozesse: ihn teilen sich Gregors laufendes Programm und jeder
Prüfstand. Was dort für Prozesse gilt, gilt für jedes Messziel.

## How to apply

1. **Vor dem Messen das Merkmal benennen.** Ein Satz: *woran erkenne ich
   dieses Ding und nur dieses Ding?* Enthält die Antwort nur eine Klasse,
   einen Namen oder „das erste sichtbare", ist sie noch keine Antwort.
2. **Taugt kein Merkmal, dann über alle Kandidaten laufen** und jeden mit
   seinen Messwerten ausgeben. Die Liste zeigt sofort, dass es mehrere gibt —
   `Select-Object -First 1` verschweigt genau das.
3. **Die Kandidatenzahl gehört in die Ausgabe.** `"E135 {0} sichtbare
   Dialoge"` hätte den Fehler in der ersten Minute gezeigt.
4. **Sichtbarkeit, Reihenfolge und Zeitpunkt sind keine Merkmale.** Der
   Kontenassistent war sichtbar, war zuerst da und blieb stehen.
5. **Ein konstanter Messwert ist verdächtig, wenn der Fehler gemeldet ist.**
   „Über alle Schritte unverändert" an einer Fassung **ohne** Behebung ist
   kein Entwarnungsbefund, sondern die Frage, ob überhaupt das Richtige
   gemessen wurde ([[gegenprobe-umdrehen]]).
6. **`perl tools/pruefe-messziel.pl`** vor dem Commit eines Messskripts; im
   `pre-commit` als 14i.

## Was diese Lehre an sich selbst gelernt hat

Der erste Selbsttest der Schranke meldete **10 von 12** — und durchgefallen
waren ausgerechnet die beiden Fälle mit dem echten Fehler. Grund: die Zeile,
die PowerShell-Kommentare entfernt (`s/#.*$//`), fraß die Fensterklasse
`'#32770'` selbst auf. Die Schranke war genau für den Fall blind, für den sie
gebaut ist — ein Messziel, das die eigene Prüfung nicht erkennt
([[schranke-liest-nur-code]]). Behoben mit einem Rückblick auf ein
Leerzeichen (`s/(?<=\s)#.*$//`), der Grund steht als Kommentar an der Stelle.

## Nachtrag 25.10.2026 (CHRONIST): dieselbe Falle in der Rollenbuchführung

`tools/rollen-faellig.pl:140` erkennt einen CHRONIST-Bericht an `Arbeitsweise/*.md` — an einem Ort, den **jede** gespiegelte Lehre teilt, nicht am Merkmal des Berichts (`CHRONIST-<datum>.md`). Gemessen: zwischen dem 23.10. 13:03 MESZ und dem 25.10. 16:39 MEZ haben 20 Commits diesen Ort berührt, keiner davon war ein CHRONIST-Lauf, und das Werkzeug meldete „aktuell". Wie bei `#32770`: das Werkzeug misst etwas, gibt eine plausible Antwort und sieht aus wie ein Ergebnis. Einzelheiten und Vorschlag in [[daueraufgaben-brauchen-einen-takt]], Nachtrag 24./25.10.2026.

**How to apply, zusätzlich:** Wer einer Rolle oder einem Ereignis ein Erkennungsmuster gibt, prüft, **wer sonst noch** dorthin schreibt — hier der Commit-Haken (`lehren-spiegeln.pl`), der Hauptagent und der LEKTOR.
