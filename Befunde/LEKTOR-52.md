# <a id="lektor-52"></a>LEKTOR-52 — Bestandsprüfung nach dem Paket 1.0.122, 23.10.2026

**Auftrag.** Gregor: *„mach. lektor und prüfer durch"*. Schwerpunkt: die vier
Befunde, die an diesem Tag neu aufgenommen ([E-137](../Intern/BEFUNDE.md#e-137) bis [E-140](../Intern/BEFUNDE.md#e-140)), und die vier, die
geschlossen wurden ([E-14](../Intern/BEFUNDE.md#e-14), [E-101](../Intern/BEFUNDE.md#e-101), [E-114](../Intern/BEFUNDE.md#e-114), [E-127](../Intern/BEFUNDE.md#e-127)) — jeweils **gegen den
Quelltext**, nicht gegen andere Dokumente. Dazu das gebaute Paket gegen das,
was die Dokumentation über es behauptet.

**Ergebnis: 14 Funde** — 5 falsch, 6 veraltet, 2 unvollständig, 1 Form.
**Einer davon traf Gregor unmittelbar.**

---

## Der Fund, der sofort wirkte

### <a id="l-52.6"></a>L-52.6 — dem Paket fehlte die Prüfanleitung
**Gewicht: unvollständig.** `C:\Users\Gregor\Eudora72-1.0.122-release`

Ein Vergleich der Dateilisten von 1.0.120 und 1.0.122 ergab **genau einen**
Unterschied: `TESTEN.txt` fehlte. Das Paket, dessen einziger Zweck ein
manueller Test ist, wäre ohne Prüfanleitung bei Gregor angekommen.
`tools/paket-bauen.ps1` erzeugt sie nicht — sie wurde bisher jedes Mal von
Hand dazugelegt.

**Erledigt:** `TESTEN.txt` nachgelegt, mit den vier Schritten aus
[TESTPLAN M3](../Intern/TESTPLAN.md#m3-e125), einem Abschnitt *Was neu ist* und
einem Abschnitt *Was in dieser Fassung nicht behoben ist* ([E-136](../Intern/BEFUNDE.md#e-136), [E-137](../Intern/BEFUNDE.md#e-137), [E-139](../Intern/BEFUNDE.md#e-139),
[E-140](../Intern/BEFUNDE.md#e-140)), damit Gregor nicht danach sucht. 4.539 Byte, CRLF wie die übrigen
Paketdateien.

---

## Was die Dokumentation über das Paket behauptete

### <a id="l-52.5"></a>L-52.5 — „nicht geschnürt", während das Paket schon bei Gregor lag
**Gewicht: falsch.** `Releases/PAKETE.md`, `CHANGELOG.md`

Beide sagten *„Nur übersetzt am 23.10.2026, nicht geschnürt"*. Das Verzeichnis
existierte seit 12:00. Die Teilaussage *„kein ZIP"* stimmt; die Überschrift
nicht. `tools/pruefe-aussenstand.pl` schlägt hier nicht an, weil es nur nach
ZIP bzw. `Releases/<nr>/` sieht, nicht nach einem Testverzeichnis.

**Erledigt**, und zugleich um die Messung ergänzt, die bisher nur im Chat
stand: `Eudora.exe` byte-gleich mit dem Bauverzeichnis, `paket-pruefen.ps1`
ohne Fehler, und der **verworfene erste Anlauf** — `paket-bauen.ps1` nimmt die
frischen Binärdateien nur mit `-AusBauverzeichnis`, und `-Bauart` steht per
Vorgabe auf **Debug**. Ohne beides blieb die Debug-`Eudora.exe` vom 30.08.2026
stehen (10.201.088 statt 3.020.800 Byte). `paket-pruefen.ps1` hat das
abgewiesen — der Fall aus
[paket-gegen-den-bau-messen](../Arbeitsweise/paket-gegen-den-bau-messen.md),
und die Schranke hat gehalten.

### <a id="l-52.7"></a>L-52.7 — die `LIESMICH.txt` stellt sich in jedem Paket als „Paket 1.0.3" vor
**Gewicht: Form — aber es ist die erste Zeile, die ein Erstanwender liest.**

Die Datei ist in jedem Paket dieselbe, ihre Kopfzeile nannte eine Nummer, die
seit Dutzenden Paketen falsch war. **Erledigt:** Kopfzeile auf *„Eudora 7.2 —
Release-Bau, LIESMICH"* ohne Nummer, mit einem Absatz, der sagt, wo die echte
Fassung steht. Auch im ausgelieferten Paket ausgetauscht.

---

## Befunde, die anderswo noch als offen standen

Das ist der Fall aus
[review-sieht-nur-den-diff](../Arbeitsweise/review-sieht-nur-den-diff.md) —
derselbe, der gestern schon dreimal kam.

| | Fundstelle | was dastand |
|---|---|---|
| <a id="l-52.8"></a>**L-52.8** | `ZIEL.md:46` | [E-101](../Intern/BEFUNDE.md#e-101) als **offen** — im *Maßstab des Projekts*, während `BEFUNDE.md` ihn als behoben führt. Dazu wörtlich die Paraphrase *„der Kern ist tot"*, die am selben Tag als Fehlerquelle aufgeschrieben wurde |
| <a id="l-52.9"></a>**L-52.9** | `Doku/ANWENDER.md:63` | [E-101](../Intern/BEFUNDE.md#e-101) *„wieder offen seit 13.10.2026"* |
| <a id="l-52.10"></a>**L-52.10** | `Intern/AUFGABEN.md:413` | [E-101](../Intern/BEFUNDE.md#e-101) unter *Was sonst noch offen ist* |
| <a id="l-52.11"></a>**L-52.11** | `Intern/AUFGABEN.md:422`, `Intern/WEITERMACHEN.md:411` | [E-14](../Intern/BEFUNDE.md#e-14) mit der Bedingung *„echter Befund erst, wenn die Meldung auch beim zweiten Start kommt"* — genau diese Bedingung war am 23.10.2026 gemessen und **nicht** erfüllt |
| <a id="l-52.12"></a>**L-52.12** | `README.md:149` | die E-101-Zeile beschreibt das Symptom ohne ein Wort zur Schließung |

Alle berichtigt. [E-114](../Intern/BEFUNDE.md#e-114) und [E-127](../Intern/BEFUNDE.md#e-127) waren **sauber** — der Fund [L-51.2](LEKTOR-51.md#l-51.2) vom
Vormittag ist abgearbeitet, kein Dokument nennt sie mehr offen.

---

## Fehler in den neuen Einträgen selbst

### <a id="l-52.1"></a>L-52.1 — E-101 widerlegt sich in sich selbst
**Gewicht: falsch.** Der letzte Absatz empfahl eine Behebung (*„`Content-` aus
der Vorgabe nehmen"*) auf der Prämisse, der Stripper laufe **nach** dem Kern.
40 Zeilen höher steht die Messung vom selben Tag, dass er **vorher** läuft.
Die Empfehlung wäre falsch gewesen: ohne `Content-` in der Vorgabe bliebe die
möglicherweise falsche Zeile der empfangenen Nachricht stehen, und der Kern
ergänzte nichts mehr. **Erledigt**, Absatz als überholt gekennzeichnet und
richtiggestellt.

### <a id="l-52.3"></a>L-52.3 — E-137 nennt die Zeilen der Nachrichtentabelle statt der Funktionen
**Gewicht: falsch (Fundstelle).** `mainfrm.cpp:481`/`:483` sind
`ON_COMMAND`-Einträge; die Funktionen stehen in `:4782` und `:4923`. Die
**Aussage** stimmt, nur der Verweis schickte den Leser an die falsche Stelle.

### <a id="l-52.4"></a>L-52.4 — der Nachweis war in Dateien geführt, in denen so etwas nicht stehen kann
**Gewicht: unvollständig.** Gezählt wurde über `*WazooWnd.h` und `*WazooBar.h`
— ein `ON_COMMAND` steht in MFC grundsätzlich in der `.cpp`. Eine Suche, die
dort nichts finden **kann**, belegt nichts. Richtig gezählt über den ganzen
Baum: `ID_FILE_CLOSE` kommt fünfmal vor, drei Behandler, keiner davon eine
Wazoo-Klasse. **Das Ergebnis war richtig, die Messung trug es nicht** —
dieselbe Klasse wie
[ausbleiben-ist-kein-befund](../Arbeitsweise/ausbleiben-ist-kein-befund.md).

### <a id="l-52.2"></a>L-52.2 — E-138 verlangte zwei Hinweise, die längst dastanden
**Gewicht: veraltet.** Der Hinweis steht in **vier** Dateien, alle committet.
Das Feld *Was noch fehlt* ist genau das, aus dem die Tabelle im CHANGELOG
erzeugt wird — der überholte Satz wanderte also weiter.

### <a id="l-52.13"></a>L-52.13 — mein CHRONIST-Bericht zählt sechs Befunde von Gregor, es sind drei
**Gewicht: falsch.** [E-137](../Intern/BEFUNDE.md#e-137), [E-138](../Intern/BEFUNDE.md#e-138), [E-139](../Intern/BEFUNDE.md#e-139) kamen von ihm; [E-140](../Intern/BEFUNDE.md#e-140) hat LEKTOR beim
Gegenprüfen abgetrennt. Die Tabelle derselben Datei nennt richtig drei.

---

## Ein Fund, der sich bei der Nachmessung auflöste

### <a id="l-52.14"></a>L-52.14 — `Unblock-File` an Verzeichnissen
LEKTOR vermutete, `Get-ChildItem -Recurse … | Unblock-File` werfe an
Verzeichnissen Fehler, und schlug `-File` vor — ausdrücklich als **nicht
gemessen** gekennzeichnet.

**Nachgemessen am 23.10.2026** in einem Wegwerfverzeichnis mit Unterordner:
**0 Fehler**, mit und ohne `-File`. Der Befehl in der Anwenderdoku bleibt, wie
er ist. Die Kennzeichnung als ungemessen hat hier genau das getan, wofür sie
da ist.

---

## Geprüft und in Ordnung

* **[E-137](../Intern/BEFUNDE.md#e-137), [E-138](../Intern/BEFUNDE.md#e-138), [E-139](../Intern/BEFUNDE.md#e-139), [E-140](../Intern/BEFUNDE.md#e-140)** — jede andere Fundstelle stimmt wörtlich,
  einzeln nachgeschlagen. Bei [E-140](../Intern/BEFUNDE.md#e-140) ist die Kernaussage nachgemessen: in
  `compmsgd.cpp` und `ReadMessageDoc.cpp` kommt `Content-Type` **kein einziges
  Mal** vor.
* **[E-14](../Intern/BEFUNDE.md#e-14)** — die Begründung bringt ihre eigene **Positivprobe** mit; am
  Protokoll von 1.0.116 stichprobenartig bestätigt.
* **[E-114](../Intern/BEFUNDE.md#e-114), [E-127](../Intern/BEFUNDE.md#e-127)** — beide Schließungen tragen, beide nennen von sich aus ihre
  Einschränkungen.
* **Die beiden neuen Lehren** — am Quelltext belegt, vollständig eingehängt;
  `Arbeitsweise/MEMORY.md` und die geladene Gedächtnisdatei sind
  **byte-identisch**.
* **Die Haken** — `tools/hooks-einrichten.sh` und die installierten
  `pre-commit`/`pre-push` nennen dieselben Schranken; die Lücke aus L-49 ist zu.

## Nicht geprüft

Ob `Strg-W` Eudora wirklich beendet ([E-137](../Intern/BEFUNDE.md#e-137)) und ob die beiden Speicherwege aus
[E-140](../Intern/BEFUNDE.md#e-140) Zeichen verlieren — beides braucht das laufende Programm, und beide
Befunde führen die Messung korrekt als ausstehend.
