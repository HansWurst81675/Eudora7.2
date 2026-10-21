# PRÜFER-42 — 7.2.0.117: die sechs Umsetzungen aus PRÜFER-41, nachgemessen

Gegenstand: **meine eigenen Forderungen aus [PRÜFER-41](PRUEFER-41.md), wie sie
umgesetzt wurden** — `61d42593` (1.0.116) und `514c1be5` (1.0.117) gegen
`a8636eae` (1.0.115). Dazu der **Merker**, den PRÜFER-41 nicht gefordert hat.
Zweig `wt/pruefer-20261020b`. Es geht um die Veröffentlichung als **v1.0.117**
für Fremde, unter anderem für den Melder aus Issue #102.

**Wie geprüft.** Am Quelltext gelesen, nichts mit Oberfläche gestartet.
Gelesen: `StartEudoraWithDefaultLocation`, `E132IstFremdesVerzeichnis`,
`E132AufrufZerlegen`, `E132LangerPfad`, `GetDirs`, `CheckMailDirectory`,
`SetupINIFilename` (`rs.cpp:1359`), `StripQuotesMT`, `FileExistsMT`,
`ConvertToLongPathName`, `CAboutDlg::OnInitDialog`, `Eudora71/Tests/TestE132.cpp`,
`tools/paket-bauen.ps1` und `tools/DEudora.ini`. Zwei eigene Messungen am
lebenden Windows (siehe [K6](#k6) und [K7](#k7)).

---

## Urteil

> ### JA — v1.0.117 geht so raus.

Alle sechs Punkte sind umgesetzt, und **fünf davon sind richtig umgesetzt**.
Die Vergleichsregel in `E132IstFremdesVerzeichnis` ist Zeichen für Zeichen die,
die ich in PRÜFER-41 vorgeschlagen habe; die Klammerung in [K2](#k2) nimmt
`GetDirs` nachweislich als **einen** Pfad; die Probenliste in [K5](#k5) trifft
genau den Fall, der die Lücke war. Der Merker ist der riskanteste Teil, und er
ist in die **sichere** Richtung gebaut: ohne `DEudora.ini` wird nichts gemerkt,
bei schreibgeschützter Datei wird nichts gemerkt, und in beiden Fällen wird
jedes Mal gefragt.

**Kein Fund dieses Berichts verliert Daten, und keiner macht Eudora
startunfähig.** Deshalb hält keiner das Paket auf. Das ist ein anderes Urteil
als in PRÜFER-41, und der Unterschied liegt nicht am Maßstab, sondern an der
Sache: damals waren zwei der vier Hochbefunde *„der Schutz greift gar nicht"*
und *„die Vorgabeantwort macht Eudora startunfähig"*. Nichts davon steht heute
hier.

**8 Funde, davon 0 hoch, 3 mittel, 5 gering.** Sieben Stellen ausdrücklich
**ohne** Fund freigegeben — sie stehen mit, weil „geprüft und richtig" eine
Aussage ist, die beim nächsten Mal Arbeit spart.

### Funde

| Fund | Zu Auftragspunkt | Schwere | Stand |
|---|---|---|---|
| **[K1](#k1)** Eine **fehlgeschlagene** `MessageBox` (Rückgabe 0) fällt in den `else`-Zweig und **übernimmt das fremde Verzeichnis** — der schlimmstmögliche Ausgang für den Fall „niemand hat die Frage gesehen" | 6 Merker | mittel | **belegt am Quelltext** (`eudora.cpp:4227`, `:4255`, `:4310`) |
| **[K2](#k2)** Ein gemerktes **„Ja"** sperrt dauerhaft und **unsichtbar** in das fremde Verzeichnis: ab dem zweiten Start kein Dialog, keine Protokollzeile ohne `LogLevel`-Bit, und der Über-Dialog nennt den Merker nicht | 6 Merker | mittel | **belegt am Quelltext** (`:4183-4208`, `:4310`) |
| **[K3](#k3)** Ist der geklammerte Pfad länger als `buf`, wird das **schließende** Anführungszeichen abgeschnitten — und eine halb geklammerte Zeile trennt `GetDirs` wieder am ersten Leerzeichen. Der Fehler aus 41-K2 kommt zurück | 2 Klammerung | gering (ab ~243 Zeichen Programmpfad) | **belegt am Quelltext** (`:4297-4300` gegen `fileutil.cpp:445`) |
| **[K4](#k4)** `MailDirHerkunft.Empty()` im Fehlerausgang von `CheckMailDirectory` kann einen **richtigen** Wert löschen: der `DataFolder`-Aufruf am Ende von `GetDirs` läuft **nach** der Zuweisung „Programmverzeichnis" | 5 Herkunft | gering | **belegt am Quelltext** (`fileutil.cpp:377` gegen `:507-516` und `:542-546`) |
| **[K5](#k5)** Neue Unwahrheit durch die K6-Weg-1-Behebung: steht in der Registry ein Aufruf **ohne** zweites Stück, bleibt `pHerkunft` auf `"Registry: …"` stehen, obwohl danach Application Data gewonnen hat | 5 Herkunft | gering | **belegt am Quelltext** (`eudora.cpp:4010-4030`) |
| **[K6](#k6)** Die Form, für die 41-K13 geschrieben wurde — Kandidat **ohne**, Eigenes **mit** Rückstrich — ist in `TestE132.cpp` **nicht** abgedeckt. Der Code ist richtig, die Schranke dagegen fehlt | 3 Grenzprüfung | gering, Prüflücke | **gemessen**: 243 Tests gefahren, Fallliste gegen die Funktion gehalten |
| **[K7](#k7)** Auf den Startwegen `:1017`/`:1029` (Anhang, `mailto:`, Briefpapier, Postfach, Automation) ist **`DefaultINIPath` leer** — der Merker ist dort ohne Wirkung, und der Dialogtext verspricht trotzdem *„Your answer is remembered"* | 6 Merker | gering | **belegt am Quelltext** (`rs.cpp:1364-1368`, nur aus `GetDirs` gerufen) |
| **[K8](#k8)** `szProbe` wird in derselben Funktion zweimal angelegt (`:4133` und `:4268`); die innere verschattet die äußere und meint etwas anderes | — | gering, Lesbarkeit | **belegt am Quelltext** |

---

## 1 — K1 aus PRÜFER-41: `ExecutableDir` notfalls selbst füllen

**Kein Fund. Die Form stimmt.** `eudora.cpp:3953-3964` gegen `GetDirs`
(`fileutil.cpp:435-442`):

| | `GetDirs` | der neue Einbau |
|---|---|---|
| Quelle | `GetModuleFileName(AfxGetInstanceHandle(), …)` | dieselbe |
| Suche | `strrchr(buf, SLASH)` | `_tcsrchr(szEigeneDatei, '\\')` |
| Abschnitt | `temp[1] = 0` | `pLetzterStrich[1] = 0` |
| Zuweisung | nur wenn `temp` | nur wenn `pLetzterStrich` |

**Der abschließende Rückstrich bleibt stehen** — beide setzen das Nullbyte auf
`[1]` hinter dem Strich, nicht auf ihn. Damit ist die Vorbedingung aus 41-K4
erfüllt, und sie ist seit der neuen Vergleichsregel ohnehin nicht mehr nötig.

Die drei Fragen aus dem Auftrag, einzeln:

* **UNC-Pfade.** `\\srv\share\unter\Eudora.exe` → `_tcsrchr` findet den letzten
  Rückstrich → `\\srv\share\unter\`. Auch der Grenzfall `\\srv\share\Eudora.exe`
  → `\\srv\share\`. Richtig in beiden Fällen.
* **Pfad ohne Rückstrich.** Kann es für ein geladenes Modul nicht geben;
  `GetModuleFileName` liefert immer einen vollständigen Pfad. Tritt es doch
  ein, bleibt `ExecutableDir` **leer** — und leer heißt bei
  `E132IstFremdesVerzeichnis` „nicht fremd", also kein Fehlalarm. Der sichere
  Ausgang.
* **Fehlschlag von `GetModuleFileName`.** Rückgabe 0 → der `if`-Rumpf läuft
  nicht, `szEigeneDatei` wird nie gelesen. **Kein Zugriff auf uninitialisierten
  Speicher.** (Das ist nicht selbstverständlich: `GetLongPathName` an anderer
  Stelle hat genau diese Falle, und `CheckMailDirectory` muss den Puffer
  deshalb vorher belegen.)

**Wird irgendwo `ExecutableDir` gesetzt, wo es vorher bewusst leer blieb?**
Nein. Alle 21 Lesestellen gesucht (`AboutDlg`, `ContentConcentrator`,
`EmoticonManager`, `ExtLaunchMgr`, `eudora.cpp`, `fileutil.cpp`): **keine
einzige** prüft auf leer oder leitet aus „leer" eine Bedeutung ab, und alle
laufen ohnehin erst, nachdem `GetDirs` denselben Wert gesetzt hat. Zwischen dem
neuen Einbau und `GetDirs` liest nur der E-132-Code. Der Wert ist in beiden
Fällen derselbe — der Einbau nimmt `GetDirs` nichts weg, er zieht es nur vor.

Eine Einschränkung fürs Protokoll, **Altbestand und in `GetDirs` identisch**:
ist der Modulpfad länger als 260 Zeichen, kürzt `GetModuleFileName` ihn, und
`_tcsrchr` findet dann den Rückstrich eines *Elternverzeichnisses*.
`ExecutableDir` wäre ein plausibler, aber falscher Ordner. Das ist nicht neu
und trifft `GetDirs` seit 1997 genauso; es gehört nur genannt, weil der neue
Einbau es auf vier weitere Startwege ausdehnt.

---

## 2 — K2 aus PRÜFER-41: die Klammerung

**Nimmt `GetDirs` das wirklich als einen Pfad? Ja.** Zeile für Zeile mit
`buf = "C:\Program Files\Eudora72\Mailverzeichnis"`:

| Schritt in `GetDirs` | Ergebnis |
|---|---|
| `strstr(CmdLine, "\" ")` — Anführungszeichen **gefolgt von** Leerzeichen | **NULL.** Das vordere `"` steht vor `C`, das hintere vor dem Nullbyte |
| `else if (letztes Zeichen != '"')` | **falsch** — das letzte Zeichen *ist* `"`. Keine Trennung, `Ini` bleibt NULL |
| `StripQuotesMT(CmdLine)` (`services.cpp:1494-1507`) | entfernt führendes **und** abschließendes Zeichen → `C:\Program Files\Eudora72\Mailverzeichnis` |
| `GetFileAttributes` → `bCmdLineIsDir` | wahr → `CheckMailDirectory(CmdLine, "command line")` |

Der Ausweichfall `szEigenes = ExecutableDir` erzeugt `"C:\…\Eudora72\"` — ein
Rückstrich **vor** dem schließenden Anführungszeichen. Auch das geht durch:
kein `" `-Paar, letztes Zeichen ist `"`, und `CheckMailDirectory` schneidet den
Rückstrich selbst wieder ab (`fileutil.cpp:361-362`).

**Was, wenn `szEigenes` selbst ein Anführungszeichen enthält?** Kann nicht
sein. `"` ist unter Windows in Datei- und Verzeichnisnamen **verboten**
(`CreateFile` weist es ab), und `szEigenes` kommt aus `GetModuleFileName`.
Damit ist auch kein `" ` im Inneren möglich — die einzige Folge, die etwas
kaputtmachen könnte.

**Was bei einem Pfad, der länger ist als `buf`?** → **[K3](#k3)**, der einzige
Fund dieses Punktes.

<a id="k3"></a>

### K3 — das abgeschnittene schließende Anführungszeichen

```cpp
// eudora.cpp:4297-4300
CString szGeklammert;
szGeklammert.Format("\"%s\"", (LPCTSTR) szEigenes);
_tcsncpy(buf, szGeklammert, sizeof(buf) / sizeof(TCHAR) - 1);
buf[sizeof(buf) / sizeof(TCHAR) - 1] = 0;
```

`buf` ist `TCHAR[MAX_PATH + 1]`, also 261 Zeichen. `szEigenes` ist
`ExecutableDir` + `"Mailverzeichnis"` (15 Zeichen) plus zwei Klammern. Ab einem
Programmverzeichnis von rund **243 Zeichen** passt das nicht mehr, und
`_tcsncpy` schneidet **hinten** ab — also genau das schließende
Anführungszeichen.

Danach ist `buf` *halb* geklammert, und das ist **schlechter als gar keine
Klammer**: `GetDirs` sieht ein letztes Zeichen, das kein `"` ist, trennt am
ersten Leerzeichen, und `StripQuotesMT` räumt das führende Zeichen weg. Der
Fehler aus 41-K2 ist damit zurück — Eudora startet nach der Vorgabeantwort
„Nein" nicht.

Die Schwere ist gering, weil ein 243 Zeichen langes Programmverzeichnis an
vielen anderen `_MAX_PATH`-Puffern derselben Funktion ebenfalls scheitert.
**Behoben** (siehe [Was ich behoben habe](#behoben)): passt die geklammerte
Form nicht, wird auf die **Kurzform** ausgewichen — die hat keine Leerzeichen
und braucht keine Klammer. Das ist QUALCOMMs eigener Ausweg aus
`RegisterCommandLine` (`:3686`).

---

## 3 — K3/K13 aus PRÜFER-41: Kurzform und Präfixgrenze

### `GetLongPathName` roh statt `ConvertToLongPathName` — reicht das? **Ja.**

Meine Empfehlung lautete `ConvertToLongPathName`, weil die Funktion den
Fehlschlag richtig behandelt. Der Einbau ruft `GetLongPathName` selbst, und
die beiden sind Zeile für Zeile gleichwertig:

| | `ConvertToLongPathName` (`fileutil.cpp:915-926`) | `E132LangerPfad` (`eudora.cpp:3923-3936`) |
|---|---|---|
| Zielpuffer | eigener `char[_MAX_PATH+1]` | eigener `TCHAR[MAX_PATH+1]` |
| Puffergröße an Win32 | `_MAX_PATH` (260) | `MAX_PATH + 1` (261) — **einen besser** |
| Fehlschlag | `dwResult == 0 \|\| > _MAX_PATH` → Original bleibt | `dwLaenge > 0 && <= MAX_PATH` → sonst bleibt der Kurzname |
| leere Eingabe | nicht geprüft | `!*pPfad` → sofort zurück |

Die Falle, vor der ich gewarnt hatte — Auflösung in einen *uninitialisierten*
Puffer, der bei `rc == 0` mit Stapelmüll stehenbleibt — ist hier **nicht**
vorhanden: `szLang` wird nur bei Erfolg gelesen. Damit ist die Empfehlung in
der Sache erfüllt. **Kein Fund.**

Der Punkt (b) aus PRÜFER-41 — *„scheitert die Auflösung des Kandidaten, auch
die Kurzform von `ExecutableDir` gegenhalten"* — ist **nicht** umgesetzt, und
das ist richtig so. Er ist durch den Einbau gegenstandslos geworden:
`E132LangerPfad` läuft jetzt auch über `szEigenesLang`, also über **beide**
Seiten. Scheitert die Auflösung des Kandidaten, scheitert sie fast immer, weil
es das Verzeichnis nicht gibt — und dann findet die Probenliste aus
[Punkt 4](#punkt4) dort weder `In.mbx` noch `Attach` noch eine `Eudora.ini`,
`bEinrichtungDa` ist falsch, und es wird gar nicht erst gefragt. Der
Fehlalarm kann diesen Weg nicht mehr nehmen.

### Stimmt deine Vergleichsregel mit meiner überein? **Zeichen für Zeichen.**

PRÜFER-41 schlug vor:

```cpp
if (_tcsnicmp(pKandidat, pEigenes, nEigen) != 0) return true;
const TCHAR cNach = pKandidat[nEigen];
return !(cNach == 0 || cNach == '\\' || cNach == '/');
```

Eingebaut ist (`eudora.cpp:3809-3822`) dieselbe Aussage, nur positiv
geschrieben: bei Gleichheit **und** Grenze → `false`, sonst `true`. Beide
Fassungen liefern für alle neun Fälle aus PRÜFER-41 dasselbe. Auch das
Abschneiden der Rückstriche (`while` statt einmal) und der Ausgang
`nEigen == 0 → false` sind übernommen.

**Speicherzugriff nachgerechnet:** `pKandidat[nEigen]` wird nur gelesen,
nachdem `_tcsnicmp` über `nEigen` Zeichen Gleichheit gemeldet hat. Ist der
Kandidat kürzer, steht dort sein Nullbyte gegen ein Nicht-Nullbyte aus
`pEigenes` — der Vergleich endet vorher mit „ungleich". Der Index ist also
immer gültig, höchstens das Nullbyte selbst. **Kein Überlauf.**

<a id="k6"></a>

### K6 — die Form aus 41-K13 steht in keinem Test

`TestE132.cpp` prüft im neuen Abschnitt (9) fünf Fälle. Die Form, **für die
41-K13 geschrieben wurde**, ist nicht darunter: *Registry liefert den Pfad ohne
Rückstrich, `ExecutableDir` trägt einen* —

| Fall | im Test? |
|---|---|
| `("C:\Eudora2\Mail", "C:\Eudora", true)` → fremd | ja |
| `("C:\Eudora2\Mail", "C:\Eudora\", true)` → fremd | ja |
| `("C:\Eudora\Mail", "C:\Eudora", true)` → nicht fremd | ja |
| `("C:\Eudora", "C:\Eudora", true)` → nicht fremd | ja |
| `("C:\Eudora\Mail", "C:\Eudora\", true)` → nicht fremd | ja |
| **`("C:\Eudora", "C:\Eudora\", true)` → nicht fremd** | **nein** ← 41-K13 |
| **`("C:\Eudora\", "C:\Eudora", true)` → nicht fremd** | **nein** |

Der Code beantwortet beide richtig (`cGrenze == 0` bzw. `== '\\'`). Es fehlt
nur die Schranke, die das festhält — und das ist genau der Fund, der in
PRÜFER-41 **hoch** war. Wer die Grenzprüfung später vereinfacht, bekommt von
den 243 Tests kein Nein. **Behoben**, zwei Zeilen.

---

<a id="punkt4"></a>

## 4 — K5 aus PRÜFER-41: die Sicherung ohne `Eudora.ini`

**Kein Fund. Die Liste ist richtig gewählt, und der Puffer hat keine Grenze.**

```cpp
// eudora.cpp:4141-4157
static const TCHAR* const apSpuren[] = { "Eudora.ini", "In.mbx", "Attach", "Embedded" };
```

**Der Puffer `szProbe` ist eine `CString`**, kein `TCHAR[]` — `szProbe + apSpuren[i]`
legt bei jedem Durchlauf eine neue, passend lange Zeichenkette an. Es gibt hier
**nichts nachzurechnen**: kein `_tcsncpy`, kein `strcat`, keine feste Größe.
Die einzige Längengrenze liegt eine Ebene tiefer in `FileExistsMT` →
`::access()`, und die gibt bei zu langem Pfad schlicht „gibt es nicht" zurück —
also „keine Einrichtung", also keine Rückfrage. Der sichere Ausgang.
(`szVerzeichnis` selbst ist vorher schon auf `MAX_PATH` begrenzt.)

**`FileExistsMT` findet auch Verzeichnisse.** Das ist die Bedingung dafür, dass
`Attach` und `Embedded` überhaupt etwas bewirken, und sie ist erfüllt:
`::access(pfad, 0)` liefert unter Windows für ein vorhandenes Verzeichnis 0
(`services.cpp:1021-1033`). Ohne das wären zwei der vier Einträge tote
Buchstaben gewesen.

**Fragt es zu oft?** Geprüft, nein:

* Das **eigene** Verzeichnis scheidet schon vorher aus — `bEinrichtungDa` wird
  gar nicht erst ausgewertet, weil die Präfixprüfung `false` liefert.
* Ein **frisch angelegtes** `Application Data\Qualcomm\Eudora` ist leer: keine
  `Eudora.ini`, kein `In.mbx`, kein `Attach`, kein `Embedded` →
  `bEinrichtungDa` falsch → keine Frage. Der erste Start auf einem fremden
  Rechner bleibt also still. Das ist wichtig, und es war vor der Erweiterung
  nicht offensichtlich.
* Ein **echtes** Eudora in Application Data hat alle vier → es wird gefragt.
  Das ist gewollt, und genau dafür gibt es jetzt den Merker.

**Fragt es zu selten?** Theoretisch ja, praktisch nein. Ein Mailverzeichnis,
in dem **weder** `Eudora.ini` **noch** `In.mbx` **noch** `Attach` **noch**
`Embedded` steht, ist kein Mailverzeichnis, aus dem jemand etwas zu verlieren
hätte. Zwei weitere Kandidaten wären `descmap.pce` (steht in jedem
Eudora-Ordner) und `Out.mbx`; beide fügen nichts hinzu, was `In.mbx` nicht
schon abdeckt, und jeder weitere Eintrag erhöht nur die Zahl der
Fehlalarme. **Die Liste so lassen.**

Der zweite Teil von 41-K5 — *„geprüft wird `szIni`, entschieden wird über
`szVerzeichnis`"* — ist mit `szProbe` aus `szVerzeichnis` vollständig
geschlossen.

---

## 5 — K6 aus PRÜFER-41: lügt „Mail folder from:" noch?

Alle vier Wege sind angefasst, und **drei sind sauber zu**:

| Weg aus 41-K6 | Behebung | Stand |
|---|---|---|
| 1 `UseAppData=1` wurde überschrieben | `if (!_tcscmp(pHerkunft, "unbekannt"))` (`eudora.cpp:4028-4030`) | zu, aber siehe **[K5](#k5)** |
| 2 Application Data, das keines ist | `if (!*buf) pHerkunft = "Programmverzeichnis …"` (`:4325-4326`) | **zu** |
| 3 häufigster Fall sagte „(unbekannt)" | `MailDirHerkunft = "Programmverzeichnis (keine andere Angabe gefunden)"` im `EudoraDir.IsEmpty()`-Zweig (`fileutil.cpp:510-516`) | **zu** |
| 4 gescheiterter Versuch löschte nicht | `MailDirHerkunft.Empty()` vor `ErrorDialog` (`fileutil.cpp:373-379`) | zu, aber siehe **[K4](#k4)** |

Zu Weg 2 eine Bemerkung, weil die Stelle gefährlich aussieht und es nicht ist:
`if (!*buf)` steht **nach** `GetDirs(buf)`, und `GetDirs` schreibt in `buf`
hinein (`*Ini++ = 0`, `StripQuotesMT`). Geprüft: bei leerem `buf` fasst
`GetDirs` es nicht an — der ganze Zerlegeblock steht hinter
`if (CmdLine && *CmdLine)`. Die Abfrage misst also noch dasselbe wie vorher.

<a id="k4"></a>

### K4 — `MailDirHerkunft.Empty()` kann einen richtigen Wert löschen

`GetDirs` ruft `CheckMailDirectory` **noch einmal, ganz am Ende**, für den
`DataFolder`-Eintrag aus der `DEudora.ini` (`fileutil.cpp:542-546`) — und zwar
**nach** der neuen Zuweisung `MailDirHerkunft = "Programmverzeichnis (keine
andere Angabe gefunden)"` aus Weg 3. Steht dort ein `DataFolder`, der nicht
existiert, dann

1. setzt Weg 3 die richtige Angabe „Programmverzeichnis",
2. scheitert `CheckMailDirectory` an `FileExistsMT`,
3. **löscht die neue Zeile sie wieder**,
4. und der Über-Dialog sagt „(unbekannt)" — obwohl `EudoraDir` weiterhin das
   Programmverzeichnis ist und die Antwort feststeht.

Das ist eine Lücke, keine Lüge: der Dialog sagt nichts Falsches, er sagt
nichts. Vor der Behebung von Weg 4 wäre in diesem Fall der richtige Wert
stehengeblieben — die Behebung macht diesen einen Fall also **schlechter**.
Sie ist trotzdem richtig, weil der Fall, den sie schließt (ein Wert aus einem
*anderen* Verzeichnis bleibt stehen), die schlimmere Sorte ist. Nachziehbar,
nicht releasekritisch.

<a id="k5"></a>

### K5 — eine neue Unwahrheit durch die Weg-1-Behebung

```cpp
// eudora.cpp:4010-4017
if (c) { c++; while (*c == ' ') c++; strcpy(buf, c); pHerkunft = "Registry: …"; }
…
if (!*buf) { if (!_tcscmp(pHerkunft, "unbekannt")) pHerkunft = "Application Data …"; … }
```

Der Wächter fragt „stand noch nichts da", nicht „wurde `buf` wirklich gefüllt".
Steht in der Registry eine Zeile, deren Rest nach dem Programmnamen **leer**
ist (`"C:\x\Eudora.exe" ` mit Leerzeichen am Ende), dann ist `c` gesetzt,
`pHerkunft` wird auf `"Registry: …"` gestellt, `buf` bleibt leer — und unten
gewinnt Application Data, **ohne** dass die Angabe nachgezogen wird. Der
Über-Dialog nennt dann die Registry für ein Verzeichnis, das aus Application
Data stammt.

Richtig wäre, den Wächter an `buf` zu hängen statt an den bisherigen Text.
Seltener Fall, kein Datenverlust, nachziehbar.

---

## 6 — Der Merker: `E132Abgelehnt` / `E132Angenommen`

Nicht von PRÜFER-41 gefordert, und der riskanteste Teil der Fassung — weil er
das Einzige wieder abschaltet, was gegen [E-132](../BEFUNDE.md#e-132) schützt. Vier Gefahren, einzeln
nachgegangen.

### Schreibgeschützte `DefaultINIPath` — **ungefährlich**

`WritePrivateProfileString` scheitert still, der Rückgabewert wird nicht
geprüft. Folge: nichts wird gemerkt, es wird **jedes Mal gefragt**. Das ist die
sichere Richtung; ein ungeprüfter Rückgabewert ist hier kein Fund, sondern die
richtige Entscheidung. (Der Dialogtext verspricht trotzdem *„Your answer is
remembered"* — siehe [K7](#k7).)

Dazu eine Lage, die der Einbau **nicht** haben kann und die ich geprüft habe,
weil sie teuer gewesen wäre: `DefaultINIPath` wird in `SetupINIFilename`
geleert, wenn die Datei fehlt (`rs.cpp:1364-1368`). Es wird also nie eine
`DEudora.ini` neu angelegt, und `GetPrivateProfileString` liest nie aus einer
Datei, die es nicht gibt.

### Die `DEudora.ini` des Pakets überlebt den Schreibzugriff — **gemessen**

Unser Paket legt `tools/DEudora.ini` neben die EXE (`paket-bauen.ps1:536`).
Das ist **QUALCOMMs Originaldatei** mit 124 Dateizuordnungen in `[Mappings]`,
107 Kommentarzeilen und dem `LogLevel` in `[Debug]` — genau die Datei, zu der
die Lehre *„Anwenderdatei nicht erschlagen"* gehört. Schreibt
`WritePrivateProfileString` dort hinein, bleibt davon etwas übrig?

**Gemessen am 21.10.2026** (Kopie im Arbeitsverzeichnis, `kernel32` über
P/Invoke, Wert mit Leerzeichen):

```
Write ok=True
Read back n=26  wert='C:\Temp\Sicherung ohne INI'
Zeilen        vorher 253   nachher 254
Mappings      vorher 124   nachher 124
Kommentare    vorher 107   nachher 107
Unterschied   genau eine Zeile: E132Abgelehnt=C:\Temp\Sicherung ohne INI
```

**Kein Fund.** Der Wert mit Leerzeichen kommt unverändert zurück; die
Zuordnungen und alle Kommentare bleiben stehen.

Zwei Folgerungen fürs Protokoll: ein `;` im Pfad wäre ebenfalls unschädlich
(die INI-Schnittstelle erkennt Kommentare nur am Zeilenanfang), und ein
Anführungszeichen im Pfad gibt es unter Windows nicht. Und: wer ein neues Paket
**über** ein altes auspackt, ersetzt die `DEudora.ini` — der Merker ist nach
jedem Update weg und wird neu gefragt. Das ist die sichere Richtung und sollte
so bleiben.

### Pfad länger als `MAX_PATH` — **ungefährlich**

`GetPrivateProfileString`/`WritePrivateProfileString` in der ANSI-Fassung
kommen über `MAX_PATH` nicht hinaus; sie scheitern, und es wird nicht gemerkt.
`szGemerkt` ist `TCHAR[MAX_PATH + 1]`, `szVerzeichnis` ebenso und beide sind
vorher auf dieselbe Länge geklemmt — ein Wert, der geschrieben werden konnte,
passt beim Lesen auch wieder herein. `sizeof(szGemerkt)` als Zeichenzahl ist in
diesem MBCS-Projekt richtig (bei `_UNICODE` wäre es zu groß; das Projekt baut
nicht mit `_UNICODE`, und die ganze Datei rechnet so).

<a id="k1"></a>

### K1 — eine fehlgeschlagene `MessageBox` übernimmt das fremde Verzeichnis

```cpp
int nWahl = nGemerkt;                               // 0, wenn nichts gemerkt
if (!nWahl)
    nWahl = ::MessageBox(NULL, szText, "Eudora 7.2", MB_YESNOCANCEL | …);
…
if (nWahl == IDCANCEL) { … return FALSE; }
if (nWahl == IDNO)     { … eigenes Verzeichnis … }
else                   { E132SpurMerken("fremdes bewusst uebernommen"); }
```

`::MessageBox` gibt bei einem Fehlschlag **0** zurück. 0 ist weder `IDCANCEL`
noch `IDNO` — der `else`-Zweig greift, und Eudora **übernimmt das fremde
Verzeichnis**, mit der Protokollzeile „fremdes bewusst uebernommen". Niemand
hat etwas bewusst getan; die Frage war nie auf dem Bildschirm.

Das ist der schlimmstmögliche Ausgang für diesen Fall und das Gegenteil der
ausdrücklichen Entwurfsregel zwei Bildschirmseiten darüber: *„die Vorgabe ist
Eigenes anlegen: wer die Meldung wegdrückt, beschädigt nichts."* Eine
Meldung, die gar nicht erscheint, ist der Grenzfall von „weggedrückt".

Wie oft? In einer gewöhnlichen Sitzung nie. Erreichbar ist es über den
Startweg `:1029` (`gbAutomationRunning`), wenn Eudora aus einem Dienst oder
einer nicht-interaktiven Station heraus über COM gestartet wird. Selten — aber
die Kosten der Behebung sind ein Vergleich. **Behoben:** `if (nWahl != IDYES)`
statt `if (nWahl == IDNO)`. Damit landet jeder Wert außer einem ausdrücklichen
„Ja" im eigenen Verzeichnis.

<a id="k2"></a>

### K2 — kann ein gemerktes „Ja" jemanden dauerhaft einsperren? **Ja, und zwar unsichtbar.**

Die Frage aus dem Auftrag, Schritt für Schritt durchgegangen:

1. Der Anwender klickt einmal „Ja" — bewusst, denn die Vorgabe ist „Nein".
2. `E132Angenommen=<fremder Pfad>` steht in der `DEudora.ini`.
3. Eudora übernimmt das fremde Verzeichnis und schreibt in dessen `Eudora.ini`
   — **genau der Schaden aus Issue #102 und [E-131](../BEFUNDE.md#e-131).**
4. `RegisterCommandLine` schreibt den fremden Pfad zurück in die Registry.
5. **Ab dem zweiten Start erscheint kein Dialog mehr.** `nWahl` kommt aus dem
   Merker, die `MessageBox` wird übersprungen.
6. Die einzige Spur ist die Protokollzeile „gemerkte Antwort Ja" — und die
   schreibt `PutDebugLog` nur mit `DEBUG_MASK_MISC` (32768) im `LogLevel`.
7. Der Über-Dialog sagt `Mail folder from: Registry: Qualcomm\Eudora\CommandLine\Current`.
   **Vom Merker steht dort kein Wort.**

Der Zustand ist also dauerhaft, er sieht von außen aus wie der Fehler, gegen
den [E-132](../BEFUNDE.md#e-132) gebaut wurde, und er ist von innen nicht zu sehen.

**Genügt der Dialogtext?** Er nennt die Lösung wörtlich — *„To be asked again,
remove the E132Abgelehnt or E132Angenommen line from DEudora.ini next to this
program"* — und das ist gut geschrieben. Aber **er wird genau einmal gezeigt:
in dem Augenblick, in dem der Anwender „Ja" sagt.** Danach nie wieder. Wer sich
drei Wochen später fragt, warum sein neues Eudora in den alten Ordner schreibt,
bekommt den Satz nicht mehr zu sehen. Ein Hinweis, der nur sichtbar ist, bevor
man ihn braucht, ist kein Hinweis. Das ist dieselbe Klasse wie
*„Anzeige ist kein Zustand"*, nur andersherum: der Zustand hat gar keine
Anzeige.

Für Issue #102 ist das der eine heikle Punkt der ganzen Fassung — der Melder
ist der Mensch, der den fremden Ordner schon hat und einmal hineinsehen will.

**Behoben, und zwar dort, wo der Dialog schon steht:** die gemerkte Antwort
steht jetzt in der Zeile `Mail folder from:` des Über-Dialogs, mit dem Namen
der Zeile, die man löschen muss. Der Über-Dialog ist genau für diese Frage
gebaut worden (`AboutDlg.cpp:395-402`), er kostet nichts und er ist jederzeit
erreichbar. Für den gemerkten Weg „Nein" gilt dasselbe, aus demselben Grund:
auch dort wird ohne Dialog entschieden.

<a id="k7"></a>

### K7 — auf vier Startwegen gibt es den Merker gar nicht

`DefaultINIPath` wird ausschließlich in `SetupINIFilename` gesetzt
(`rs.cpp:1364`), und `SetupINIFilename` wird ausschließlich aus `GetDirs`
gerufen. Auf den Wegen `:1017` (Anhang, Briefpapier, `mailto:`, Postfachdatei)
und `:1029` (Automation) läuft `GetDirs` **nach**
`StartEudoraWithDefaultLocation`, nicht davor — `DefaultINIPath` ist dort also
**leer**:

* `if (bFremd && !DefaultINIPath.IsEmpty())` → nichts wird gelesen,
* `if (… && !DefaultINIPath.IsEmpty())` → nichts wird geschrieben,
* und der Dialog behauptet trotzdem *„Your answer is remembered for this
  folder."*

Praktisch wirkt sich das kaum aus: diese Wege nimmt man erst, wenn **keine**
Instanz läuft (`ProcessAttachmentWEI` fängt den Normalfall ab), also höchstens
einmal je Sitzung. Es ist auch die sichere Richtung — gefragt wird eher zu oft
als zu selten. Aber die Zusage im Dialogtext stimmt dort nicht, und das gehört
benannt, bevor es jemand als Fehler meldet. Nachziehbar; wer es beheben will,
setzt `DefaultINIPath` am Anfang von `StartEudoraWithDefaultLocation` genauso
nach, wie der Einbau es jetzt mit `ExecutableDir` tut (der Wert hängt nur von
`ExecutableDir` ab, steht also unmittelbar bereit). Ich habe es **nicht**
gemacht: es verändert zusätzlich das Verhalten von `UseAppData` auf diesen
Wegen, und das ist eine Änderung, die eine eigene Messung braucht — nicht eine,
die man in einen Prüfbericht schiebt.

<a id="k8"></a>

### K8 — `szProbe` zweimal, mit zwei Bedeutungen

`eudora.cpp:4133` legt `szProbe` als **Verzeichnis mit Rückstrich** an (Basis
für die Probenliste). `:4268`, im `IDNO`-Zweig, legt eine zweite `szProbe` an,
die eine **Datei** meint (`…\Mailverzeichnis\Eudora.ini`), und verschattet die
erste. Kein Fehler — die innere wird nur innerhalb ihres Blocks benutzt und die
äußere danach nicht mehr. Aber zwei Dinge mit demselben Namen und
unterschiedlicher Bedeutung in einer Funktion sind die Vorbedingung für den
nächsten Fehler. Nachziehbar; ich habe es nicht angefasst, weil eine
Umbenennung mehr Zeilen bewegt als sie wert ist, solange niemand sonst in der
Funktion arbeitet.

---

<a id="behoben"></a>

## Was ich behoben habe

Drei Funde, alle klein, alle auf meinem Zweig:

| | Datei | Änderung |
|---|---|---|
| [K1](#k1) | `eudora.cpp` | `if (nWahl != IDYES)` statt `if (nWahl == IDNO)` — eine fehlgeschlagene `MessageBox` landet nicht mehr im fremden Verzeichnis |
| [K2](#k2) | `eudora.cpp` | die gemerkte Antwort steht jetzt in `Mail folder from:` des Über-Dialogs, mit dem Namen der Zeile, die man löschen muss |
| [K3](#k3) | `eudora.cpp` | passt die geklammerte Form nicht in `buf`, wird auf die Kurzform ausgewichen statt das schließende Anführungszeichen abzuschneiden |
| [K6](#k6) | `TestE132.cpp` | die zwei fehlenden Grenzfälle aus 41-K13 |

**Nicht angefasst:** [K4](#k4), [K5](#k5), [K7](#k7), [K8](#k8). Keiner
verliert Daten, keiner hält das Paket auf, und [K7](#k7) braucht eine eigene
Messung.

**Wichtig für die Veröffentlichung:** diese vier Änderungen sind **nicht** in
dem Paket, das gemessen wurde. Wer sie nimmt, bekommt eine neue Nummer und
muss den Prüfstandlauf wiederholen. **Mein Urteil hängt nicht daran** — die
Zeile oben lautet „v1.0.117 geht so raus", und das gilt mit oder ohne diese
vier.

```
Release gebaut   siehe unten
Testsammlung     siehe unten
```

---

## Was diese Prüfung nicht abdeckt

Damit niemand sie für mehr hält, als sie ist:

1. **Nichts gestartet.** Gregors Prüfstandlauf (1.0.116 rot, 1.0.117 grün,
   `C:\Temp\Eudora Pruefstand 116` gegen `C:\Temp\Sicherung ohne INI`) ist die
   einzige Messung am laufenden Programm, und sie fährt **einen** Startweg,
   den mit leerer Befehlszeile. Die vier anderen, die die K1-Behebung aus
   PRÜFER-41 erst scharf macht, sind **nur am Quelltext** geprüft — auch von
   mir.
2. **Der Merker ist am laufenden Programm nie gefahren worden.** Dass die
   `DEudora.ini` den Schreibzugriff übersteht, habe ich mit `kernel32` direkt
   gemessen, nicht mit Eudora. Der Weg *„Ja sagen, beenden, neu starten,
   kein Dialog"* steht in keiner Messung.
3. **41-K9 steht noch offen**: der Weg „Abbrechen" schreibt weiterhin keine
   einzige Zeile ins Protokoll, weil `E132SpurAusgeben` erst nach
   `InitDebug` läuft und `IDCANCEL` vorher aussteigt. Kein Datenverlust,
   aber die Messung, die beim nächsten Fehlerbericht helfen soll, fehlt auf
   diesem Weg weiterhin.
4. **41-K11 und 41-K12 stehen noch offen** (abgeschnittene Dialogzeilen,
   uninitialisiertes `cmdLine`). Beide gering, beide unverändert.
