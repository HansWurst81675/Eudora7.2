# <a id="pruefer-90"></a>PRUEFER-90

Lauf nach [PRUEFER-89](PRUEFER-89.md). Zweig wt/pruefer-20261103, abgezweigt von `origin/e128_endung_aus_inhalt` (Stand c2402a4c). Geprüft wird `origin/main..HEAD -- Eudora71 tools Releases/1.0`: die Commits 23b31352 und c2402a4c ([E-128](../Intern/BEFUNDE.md#e-128), [E-213](../Intern/BEFUNDE.md#e-213)). Danach, nur lesend, die Einarbeitung von PRUEFER-89 auf `origin/e170_label_ohne_uidplus` (01f4c9cd). Auf Zuruf der Hauptsitzung vorgezogen: der Commit 3c6d988d auf `origin/e133_mailverzeichnis_fehlt` (Abschnitt *Zusatz: e133*). Eudora habe ich weder gebaut noch gestartet. Keinen Prüfstand habe ich angefasst.

## Ergebnis vorweg

*(wird nach den Abschnitten zu [E-128](../Intern/BEFUNDE.md#e-128) und [E-170](../Intern/BEFUNDE.md#e-170) geschrieben)*

## Zusatz: e133

Geprüft: 3c6d988d *„PRUEFER-87 Nachtrag 2 P1: Kurzform-Grenze gegen MAX_PATH, Laengenpruefung in CheckMailDirectory“* (`eudora.cpp`, `fileutil.cpp`, `Tests/TestE133.cpp`, `Tests/Extract.ps1`). Zeilen sind Stand `origin/e133_mailverzeichnis_fehlt`. Nur gelesen, nicht gebaut.

**Ergebnis: Nichts hält den Merge von e133 auf.** Die Längenprüfung sitzt an der richtigen Stelle, und ihre Grenze stimmt auf das Byte.

### Pufferlängen in CheckMailDirectory

Am Quelltext belegt (fileutil.cpp):

- `szShortEDir` und `Edir` fassen je `_MAX_PATH + 1` = 261 Byte (:346-347).
- `E209MailDirPasst` lässt höchstens 259 Zeichen durch, die zwei Zeichen Laufwerk eingerechnet (:333ff). Geprüft wird vor dem `strcat` (:363 vor :370), und zwar `strlen(dir)` vor `TrimWhitespaceMT`. Das ist die strengere Seite.
- Rechnung für den längsten erlaubten Fall: `szShortEDir` bekommt 259 Zeichen und die Null, also 260 Byte. `GetFullPathName` kopiert nur bei `dwAbsLen < sizeof` (:378ff). `Edir` wird mit `strcpy` gesät, höchstens 259 Zeichen. `GetLongPathName(…, _MAX_PATH)` (:387) schreibt nur bei einem Ergebnis bis 259 Zeichen, sonst bleibt die Saat. Der Rückstrich (:424) macht daraus höchstens 260 Zeichen und die Null, also genau 261 Byte. **Kein Überlauf.**
- Die Grenzwerte im Test (259 ja, 259 mit Laufwerk nein, 260 nein, 275 nein, NULL nein) treffen genau diese Rechnung. Die Funktion wird echt aus `fileutil.cpp` geschnitten (Extract.ps1 Region R5).

### Die beiden Kurzform-Ausweichen (eudora.cpp)

- `E133InBefehlszeile` (:4145ff) und der E-132-Weg *„Nein“* (:4586) weichen jetzt schon ab 260 Zeichen Pfad auf die Kurzform aus, nicht erst ab der Größe von `buf`. Belegt.
- **Gegenvermutung: `GetShortPathName(…, szKurz, MAX_PATH + 1) > 0` (:4157, :4586).** Ist der Puffer zu klein, liefert die Funktion die nötige Länge (> 0) und schreibt nichts. Dann würde ein nicht beschriebenes `szKurz` übernommen. Erreichbar ist das hier nicht. `szPfad` kommt aus `SHGetPathFromIDList` in einen Puffer von `MAX_PATH + 1` (:4130-4132), ist also höchstens 259 Zeichen lang. `szEigenes` stammt aus `ExecutableDir`, und das kommt aus `GetModuleFileName` in einen Puffer von 261 Byte. Die Kurzform ist nie länger als die Langform, sie passt also in `szKurz`. Am Quelltext belegt. Sauberer wäre trotzdem `n > 0 && n <= MAX_PATH` (siehe K-Liste, **sehr gering**). Das hält nichts auf.
- Mit einem Pfad über 259 Zeichen und ohne Kurzform bleibt die Langform stehen. `CheckMailDirectory` weist sie dann ab wie ein fehlendes Verzeichnis. Belegt.

### Trifft der Test den Weg?

- `E209MailDirPasst` wird im Verhalten geprüft, mit den echten Grenzen. Belegt.
- `CheckMailDirectory` selbst läuft nicht im Test, denn es ruft `ErrorDialog`. Dass die Prüfung **vor** dem `strcat` steht, verlangt der Test über die Stellung im Text (`QT_Stelle`, TestE133.cpp). Das reicht für diesen Befund.
- `E133InBefehlszeile` läuft mit 270 Zeichen und einem Wächterbyte. Den Ordner gibt es nicht, `GetShortPathName` scheitert also, und es bleibt die Langform. Geprüft wird, dass `buf` abgeschlossen ist und nicht überschrieben wird. Den Zweig *„Kurzform gefunden“* deckt der Test nicht ab. Das ist eine Vermutung aus dem Testtext, ohne Bedeutung für die Sicherheit.
- Die Gegenproben aus der Commit-Nachricht (vier Stück, je 390/391 rot) habe ich nicht nachgefahren. Auftragsgemäß habe ich nur gelesen.

### Nebenbefund außerhalb des Diffs (alt, QUALCOMM)

`GetEnvironmentVariable(EudoraEnvironVar, buf, sizeof(buf))` (fileutil.cpp:515): Ist die Umgebungsvariable länger als 260 Zeichen, liefert die Funktion die nötige Länge und lässt `buf` unverändert. In `buf` steht dann noch das Programmverzeichnis aus `GetModuleFileName`. `CheckMailDirectory` nimmt dann still das Programmverzeichnis statt einer Fehlermeldung. Belegt am Quelltext und an der Schnittstelle von `GetEnvironmentVariable`, nicht gemessen. Schwere **sehr gering**, nicht von e133 eingeführt, hält nichts auf.

## 1. E-128: der Weg am Quelltext

*(folgt)*

## 2. Testsuite und Gegenproben

*(folgt)*

## 3. E-213

*(folgt)*

## 4. E-170: Einarbeitung von PRUEFER-89

*(folgt)*

## 5. Funde

*(folgt)*

## Übersicht

*(folgt)*
