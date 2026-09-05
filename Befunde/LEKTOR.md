# LEKTOR — Befunde zur Aktualität der Dokumentation

**Agent:** LEKTOR · **Zweig:** `wt/lektor-3` · **Datum:** 06.09.2026 ·
**Bezugscommit:** `81851e5` (`fehler-nach-1010`, vor `f2a954d`/`c3babf0`)

## L-1 — Die README war ein Grabungsbericht, keine Anleitung

Gregor am 06.09.2026, zu Sätzen wie *„Stand der Tabelle: die Zeilen zu Bauzustand
und Ersatzschicht sind an `a807b93` gemessen, die Zeilen zu Start, Menüs,
Erscheinungsbild, Abruf, Paket und Produktversion am 31.08.2026 …"*:

> *„warum ist es noch keinem aufgefallen? sollte up to date sein. das
> interessiert ja keinen."*

Er hat recht. Das Gerüst — „gemessen an Commit X am Datum Y", „wer den Stand
prüft, misst neu und nennt seinen eigenen Bezugscommit", Berichtigungskästen zu
Ständen, die durch neuere ersetzt sind — war sinnvoll, solange sich stündlich
etwas änderte. Es verdeckt inzwischen die Anleitung.

**Die Leitlinie, nach der die vier Dateien jetzt gefasst sind:**

- Die Datei sagt, **was jetzt gilt**. Ein einziger Satz am Anfang nennt Fassung
  und Datum, mehr nicht.
- Belege gehören in `BEFUNDE.md` / `Befunde/*.md`, und dorthin wird **verwiesen**,
  statt sie zu wiederholen.
- Berichtigungskästen zu Ständen, die durch neuere ersetzt sind, fallen weg —
  der Beleg steht in den Befunden und im git-Verlauf.
- **Ausnahme:** eine Berichtigung bleibt stehen, wenn sie vor einem Irrtum warnt,
  dem jemand sonst erneut aufsitzt. Stehengeblieben sind deshalb:
  `/p:BuildProjectReferences=false` wird **nicht mehr** gebraucht;
  `tools/paket-pruefen.ps1` ist **kein** Nachweis für Kriterium 0; die
  Registerkartenleiste ist **nicht** verzichtbar; **E-11 ist zurückgenommen**.

**Ergebnis, gemessen mit `git diff --stat`:**

| Datei | vorher | nachher |
|---|---|---|
| `README.md` | 427 | 336 |
| `AUFGABEN.md` | 554 | 332 |
| `WEITERMACHEN.md` | 688 | 218 |
| `ZIEL.md` | 174 | 117 |

## L-2 — Zwei Anleitungen galten nur noch für den Debug-Bau

