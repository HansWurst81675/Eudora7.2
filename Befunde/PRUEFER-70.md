# <a id="pruefer-70"></a>PRUEFER-70 — Nachprüfung der Einarbeitung von PRUEFER-69 K1 und K2, 01.11.2026

**Auftrag.** Kurzer Abschlusslauf. Geprüft habe ich nur, was seit `8cd65d55`
unter `Eudora71` dazukam (`git log -p 8cd65d55..HEAD -- Eudora71`, Stand
`6f762167`). Das ist ein Commit, `10102f8d`, mit zwei Dateien:
`Eudora71/Tests/TestE136.cpp` (zu [PRUEFER-69](PRUEFER-69.md) [K1](PRUEFER-69.md#k1)) und
`Eudora71/Tests/TinyTest.cpp` (zu [PRUEFER-69](PRUEFER-69.md) [K2](PRUEFER-69.md#k2)).

Eudora wurde weder gebaut noch gestartet. Gebaut und gefahren habe ich nur
die Testsuite im Arbeitsbaum `.wt/pruefer` (`perl tools/pruefe-tests-gruen.pl`).
Grundlauf: **350 Tests, 350 bestanden, Rückgabe 0** (gemessen). Für die drei
Gegenproben habe ich Quelldateien vorübergehend per Perl geändert (`binmode`,
je 1 Treffer). Danach habe ich sie mit `git checkout -- <datei>`
wiederhergestellt, und `git diff --quiet` war jedes Mal leer. Der Lauf nach
der letzten Wiederherstellung war wieder 350/350 mit Rückgabe 0. Die
Testsammlung wurde also neu gebaut (gemessen).

Jede Aussage trägt ihre Herkunft: **gemessen**, **am Quelltext belegt**
(Datei:Zeile) oder **Vermutung**.

**Ergebnis vorweg.**

* **Die Einarbeitung von [PRUEFER-69](PRUEFER-69.md#pruefer-69) K1 hält.** Der Test zählt in
  `GetMessageBody` die Zuweisung `szMsg = cbstr;` und verlangt genau eine.
  Findet der Test die Funktion nicht mehr, wird er **rot** und meldet das
  auch. Er fällt also nicht still auf „nichts geprüft“ (gemessen, Gegenprobe
  1). Eine Lücke bleibt: Wer die Zuweisung ohne Leerzeichen schreibt
  (`szMsg=cbstr;`), zerstört die Emoji wieder, und alle Tests bleiben grün
  (gemessen, [K1](#k1)).
* **Die Einarbeitung von [PRUEFER-69](PRUEFER-69.md#pruefer-69) K2 hält.** Eine Abweichung außerhalb
  eines Tests zählt jetzt als Fehler im Testgerüst. Die Ergebniszeile bleibt
  „350 bestanden, 0 fehlgeschlagen“, die Rückgabe ist 1. `pruefe-tests-gruen.pl`
  weist den Lauf deshalb **ab** und zeigt die Zeile an (gemessen, Gegenprobe
  3). Einen Fall, der grün meldet, obwohl er rot sein müsste, habe ich nicht
  gefunden. Nur zwei Ausgaben beschreiben die Rückgabe jetzt falsch
  ([K2](#k2)).
* **Keiner der beiden Funde hält das Paket auf.** Beide betreffen nur Tests
  und Ausgaben. Am Programm Eudora ändert sich nichts.

---

## <a id="haelt"></a>Was hält

**Gegenprobe 1: Funktion nicht auffindbar ([PRUEFER-69](PRUEFER-69.md#pruefer-69) K1).** Ich habe in
`Eudora71/Eudora/TridentReadMessageView.cpp` die Endmarke des Abschnitts
umbenannt (`GetMessageAsHTML(` → `GetMessageAsHTMLx(`, 1 Treffer). Damit
liefert `QT_Abschnitt` NULL: Die Endmarke fehlt
(`Eudora71/Tests/Quelltext.cpp:299-301`, am Quelltext belegt). Ergebnis:
**349/1, Rückgabe 1**, im Test die Zeile
`GetMessageBody nicht gefunden (E-136)   (Zeile 72)` (gemessen). Ein kleiner
Umbau, der den Abschnitt verliert, macht den Test also rot. Er bleibt nicht
grün.

Dass die eine erlaubte Zuweisung im Zweig für reinen Text steht, sichern zwei
Prüfungen gemeinsam (am Quelltext belegt). Die Prüfung auf die ganze Zeile
`if( bAsHTML ) szMsg = E136HtmlAusBstr( (BSTR) cbstr ); else szMsg = cbstr;`
steht in `TestE136.cpp:65`, die Zählung „genau 1“ in `TestE136.cpp:75-76`.
Die Zeile im Kommentar `TridentReadMessageView.cpp:2918` zählt nicht mit,
weil `QT_LiesNurCode` Kommentare entfernt und ihr außerdem das Semikolon fehlt
(am Quelltext belegt, `Quelltext.cpp:245`). Gemessen: Der Grundlauf meldet
`'szMsg = cbstr;' 1-mal (soll 1)`.

**Gegenprobe 3: Abweichung außerhalb eines Tests ([PRUEFER-69](PRUEFER-69.md#pruefer-69) K2).** Den
anderen Weg, das doppelte `TT_EndTest`, hat `10102f8d` schon selbst
gegengeprüft. Ich habe deshalb in `TestE136.cpp` direkt hinter dem
`TT_EndTest()` von `Test_E136_Stelle` ein `TT_Fail(...)` eingesetzt. Ergebnis
(gemessen):

```
[FEHL] (Geruest, ausserhalb eines Tests) Gegenprobe PRUEFER-70 ausserhalb
 Ergebnis: 350 Tests, 350 bestanden, 0 fehlgeschlagen
 Geruestfehler (Testcode, kein Test): 1 - Rueckgabe deshalb nicht 0
```

`EudoraTests.exe` gibt 1 zurück, `pruefe-tests-gruen.pl` endet mit 1 und
druckt `MANGEL - diese Tests sind rot:` samt der `[FEHL] (Geruest …)`-Zeile
(gemessen). Das Werkzeug urteilt `rot`, sobald `$rc != 0` ist
(`tools/pruefe-tests-gruen.pl:97`, am Quelltext belegt). Sein Selbsttestfall
„gruen, aber Rueckgabe != 0“ deckt genau diese Form ab
(`tools/pruefe-tests-gruen.pl:127`). „Bestanden“ zählt weiter nur die
benannten grünen Tests (350).

**Kein grüner Fall, der rot sein müsste.** Beide Wege in die
Gerüstfehler-Zählung (`TinyTest.cpp:120`, `TinyTest.cpp:147`) erhöhen
`s_iGeruestfehler`. Die Rückgabe ist `s_iFailedTests + s_iGeruestfehler`
(`TinyTest.cpp:229`), und `TestMain.cpp:216-217` reicht sie unverändert
durch. `RunTests.cmd` gibt `%ERRORLEVEL%` weiter (`RunTests.cmd:19-23`). Alles
am Quelltext belegt. Eine Abweichung, die vorher die Rückgabe erhöhte, erhöht
sie also auch jetzt.

---

## <a id="k1"></a>K1 — Die Zählung „genau eine `szMsg = cbstr;`“ erkennt nur diese eine Schreibweise

**Was passiert (gemessen, Gegenprobe 2).** In
`TridentReadMessageView.cpp:2926` habe ich `szMsg = cbstr;` durch
`szMsg = cbstr; szMsg=cbstr;` ersetzt (1 Treffer). Weil der `else`-Zweig keine
Klammern hat, läuft die zweite Zuweisung immer, auch für HTML. Damit ist
genau der Fehler wieder da, den [PRUEFER-69](PRUEFER-69.md) [K1](PRUEFER-69.md#k1) abfangen
sollte: *Speichern unter* als `.htm` macht Emoji wieder zu `??`. Ergebnis:
**350/350, Rückgabe 0**, Notiz `'szMsg = cbstr;' 1-mal (soll 1)`.

**Warum.** `QT_LiesNurCode` zieht Leerraum auf **ein** Leerzeichen zusammen,
entfernt ihn aber nicht (`Quelltext.h:30-32`, `Quelltext.cpp:247`, am
Quelltext belegt). `szMsg=cbstr;`, `szMsg = cbstr ;` oder
`szMsg = (LPCTSTR) cbstr;` enthalten den Suchtext nicht. Dasselbe Muster hat
die ältere Prüfung für den Strg-S-Weg,
`!QT_Enthaelt(pR, "szBody = cbstr;")` in `TestE136.cpp:61` (am Quelltext
belegt; dass sie bei `szBody=cbstr;` grün bleibt, ist eine **Vermutung**
nach demselben Mechanismus, nicht gemessen).

**Einordnung.** Jemand müsste die Zeile von Hand und in anderer
Schreibweise wieder einsetzen. Gegen das wahrscheinlichste Zurückfallen
schützt der Test: eine kopierte Originalzeile oder ein Zusammenführen mit
dem alten Stand (Gegenprobe aus `10102f8d`: 349/1).

**Vorschlag.** Im Abschnitt zusätzlich ohne Leerraum zählen: eine Kopie von
`pFn`, aus der jedes Leerzeichen entfernt ist, und darin
`QT_Zaehle(…, "szMsg=cbstr;") == 1`. Dasselbe für `szBody` in SaveInfo. Mit
Typumwandlungen wird das nicht fertig, deckt aber alle Varianten im
Leerraum ab.

## <a id="k2"></a>K2 — Zwei Ausgaben nennen die Rückgabe noch „Zahl der roten Tests“

**Was passiert (gemessen, Gegenprobe 3).** `pruefe-tests-gruen.pl` druckt im
Gerüstfall:

```
    fehlgeschlagen      0
    Rueckgabewert       1   (TestMain.cpp:127 liefert die Zahl der roten)
```

Die Zeilennummer stimmt nicht mehr: Die Rückgabe steht in
`TestMain.cpp:216-217`. Und seit `10102f8d` ist die Rückgabe nicht mehr „die
Zahl der roten“, sondern rote Tests plus Gerüstfehler
(`tools/pruefe-tests-gruen.pl:87`, `TinyTest.cpp:229`, am Quelltext belegt).
`RunTests.cmd:22` schreibt dieselbe Summe als `Fehlgeschlagene Tests: 1`
hinaus, zwei Zeilen unter `0 fehlgeschlagen` (am Quelltext belegt; die
Ausgabe von `RunTests.cmd` selbst habe ich nicht gefahren, **Vermutung**
nach `RunTests.cmd:19-22`).

**Einordnung.** Das Urteil ist richtig, nur die Beschriftung führt in die
Irre. Wer „0 fehlgeschlagen, Rückgabe 1 (Zahl der roten)“ liest, hält
womöglich die Schranke für kaputt statt den Testcode. Die eigene Zeile
`Geruestfehler (Testcode, kein Test): 1` erscheint nur in der Ausgabe von
`EudoraTests.exe`. `pruefe-tests-gruen.pl` gibt sie nicht weiter, es zeigt
nur `[FEHL]`-Zeilen (`tools/pruefe-tests-gruen.pl:99`).

**Vorschlag.** Klammertext in `pruefe-tests-gruen.pl:87` auf „TestMain.cpp
liefert rote Tests + Gerüstfehler“ ändern und Zeilen mit `Geruestfehler`
mit ausgeben. Die Zeile in `RunTests.cmd:22` heißt dann „Rückgabe (rote Tests
+ Gerüstfehler)“.

---

## Neue Kennungen

Keine. Beide Funde betreffen nur Tests und Ausgaben, nicht das Programm. Die
zugeteilten Kennungen E-182 und E-183 bleiben frei.

## Übersicht

| Fund | Was passiert | Schwere | Hält das Paket auf? |
|---|---|---|---|
| — | 350/350 im Grundlauf. Fehlt der Abschnitt `GetMessageBody`, ist der Test rot (349/1, gemessen). Eine Abweichung außerhalb eines Tests ergibt Rückgabe 1, und `pruefe-tests-gruen.pl` weist ab (gemessen). Kein grüner Fall gefunden, der rot sein müsste. | keine | nein |
| [K1](#k1) | `szMsg=cbstr;` (ohne Leerzeichen) hinter dem `else` stellt den E-136-Fehler wieder her, und alle Tests bleiben grün (350/350, gemessen). Dieselbe Lücke vermutlich bei `szBody` (SaveInfo). | niedrig (nur Tests) | nein |
| [K2](#k2) | `pruefe-tests-gruen.pl:87` und `RunTests.cmd:22` nennen die Rückgabe „Zahl der roten“ bzw. „Fehlgeschlagene Tests“. Sie enthält jetzt auch die Gerüstfehler, und die Zeilenangabe `TestMain.cpp:127` ist veraltet. Das Urteil stimmt. | niedrig (Ausgabe) | nein |
