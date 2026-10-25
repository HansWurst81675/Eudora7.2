# <a id="lektor-59"></a>LEKTOR-59 — Schlusslauf vor dem PR: Commit 62b0a80c (E-148-Berichtigung, geflickte Tabellen, Tabellenschranke), 25.10.2026

**Auftrag.** Nur der Commit `62b0a80c` (*„[LEKTOR-58](LEKTOR-58.md#lektor-58) eingeholt; zerrissene
Tabellen geflickt, Schranke sieht Intern/"*): `CHANGELOG.md` und `README.md`
zu [E-148](../Intern/BEFUNDE.md#e-148) (kompromittierte eMudhra-Wurzeln in der
mitgelieferten Zertifikatsliste), die geflickten Tabellen in
`Intern/BEFUNDE.md`, `tools/WERKZEUGE.md`, `tools/ZWEIGE.md` und das Werkzeug
`tools/pruefe-tabellenzeilen.pl`. Gefragt war nur: Ist etwas davon **falsch**
oder **zerbrochen**? Keine Formfunde, keine Wiederholung aus
[LEKTOR-57](LEKTOR-57.md#lektor-57) und [LEKTOR-58](LEKTOR-58.md#lektor-58).

**Ergebnis vorweg.** Die Berichtigung zu [E-148](../Intern/BEFUNDE.md#e-148) stimmt mit dem Quelltext
überein. **Zwei Funde**, beide klein, keiner hält den PR auf:

* **Der Rückweg im README-Rat für ältere Pakete setzt eine Sicherungskopie
  voraus, die der Rat nirgends anlegen lässt** ([L-59.1](#l-59.1)).
* **Der Selbsttest der Tabellenschranke nennt eine falsche Aufteilung seiner
  Fälle, und `WERKZEUGE.md` nennt in derselben Zeile zwei verschiedene
  Fallzahlen** ([L-59.2](#l-59.2)).

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **belegt** (Zitat
mit Datei:Zeile), **Vermutung**.

---

## Mechanisch

Gemessen am 25.10.2026 in diesem Arbeitsbaum auf `62b0a80c`.

| Werkzeug | Ausgabe |
|---|---|
| `perl tools/doku-pruefen.pl` | kein Widerspruch; nur die bekannten Hinweise *„nennt weder den Quellstand 7.2.0.122 …"* |
| `perl tools/pruefe-tabellenzeilen.pl` | *„300 Dateien, keine gebrochene Tabellenzeile."* (in [LEKTOR-58](LEKTOR-58.md#lektor-58): 278 — jetzt mit `Intern/` und `Doku/`) |
| `perl tools/pruefe-tabellenzeilen.pl --selbsttest` | *„22 Faelle, 22 richtig, 0 falsch / (14 muessen durchgehen, 6 muessen abweisen)"* — siehe [L-59.2](#l-59.2) |

## Geprüft und richtig

* **Suchreihenfolge Mailverzeichnis vor Programmverzeichnis** (belegt):
  `Eudora71/QCSSL/src/QCSSLContext.cpp:403-404` *„determining if the specified
  file exists, first in EudoraDir, then in ExecutableDir"*, Code ab Zeile 430
  *„Default to the first directory (EudoraDir)"*. Damit stimmen
  `README.md:223-224` (*„zuerst im Mailverzeichnis, sonst im
  Programmverzeichnis"*), `README.md:250-252` und `CHANGELOG.md:111-112`
  (*„Eine eigene `rootcerts.p7b` im Mailverzeichnis hat Vorrang"*).
* **„gemessen mit OpenSSL; mit Eudora selbst … im Paket 7.2.0.123"**
  (`CHANGELOG.md:109-111`) sagt jetzt dasselbe wie `README.md:236-240`. Der
  Widerspruch aus [L-58.3](LEKTOR-58.md#l-58.3) ist behoben (belegt).
* **Geflickte Tabellen** (gemessen): `Intern/BEFUNDE.md:380` ([E-148](../Intern/BEFUNDE.md#e-148)) ist
  wieder eine Zeile und endet auf ` |`; die entfernten Leerzeilen in
  `BEFUNDE.md`, `WERKZEUGE.md` und `ZWEIGE.md` standen jeweils vor einer
  Tabellenzeile ohne Trennzeile darunter, verbinden also keine zwei echten
  Tabellen. Die Schranke meldet im Bestand nichts mehr.
* **Erweiterung der Schranke** (belegt, `tools/pruefe-tabellenzeilen.pl:60-64`
  und `108-129`): `Intern/*.md` und `Doku/*.md` stehen in der Bestandsliste;
  eine Leerzeile mitten in einer Tabelle wird gemeldet, eine vor einer neuen
  Tabelle nicht. Beide Richtungen haben einen Selbsttestfall.

## Funde

### <a id="l-59.1"></a>L-59.1 — README: „die alte Datei zurücklegen", ohne dass eine alte Datei aufgehoben wurde

**Was passiert:** Wer mit einem älteren Paket dem Rat folgt und danach einen
Zertifikatsfehler bekommt, soll eine Datei zurücklegen, die er nach dem Wortlaut
der Anleitung überschrieben hat. **Zerbrochen** (belegt):

* `README.md:243-245`: *„`rootcerts.p7b` im Programmverzeichnis durch die neue
  Datei aus `Releases/1.0/` ersetzen (Eudora vorher beenden)"* — kein Wort von
  einer Sicherungskopie.
* `README.md:248`: *„meldet Eudora einen Zertifikatsfehler, die alte Datei
  zurücklegen."*

Die alte Liste liegt zwar in jedem älteren Paket-ZIP. Das steht aber nicht da.
Außerdem sagt der Satz nicht, dass mit der alten Datei auch die vier
eMudhra-Wurzeln zurückkommen, also die Lücke, um die es im Abschnitt geht
(belegt durch das Fehlen; Vermutung, dass ein Leser das übersieht).
**Vorschlag:** in Zeile 244 *„(vorher die alte Datei umbenennen, z. B. in
`rootcerts.p7b.alt`)"*, und in Zeile 248 *„— damit vertraut Eudora den
eMudhra-Wurzeln wieder; dann nur im eigenen Netz benutzen"*.

### <a id="l-59.2"></a>L-59.2 — Selbsttest der Tabellenschranke: Aufteilung falsch ausgegeben, `WERKZEUGE.md` nennt 18 und 22 Fälle in einer Zeile

**Was passiert:** Nichts am Prüfergebnis — die Schranke prüft richtig. Falsch
ist nur, was sie und ihre Beschreibung über den eigenen Selbsttest sagen.
**Falsch** (gemessen und belegt):

* `tools/pruefe-tabellenzeilen.pl:239` gibt fest aus *„(14 muessen durchgehen,
  6 muessen abweisen)"* — zusammen 20. Gezählt an den Erwartungswerten in
  Zeile 197-221 (`grep -o ', [0-9]* \],\?$' | sort | uniq -c`): **15** Fälle
  mit 0 Funden, **7** mit Funden (6 × 1, 1 × 2), zusammen 22. Die Zeile war
  vor `62b0a80c` richtig; der Commit hat zwei Fälle (einer je Richtung)
  dazugenommen und sie nicht nachgezogen.
* `tools/WERKZEUGE.md:125`, derselbe Tabelleneintrag: vorn *„Gegenprobe:
  `--selbsttest`, **18 Fälle in beide Richtungen**, davon 13, die durchgehen
  müssen"*, hinten *„Selbsttest jetzt **22 Fälle**"*. Der vordere Satz ist
  stehen geblieben.

**Vorschlag:** Zeile 239 aus den Fällen zählen statt fest schreiben; in
`WERKZEUGE.md:125` den vorderen Satz auf *„22 Fälle, davon 15, die durchgehen
müssen"* setzen.

## <a id="fragen"></a>Was nur Gregor entscheiden kann

Keine neue Frage. Ob der README-Rat für ältere Pakete überhaupt einen Rückweg
zur kompromittierten Liste anbieten soll, ist eine Formulierungsfrage, die
der Hauptagent mit [L-59.1](#l-59.1) erledigen kann.

## Nicht geprüft

* Ob Eudora bei einem nicht vertrauten Serverzertifikat einen
  *Zertifikatsfehler meldet* oder eine Rückfrage zum Vertrauen stellt
  (`README.md:248`) — nicht am Quelltext verfolgt, Zeitrahmen dieses Laufs.
* Die 13 entfernten Leerzeilen in `tools/ZWEIGE.md` einzeln gegen ihre
  Darstellung auf GitHub; geprüft ist nur, dass die Schranke nichts mehr meldet.