Gregor zu `README.md:160` (`-NurPruefen`) und `:162` (Kasten „Achtung
`0xc000007b`"): *„ist es noch aktuell? braucht man jetzt noch diese infos?"*

**Beide sind für den Normalfall überholt, aber nicht falsch.** Sie betreffen nur
noch den **Debug**-Bau: das ausgelieferte Release-Paket bringt `mfc140.dll`,
`msvcp140.dll` und `vcruntime140.dll` selbst mit (Befund F-1), und die vier
Debug-Laufzeiten dürfen ohnehin nicht weiterverteilt werden.

**Umgestellt statt gelöscht:** sie stehen jetzt unter der Überschrift
*„Nur für den Debug-Bau: die Laufzeit-DLLs"*, die mit dem Satz beginnt „Das
Release-Paket braucht nichts aus diesem Abschnitt."

## L-3 — Dieselbe Falle steht noch an drei weiteren Stellen

`STARTUMGEBUNG.md:80-95`, `Releases/PAKETE.md:132-135` und — abgeschwächt —
`Releases/1.0/README.md` verlangen die vier Debug-Laufzeiten als **Punkt 1 einer
Checkliste für jeden, der ein Paket auspackt**. Wer dem folgt, holt sich die
**nicht verteilbaren** DLLs ins Paket. Das ist genau der Mangel, der für
`Releases/1.0.3/LIESMICH.txt` am 31.08.2026 schon einmal behoben wurde
(`LEKTORAT.md:313-322`) — er ist nur nicht überall nachgezogen worden.

**Nicht behoben** (fremde Dateien), gehört in den nächsten Durchgang.

## L-4 — Was in den anderen `.md` noch einen überholten Stand behauptet

Gelesen am 06.09.2026, alle 24 Dateien außer `README.md`, `AUFGABEN.md`,
`WEITERMACHEN.md`, `ZIEL.md` (die gehören diesem Durchgang) und `BEFUNDE.md`
(fassen mehrere Agenten gleichzeitig an). **Nichts davon ist behoben** — die
Liste ist der Auftrag für den nächsten Durchgang.

### Schwer: führt einen Leser aktiv in die Irre

| Datei : Zeile | Was dort steht | Warum überholt |
|---|---|---|
| `PORTIERUNG.md:149-162` | Kasten „gemessen 05.09.2026": OT501 scheitert, „aus einem reinen Projektmappen-Bau kommt deshalb **nie** eine `Eudora.exe`", zweiter Gang mit `/p:BuildProjectReferences=false` | Trägt ein tagesaktuelles Datum, ist aber der Stand **vor** B-3. Gesamtbau grün (18/0/1) |
| `PORTIERUNG.md:52-63` | „16 der 18 Projekte werden fertig"; „ein voller Solution-Bau meldet 3 Fehler, alle aus `OT501`"; `EudoraRes.vcxproj:351` | Der Berichtigungskasten in Z. 36-41 deckt nur die Tabelle darüber ab. Die genannte Zeile existiert nicht mehr (schon als M-8 in `PRUEFUNG-CODE.md:534` gemeldet, nie nachgezogen) |
| `PORTIERUNG.md:571-574` und `Eudora71/OpenSSL3/BAUEN.md:7-15` | „die beiden `.lib` liegen **nicht** im Repo … `QCSSL` endet mit `LNK1104: libssl.lib`", mit Handlungsanweisung ganz oben in der Datei | Sie liegen im Repo; ein frischer Klon bindet `QCSSL` ohne Zutun. Wer der Anweisung folgt, baut 25 Minuten OpenSSL ohne Not |
| `STARTUMGEBUNG.md:80-95` | Checkliste Punkt 1: die vier Debug-Laufzeiten dazulegen, „für jeden, der ein Paket in ein frisches Verzeichnis packt" | Siehe L-3 |
| `Releases/PAKETE.md:132-135` | im Abschnitt zum **Release**-Paket: „Ohne die vier VS2022-Debug-Laufzeiten scheitert der Start mit `0xc000007b`" | Siehe L-3; widerspricht der eigenen Überschrift |
| `Releases/PAKETE.md:99-104`, `:174-175` | die Unterscheidung der beiden 1.0.3-ZIPs wird mit „enthält die Behebung von **E-11**" begründet | **E-11 ist zurückgenommen** — die Begründung trägt nicht mehr |
| `PORTIERUNG.md:469-472` | „**E-11 war der Absturz auf frischen Installationen**, behoben in `eudora.cpp:3372`" | Zurückgenommen. Die Fehlerklasse R-1 bleibt — genau diese Unterscheidung fehlt |
| `PRUEFUNG-BRANCH.md:170-175`, `:280-281` | „Damit ist die Ursache von Gregors Absturz **wieder offen**" | Nicht mehr offen: **E-25** |
| `Pruefung/PRUEFUNG-KETTE.md:284-289`, `:520-525` | „Der Absturz … ist **weiterhin unerklärt**" | Erklärt (E-25). Der Rest des Berichts bleibt gültig |
| `Pruefung/PRUEFUNG-ZEIGER.md:46` | „der Assistentenpfad, auf dem Gregor die Abstürze **E-6/E-9/E-11** gesehen hat" | E-11 zurückgenommen |
| `ABRUF-PRUEFEN.md:53-73`, `:162` | „**Belegt ist Port 110 mit STARTTLS**"; „das ist **nicht** der Weg, den diese Anleitung empfiehlt (Port 995)"; Entscheidungsbaum „auf 995 horcht dort nichts"; Verweis auf einen UNGEPRÜFT-Hinweis, den es nicht mehr gibt | **Port 995 mit TLSv1.3 ist am 06.09.2026 belegt.** Der empfohlene Weg ist damit der gemessene |

### Mittel: falscher Versions- oder Paketstand als aktuell

| Datei : Zeile | Was |
|---|---|
| `Releases/PAKETE.md:93` | jüngster Abschnitt ist **1.0.3**; 1.0.4 bis 1.0.10 fehlen ganz. Die Buchführungsdatei endet sieben Pakete vor dem Stand (war schon M-4 in `PRUEFUNG-CODE.md:614`) |
| `Releases/PAKETE.md:15-34`, `:66-68` | „Wie man die Version hebt", durchgerechnet für `1.0.3 → 1.0.4`. Das Verfahren stimmt, die Zahlen sind sieben Runden alt |
| `Releases/PAKETE.md:164-172` | Tabelle „Stand nach ZIEL.md (31.08.2026)": „keine der beiden veröffentlichten Fassungen ist von jemandem gestartet worden" |
| `Releases/PAKETE.md:113-114` | „LIESMICH beschreibt **noch den Debug-Weg**" — sie ist am 31.08. abends neu gefasst worden (`LEKTORAT.md:313`) |
| `PRUEFUNG-BAU.md:83-91` | `Version.h` sage `7.2.0.3`, Tabelle mit FileVersion 7.2.0.3; datiert 05.09.2026 und deshalb leicht als aktuell zu lesen |
| `PRUEFUNG-CODE.md:526` | der „richtige" Wert der Berichtigung M-8 ist selbst überholt (dort 1.0.4 / 7.2.0.4) |
| `PRUEFUNG-CODE.md:543-564`, `:637` | **M-11** („voller Bau meldet 3 Fehler, `LNK1181: QCUtils.lib`") ist mit `77424fc` behoben (fünf `ProjectReference` auf `QCUtils`), steht aber weiter im Mängelverzeichnis |
| `PRUEFUNG-CODE.md:659-662`, `PRUEFUNG-BRANCH.md:288-289`, `Pruefung/PRUEFUNG-PAKET.md:20-23`, `:364-384` | Empfehlungen rund um Paket 1.0.2/1.0.3 („1.0.2 zurückziehen", „die nächste Auslieferung heißt 1.0.4") |
| `LEKTORAT.md:383-386`, `:412-423` | jüngster Eintrag ist der vierte Durchgang vom 05.09. mit 1.0.4; X-5 und X-6 werden dort noch als „liegt auf einem Arbeitszweig" geführt. **Ein fünfter Durchgang fehlt** — dieser hier |

### Mittel: „noch nicht gebaut / nie gestartet / offen", was längst erledigt ist

| Datei : Zeile | Was |
|---|---|
| `STARTUMGEBUNG.md:138-143` | „**Ob Eudora startet, sagt diese Datei nicht** … alles danach ist **offen**" — widerspricht dem eigenen Kasten in Z. 6-14 |
| `STARTUMGEBUNG.md:65`, `:71-73` | `EudoraRes.dll` „hängt an OT501" und werde „beim Solution-Bau übersprungen" — seit B-3 nicht mehr |
| `STARTUMGEBUNG.md:120-134` | SUPERASSERT-Dialoge „weil bisher **ausschließlich der Debug-Bau** läuft"; dazu die alte Form der Bau-Kennung (M-9) |
| `Eudora71/OTShim/BEFUND-ANSICHT.md:353-369`, `BEFUND-MENUE.md:131-152` | Bauzustand „`LNK1104: imap.lib`"; „zu prüfen, ob ein Bau der ganzen Solution die Datei erzeugt"; eine „falsifizierbare Vorhersage", die E-1 längst entschieden hat |
| `Eudora71/OTShim/PLAN.md:330-333`, `:423-451` | Projektverweis auf `OT501` (Zeile 1015), Attrappe `OTA50D.LIB`, „`EudoraRes.dll` fehlt in `Bin/Debug`, der Startversuch scheitert daran voraussichtlich vor allem anderen" |
| `Eudora71/VC71Bruecke/BEFUND.md:432-435`, `:486-501` | „Nächster Schritt: Startversuch mit der Brücke … das Auslieferungspaket gegenprüfen … `VC71Bruecke` in die Solution eintragen" — alle drei erledigt, Punkt 3 sogar im Kasten darüber |
| `Releases/1.0/README.md:124-129`, `:257` | „Ob Eudora selbst die Datei annimmt, ist **nicht getestet**" (rootcerts) — Eudora handelt TLS im Betrieb erfolgreich aus |
| `BEFUNDE-ALTBESTAND.md:269-275` und `tools/patches/zertifikatspruefung-verschaerfen.md:114-122` | die alte CR-Anzahl-Regel und „`git commit --no-verify` gerechtfertigt"; der Berichtigungskasten unmittelbar darüber widerlegt den Absatz |
| `PRUEFUNG-BAU.md:427-485`, `AGENTEN.md:173` | Bauanleitung als roher `MSBuild.exe`-Aufruf; `tools/bauen.ps1` (X-6) tut genau das, was der Abschnitt „nicht dem Rückgabewert glauben" von Hand verlangt |
| `PORTIERUNG.md:3`, `:8`, `:31`, `:91-92` | Kopf „Stand: 2026-08-31 · Branch `darstellung-und-menue`", Prüfstandsmarke `d826a3f`, Messungen mit `-p:BuildProjectReferences=false`, „die übrigen Projekte sind im Release-Zweig **ungetestet**" |
| `PORTIERUNG.md:16-18`, `:441-446`, `Releases/1.0/README.md:26`, `Releases/1.0/AUSLIEFERUNGEN.md:47-52` | der Servertest überall nur als „Port 110 mit STARTTLS"; Port 995 / TLSv1.3 fehlt |

**Ohne Befund:** `Eudora71/Tests/QCSSL/README.md` und
`Eudora71/OTShim/INVENTAR.md`.

## L-5 — Das Verzeichnis in `BEFUNDE.md` behauptet drei falsche Stände

Nicht behoben, weil mehrere Agenten diese Datei gleichzeitig anfassen — aber
belegt:

- **`Z-3` steht als „offen"**, ist aber behoben. `git log` nennt `57fe6a4`
  („Z-3 richtig behoben"), und `grep -n QCUtils Eudora71/Importers/NSImport/NSImport.vcxproj`
  zeigt in Zeile 156 den `ProjectReference`. Dasselbe in `OEImport`, `OLImport`
  und `plstclnt`.
- **`E-24` und `E-25` fehlen im Verzeichnis** und in der Statusspalte, obwohl
  beide Befunde geschrieben und die Behebungen im Zweig sind
  (`Befunde/POSTFACH.md`, `Befunde/ASSISTENT.md`).
- Die Prüfstandsmarke steht auf `3d03c50`, die Kopfzeile nennt **6960 Zeilen**;
  `wc -l < BEFUNDE.md` sagt am 06.09.2026 **7334**.

Die Auflage im Verzeichnis selbst lautet: *„wer einen Befund fortschreibt, ändert
die Statusspalte hier mit."* Sie ist dreimal nicht eingehalten worden. Ein
Verzeichnis, das falsche Stände behauptet, ist schlimmer als keines — das steht
dort wörtlich.

## L-6 — Arbeitshinweis: nicht mit dem Edit-Werkzeug

Am 05.09.2026 hat es die README an 238 Stellen doppelt kodiert. Dieser Durchgang
ist deshalb ohne Edit-Werkzeug gearbeitet: die Dateien sind mit `cat`-Heredoc
erzeugt und mit `perl` und `:raw` an ihren Platz kopiert worden, danach jedes Mal
gemessen — Zeilenzahl, CR-Zahl und die Folgen `C3 83`, `C3 A2`, `EF BF BD`. Alle
fünf Dateien: `CR=0`, alle drei Zähler `0`.

**Nebenbefund zum Werkzeug:** ein `cat`-Heredoc über etwa 10 KB bricht mit
„unexpected EOF while looking for matching `'`" ab — offenbar abgeschnitten. Wer
eine große Datei so schreibt, teilt sie in Stücke und setzt sie mit `cat` wieder
zusammen; sonst entsteht lautlos eine halbe Datei.
