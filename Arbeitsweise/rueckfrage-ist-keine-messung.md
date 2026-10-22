---
name: rueckfrage-ist-keine-messung
description: "Gregor zu \"S-3b\": \"ist es die s-bahn?\" - und als ich IHN nach der Bedeutung der vier unklaren Nummernkreise fragte: \"wie kann ich dir sagen, ob wir es abhaken koennen, wenn nicht mal du mir sagen kannst, was es ist?\" Die Antwort stand in den einfuehrenden Commits"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 3f65ec35-9408-4b65-b617-033776baffe9
  modified: 2026-10-22T12:20:00.000Z
---

Schranke: keine - eine Rueckfrage laesst sich nicht maschinell abweisen; sie geht als Text in den Chat und an keinem Haken vorbei. Was gebaut wurde, ist die **Antwort**: die Legende aller 16 Nummernkreise in `Intern/BEFUNDE.md`, jede Zeile mit ihrer Fundstelle. Die Probe steht unten unter *How to apply* Punkt 2 und ist der Befehl, der sie erzeugt hat.

# Eine Rueckfrage ist keine Messung — sie ist eine an Gregor weitergereichte

**Regel.** Was im Repository steht, messe ich. Gregor wird gefragt, wenn
eine **Entscheidung** ansteht oder etwas nur er wissen kann — was er sehen
will, wie etwas aussehen soll, ob er eine Fassung freigibt. Eine Frage nach
einer Tatsache, die im Repository steht, ist keine Ruecksprache, sondern
abgewaelzte Arbeit.

## Was passiert ist (22.10.2026)

Gregor las eine Zeile mit der Kennung `S-3b`:

> *„ist es die s-bahn?"*

Gemessen: **16 Nummernkreise** im Bestand — `E-`, `A-`, `AN-`, `S-`, `B-`,
`M-`, `R-`, `V-`, `P-`, `PR-`, `W-`, `F-`, `X-`, `Z-`, `NP2-`, `NP3-` —
**nirgends erklaert.** `CLAUDE.md` nennt acht davon und sagt nur, dass es
sie gibt.

Mein naechster Schritt war falsch: ich habe **ihn** gefragt, was vier der
Kreise bedeuten sollen. Seine Antwort:

> *„wie kann ich dir sagen, ob wir es abhaken koennen, wenn nicht mal du mir
> sagen kannst, was es ist?"*

Er hat recht, und das Nachmessen hat es belegt: **jeder der vier Kreise war
in seinem einfuehrenden Commit benannt**, mit Datum und Wortlaut —

| Kreis | stand seit | woertlich |
|---|---|---|
| `B-` | `23ca822e`, 30.08.2026 | *„VC71Bruecke: eigene msvc…"* — die Ersatzbausteine fuer fehlende Fremdbibliotheken |
| `M-` | `3ad6768b`, 30.08.2026 | *„Befund M-1 …"* — die Menueleiste |
| `R-` | `8f1c51e1`, 31.08.2026 | die Fehlerklasse hinter E-11, gezaehlt von `tools/releasebuffer-pruefen.pl` |
| `P-` | `4e72c9f4`, 30.08.2026 | *„Tests: Registerkar…"* — Funde aus einem Testlauf gegen die Ersatzschicht |

Die Frage hat also nichts erfahren, was ich nicht in drei Minuten haette
messen koennen — und sie hat Gregor die Arbeit aufgeladen, in seinem
Gedaechtnis nach einem Kuerzel von vor acht Wochen zu suchen, das **ich**
vergeben hatte.

## Warum die benachbarten Lehren nicht gegriffen haben

- [[bestand-vor-neuer-suche]] trifft die Sache genau, hat aber einen eng
  gefassten Ausloeser: `offene-befunde.pl` und `befund-suchen.pl`, beide auf
  `Intern/BEFUNDE.md`. *„Was bedeutet dieses Praefix?"* ist keine Suche nach
  einem Befund, sondern nach seiner **Herkunft** — und die steht in der
  Commit-Geschichte, die kein Werkzeug durchsucht.
- [[pruefen-statt-vermuten]] verbietet die Vermutung. Eine Rueckfrage fuehlt
  sich wie das Gegenteil einer Vermutung an — sorgfaeltig, vorsichtig,
  ehrlich. Deshalb hat die Lehre nicht gefeuert: sie kennt nur zwei
  Zustaende, raten und messen, und sieht nicht, dass Fragen ein drittes ist.
- [[erst-pruefen-dann-anweisen]] deckt den umgekehrten Weg ab, die
  Handlungsanweisung an Gregor. Hier ging keine Anweisung hinaus, sondern
  eine Frage — und die kostet ihn genauso viel.

## How to apply

1. **Vor jeder Frage an Gregor: wo steht die Antwort, wenn sie im
   Repository steht?** Drei Orte, in dieser Reihenfolge: die Datei selbst,
   `git log -S` auf den gesuchten Ausdruck, `git log --diff-filter=A` auf
   die Datei, in der er zuerst auftauchte.
2. **Der Befehl, der die Legende erzeugt hat**, und damit die Probe fuer
   jedes kuenftige Kuerzel:

   ```bash
   git log --reverse --oneline -S'S-3' -- '*.md' | head -3
   ```

   Er nennt den Commit, der die Kennung eingefuehrt hat, samt
   Commit-Nachricht — und die Commit-Nachricht sagt in diesem Projekt fast
   immer, wofuer sie steht.
3. **Eine Frage, die ich stellen muss, ist zuerst ein Befund.** *„Was
   bedeutet `S-`?"* ist nicht die Frage, sondern die Meldung: *es gibt
   keine Legende.* Gebaut wurde deshalb die Legende, nicht die Antwort auf
   die eine Frage.
4. **Erlaubte Fragen an Gregor:** was er will, was er sieht, ob er freigibt,
   welche Reihenfolge gelten soll. **Nicht erlaubt:** was im Repo steht, was
   ich selbst geschrieben habe, was ein Werkzeug ausgibt.
5. **Wer ein Kuerzel vergibt, schreibt im selben Commit auf, wofuer es
   steht.** Sonst ist in acht Wochen niemand mehr da, der es weiss — auch
   nicht der, der es vergeben hat ([[wissen-gehoert-in-dateien]]).
