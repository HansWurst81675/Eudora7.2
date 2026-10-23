---
name: stand-23-10-2026-abend
description: "Was am 23.10.2026 beim Abschalten offen blieb und in KEINER Repo-Datei steht - die fertige Berichtigung des Testplan-Kopfes, der Zweigname, und was Gregor als naechstes erwartet"
metadata:
  node_type: memory
  type: project
  originSessionId: 3f65ec35-9408-4b65-b617-033776baffe9
  modified: 2026-10-23T11:26:09.774Z
---

Schranke: keine - ein Stand beim Abschalten laesst sich nicht pruefen, nur aufschreiben. Der Ausloeser ist Gregors Satz "ich fahre jetzt runter": dann gehoert alles, was nur im Chat steht, in eine Datei ([[wissen-gehoert-in-dateien]], [[abschalten-ist-ein-termin]]).

# Stand beim Abschalten am 23.10.2026

## Das Repo ist gesichert

`main` auf `dd1d1f82`, nichts uncommittet außer den fünf DLLs unter
`Eudora71/Bin/Release/` (`DirServ`, `EudoraBk`, `ISock`, `Ldap`, `Ph`) — die
stempelt der Bau bei jedem Lauf neu, ohne dass sich der Inhalt ändert, das ist
**E-130**. Nichts ungepusht, kein Zweig offen, alle vier PRs des Tages (#151
bis #154) gemergt und bestätigt.

## Nachtrag 23.10.2026 nachmittags: erledigt

Die Berichtigung des Testplan-Kopfes ist gemacht, im Zweig
`e-125-urteil-und-testplan` (Gregor hat den Namen bestätigt). Gregor hat
1.0.122 getestet (Ablehnung bestätigt, Gegenprobe als nicht durchführbar
abgelehnt); die Gegenprobe ist am Prüfstand gefahren und als
Regressionsfall E-125a–c eingebaut, Bericht in
`Intern/TESTBERICHT-E125.md`. Was unten steht, ist der Stand von mittags.

## Was NICHT gesichert ist

**Die Berichtigung des Abschnitts *„Was jetzt zu testen ist"* in
`Intern/TESTPLAN.md`.** Sie war fertig formuliert, als Gregor abschaltete, und
brauchte nur noch einen abgestimmten Zweignamen. Vorschlag war
`e-139-und-e101-testluecke`, vorher noch keine Antwort.

**Warum es dringend ist.** Gregor hat den Abschnitt am 23.10.2026 selbst
gemeldet: *„vom 23.10. -> Was jetzt zu testen ist -> Die Auswahlbox im
To:-Feld — bleibt sie gleich groß? ernsthaft?"* Der Abschnitt schickt ihn auf
einen Test aus Paket 1.0.120 und erwähnt das Paket, das er in der Hand hält,
mit keinem Wort. Nachgemessen war er an **drei von vier** Punkten falsch:

| im Plan | tatsächlich |
|---|---|
| C10 *„neu in 1.0.120 und offen"* | E-135 hat Gregor am **21.10.2026 bestätigt** |
| C9 *„nur noch Gegenprobe"* | stimmt (E-134, am 21.10. bestätigt) |
| C8 *„noch nicht gefahren"* | derselbe Fall wie M1, doppelt geführt |
| M3 / E-125 — das Paket 1.0.122 | **kommt gar nicht vor** |

Der fertige Ersatztext lag in
`scratchpad/testplan-kopf.pl` und ist mit dem Scratchpad weg. Er ist aber in
zwei Minuten neu zu schreiben: Abschnitt auf M3 (E-125, Paket 1.0.122) als
einzigen offenen Fall umstellen, M1 als stehenden Fall vor jedem Release, M2
als am 23.10. erledigt, und C8 bis C10 ausdrücklich als Nachschlagewerk mit
dem Hinweis, dass C10 zwei Tage lang falsch als offen dastand.

## Was Gregor als nächstes erwartet

1. ~~**Sein Lauf an 1.0.122**~~ erledigt (siehe Nachtrag) nach `Intern/TESTPLAN.md#m3-e125` — vier Schritte,
   Schritt 4 ist die Gegenprobe mit einem Entwurf. Das Paket liegt in
   `C:\Users\Gregor\Eudora72-1.0.122-release` mit `TESTEN.txt`.
2. **E-139 bauen** — er hat ausdrücklich gefragt, ob ich es nur aufschreibe.
   `AfxMessageBox` in `spell.cpp:58` durch `NoteDialog` ersetzen, dazu eine
   Ressourcenzeile und einen INI-Schlüssel. Ergäbe 7.2.0.123.
3. **PRÜFERs fertigen Testfall** aus `Befunde/PRUEFER-46.md` in
   `Eudora71/Tests/TestE101.cpp` einsetzen.
4. **E-141 nicht ohne sein Ja** — der Klammerfehler ändert Verhalten an einer
   alten Stelle für *alle* Übertragungen.

## Zwei Dinge, die er gesagt hat und die bleiben

**Kürzel.** *„ich ignoriere kürzel, die mir nichts sagen. werde einfach nicht
mehr drauf reagieren und dich auch nicht informieren."* Das ist keine
Stilfrage: an diesem Tag kamen **vier der entscheidenden Messungen von ihm**
(die gespeicherte Datei, „Adressbuch und Filter sind dasselbe Fenster", die
Start-Messung zu E-139, das Bildschirmfoto mit dem deutschen Meldungstext).
Wer ihn mit `K1`, `L-52.4`, `M3` abspeist, verliert diese Quelle.
Siehe [[kuerzel-im-chat-uebersetzen]] — die Lehre steht seit dem 15.10. im
Repo und ist an diesem Tag zweimal gebrochen worden.

**Die drei Arbeitsbäume** `Eudora7.2-wt-chronist`, `-wt-lektor`, `-wt-pruefer`
stehen auf abgelöstem HEAD, sind aber sauber und ihre Stände stecken in
`main`. `gesichert.pl` meldet sie bei jedem Lauf als Fehlalarm. Ich habe
gefragt, ob ich sie entfernen soll — **keine Antwort, also stehen lassen**.
