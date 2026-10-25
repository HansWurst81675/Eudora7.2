# <a id="lektor-61"></a>LEKTOR-61 — Bestand gegen die Release-Definition vom 25.10.2026 (seit 40f4cbae), 25.10.2026

**Auftrag.** Alle `.md` außer `Arbeitsweise/` und `Befunde/` gegen den Bestand
prüfen, nicht gegen den Diff; geändert seit `40f4cbae` sind 14 Commits bis
`48cd36fa`. Schwerpunkt: Gregors neue Definition eines Releases 7.2.1.x in
`ZIEL.md:18-40` — *„ohne einschränkungen … bis auf die paar themen, die in
readme stehen … alles implementiert und getestet. die tests ergebnisse müssen
im repo dokumentiert werden"*. Gefragt ist also: Was nennt die README als
Einschränkung, ist alles andere wirklich erledigt und getestet, und wo stehen
die Testergebnisse?

**Ergebnis vorweg.** Die README und der Bestand passen **nicht** zu der neuen
Definition. **11 Funde** (3 falsch, 4 unvollständig, 3 veraltet, 1 Form).
Die drei schwersten:

1. **Was zu 7.2.1 noch fehlt, zeigt `ZIEL.md` oben als „0 offen" an** —
   gleichzeitig nennt dieselbe Datei zwei Kriterien nur „fast" erfüllt, wegen
   einer Fehlermeldung, die in keinem Befund steht und deshalb von keinem
   Werkzeug gezählt wird ([L-61.1](#l-61.1)).
2. **Mindestens zehn offene Fehler, die ein Anwender bemerkt, stehen nicht in
   der README** — darunter *Strg-W beendet ganz Eudora* (von Gregor gefunden)
   und *ein Antwortentwurf verliert seine Zuordnung zum Gesprächsfaden* (von
   Gregor bestätigt) ([L-61.2](#l-61.2)).
3. **Für Gregors Testergebnisse je Kriterium gibt es im Repo keinen Ort** —
   `ZIEL.md:31-34` verlangt sie in `Releases/PRUEFBERICHT.md`, und der Bericht
   schließt sie in seinem letzten Abschnitt ausdrücklich aus ([L-61.5](#l-61.5)).

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **belegt** (Zitat
mit Datei:Zeile), **Vermutung**.

---

## Mechanisch

Gemessen am 25.10.2026 in diesem Arbeitsbaum auf `48cd36fa`. Die Ausgaben sind
zitiert, nicht als Urteil übernommen — drei der Funde unten sieht keines
dieser Werkzeuge.

| Werkzeug | Ausgabe (gekürzt) |
|---|---|
| `perl tools/doku-pruefen.pl` | *„Kein Widerspruch gefunden."*; 13 Hinweise „nennt weder den Quellstand 7.2.0.122 noch die Paketnummer 1.0.122" (Release-Notizen, Issue-Antworten, `Doku/HINTERGRUND.md` u. a. — Archivdateien, kein Fund). **Nicht gemeldet:** `ZIEL.md:166` nennt 7.2.0.120 als Stand ([L-61.9](#l-61.9)) |
| `perl tools/offene-befunde.pl` | *„39 offene Befunde, in beiden Listen gleich."*; davon 27 aktuell gemessen (22 nur am Quelltext), 12 nie gemessen |
| `perl tools/pruefe-regressionstest.pl` | 204 Befunde, 67 mit Testfall, 2 manuell im Plan, 68 behoben ohne Testfall; **kritisch 69, davon 46 mit Testfall, 21 ohne jede Prüfung** (`S-1 S-8 V-1 AN-1 E-2 E-3 E-23 E-32 E-60 E-64 E-72 E-82 E-120 E-122 E-123 E-124 E-126 E-129 E-136 E-133 E-39`); *„Kein neues ‚behoben' ohne Regressionstest."* |
| `perl tools/ziel-stand.pl` | *„19 von 19 erfüllt, 0 offen - ZIEL.md ist auf dem Stand."* — siehe [L-61.1](#l-61.1) |
| `perl tools/pruefe-tabellenzeilen.pl` | *„305 Dateien, keine gebrochene Tabellenzeile."* |

## Funde aus dem letzten Bericht

[LEKTOR-60](LEKTOR-60.md#lektor-60) hatte **keinen eigenen Fund**; er bestätigte
zwei Funde aus [LEKTOR-59](LEKTOR-59.md#lektor-59). Beide sind heute weiter
**erledigt**:

* [L-59.1](LEKTOR-59.md#l-59.1) (der README-Rat für ältere Pakete ließ keine
  Sicherungskopie von `rootcerts.p7b` anlegen) — **erledigt** (belegt):
  `README.md:244` *„in `rootcerts.p7b.alt` umbenennen"*, `:249` *„`rootcerts.p7b.alt`
  wieder in `rootcerts.p7b` umbenennen"*.
* [L-59.2](LEKTOR-59.md#l-59.2) (der Selbsttest der Tabellenschranke zählte
  falsch) — **erledigt** (gemessen): `perl tools/pruefe-tabellenzeilen.pl
  --selbsttest` → *„22 Faelle, 22 richtig, 0 falsch / (15 muessen durchgehen,
  7 muessen abweisen)"*; `tools/WERKZEUGE.md:125` *„22 Fälle in beide
  Richtungen, davon 15"*.

## Die Release-Definition gegen den Bestand

`ZIEL.md:27-36` zieht aus Gregors Satz vier Folgerungen. Je Folgerung, was der
Bestand heute hergibt:

| Folgerung (`ZIEL.md`) | Stand | Funde |
|---|---|---|
| 1. Weitergabe ohne Einschränkung außer der README (`:27-28`) | **nicht erfüllt** — die README nennt 22 Zeilen *Bekannte Fehler* (`README.md:145-168`), es sind aber 39 Befunde offen und eine Meldung ohne Befund; mindestens zehn anwendersichtbare fehlen, eine README-Aussage widerspricht einem offenen Befund | [L-61.1](#l-61.1), [L-61.2](#l-61.2), [L-61.3](#l-61.3), [L-61.4](#l-61.4) |
| 2. Alles implementiert und getestet, auch von Gregor (`:29-30`) | **teilweise** — der automatische Teil ist BESTANDEN (`Releases/PRUEFBERICHT.md`, 301/19/32); die Kriterientabelle stammt von 7.2.0.55 (`ZIEL.md:79-80`), Gregors Lauf aller neun Kriterien steht aus | [L-61.1](#l-61.1), [L-61.5](#l-61.5) |
| 3. Testergebnisse im Repo, auch Gregors je Kriterium (`:31-34`) | **automatisch ja, Gregors nein** — es gibt keinen Ort dafür | [L-61.5](#l-61.5) |
| 4. Rückstand an Tests in den Release-Notizen (`:35-36`) | **nicht vorbereitet** — keine Schranke, keine Notizen für 7.2.1 | [L-61.5](#l-61.5) |

---

## <a id="l-61.1"></a>L-61.1 — falsch: „0 offen" in `ZIEL.md`, während zwei Kriterien „fast" heißen

**Was passiert.** Wer wissen will, was zu 7.2.1 fehlt, wird von der README nach
`ZIEL.md` geschickt (`README.md:136-137` *„Was zur Fassung 7.2.1 noch fehlt,
steht erzeugt ganz oben in ZIEL.md — dort und nur dort"*). Dort steht, es fehle
nichts. Dieselbe Datei sagt weiter unten das Gegenteil.

* **Oben** (belegt): `ZIEL.md:44` *„Stand: 19 von 19 erfüllt, 0 offen."*,
  `:50` *„Alle Zeilen des Maßstabs sind erfüllt."*
* **Unten** (belegt): `ZIEL.md:199-203` *„Neun Kriterien: sieben sind belegt
  (0, 1, 3, 5, 6, 7, 8), zwei sind fast erfüllt (2, 4). Was Kriterium 2 noch
  fehlt, steht vollständig in der Zeile 2a: [E-77](../Intern/BEFUNDE.md#e-77) … und die Meldung
  ‚Encountered an improper argument' beim Anzeigen mancher Nachrichten — diese
  Meldung fehlt auch Kriterium 4."* Ebenso `Intern/WEITERMACHEN.md:65` und
  `:79-82` *„Beiden noch nicht erfüllten Kriterien fehlt dasselbe"*, `:300`
  *„Die Meldung … beim Anzeigen neu messen."*
* **Warum kein Werkzeug es sieht** (gemessen): `grep -n "improper argument"
  Intern/BEFUNDE.md` findet nur [E-16](../Intern/BEFUNDE.md#e-16),
  [E-33](../Intern/BEFUNDE.md#e-33), [E-34](../Intern/BEFUNDE.md#e-34),
  [E-37](../Intern/BEFUNDE.md#e-37) und [E-115](../Intern/BEFUNDE.md#e-115) —
  alle behoben oder überholt, keiner zum **Anzeigen** einer Nachricht. Die
  Meldung hat keinen Befund; `ziel-stand.pl` und `offene-befunde.pl` lesen nur
  Befundurteile und zählen sie deshalb nicht. Auch die README nennt sie nicht
  (gemessen: `grep -c "improper argument" README.md` → 0).
* **Dazu** (belegt): `ZIEL.md:79-80` *„die Tabelle der Kriterien neu messen
  (ihre Urteile stammen von 7.2.0.55), dann Gregors Test aller neun
  Kriterien"* — das steht als Schritt vor dem Release, nicht im erzeugten
  Block oben.

**Gegen die Release-Definition:** Die Meldung ist weder in der README noch als
erledigt belegt. Seit [E-43](../Intern/BEFUNDE.md#e-43) ist es
**Vermutung** (`WEITERMACHEN.md:303-304` *„gut möglich, dass die Meldung mit
verschwunden ist"*), dass sie nicht mehr kommt — gemessen ist es nicht.

**Was zu tun wäre:** die Meldung messen und je nach Ergebnis einen Befund
anlegen oder Zeile 2a, `ZIEL.md:199-203` und `WEITERMACHEN.md:65-82,300`
berichtigen; den erzeugten Block so fassen, dass er die ausstehenden
Release-Schritte (`ZIEL.md:79-81`) mitnennt.

## <a id="l-61.2"></a>L-61.2 — unvollständig: offene, anwendersichtbare Fehler fehlen in der README

**Was passiert.** `ZIEL.md:28` *„Was dort nicht steht, muss gehen."* Die
Tabelle *Bekannte Fehler* (`README.md:145-168`) wird von Hand geführt; die
Liste der offenen Befunde (`Intern/WEITERMACHEN.md:347-391`, 39 Zeilen) wird
erzeugt. Beide sind nicht abgeglichen.

Gemessen (`grep -c` je Kennung in `README.md`, Urteil aus `Intern/BEFUNDE.md`):

| Befund | was der Anwender erlebt | Urteil (belegt) | README |
|---|---|---|---|
| [E-137](../Intern/BEFUNDE.md#e-137) | **Strg-W** auf der Wazoo-Leiste (Adressbuch, Filter, Postfächer) beendet **ganz Eudora** statt das Fenster zu schließen | `BEFUNDE.md:389` *„offen, am 23.10.2026 von Gregor am laufenden Programm gefunden"* | 0 |
| [E-142](../Intern/BEFUNDE.md#e-142) | ein Entwurf aus einem IMAP-Ordner nach `Out` gezogen ergibt eine **leere** Nachricht | `:378` *„offen, von Gregor am 23.10.2026 am laufenden Programm bestätigt"* | 0 — siehe [L-61.4](#l-61.4) |
| [E-144](../Intern/BEFUNDE.md#e-144) | ein Antwortentwurf, nach `Out` zurückgeschoben, verliert `In-Reply-To`/`References` — die Antwort fällt beim Empfänger aus dem Gesprächsfaden | `:385` *„offen, von Gregor am 23.10.2026 am laufenden Programm bestätigt"* | 0 |
| [E-136](../Intern/BEFUNDE.md#e-136) | ein Emoji, das richtig angezeigt wird, wird beim Speichern zu „??" | `:390` *„offen, am 22.10.2026 an 7.2.0.120 gemessen"*; einer der sechs „Randfälle" (`ZIEL.md:57`) | 0 — nur `Doku/ANWENDER.md:278-288` |
| [E-146](../Intern/BEFUNDE.md#e-146) | nach dem Umbenennen eines IMAP-Ordners führt Eudora ihn unter anderem Namen als der Server | `:383` *„offen, an unserem Code gemessen"* | 0 |
| [E-143](../Intern/BEFUNDE.md#e-143) | aus dem Suchfenster kommt der `Out`-Hinweis je Nachricht — zwanzig Treffer, zwanzig Dialoge; ein Filter nach `Out` hält den Abruf an | `:379` *„offen, am Quelltext belegt"* | 0 |
| [E-141](../Intern/BEFUNDE.md#e-141) | eine Übertragung IMAP → `Out` stößt die IMAP-Nachbearbeitung an, bis zu einem `EXPUNGE` | `:377` *„offen, am Quelltext belegt"* | 0 |
| [E-139](../Intern/BEFUNDE.md#e-139) | die Meldung „Rechtschreibprüfung nicht vorhanden" kommt bei jeder Gelegenheit wieder | `:387` *„offen, … von Gregor am laufenden Programm gefunden"* | 0 |
| [E-140](../Intern/BEFUNDE.md#e-140) | *File → Save As* aus Nachrichten- und Verfassen-Fenster schreibt ohne Zeichensatzangabe | `:386` *„offen, am Quelltext belegt, nie gemessen"* | 0 |
| [E-145](../Intern/BEFUNDE.md#e-145) | Base64-Dekodieren wertet Bytes über 127 als gültig | `:384` *„offen, am Quelltext belegt"* | 0 |

Nicht in die Tabelle aufgenommen, weil nach dem Urteil nicht anwendersichtbar
oder Werkzeug: [E-151](../Intern/BEFUNDE.md#e-151) (Prüfstände nicht aus dem
Klon), [E-109](../Intern/BEFUNDE.md#e-109), NP-, S-, P-, R-Punkte. Ob
[E-92](../Intern/BEFUNDE.md#e-92)/[E-91](../Intern/BEFUNDE.md#e-91)
(Weiterleitungskopf und Zitate sehen anders aus als bei Thunderbird) und
[E-78](../Intern/BEFUNDE.md#e-78) (Leistenanordnung) ein Anwender bemerkt, ist
nicht gemessen — **Vermutung:** kaum.

**Was zu tun wäre:** je offenem Befund entscheiden, ob er bis 7.2.1 behoben
oder in die README aufgenommen wird (das Produkturteil ist Gregors — siehe
unten); und die Tabelle aus derselben Quelle prüfen wie die offenen Befunde,
damit die README nicht wieder still zurückfällt (Lehre *Liste aus einer
Quelle*).

## <a id="l-61.3"></a>L-61.3 — falsch: die README verspricht Anhänge „mit Endung", über IMAP fehlt sie

* `README.md:106` (belegt): *„Schreiben, antworten, weiterleiten, Anhänge mit
  vollem Namen und Endung"*.
* [AN-1](../Intern/BEFUNDE.md#an-1) ist offen (gemessen:
  `Intern/WEITERMACHEN.md`, offene Liste, *„allein B5.7 — der IMAP-Weg ruft
  `SetExtension` nicht auf"*); `Doku/ANWENDER.md:62-64` sagt es richtig:
  *„über IMAP wird keine Endung aus dem MIME-Typ nachgetragen, wenn der Name
  keine hat"*.
* Gregor hat [AN-1](../Intern/BEFUNDE.md#an-1) zurückgestellt (`ZIEL.md:57`
  *„[AN-1](../Intern/BEFUNDE.md#an-1) später"*) — gerade deshalb gehört die Einschränkung in die README.
  [AN-1](../Intern/BEFUNDE.md#an-1) steht zudem unter den 21 kritischen Befunden ohne jede Prüfung
  (`pruefe-regressionstest.pl`, oben).

## <a id="l-61.4"></a>L-61.4 — unvollständig: der vereinbarte Hinweis zu E-142 ist weder gebaut noch in der README

* **Vereinbart** (belegt): `Intern/BEFUNDE.md:378` *„Vereinbart — Gregor am
  24.10.2026: ‚wir haben ausgemacht, daß es als hinweis kommt, daß bei dieser
  aktion mail inhalt verloren gehen kann, das sollte reichen.'"*; ebenso
  `Intern/WEITERMACHEN.md:142` (5).
* **Nicht gebaut** (gemessen): `grep -rn "[E-142](../Intern/BEFUNDE.md#e-142)" Eudora71/Eudora/*.cpp
  Eudora71/Eudora/*.rc` → kein Treffer; das Urteil steht weiter auf *„offen"*.
* **Nicht in der README** (gemessen): `grep -c "E-142" README.md` → 0.

**Gegen die Release-Definition:** Ein Release 7.2.1 mit diesem Stand ließe den
Anwender eine leere Nachricht in `Out` finden, ohne Hinweis im Programm und
ohne Zeile in der README. Einer von beiden Wegen muss vorher stehen.

## <a id="l-61.5"></a>L-61.5 — unvollständig: für Gregors Ergebnisse je Kriterium gibt es keinen Ort

* **Verlangt** (belegt): `ZIEL.md:31-34` *„Releases/PRUEFBERICHT.md für alles
  Automatische … und die Ergebnisse von Gregors Test je Kriterium. Ein Release
  ohne dokumentierte Ergebnisse gibt es nicht."*
* **Der Bericht schließt sie aus** (belegt): `Releases/PRUEFBERICHT.md:444-449`
  *„Was dieser Bericht nicht abdeckt: Die manuellen Faelle in TESTPLAN.md,
  Teil M … Ein Release gilt erst nach Gregors eigenem Lauf … dieser Bericht
  ersetzt das nicht."* Der Text kommt aus dem Werkzeug
  (`tools/pruefbericht.pl:389-391`), wird also bei jedem Lauf wieder so
  erzeugt.
* **Der Testplan hat keinen Abschnitt je Kriterium** (gemessen: `grep -n "^#"
  Intern/TESTPLAN.md` — Teile A, B, C, M, D; keiner zu den neun Kriterien aus
  `ZIEL.md:186-197`). Teil M (`TESTPLAN.md:519-630`) hat Schritte und
  Sollzustand, aber **keine Ergebniszeile**; `TESTPLAN.md:16-17` *„Vor dem
  Release 7.2.1 bleiben die Fälle M1 und M3 … von Hand zu fahren."*
  Teil D (`:631-650`) trägt Urteile in `BEFUNDE.md` ein — je Befund, nicht je
  Kriterium.
* **Release-Notizen und Rückstand** (belegt): `ZIEL.md:35-36` verlangt, dass
  die Notizen den Rückstand nennen (heute 21 kritische ohne Prüfung). Für
  7.2.1 gibt es keine Notizen (gemessen: `ls Releases/` — nur `1.0.*`), und
  `tools/release-veroeffentlichen.ps1:44,248` nimmt `-Notizen` nur
  wahlweise; keine Schranke prüft den Rückstand. Ebenda `:173-174` setzt die
  Marke `'v' + $Fassung` (also `v1.0.<n>`) und den Titel mit festem
  `'7.2.0.'` — bekannt seit [L-53.16](LEKTOR-53.md#l-53.16), in
  `ZIEL.md:81` und `WEITERMACHEN.md:146` richtig als offen geführt.
* **„Am Paket gelaufen"** (`ZIEL.md:29-30`): der Prüfbericht misst am Bau in
  `Eudora71\Bin\Release` (`Releases/PRUEFBERICHT.md`, Kopf *„Massstab fuer die
  Pruefstandsfaelle ist der Bau in Eudora71\Bin\Release"*), nicht am ZIP.
  **Vermutung:** gleichwertig, solange der Paketbau genau diese `Eudora.exe`
  einpackt — gemessen ist das hier nicht.

**Was zu tun wäre:** einen Ort für Gregors Ergebnis je Kriterium (und je
Teil-M-Fall) festlegen — mit Paketnummer, Datum, ja/nein, Zitat — und ihn aus
`pruefbericht.pl` mit ausgeben; die 7.2.1-Notizen mit dem Rückstand
vorbereiten.

## <a id="l-61.6"></a>L-61.6 — veraltet: die README verweist auf „7.2.0.123", das nie veröffentlicht wird

* `README.md:147` (belegt): *„Behoben ab 7.2.0.123"*; `:232` *„Was behoben ist
  (ab 7.2.0.123)"*; `:239-240` *„Mit Eudora selbst ist das erst im Paket
  7.2.0.123 zu messen"*.
* Seit dem 25.10.2026 abends (belegt): `ZIEL.md:38-40` *„Zwischenstände wie
  7.2.0.123 sind Testpakete für Gregors lokalen Test, keine Releases;
  veröffentlicht wird erst 7.2.1.\<n\>"*.

**Was passiert.** Wer die öffentliche README liest und das eMudhra-Risiko
([E-148](../Intern/BEFUNDE.md#e-148): Eudora vertraute vier
Wurzelzertifikaten mit kompromittierten Zwischenzertifikaten) loswerden will,
sucht ein Paket 7.2.0.123, das es auf GitHub nicht geben wird. Richtig wäre
*„ab dem Release 7.2.1"*.

## <a id="l-61.7"></a>L-61.7 — unvollständig: E-150 ist behoben, fehlt aber im CHANGELOG

* [E-150](../Intern/BEFUNDE.md#e-150) (im Fenster *Task Status* konnte das
  Abschalten einer Spalte 4 Byte hinter ein Feld schreiben) steht als
  *„behoben … kommt mit Paket 7.2.0.123"* (`Intern/BEFUNDE.md:381`, belegt).
* Commit `1e85186c` hat die Zeile aus *Noch offen* entfernt (gemessen: `git
  show 1e85186c -- CHANGELOG.md`, eine gelöschte Zeile), aber im Abschnitt
  *Seit 7.2.0.122, noch ohne Paket* (`CHANGELOG.md:98` ff.) keinen Eintrag
  angelegt (gemessen: `grep -c "E-150" CHANGELOG.md` → 0).
* Derselbe Abschnitt sagt in `CHANGELOG.md:100` *„Gemergt am 23.10.2026 (PR
  #157 und #158)"* — das stimmt nur noch für [E-116](../Intern/BEFUNDE.md#e-116)
  und [E-130](../Intern/BEFUNDE.md#e-130); [E-148](../Intern/BEFUNDE.md#e-148),
  [E-77](../Intern/BEFUNDE.md#e-77), [E-113](../Intern/BEFUNDE.md#e-113),
  [E-119](../Intern/BEFUNDE.md#e-119) kamen am 24./25.10. dazu (belegt:
  `BEFUNDE.md:324,359,365,382`, jeweils *„24.10.2026"* bzw. *„25.10.2026"*).
  Die Überschrift `:98` nennt [E-148](../Intern/BEFUNDE.md#e-148) und [E-150](../Intern/BEFUNDE.md#e-150) nicht.

## <a id="l-61.8"></a>L-61.8 — falsch: `Doku/ANWENDER.md` sagt „nur was heute fehlt" und führt Geschlossenes

* `Doku/ANWENDER.md:7-8` (belegt): *„Hier steht nur, was heute fehlt. Keine
  Fassungsgeschichte, keine behobenen Fehler"*.
* Darunter (belegt): `:63` [E-101](../Intern/BEFUNDE.md#e-101) *„am 23.10.2026
  geschlossen"*, `:68` [E-114](../Intern/BEFUNDE.md#e-114) *„am 23.10.2026
  geschlossen"*, `:73-77` [E-115](../Intern/BEFUNDE.md#e-115) *„Behoben in
  7.2.0.86"*.

Für die Release-Definition zählt das, weil die README für die Grenzen auf
diese Liste verweist (`README.md:288-290`) — eine Liste, in der Erledigtes
neben Offenem steht, macht die Einschränkungen nicht mehr ablesbar. Dazu
`README.md:290` *„steht oben unter [Was es nicht kann](Doku/ANWENDER.md…)"* —
es steht nicht oben, sondern in einer anderen Datei (Form).

## <a id="l-61.9"></a>L-61.9 — veraltet: `ZIEL.md:166` nennt 7.2.0.120 als Stand

* `ZIEL.md:166` (belegt): *„Stand 22.10.2026. Quellstand 7.2.0.120 / VERSION
  1.0.120"*.
* Gemessen: `cat VERSION` → `1.0.122`; der Prüfbericht nennt *„Quellstand
  7.2.0.122"*.
* `doku-pruefen.pl` meldet es nicht — es prüft offenbar, ob der aktuelle Stand
  **genannt** wird (`ZIEL.md:38` nennt 7.2.0.123), nicht, ob ein **älterer**
  als Stand ausgegeben wird (**Vermutung** zur Ursache, aus der Ausgabe oben
  geschlossen).

## <a id="l-61.10"></a>L-61.10 — veraltet: `TESTPLAN.md:251` nennt 277 Tests

* `Intern/TESTPLAN.md:251` (belegt): *„Eigene Tests dieser Fassung: 277
  Tests, 277 bestanden (Stand 7.2.0.122, 23.10.2026)"* — gemessen am
  Prüfbericht heute: 301 Unit-Tests am selben Quellstand 7.2.0.122.
* Die Zeile sagt selbst, dass sie aus `tools/pruefbericht.pl` erzeugt gehört
  und *„am 23.10.2026 zum dritten Mal veraltet"* war
  ([L-51.16](LEKTOR-51.md)). Jetzt zum vierten Mal.

## <a id="l-61.11"></a>L-61.11 — Form: das Testpaket 7.2.0.123 hat noch keine Prüfanleitung

* `Intern/TESTPLAN.md:6-8` (belegt): *„Was jetzt zu testen ist — Im Moment
  nichts."*; der Abschnitt *„Was bekannt ist — bitte nicht als neuen Fehler
  melden"* (`:224-241`) nennt `data:`-Bilder, zu breite Bilder und `35px` —
  genau das, was mit 7.2.0.123 behoben kommt
  ([E-119](../Intern/BEFUNDE.md#e-119), [E-113](../Intern/BEFUNDE.md#e-113),
  [E-116](../Intern/BEFUNDE.md#e-116)).
* Für 1.0.122, das Gregor heute hat, ist das richtig. **Beim Schnüren von
  7.2.0.123** muss der Testplan mitgehen, sonst sagt er Gregor, die neuen
  Behebungen nicht zu melden. Kein Fehler heute, ein Termin.

---

## Geprüft, kein Fund

* **Neue Regressionstests** (gemessen am Prüfbericht): [E-51](../Intern/BEFUNDE.md#e-51) als Schranke
  (`Releases/PRUEFBERICHT.md:392` *„vorher=0 rueckfall=1 danach=0"*), [E-97](../Intern/BEFUNDE.md#e-97) und
  [E-100](../Intern/BEFUNDE.md#e-100) (`:432-433`, *„dialog=1 lebt=1"*), [E-67](../Intern/BEFUNDE.md#e-67) (`:434`), [E-99](../Intern/BEFUNDE.md#e-99) als Unit-Test
  (`:352`). Keiner steht mehr unter den kritischen ohne Prüfung.
* **Ausreißer im Prüfstandsprotokoll**: `tools/TESTLAEUFE.md:403-407` — vier
  E-97-Läufe am sauberen Bau `796369bb` mit *„musste abgeschossen werden"*.
  Erklärt in `718509c0` und `tools/messen-e97.ps1:243-250`: ein stehen
  gebliebener Hinweis zur Rechtschreibprüfung
  ([E-139](../Intern/BEFUNDE.md#e-139)) blockierte das Beenden; ab
  `TESTLAEUFE.md:408` *„Schliesszeit 1 s"*. Ein Fehler der Messung, nicht von
  Eudora.
* **Dauer im Prüfbericht**: 0:07 + 0:08 + 5:05 = 5:20, wie angegeben
  (`Releases/PRUEFBERICHT.md`, Tabelle *Dauer*). Die Commit-Nachricht
  `648b803d` nennt 5 min 22 s — nur die Nachricht, keine `.md`.
* **Marke `v7.2.1.<n>`**: in `ZIEL.md:81`, `WEITERMACHEN.md:146` als
  entschieden geführt; keine Stelle im Bestand führt sie mehr als offen
  (gemessen: `git grep -i "marke.*offen"` ohne `Befunde/`, `Arbeitsweise/`).
* **[E-151](../Intern/BEFUNDE.md#e-151)** (Prüfstände nur unter `C:\Temp` der
  Entwicklermaschine): in `BEFUNDE.md:380` als zurückgestellt, in beiden
  offenen Listen geführt. Der Prüfbericht sagt offen, dass die Fälle unter
  `C:\Temp` laufen.
* **`Intern/PRUEFBERICHT.md`** ist ein Archiv vom 30.08.2026 und sagt das in
  Zeile 3; die README unterscheidet beide Dateien (`README.md:88`).

## Nicht geprüft

* Der Inhalt der Archivdateien unter `Releases/1.0.*/` und
  `Releases/ISSUE-102-*` — sie beschreiben ihren damaligen Stand.
* Ob die README-Tabelle die **Wirkung** jedes aufgeführten Befunds richtig
  beschreibt; geprüft ist nur, was fehlt.
* Die Urteilszeilen der behobenen Befunde gegen den Quelltext — das ist
  PRÜFER-Sache (PRÜFER-53 läuft parallel).

## Was nur Gregor entscheiden kann

1. **Offene Fehler, die ein Anwender merkt, vor 7.2.1 beheben oder als
   Einschränkung in die README?** Nach deiner Definition ist beides zulässig.
   Betroffen sind vor allem: *Strg-W auf der Wazoo-Leiste beendet ganz Eudora*
   ([E-137](../Intern/BEFUNDE.md#e-137), von dir gefunden), *ein Antwortentwurf
   verliert beim Zurückschieben nach `Out` die Zuordnung zum Gesprächsfaden*
   ([E-144](../Intern/BEFUNDE.md#e-144), von dir bestätigt), *nach dem
   Umbenennen eines IMAP-Ordners stimmt der Name nicht mit dem Server überein*
   ([E-146](../Intern/BEFUNDE.md#e-146)), *zwanzig Suchtreffer nach `Out`
   ergeben zwanzig Dialoge* ([E-143](../Intern/BEFUNDE.md#e-143)) und *die
   Rechtschreib-Meldung kommt immer wieder* ([E-139](../Intern/BEFUNDE.md#e-139)).
   Verloren geht bei keinem davon eine Nachricht im Postfach (laut Urteilen);
   bei [E-137](../Intern/BEFUNDE.md#e-137) ist nicht gemessen, ob ein offenes, ungespeichertes
   Verfassen-Fenster dabei verloren geht.
