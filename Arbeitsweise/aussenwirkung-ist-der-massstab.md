---
name: aussenwirkung-ist-der-massstab
description: "43 Schranken meldeten gruen, waehrend in der Wurzel 21 Dateien mit 25.532 Zeilen lagen und README.md allein 1266 - am 22.10.2026 hat Gregor an einem Tag viermal gesehen, was keine Schranke sieht: das gerenderte Dokument"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 3f65ec35-9408-4b65-b617-033776baffe9
  modified: 2026-10-22T12:00:00.000Z
---

Schranke: tools/pruefe-tabellenzeilen.pl und tools/pruefe-nicht-kann.pl — die ersten beiden Schranken dieses Projekts, die nicht den Quelltext einer Datei pruefen, sondern **was daraus im Browser wird**. Beide sind abweisend verdrahtet (`tools/hooks-einrichten.sh:142` und `:159`); `lehren-schranken.pl` erkennt das nicht, weil es die Schreibweise `tools/<name>` sucht und die nur in der Inventarliste am Ende des Hakens steht, in der beide fehlen — siehe [CHRONIST-2026-10-22](CHRONIST-2026-10-22.md), *Offen* Nr. 7. Gegenproben: `--selbsttest` 12 bzw. 10 Faelle, beide Richtungen.

# Der Massstab ist die Aussenwirkung, nicht die gruene Schranke

**Regel.** Eine Schranke prueft eine Eigenschaft, die ich benannt habe. Der
Leser sieht ein Dokument. Zwischen beidem liegt alles, woran noch niemand
gedacht hat — und genau dort sitzt das, was ein Fremder zuerst bemerkt. Wer
wissen will, wie das Repository wirkt, **oeffnet es** so, wie ein Fremder es
oeffnet, statt die Zahl der gruenen Haken zu zaehlen.

## Was passiert ist (22.10.2026)

Am Ende eines Tages, an dem jeder einzelne Commit durch 43 Schranken im
`pre-commit` gegangen war, schrieb Gregor:

> *„mich interessiert nicht, ob irgendwo eine wurzel oder anker fehlt. die
> wirkung nach aussen ist entscheidend, und das ist aktuell = chaos! sowas
> fasst kein entwickler an, um daran weiter zu arbeiten."*

und kurz darauf:

> *„mir reicht es! ich moechte nicht dauernd (!) hinter dir dein chaos
> aufraeumen! und dich drauf hinweisen. dafuer hast du deine agenten. und
> deine vorgaben und ziele. mach es einmal richtig fertig!"*

**Vier Funde an einem Tag, alle von ihm, keiner von einer Schranke:**

| Was er sah | Gemessen | Warum keine Schranke es sah |
|---|---|---|
| *„hat ein darstellungsproblem: der text ist links, nicht rechts"* | zwei Tabellenzeilen in `WEITERMACHEN.md` ueber zwei physische Zeilen gebrochen. Im Quelltext sieht die Datei heil aus; GFM liest die zweite Haelfte per *lazy continuation* als eigene Tabellenzeile und schiebt ihren Text in Spalte 1 | keine Schranke las je das **gerenderte** Ergebnis |
| *„das ist doch bullshit! hier steht unter der ueberschrift ‚was es nicht kann', entsteht also der eindruck, all das kann unser eudora nicht!"* | der Abschnitt hatte **224 Zeilen, davon 37 ueber Behebungen und Veroeffentlichungen**, samt vollstaendiger Fassungsgeschichte (v1.0.120, .87, .84, .83). Nach dem Aufraeumen: 86 Zeilen, 11 Punkte | jede einzelne Zeile war **wahr**. Falsch war nur, was die Ueberschrift aus ihnen machte |
| *„ist es die s-bahn?"* (zu `S-3b`) | **16 Nummernkreise** (`E-`, `A-`, `AN-`, `S-`, `B-`, `M-`, `R-`, `V-`, `P-`, `PR-`, `W-`, `F-`, `X-`, `Z-`, `NP2-`, `NP3-`), nirgends erklaert | eine Kennung ist fuer jede Schranke ein Schluessel, fuer den Leser ein Raetsel |
| *„ist das eine tabelle?"* | `ZIEL.md:52`: **9356 Zeichen in einem Absatz**, unter einem Kasten, der woertlich sagt *„Diese Tabelle ist die Quelle"*. Beim Nachmessen ueber die fuehrenden Dokumente: 20 Absaetze ueber 1200 Zeichen, der laengste `Intern/WEITERMACHEN.md:164` mit **11.553** | kein Werkzeug misst die **Form** eines Dokuments |

Dazu der Gesamtbefund, der keiner Einzelmeldung entsprach und deshalb von
niemandem gemeldet wurde: **21 Markdown-Dateien in der Wurzel, 25.532
Zeilen**, `README.md` allein **1266**. Kein `LICENSE`. Das ist die erste
Seite, die ein Fremder sieht.

## Warum die benachbarten Lehren nicht gereicht haben

- [[erfolg-aus-anwendersicht]] misst, **was Gregor danach tun kann** — am
  laufenden Programm. Der Leser eines Repositoriums kommt darin nicht vor.
- [[einigkeit-ist-kein-beweis]] sagt genau das Richtige — *„der Massstab
  kommt von aussen"* — und nennt als Beispiele fuer „aussen" den Tag, die
  ausgelieferte EXE, Gregors Lauf. **Das gerenderte Dokument steht nicht in
  dieser Liste.** Alle 43 Schranken lesen Quelltext.
- `tools/doku-pruefen.pl` und seinesgleichen halten Dokumente
  **gegeneinander**. Vier Dokumente koennen sich einig sein und zusammen
  unlesbar.

## How to apply

1. **Einmal je Arbeitsblock das Repository so oeffnen, wie ein Fremder es
   oeffnet** — die Startseite auf GitHub, nicht `git show`. Die Frage ist
   nicht *„stimmt es?"*, sondern *„wo faengt jemand an, der das nicht
   gebaut hat?"*
2. **Eine Ueberschrift ist eine Zusage.** Unter *„Was es nicht kann"* steht
   nur, was es heute nicht kann; unter *„Diese Tabelle"* steht eine Tabelle.
   Jede Zeile einzeln wahr zu haben, reicht nicht
   (`tools/pruefe-nicht-kann.pl` weist das jetzt ab).
3. **Form ist Inhalt.** Ein Absatz ueber 1200 Zeichen, eine Tabellenzeile
   ueber zwei physische Zeilen, eine Kennung ohne Legende — das sind keine
   Schoenheitsfragen, sondern die Stellen, an denen der Leser aussteigt.
4. **Wenn Gregor einen Befund mit „schau dir mal an" einleitet, ist die
   Quelle nicht die Antwort.** Dreimal an diesem Tag sah die Datei im
   Quelltext in Ordnung aus. Gerendert war sie es nicht.
5. **Eine neue Schranke dieser Art prueft die Wirkung, nicht die Schreibweise.**
   `pruefe-tabellenzeilen.pl` laesst den fehlenden Abschluss-Pipe durch (GFM
   erlaubt ihn, `Intern/BEFUNDE.md:255` nutzt ihn) und weist nur ab, was der
   Leser falsch zu sehen bekommt ([[schranke-gegentesten]]).
6. **Die Zahl gruener Schranken ist kein Zustandsbericht.** 43 von 43 gruen
   und *„sowas fasst kein entwickler an"* sind an diesem Tag gleichzeitig
   wahr gewesen.
