## E-29 — Absturzberichte auswerten: `tools/absturz-auswerten.pl`

**Agent:** SPUR · **Zweig:** `wt/spur` · **Datum:** 06.09.2026 ·
**Fassung:** 7.2.0.12 (Bericht) / 7.2.0.13 (Werkzeug) ·
**Status:** Werkzeug fertig, 15 Selbsttests grün, gegen die echte
`Exception.log` gemessen

Eudora schreibt bei einem Absturz von selbst einen Bericht nach
`<Mailverzeichnis>\Exception.log`. Darin steht der Aufrufstapel — aber nur als
nackte Adressen. Dieses Werkzeug übersetzt sie in Funktionsnamen.

---

### 1. Warum die erste Auswertung falsch war

Am 06.09.2026 wurde der Bericht der Fassung 7.2.0.12 von Hand ausgewertet,
indem gegen die im Kopf der Zuordnungsdatei genannte **vorgesehene**
Ladeadresse `00400000` gerechnet wurde. Heraus kam ein Name aus dem
Ressourcenbereich — sichtbarer Unsinn.

Ursache: Windows lädt `Eudora.exe` verschoben (ASLR). Die vorgesehene
Ladeadresse gilt also gerade **nicht**, und die tatsächliche stand nirgends im
Bericht. Ohne Bezugspunkt ist keine einzige Adresse zuzuordnen.

Behoben ist das durch `QCExceptionHandler::WriteModuleTable()` in
`Eudora71/Eudora/ExceptionHandler.cpp` (Befund E-26): ab 7.2.0.13 steht vor dem
Aufrufstapel eine Tabelle mit den Ladeadressen aller geladenen Module.

Dieses Werkzeug liest genau diese Tabelle — und **rät nicht**, wenn sie fehlt.
Ein geratener Funktionsname ist schlimmer als gar keiner: er schickt die
Fehlersuche in die falsche Datei. Genau daran ist der erste Versuch
gescheitert.

---

### 2. Aufruf

```
perl tools/absturz-auswerten.pl
perl tools/absturz-auswerten.pl <Exception.log>
perl tools/absturz-auswerten.pl <Exception.log> <Eudora.map>
```

Ohne Argumente sucht das Werkzeug den Bericht der Reihe nach unter

1. `%EUDORA_EXCEPTION_LOG%`
2. `%EUDORA_MAILVERZEICHNIS%\Exception.log`
3. `%USERPROFILE%\Eudora72-*-release\Mailverzeichnis\Exception.log`
   (die neueste Fassung zuerst)
4. `%APPDATA%\Qualcomm\Eudora\Exception.log`

und die Zuordnungsdatei unter `Eudora71\Bin\Release\Eudora.map` im Arbeitsbaum.
Visual Studio wird **nicht** gebraucht.

| Schalter | Wirkung |
|---|---|
| `--karte=PFAD` | Zuordnungsdatei ausdrücklich benennen |
| `--ladeadresse=HEX` | tatsächliche Ladeadresse von `Eudora.exe` von Hand setzen — Notbehelf für alte Berichte, siehe Abschnitt 5 |
| `--letzter` | nur den letzten Bericht der Datei auswerten (Eudora hängt jeden Absturz an) |
| `--kein-undname` | keine lesbaren C++-Namen versuchen |
| `--hilfe` | Übersicht |

**Rückgabewerte:** `0` = mindestens eine Adresse aufgelöst · `1` = Aufruf- oder
Dateifehler · `2` = nichts auflösbar (z. B. Modultabelle fehlt). `2` ist kein
Fehler des Werkzeugs, sondern eine Aussage über den Bericht.

---

### 3. Was dabei herauskommt

Bericht **mit** Modultabelle (hier mit einer künstlich eingesetzten
Ladeadresse gegen die echte `Eudora.map` gemessen):

