---
name: anwenderdatei-nicht-erschlagen
description: "Eine Datei, die es beim Anwender oder im Original schon gibt, wird gelesen und ergaenzt - nie neu geschrieben und ins Paket gelegt"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-07T12:45:18.145Z
---

Schranke: tools/paket-pruefen.ps1 (vor jeder Übergabe an Gregor — prüft die Eudora.ini im Mailverzeichnis und die Vollständigkeit von DEudora.ini)

# Was es schon gibt, wird gelesen — nicht ueberschrieben

Am 07.09.2026 habe ich `tools/DEudora.ini` angelegt, damit neue Konten die
richtigen Vorgaben bekommen. Meine Fassung hatte **nur** einen `[Settings]`-Teil
mit sechs Schluesseln — 67 Zeilen. `tools/paket-bauen.ps1` legt sie neben
`Eudora.exe` ins Paket.

Dann zeigte Gregor seine eigene Datei. Sie traegt zusaetzlich `[Mappings]` mit
**124 Dateizuordnungen** (128 Zeilen). Wer mein Paket ueber eine bestehende
Installation auspackt, verliert sie alle.

Es gab keinen Grund, das nicht zu wissen:

- Die Originaldatei von QUALCOMM lag **im Repo**:
  `InstallersForEudora/Eudora7.1/Data/INIfiles/deudora.ini`, 128 Zeilen,
  124 Zuordnungen. Ich hatte sie in derselben Stunde sogar geoeffnet.
- Ich hatte `Eudora71/Eudora/MIMEMap.cpp:225-265` gelesen und richtig
  festgestellt, dass eine Datei ohne `[Mappings]` beim **Lesen** nichts kaputt
  macht (`Eudora.ini` zuerst, `DEudora.ini` danach, additiv). Daraus habe ich
  „kein Risiko" geschlossen — und dabei die **zweite** Wirkung uebersehen:
  nicht das Lesen ist der Schaden, sondern das **Auspacken ueber die vorhandene
  Datei**.

Aufgefallen ist es nur, weil Gregor die Datei von sich aus gezeigt hat.

Die Berichtigung war: Originaldatei nehmen, die vier Zusatzzeilen in
`[Settings]` einfuegen, und **byteweise** nachweisen, dass die 124 Zuordnungen
unveraendert sind (`cmp` auf die extrahierten Zeilen: gleich). Dazu eine
Schranke in `tools/doku-pruefen.pl` (Pruefung 11 / A-1), die roter wird, wenn
die Zuordnungen fehlen — gegengetestet in beide Richtungen.

**Warum:** Ein Werkzeug, das eine Datei erzeugt, sieht die Datei des Anwenders
nicht. Der Schaden entsteht nicht bei mir, sondern beim Auspacken auf seinem
Rechner, und er ist dort **nicht zurueckholbar** — es gibt kein `git checkout`
in einer Installation. Und er wird nicht bemerkt: fehlende MIME-Zuordnungen
aeussern sich Wochen spaeter als „der Anhang oeffnet falsch".

**Wie anwenden — bevor ein Werkzeug eine Datei schreibt, packt oder kopiert:**

1. **Fragen, ob es sie schon gibt.** Drei Orte durchsuchen, nicht einen:
   ```
   git ls-files | grep -i '<name>'
   find . -iname '<name>' -not -path './.git/*'
   unzip -l Releases/<letztes Paket>.zip | grep -i '<name>'
   ```
   Ein Treffer in `InstallersForEudora/` ist die **Originalfassung des
   Herstellers** und damit der Ausgangspunkt, nicht eine Altlast.
2. **Vom Original ausgehen, nur ergaenzen.** Die vorhandene Datei kopieren,
   meine Zeilen einfuegen, und danach beweisen, dass der Rest identisch ist
   (Zeilen zaehlen **und** `cmp`). „Ich habe die wichtigen Werte uebernommen"
   ist kein Beweis.
3. **Zwei Fragen trennen: liest es sich harmlos, und ueberschreibt es etwas?**
   Ein additives Leseverhalten im Quelltext sagt nichts ueber das Auspacken.
4. **Byteform des Originals uebernehmen.** Hier: CRLF, weil
   `GetPrivateProfileString` sonst Werte verliert — die beiden vorhandenen INIs
   im Paket hatten CRLF=128, meine erste Fassung nur-LF=67
   ([[quelldateien-nur-byte-erhaltend-aendern]]).
5. **Schranke dazu**, die den Verlust melden wuerde, mit Gegentest — sonst
   passiert es beim naechsten Mal wieder ([[fehlerklassen-abstellen]],
   [[schranke-gegentesten]]).
6. **Gregors Testverzeichnis bleibt lesend.** Was dort liegt, wird nicht von mir
   angefasst; wenn ich es wissen muss, frage ich nach dem Inhalt
   ([[nichts-auf-gregors-bildschirm-starten]]).

Siehe [[pruefen-statt-vermuten]] und [[lauffaehiges-ergebnis-liefern]].

## Nachtrag 10.09.2026 — dasselbe noch einmal, diesmal durch das Auspacken selbst

Punkt 3 dieser Lehre trennt zwei Fragen: *liest es sich harmlos* und
*ueberschreibt es etwas*. Am 10.09.2026 habe ich die zweite Frage nicht
gestellt und den Schaden dann selbst angerichtet — nicht ueber eine Datei im
Paket, sondern ueber das **Ziel des Auspackens**.

Beim Ablegen von Paket 1.0.40 habe ich das ZIP nach `C:\Users\Gregor`
entpackt, statt in ein Unterverzeichnis. **Das Paket-ZIP hat keine eigene
Wurzelebene:** `Eudora.exe`, `Mailverzeichnis\`, `Plugins\` und 154 weitere
Eintraege liegen direkt auf der obersten Ebene. Also landeten 157 Dateien
direkt im Benutzerverzeichnis, und `Mailverzeichnis\Eudora.ini` — Gregors
eigene, um 09:21 angelegte Fassung — wurde von der Paketvorlage
ueberschrieben.

Aufgeraeumt hat es `tools/home-aufraeumen.ps1`: geloescht wird nur, was in
**Groesse und Zeitstempel** exakt zum Paket passt, Ordner nur, wenn sie leer
sind, und die `Eudora.ini` wird aus dem Stand zurueckgestellt, der zu den
uebrigen Dateien passt (`Junk.mbx` 492875 B, `GMX.mbx` 37604 B,
`Filters.pce` 404 B — das ist 1.0.36 und kein anderer Stand).

**Wie anwenden, zusaetzlich zu den sechs Punkten oben:**

7. **Nie in ein Verzeichnis auspacken, in dem schon etwas anderes wohnt.**
   Ziel ist immer ein eigenes, neu angelegtes Unterverzeichnis — auch dann,
   wenn das ZIP scheinbar eine Wurzelebene hat.
8. **Vor jedem Auspacken die oberste Ebene des Archivs auflisten.** Ein
   Befehl, und er beantwortet die einzige Frage, auf die es ankommt:

       unzip -l <paket>.zip | awk '{print $4}' | cut -d/ -f1 | sort -u | head

   Mehr als ein Eintrag heisst: das Archiv bringt keine Wurzel mit und darf
   nur in ein leeres Verzeichnis.
9. **Gregors Benutzerverzeichnis ist kein Arbeitsverzeichnis.** Was dort
   liegt, ist seins ([[nichts-auf-gregors-bildschirm-starten]]); ein
   Paketinhalt gehoert nach `%USERPROFILE%\Eudora72-<Fassung>-release\`, so
   wie die Fassungen davor auch.