```
  Modultabelle: 3 Eintraege.
  Eudora.exe geladen an 00700000, Groesse 002CD000  (Modultabelle des Berichts)
  Verschiebung gegenueber der Karte: +00300000

  Aufrufstapel:

  EIP  414E3345  ---
       Keinem geladenen Modul zuzuordnen (freigegebener Speicher, JIT-Code
       oder ein zerstoerter Stapel). Nicht aufgeloest.
  #02  008962D7  Eudora.exe  Versatz 001962D7
       ?GetLogin@CImapMailbox@@QAEJXZ + 0xC4   [EuImap:ImapMailbox.obj]
       lesbar: public: long __thiscall CImapMailbox::GetLogin(void)
  #03  6FB9A3E6  mfc140.dll  Versatz 0019A3E6
       Fremdmodul - dafuer liegt hier keine Karte vor, nicht aufgeloest.
```

Bericht **ohne** Modultabelle (der echte von 7.2.0.12):

```
  DIE MODULTABELLE FEHLT IN DIESEM BERICHT.

  Die Adressen im Aufrufstapel lassen sich deshalb KEINEM Funktionsnamen
  zuordnen. Geraten wird nicht.
  ...
  Der Aufrufstapel unaufgeloest, damit er wenigstens festgehalten ist:
    0023:00894B53 (...) Eudora.exe
```

Rückgabewert 2 — und kein einziger Name. Das ist der Beweis, dass das Werkzeug
nicht rät.

---

### 4. Wie gerechnet wird

| Schritt | Quelle |
|---|---|
| vorgesehene Ladeadresse | `Preferred load address is 00400000` im Kopf der `.map` — **gelesen, nicht fest eingebaut** |
| tatsächliche Ladeadresse | Zeile `Eudora.exe` der Modultabelle im Bericht |
| Versatz im Bild | Stapeladresse − tatsächliche Ladeadresse |
| Adresse in der Karte | Versatz + vorgesehene Ladeadresse |
| Name | Eintrag mit der größten Adresse ≤ dieser Adresse, plus Abstand |

Zwei Fallen, die dabei eingebaut sind:

* **Abschnitt `0000` wird übersprungen.** Das sind absolute Symbole
  (`<absolute>`, `<linker-defined>`); in der echten `Eudora.map` stehen davon
  2757 Stück, die meisten mit der Adresse `00000000`. Wer sie mitnimmt, holt
  sich für jede kleine Adresse einen Treffer wie `___AbsoluteZero` ein.
  Nach dem Ausfiltern bleiben 48360 brauchbare Namen (statt 51117).
* **Zusammengefaltete Namen werden alle genannt.** Der Binder legt gleiche
  Funktionsrümpfe auf dieselbe Adresse (COMDAT folding). Das ist eine echte
  Mehrdeutigkeit und gehört in die Ausgabe, statt willkürlich einen Namen zu
  wählen.

Zusätzlich schlägt das Werkzeug Alarm, wenn der Abstand zum gefundenen Namen
über 64 KB liegt, wenn die Adresse hinter dem letzten Namen der Karte liegt,
oder wenn der Treffer kein Funktionssymbol ist (kein `f` in der Karte) — alles
drei sind Anzeichen dafür, dass die Karte nicht zu diesem Bau gehört.

Lesbare C++-Namen kommen von `undname.exe` aus Visual Studio, falls es
gefunden wird (`%UNDNAME%`, sonst
`…\VC\Tools\MSVC\*\bin\Host*\x86\undname.exe`). Es wird ohne Shell, ohne
Rückfrage und mit umgelenkter Eingabe aufgerufen; fehlt es, steht nur der
verstümmelte Name da, und das Werkzeug bleibt vollständig brauchbar.

---

### 5. Was es **nicht** kann

* **Alte Berichte auflösen.** Ohne Modultabelle geht es nicht, und es wird
  nicht geraten. Berichte bis einschließlich 7.2.0.12 haben sie nicht. Wer so
  einen Absturz braucht, löst ihn mit 7.2.0.13 oder neuer noch einmal aus.
* **Fremdmodule auflösen.** Für `mfc140.dll`, `USER32.dll` und so weiter liegt
  keine Karte vor. Sie werden mit Modulnamen und Versatz ausgegeben, aber
  keinem Namen zugeordnet. (Der Bericht selbst nennt für Systembibliotheken
  oft schon einen ungefähren Namen aus den Exporten — der steht in der
  Rohzeile.)
* **Prüfen, ob die Karte zum Bau passt.** Eine Karte aus einem anderen Bau
  liefert Namen, die nur zufällig stimmen. Das Werkzeug warnt bei
  unplausiblen Abständen, aber es kann es nicht beweisen. Wer auswertet, nimmt
  die `Eudora.map` aus demselben Bau wie die abgestürzte `Eudora.exe`.
* **Eine Zeilennummer nennen.** Dafür bräuchte es die `.pdb` und einen
  Symbolserver. Die Karte kennt nur Funktionsanfänge.
* **`--ladeadresse` überprüfen.** Der Schalter ist ein Notbehelf für den Fall,
  dass die Ladeadresse aus *derselben Sitzung* anderweitig belegt ist (Process
  Explorer, Debugger). Eine erfundene Zahl liefert erfundene Namen — dann
  lieber gar kein Ergebnis.

---

### 6. Gegenprobe

```
perl tools/absturz-auswerten-tests.pl        # 15 Faelle
perl tools/absturz-auswerten-tests.pl -v     # zusaetzlich die volle Ausgabe
```

Jeder Fall baut seine eigene künstliche Karte und seinen eigenen künstlichen
Bericht in einem Wegwerf-Verzeichnis. Es wird nichts gebaut und nichts
gestartet. Geprüft wird nicht nur, dass das Richtige dasteht, sondern auch,
dass das Falsche **nicht** dasteht — sonst wäre der Fehler vom 06.09.2026
wieder möglich.

| Fall | prüft |
|---|---|
| 1 | mit Modultabelle → Namen werden aufgelöst, Zwillinge genannt, kein `___AbsoluteZero` |
| 2 | ohne Modultabelle → klare Meldung, Rückgabe 2, **kein einziger Name** |
| 3 | nur Fremdmodule → als fremd gekennzeichnet, kein Eudora-Name |
| 4 | Adresse vor dem ersten Namen der Karte → gemeldet, kein Absturz |
| 5 | Adresse außerhalb aller Module (der echte EIP `414E3345`) → benannt, nicht zugeordnet |
| 6a–6d | Bericht fehlt / Karte fehlt / Karte ohne Kopfzeile / Bericht leer → Rückgabe 1 |
| 7 | `--ladeadresse` ersetzt die fehlende Tabelle |
| 8, 8b | zwei Berichte in einer Datei; `--letzter` |
| 9, 10 | `--hilfe`; unbekannter Schalter |
| 11 | `undname.exe` macht lesbare Namen daraus (wird übersprungen, wenn es fehlt) |

Stand 06.09.2026: **15 grün, 0 rot, 0 übersprungen.**

Zusätzlich gegen die echte Datei gemessen:

```
perl tools/absturz-auswerten.pl \
  "C:\Users\Gregor\Eudora72-1.0.12-release\Mailverzeichnis\Exception.log" \
  --karte="…\Eudora71\Bin\Release\Eudora.map"
→ DIE MODULTABELLE FEHLT IN DIESEM BERICHT.  (Rueckgabe 2)
```

Das ist das erwartete Ergebnis und der Beleg, dass nicht geraten wird.

---

### 7. Betroffene Dateien

| Datei | was |
|---|---|
| `tools/absturz-auswerten.pl` | das Werkzeug |
| `tools/absturz-auswerten-tests.pl` | 15 Selbsttests |
| `Eudora71/Eudora/ExceptionHandler.cpp` | Quelle der Modultabelle (Befund E-26, nicht von SPUR geändert) |
