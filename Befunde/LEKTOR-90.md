# <a id="lektor-90"></a>LEKTOR-90 — Bestand nach der Behebung von E-166 auf dem Zweig `e166-junk_message_fix`, 28.10.2026

**Auftrag.** Lauf über `7148ce09..473f570f` (sieben Commits, darunter der
Merge von PR #180 und die Behebung in `persona.cpp`) und Bestand der 61
`.md` ohne `Arbeitsweise/` und `Befunde/`. Neu seit
[LEKTOR-89](LEKTOR-89.md#lektor-89): [E-166](../Intern/BEFUNDE.md#e-166) (die Junk-Frage kam bei Gregor
zweimal) ist als **behoben auf dem Zweig** eingetragen — Ursache
`CPersonality::Modify` leert den INI-Zwischenspeicher, ohne ihn vorher zu
schreiben; [E-124](../Intern/BEFUNDE.md#e-124) (Defender-Fehlalarm) hat einen Nachtrag vom 28.10.;
zwei neue Messskripte und die Prüfstandsfälle E-166a/E-166b. Besonders:
passen alle Stellen, die [E-166](../Intern/BEFUNDE.md#e-166) oder die Junk-Frage nennen, zum neuen Stand,
und gibt der Stand-Vermerk in `Intern/WEITERMACHEN.md` den Tag richtig
wieder? Gemessen im Arbeitsbaum `Eudora7.2-wt-lektor` auf
`wt/lektor-20261028` (= `473f570f`).

**Ergebnis vorweg.** **11 Funde: 2 falsch, 3 veraltet, 2 unvollständig,
3 ungenau, 1 Hinweis.** Der Einstieg für die nächste Sitzung stimmt nicht
mehr: `Intern/WEITERMACHEN.md` sagt, [E-166](../Intern/BEFUNDE.md#e-166) sei am Prüfstand *„nicht
nachstellbar“* und gehe erst weiter, wenn Gregor die beiden Bibliotheken
bringt — beides ist seit dem Nachmittag überholt; Zweig, Behebung und
ausstehender Test stehen dort nirgends ([L-90.1](#l-90.1)). [E-166](../Intern/BEFUNDE.md#e-166) ist aus
den erzeugten Listen „Noch offen“ verschwunden, steht aber in keinem
CHANGELOG-Abschnitt und nicht unter „Bekannte Fehler“ in der README —
obwohl der Fehler in `v1.0.120` und im Testpaket 1.0.127 steckt und
Einstellungen still verliert ([L-90.3](#l-90.3), [L-90.4](#l-90.4)). Die
Einstufung *„wichtig“* widerspricht der eigenen Begründung: die Legende in
`BEFUNDE.md` stellt verlorene Einstellungen ausdrücklich unter *kritisch*
([L-90.5](#l-90.5)). Und [E-166](../Intern/BEFUNDE.md#e-166) belegt selbst, dass die Junk-Zusätze auf
einem Rechner mit VC-7.1-Laufzeit **laden** — `FILTER.md`, ANWENDER und
README sagen weiter ohne Einschränkung, die Junk-Punktzahl bleibe immer 0
([L-90.6](#l-90.6)).

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **belegt**
(Zitat mit Datei:Zeile), **Vermutung**. Nichts berichtigt — der Auftrag
erlaubt nur diesen Bericht und `Intern/LEKTORAT.md`.

---

## Funde aus LEKTOR-89

| Fund | worum es ging | Stand | Beleg |
|---|---|---|---|
| [L-89.1](LEKTOR-89.md#l-89.1) | S-3c sagte, ohne `MFC71.DLL` falle „vor allem das Adressbuch“ aus | **erledigt** | `Intern/BEFUNDE.md:2971` *„Verzeichnisdienst-Protokoll \*EudoraBk\* (nicht das eigene Adressbuch)“*, `:2979-2981`; Kopf von [S-3](../Intern/BEFUNDE.md#s-3) `:212` *„das eigene Adressbuch arbeitet“*; `Intern/STARTUMGEBUNG.md:120-122` (belegt). Zur Klammer dort siehe [L-90.10](#l-90.10) |
| [L-89.2](LEKTOR-89.md#l-89.2) | [E-166](../Intern/BEFUNDE.md#e-166) sagte, der Dialog schreibe keine Protokollzeile | **erledigt** | gemessen: `schreibt keine Zeile` in `BEFUNDE.md:383` 0 Treffer; die Tastenzeile von 22:26 ist gezählt und berichtigt (*„\*\*Berichtigt am 28.10.2026:\*\* um 22:26 wurde die Frage \*\*doch\*\* beantwortet“*). Neu dazu [L-90.8](#l-90.8) |
| [L-89.3](LEKTOR-89.md#l-89.3) | zwei widerlegte Sätze in [E-166](../Intern/BEFUNDE.md#e-166), verrutschte Klammer, `trnslate.cpp:3145` | **erledigt** | gemessen: `passt die Vermutung oben nur`, `endet **ohne**`, `trnslate.cpp:3145` je 0 Treffer in `:383`; Klammer steht hinter *„gemeldet von Gregor am 27.10.2026“* |
| [L-89.4](LEKTOR-89.md#l-89.4) | S-3-Kopf ohne die Messung vom 28.10., „bei Benutzung“, Verweise auf `#s-3` | **teilweise** | Kopf `:212` *„\*\*Zuletzt gemessen: 28.10.2026 an 7.2.0.127\*\* (S-3c …)“* und `:2967-2968` *„vier laedt Eudora erst bei Benutzung, die drei Zusaetze in `Plugins` beim Start“* — erledigt. **Offen:** `tools/WERKZEUGE.md:142` *„([S-3c](../Intern/BEFUNDE.md#s-3), Abschnitt S-3c)“* und `Intern/WEITERMACHEN.md:135` *„[S-3](BEFUNDE.md#s-3) Abschnitt S-3c erweitert“* zeigen weiter auf `#s-3` (belegt) |
| [L-89.5](LEKTOR-89.md#l-89.5) | erster nicht abgesprochener Start ohne Vermerk | **erledigt** | `tools/TESTLAEUFE.md:546` *„— \*\*nicht abgesprochen\*\*, siehe Arbeitsweise/erlaubnis-nicht-hineinlesen.md Nachtrag 28.10.2026“* (belegt) |
| [L-89.6](LEKTOR-89.md#l-89.6) | „hier weiter“ nannte Erledigtes als nächsten Schritt, Ankündigung als Freigabe | **erledigt, inzwischen wieder veraltet** | der 27.10.-Teil sagt jetzt *„kündigte den Prüfstand für den 28.10. an — eine Ankündigung, keine Freigabe“*; der 28.10.-Block hat ein eigenes *„Als Nächstes“* — das ist seit dem Nachmittag überholt → [L-90.1](#l-90.1) |
| [L-89.7](LEKTOR-89.md#l-89.7) | PR-Beschreibung #180 ohne [E-166](../Intern/BEFUNDE.md#e-166) | **erledigt** | gemessen: `gh pr view 180 --json body` enthält *„[E-166](../Intern/BEFUNDE.md#e-166)“* zweimal; PR ist gemergt (`512a3b46`, 12:51) |
| [L-89.8](LEKTOR-89.md#l-89.8) | DEFENDER-FEHLALARM „seit dem 23.10. nichts Neues“ | **erledigt, wieder überholt** | `Releases/DEFENDER-FEHLALARM.md:3` trennt jetzt Vorgang und Alarm (*„Der Alarm selbst kam am 26.10.2026 an 1.0.124 und am 27.10.2026 an 1.0.127 wieder“*); der Fall vom 28.10. fehlt → [L-90.9](#l-90.9) |
| [L-89.9](LEKTOR-89.md#l-89.9) | FILTER.md: auch `MSVCR71.dll` fehle im Paket | **erledigt** | `Intern/FILTER.md:495-497` *„`MSVCR71.dll` ersetzt der eigene Nachbau ([B-1](../Intern/BEFUNDE.md#b-1))“*, `SMIME.dll` genannt (belegt) |
| [L-89.10](LEKTOR-89.md#l-89.10) | README und ANWENDER nennen den Junk-Filter nicht | **erledigt** | `README.md:165` *„S/MIME und der Junk-Filter fehlen“*, `Doku/ANWENDER.md:18` (belegt). Die Aussage selbst ist zu absolut → [L-90.6](#l-90.6) |
| [L-88.9](LEKTOR-88.md#l-88.9) | [E-124](../Intern/BEFUNDE.md#e-124) kennt den Defender-Fall an 1.0.127 nicht | **teilweise** | `BEFUNDE.md:370` trägt jetzt *„Zuletzt gemessen: 28.10.2026 an 7.2.0.127“* (die `EudoraRes.dll` am Prüfstand); der Fall vom 27.10. (Gregors `Eudora.exe` 16:47, `Intern/TESTPLAN.md:51`) fehlt weiter — gemessen: weder `16:47` noch `27.10.2026` in der Zeile |
| [L-88.10](LEKTOR-88.md#l-88.10) | PRÜFER-63 nennt [E-165](../Intern/BEFUNDE.md#e-165)/[E-166](../Intern/BEFUNDE.md#e-166) „nicht vergeben“ | **offen** | `Befunde/PRUEFER-63.md:186` *„Keine. [[E-165](../Intern/BEFUNDE.md#e-165)] und [[E-166](../Intern/BEFUNDE.md#e-166)] sind nicht vergeben.“* unverändert (belegt) |

## Mechanisch zuerst (gemessen, nicht als Urteil übernommen)

| Werkzeug | Ausgabe |
|---|---|
| `perl tools/doku-pruefen.pl` | rc=0, *„Kein Widerspruch gefunden.“*; 47 Dateien; zur Kenntnis 15 Dateien ohne 7.2.0.127 (dieselben wie in [LEKTOR-89](LEKTOR-89.md#lektor-89)) |
| `perl tools/offene-befunde.pl` | rc=0, *„41 offene Befunde, in beiden Listen gleich.“* — eins weniger als in [LEKTOR-89](LEKTOR-89.md#lektor-89), weil [E-166](../Intern/BEFUNDE.md#e-166) jetzt als behoben zählt; 5 aktuell, 25 veraltet, 11 nie gemessen |
| `perl tools/pruefe-regressionstest.pl` | rc=0, *„Kein neues "behoben" ohne Regressionstest.“*; 22 kritische ohne jede Prüfung (darunter [E-39](../Intern/BEFUNDE.md#e-39)) |
| `perl tools/ziel-stand.pl` | rc=0, *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“* |
| `perl tools/pruefe-befundurteile.pl` | rc=0, *„Kein Dokument erklaert einen offenen Befund fuer erledigt“* |
| `perl tools/rollen-faellig.pl` | LEKTOR, **PRÜFER** (*„1 Datei(en) … - Eudora71/Eudora/persona.cpp“*) und CHRONIST fällig |

Alle fünf Doku-Schranken grün. Keine liest, ob der „hier weiter“-Block den
Tag beschreibt, ob ein behobener Befund irgendwo im CHANGELOG steht oder ob
die Einstufung zur Begründung passt — [L-90.1](#l-90.1),
[L-90.3](#l-90.3) und [L-90.5](#l-90.5) liegen außerhalb ihrer Reichweite.

## Stand-Vermerk vom 28.10.2026 (Frage 2)

* `Intern/WEITERMACHEN.md:3` *„\*\*Stand 28.10.2026.\*\*“* — das Datum ist
  richtig, der Inhalt beschreibt den **Vormittag** → [L-90.1](#l-90.1).
* `Intern/AUFGABEN.md:3` *„(Quellstand seit 27.10.2026 unverändert)“* — seit
  `249e4f95` nicht mehr wahr → [L-90.2](#l-90.2).
* `Intern/TESTPLAN.md:1` *„(Inhalt seit 27.10.2026 unverändert)“* — wahr
  (gemessen: `git log 7148ce09..HEAD -- Intern/TESTPLAN.md` leer). Dass
  Gregors E-166-Prüfschritt noch nicht darin steht, ist richtig: er gehört
  ins nächste Testpaket, das es noch nicht gibt.
* `Releases/PAKETE.md:6` *„geschnürt ist bis 1.0.127“* — wahr; der Bau vom
  28.10. ist nur übersetzt, kein Paket (gemessen: Fenstertitel in
  `tools/TESTLAEUFE.md:562` *„Paket 1.0.127+772ed08d 2026-10-28 14:08“*,
  kein ZIP dazu).
* `README.md:101` *„Stand \*\*7.2.0.127\*\* / `VERSION` \*\*1.0.127\*\*“* —
  für das Paket wahr; vom Quellstand auf diesem Zweig sagt die README nichts
  → [L-90.4](#l-90.4).

---

## <a id="l-90.1"></a>L-90.1 — falsch: der Einstieg sagt, E-166 sei nicht nachstellbar und warte auf Gregor

**Was passiert:** wer morgen mit `WEITERMACHEN.md` anfängt, liest, die
Junk-Frage lasse sich am Prüfstand nicht nachstellen und man warte auf
Gregors Bibliotheken — und den Merge von PR #180. Alles drei ist erledigt;
dass die Ursache gefunden, behoben, gebaut und gegengeprüft ist und nur
Gregors Test fehlt, steht im Einstieg nirgends. Ebenso wenig, auf welchem
Zweig man steht.

* **Belegt**, `Intern/WEITERMACHEN.md:135`: *„\*\*Stand 28.10.2026 — hier
  weiter:\*\* [[E-166](../Intern/BEFUNDE.md#e-166)] am Prüfstand gemessen, dort nicht nachstellbar
  (Junk-Zusätze laden ohne `MFC71.DLL`/`MSVCP71.dll` nicht …) … \*\*Als
  Nächstes:\*\* Gregor merged PR #180; [[E-166](../Intern/BEFUNDE.md#e-166)] weiter, sobald Gregor
  `MFC71.DLL` und `MSVCP71.dll` für den Prüfstand bringt …; [[E-165](../Intern/BEFUNDE.md#e-165)] am
  Prüfstand messen … CHRONIST ist fällig“*.
* **Gemessen**: PR #180 ist gemergt (`gh pr list`: `"number":180,
  "state":"MERGED"`; Merge-Commit `512a3b46`, 12:51). Die Bibliotheken
  waren da: `Intern/BEFUNDE.md:383` *„mit Gregors `MFC71.DLL` und
  `msvcp71.dll` aus seinem `SysWOW64` (Fassungen 7.10.6041 und 7.10.6052“*;
  Behebung `249e4f95`, Regressionsfall `473f570f`.
* **Gemessen**: `git diff 512a3b46..HEAD -- Intern/WEITERMACHEN.md` ändert
  nur die erzeugte Tabelle ([E-166](../Intern/BEFUNDE.md#e-166) heraus, [E-124](../Intern/BEFUNDE.md#e-124) neues Datum) — der Block
  `:135` ist in beiden E-166-Commits unberührt geblieben.
* **Belegt**, ebenso veraltet: `Intern/WEITERMACHEN.md:9` (Quellstand)
  *„Zweig `0.125_ergebnisse`“* — der Arbeitszweig ist
  `e166-junk_message_fix` (`tools/ZWEIGE.md:188`), und der Quellstand weicht
  seit `249e4f95` vom Paket 1.0.127 ab (`persona.cpp`).

**Was zu tun wäre:** neuer Block *„Stand 28.10.2026 nachmittags — hier
weiter“*: Zweig `e166-junk_message_fix`; [[E-166](../Intern/BEFUNDE.md#e-166)] Ursache gemessen,
behoben, gebaut, E-166a/b grün am neuen Bau, rot an 1.0.127; PRÜFER fällig
für `persona.cpp`; als Nächstes PR → Gregor merged, dann Gregors Test im
nächsten Testpaket; [[E-165](../Intern/BEFUNDE.md#e-165)] weiter offen. Den Vormittagsblock als überholt
kennzeichnen.

## <a id="l-90.2"></a>L-90.2 — veraltet: AUFGABEN sagt, der Quellstand sei seit dem 27.10. unverändert

**Was passiert:** der Kopf von `AUFGABEN.md` versichert, am Quelltext habe
sich seit dem Testpaket nichts getan. Auf diesem Zweig ist `persona.cpp`
geändert.

* **Belegt**, `Intern/AUFGABEN.md:3`: *„\*\*Stand 28.10.2026\*\* (Quellstand
  seit 27.10.2026 unverändert)“*.
* **Gemessen**: `git log -- Eudora71` jüngster Commit `249e4f95 2026-10-28
  14:06:04` *„[E-166](../Intern/BEFUNDE.md#e-166): Ursache gemessen - CPersonality::Modify verwirft
  ungeschriebene INI-Einstellungen“*, Diff `+7` Zeilen in
  `Eudora71/Eudora/persona.cpp`.

**Was zu tun wäre:** *„Quellstand 7.2.0.127 plus Behebung [[E-166](../Intern/BEFUNDE.md#e-166)]
(`persona.cpp`, nur übersetzt, kein Paket)“*. In [LEKTOR-89](LEKTOR-89.md#lektor-89) war derselbe Satz
wahr — er ist mit der Behebung gekippt, nicht vorher.

## <a id="l-90.3"></a>L-90.3 — unvollständig: E-166 ist aus „Noch offen“ verschwunden und steht in keinem CHANGELOG-Abschnitt

**Was passiert:** wer im CHANGELOG nach der Junk-Frage sucht, findet sie
nicht mehr — weder unter „Noch offen“ noch unter einer Fassung. Der
CHANGELOG verspricht aber genau das.

* **Belegt**, `CHANGELOG.md:18-20`: *„was \*behoben\* wurde, steht weiter
  unten in diesem Dokument unter der jeweiligen Fassung.“*
* **Gemessen**: `git diff 512a3b46..HEAD -- CHANGELOG.md` entfernt die
  E-166-Zeile aus der erzeugten Tabelle und fügt nichts hinzu; `grep -c
  '[E-166](../Intern/BEFUNDE.md#e-166)' CHANGELOG.md` → 0. Oberster Fassungsabschnitt ist `:100` *„## 7.2.0.127“*.
* **Belegt**, Ursache: das Urteil `BEFUNDE.md:383` beginnt mit
  *„\*\*behoben auf dem Zweig `e166-junk_message_fix` (28.10.2026)“*, und
  `offene-befunde.pl` zählt jedes *behoben* als geschlossen (*„41 offene
  Befunde“*, vorher 42). Die Fassung, unter der die Behebung erscheinen
  wird, gibt es nach [nummer-erst-beim-schnueren](../Arbeitsweise/nummer-erst-beim-schnueren.md)
  noch nicht.
* Dazu: `Intern/WEITERMACHEN.md` verliert [E-166](../Intern/BEFUNDE.md#e-166) aus derselben erzeugten
  Liste (`:357ff`) — nur der veraltete Block `:135` nennt ihn noch
  ([L-90.1](#l-90.1)).

**Was zu tun wäre:** eine Stelle, die behobene, noch nicht geschnürte
Befunde trägt (etwa ein Abschnitt *„Nach 7.2.0.127, nur übersetzt“* oben im
CHANGELOG), oder das Urteil so fassen, dass [E-166](../Intern/BEFUNDE.md#e-166) bis zum Paket in
„Noch offen“ bleibt. Wie, ist Form der Doku — Sache des Hauptagenten.
**Vermutung**: der erste Entwurf wollte das zweite (*„\*\*offen —
Ursache am Prüfstand gemessen und im Zweig … behoben; Gregors Test steht
aus\*\*“* in einer Zwischendatei des Hauptagenten); eingecheckt ist das
erste.

## <a id="l-90.4"></a>L-90.4 — unvollständig: README „Bekannte Fehler“ kennt den Einstellungsverlust nicht

**Was passiert:** wer `v1.0.120` oder das Testpaket 1.0.127 benutzt und die
Konto-Eigenschaften mit OK schließt, verliert jede Einstellung, die Eudora
seit dem letzten Schreiben nur im Speicher hielt — ohne Meldung. Die README
listet den älteren, ähnlichen Fall [E-39](../Intern/BEFUNDE.md#e-39) (Einstellungen einer
gelöschten Persönlichkeit), diesen nicht.

* **Belegt**, Wirkung: `Intern/BEFUNDE.md:383` *„Ursache: wer die
  Konto-Eigenschaften mit OK schließt, verliert jede Einstellung, die Eudora
  seit dem letzten Schreiben der `Eudora.ini` nur im Speicher hielt“*.
* **Belegt am Quelltext**: der Weg betrifft jeden Anwender, nicht nur
  Rechner mit Junk-Zusatz — `Modify` rufen *Konto → Eigenschaften*
  (`ModifyAcctSheet.cpp:126`), der Konto-Assistent
  (`AccountWizard/Src/WizardPropSheet.cpp:199`) und der Import
  (`MAPIImport.cpp:1970`, `:2043`); vor `249e4f95` stand in
  `persona.cpp:221` `RemoveAllFromCache()` ohne vorheriges `FlushINIFile()`
  (gemessen: `git show 249e4f95^:Eudora71/Eudora/persona.cpp`).
* **Belegt**, Gegenstück: `README.md:160` *„Wird die gerade benutzte
  Persönlichkeit gelöscht, können Reste ihrer Einstellungen wiederkommen |
  \*\*Einstellungen\*\* der Persönlichkeit (Ihre Post nicht)“* →
  [E-39](../Intern/BEFUNDE.md#e-39). Für [E-166](../Intern/BEFUNDE.md#e-166): gemessen `grep -c 'E-166' README.md` → 0.
* **Vermutung**: welche Einstellungen außer der Junk-Antwort im Alltag
  ungeschrieben im Speicher liegen, ist nicht gemessen; der Befund nennt nur
  `AskedAboutJunk` und `UseJunkMailbox`.

**Was zu tun wäre:** eine Zeile nach dem Muster der übrigen: *„Bis Paket
1.0.127: wer \*Konto → Eigenschaften\* mit OK schließt, verliert zuvor
geänderte, noch nicht gespeicherte Einstellungen | Einstellungen (Post
nicht) | vorher Eudora einmal beenden und neu starten | [[E-166](../Intern/BEFUNDE.md#e-166)]“*; nach dem
Paket mit *„Behoben ab …“*. Ebenso die Regel
[doku-bei-jedem-commit-mitziehen](../Arbeitsweise/doku-bei-jedem-commit-mitziehen.md):
README und `Intern/PORTIERUNG.md` sind mit `249e4f95` nicht mitgezogen
(gemessen: `git show --stat 249e4f95`).

## <a id="l-90.5"></a>L-90.5 — ungenau: E-166 ist „wichtig“ eingestuft, die Begründung beschreibt „kritisch“

**Was passiert:** die Stufe entscheidet, ob ein Befund vor jedem Release
geprüft werden muss. [E-166](../Intern/BEFUNDE.md#e-166) begründet seine Stufe mit stillem
Einstellungsverlust — genau das, was die Legende derselben Datei unter
*kritisch* führt; *wichtig* heißt dort ausdrücklich, dass nichts verloren
geht.

* **Belegt**, `Intern/BEFUNDE.md:383`: *„\*\*Stufe: wichtig\*\*
  (Einstellungen gehen verloren, ohne dass es jemand merkt)“*.
* **Belegt**, Legende `Intern/BEFUNDE.md:147-148`: *„\*\*kritisch\*\* | Post
  oder Einstellungen gehen verloren oder werden still beschädigt“* —
  *„\*\*wichtig\*\* | Eine Funktion ist unbrauchbar, aber nichts geht
  verloren und der Anwender merkt es sofort“*; ebenso
  `tools/pruefe-regressionstest.pl:301` *„wichtig … nichts geht verloren“*.
* **Belegt**, Vergleich: [E-39](../Intern/BEFUNDE.md#e-39) (`BEFUNDE.md:416`) *„Stufe: kritisch\*\*
  (Datenschaden: INI-Abschnitt einer geloeschten Persoenlichkeit kehrt
  zurueck)“*.

**Was zu tun wäre:** Stufe *kritisch*; der Prüfstandsfall E-166a/b deckt
die Pflicht „vor jedem Release“ schon. Einstufung ist dem Hauptagenten
übertragen — keine Frage an Gregor.

## <a id="l-90.6"></a>L-90.6 — falsch auf Rechnern mit VC-7.1-Laufzeit: „die Junk-Punktzahl bleibt bei jeder Nachricht 0“

**Was passiert:** `FILTER.md` und die Anwenderseiten sagen ohne
Einschränkung, die Junk-Bewertung arbeite in dieser Portierung nicht. [E-166](../Intern/BEFUNDE.md#e-166)
zeigt, dass sie auf Gregors eigenem Rechner arbeitet — sonst wäre die Frage
nie gekommen. Wer dort Regeln auf die Punktzahl baut (`FILTER.md` warnt
selbst: *„Wer so eine Regel mit \*Transfer To\* verbindet, verschiebt sein
ganzes Postfach“*), verlässt sich auf eine Aussage, die für ihn nicht gilt.

* **Belegt**, `Intern/FILTER.md:507` *„Jede eingehende Nachricht behält die
  Punktzahl \*\*0\*\*.“*; `Doku/ANWENDER.md:126-127` *„warum diese
  Punktzahl hier bei jeder eingehenden Nachricht \*\*0\*\* bleibt“*;
  `Doku/ANWENDER.md:18` *„LDAP, Ph, S/MIME, der Junk-Filter und die Suche
  über den Verzeichnisdienst fallen aus“*; `README.md:165` *„S/MIME und der
  Junk-Filter fehlen“*.
* **Belegt am Quelltext**, `eudora.cpp:1792-1794`: die Frage kommt nur
  `if (!pJunkList->IsEmpty() && (askedBits&introAsked)==0)` — also nur mit
  geladenem Junk-Zusatz. **Belegt**, `BEFUNDE.md:383`: *„Bei Gregor hat
  `SpamWatch` geladen“* (Fassung `512a3b46`) bzw. *„Lauf 1 — alle drei
  Junk-/S/MIME-Zusätze laden“* mit Gregors DLLs aus `SysWOW64`.
* Folge für [E-74](../Intern/BEFUNDE.md#e-74) (**belegt**, `FILTER.md:520-523`): `DeleteFetchedJunk=0`
  steht nur in `tools/DEudora.ini`, also für neu angelegte Stände
  (`CHANGELOG.md:4434`); auf einem Rechner mit geladenem `SpamWatch` und
  einer älteren `Eudora.ini` greift die eingebaute Vorgabe **1**.
  **Vermutung**, nicht gemessen: ob das bei Gregor so ist.

**Was zu tun wäre:** überall *„… fallen aus, **sofern** `MFC71.DLL` und
`MSVCP71.dll` nicht schon auf dem Rechner liegen (etwa aus anderer Software
in `SysWOW64`) — dann arbeiten Junk-Filter, S/MIME und Verzeichnisdienste
wie im Original“*; in `FILTER.md` den Abschnitt *„Praktisch heißt das“*
unter diese Bedingung stellen. Für die Verzeichnisdienste ist das eine
**Vermutung** (nicht gemessen, ob [E-47](../Intern/BEFUNDE.md#e-47) bei Gregor ausbleibt).

## <a id="l-90.7"></a>L-90.7 — ungenau: „Microsoft hat sie nie veröffentlicht“

**Was passiert:** drei Stellen beschreiben dieselben zwei Dateien mit drei
verschieden starken Sätzen. Der stärkste ist durch [E-166](../Intern/BEFUNDE.md#e-166) widerlegt: die
Dateien liegen mit Microsoft-Fassungsnummern auf Gregors Rechner.

* **Belegt**, `Intern/BEFUNDE.md:212` ([S-3](../Intern/BEFUNDE.md#s-3)): *„Microsoft hat sie nie
  veröffentlicht, siehe [[E-47](../Intern/BEFUNDE.md#e-47)]“*; `:294` ([E-47](../Intern/BEFUNDE.md#e-47)): *„die hat Microsoft nie
  als Redistributable veröffentlicht“*; `Intern/FILTER.md:495-496` und
  `Doku/ANWENDER.md:20-21`: *„nie zur Weitergabe freigegeben“*.
* **Belegt**, `BEFUNDE.md:383`: *„Gregors `MFC71.DLL` und `msvcp71.dll` aus
  seinem `SysWOW64` (Fassungen 7.10.6041 und 7.10.6052“*.

**Was zu tun wäre:** [S-3](../Intern/BEFUNDE.md#s-3) auf die Formulierung von FILTER/ANWENDER bringen.
Ob die Lizenz die Weitergabe erlaubt, prüft dieser Bericht nicht — die
Aussage selbst ist ungeprüft übernommen und nirgends mit einer Quelle
belegt (gemessen: keine der drei Stellen nennt eine).

## <a id="l-90.8"></a>L-90.8 — ungenau: E-166 sagt, im ersten Protokoll hätten die Junk-Zusätze geladen — dann hätte die Frage kommen müssen

**Was passiert:** der Satz erklärt, warum die Frage in Gregors erstem
Protokoll fehlt, und gibt einen Grund an, der sie gerade erzwingen würde.
Entweder fehlt ein *„nicht“*, oder es fehlt die Erklärung, warum Bit 1
schon gesetzt war.

* **Belegt**, `Intern/BEFUNDE.md:383`: *„im ersten (`test_0.127`,
  Sitzungen 27.10. 15:41, 16:37 und 16:49 …) steht die Frage nicht — dort
  luden die Junk-Zusätze.“* — der Halbsatz *„dort luden die Junk-Zusätze“*
  ist in `249e4f95`/`473f570f` neu (gemessen: `git diff 512a3b46..HEAD
  --word-diff`).
* **Belegt am Quelltext**: `eudora.cpp:1792` — mit geladenem Zusatz und
  `(askedBits&introAsked)==0` kommt die Frage beim Start. Gregors Stand war
  laut demselben Eintrag *„leerer Stand“*.

**Was zu tun wäre:** im ersten Protokoll nachsehen, ob `Plugin: Loading
…SpamWatch.dll` dort steht (Protokollschalter `0x100` war bei Gregor
vermutlich nicht gesetzt — dann ist die Aussage nicht messbar und gehört
gestrichen). Gregors Protokolle sind nicht in meiner Reichweite.

## <a id="l-90.9"></a>L-90.9 — veraltet: DEFENDER-FEHLALARM kennt den 28.10. nicht, E-124 nicht den 27.10.

**Was passiert:** am 28.10. hat Defender zum ersten Mal **nicht** die
`Eudora.exe`, sondern die `EudoraRes.dll` aus Paket 1.0.127 in Quarantäne
genommen — dreimal, schon beim Lesen der Dateiversion. Die Seite zum
Fehlalarm, deren Kopf vom selben Tag ist, sagt dazu nichts. Umgekehrt kennt
[E-124](../Intern/BEFUNDE.md#e-124) den Fall vom 27.10. nicht, den die Seite nennt.

* **Belegt**, `Intern/BEFUNDE.md:370`: *„\*\*28.10.2026, am Prüfstand
  `C:\Temp\E166` gemessen (`Get-MpThreatDetection`):\*\* Defender nahm
  dreimal die `EudoraRes.dll` aus Paket 1.0.127 in Quarantäne … —
  erstmals die Ressourcen-DLL, nicht `Eudora.exe`.“*
* **Belegt**, `Releases/DEFENDER-FEHLALARM.md:3`: *„Der Alarm selbst kam am
  26.10.2026 an 1.0.124 und am 27.10.2026 an 1.0.127 wieder“* — kein
  28.10., kein `EudoraRes`; gemessen: `grep -c EudoraRes
  Releases/DEFENDER-FEHLALARM.md` → 0.
* **Gemessen**: [E-124](../Intern/BEFUNDE.md#e-124) enthält weder `16:47` noch `27.10.2026`
  (Gregors Fall aus `Intern/TESTPLAN.md:51`) — [L-88.9](LEKTOR-88.md#l-88.9) Rest.
* Ungenau dazu: *„Bedrohungskennung 2147731250 wie bei 1.0.113“* — die
  Kennung steht nirgends sonst im Repo (gemessen: `git grep -l 2147731250`
  → nur `Intern/BEFUNDE.md`); für 1.0.113 ist nur der Name
  `Trojan:Win32/Bearfoos.A!ml` verzeichnet (`Releases/PAKETE.md:359`). Den
  Erkennungsnamen für die `EudoraRes.dll` nennt der Nachtrag nicht.

**Was zu tun wäre:** DEFENDER-FEHLALARM um den 28.10. ergänzen (Ressourcen-
DLL, ausgelöst durch Lesen, nicht durch Start — für eine neue Einreichung
bei Microsoft heißt das: nicht nur die `Eudora.exe`); [E-124](../Intern/BEFUNDE.md#e-124) um den
27.10.; Erkennungsname zur Kennung.

## <a id="l-90.10"></a>L-90.10 — ungenau: Messangaben in E-166 und STARTUMGEBUNG

**Was passiert:** vier kleine Angaben führen den Leser an die falsche
Stelle oder zum falschen Bau.

* **Belegt/gemessen**, `BEFUNDE.md:383` *„`persona.cpp:194-195` `SetCurrent`,
  `:793-794`“* — im heutigen Stand `persona.cpp:800-801` (gemessen: `grep -n
  RemoveAllFromCache`); `:793-794` ist die Zählung **vor** der Behebung im
  selben Commit (`git show 249e4f95^:… | grep -n` → `794`). Ebenso
  `persona.cpp:213ff` für `Modify`: stimmt (`:213`).
* **Gemessen**, *„Nachgemessen am neuen Bau (28.10.2026, `tools/bauen.ps1`
  auf Commit `249e4f95` …)“* — der Fenstertitel aller Läufe am neuen Bau
  nennt `Paket 1.0.127+772ed08d 2026-10-28 14:08`
  (`tools/TESTLAEUFE.md:562-566`, `:568`; `Intern/pruefstand-buch.tsv:34-35`).
  `772ed08d` ändert nur `tools/ZWEIGE.md`, der Quelltext ist derselbe — die
  Angabe sollte aber den Commit nennen, der im Titel steht.
* **Belegt**, *„\*\*Zuletzt gemessen: 28.10.2026 an 7.2.0.127\*\*“* — am
  28.10. liefen zwei verschiedene Bauten mit dieser Nummer (`+ea3ebcbd` mit
  Fehler, `+772ed08d` ohne; `TESTLAEUFE.md:567` und `:568`). Ohne den
  Commit sagt die Marke nicht, an welchem.
* **Belegt**, `Intern/STARTUMGEBUNG.md:121-122` *„das eigene Adressbuch
  arbeitet (gemessen 28.10.2026, Befund [E-166](../Intern/BEFUNDE.md#e-166))“* — [E-166](../Intern/BEFUNDE.md#e-166) hat das Adressbuch
  nicht gemessen, sondern das Laden der drei Zusätze; die Klammer gehört
  hinter *„Junk-Filter und S/MIME“*. Dazu ist *„Befund [E-166](../Intern/BEFUNDE.md#e-166)“* der einzige
  unverlinkte Verweis auf [E-166](../Intern/BEFUNDE.md#e-166) im Bestand.

**Was zu tun wäre:** die vier Angaben berichtigen. Hindert nichts.

## <a id="l-90.11"></a>L-90.11 — Hinweis: „behoben“ ohne PRÜFER, und ein Prüfstandsfall, der ohne fremde Dateien immer rot ist

**Was passiert:** [E-166](../Intern/BEFUNDE.md#e-166) heißt *behoben*, die Behebung hat noch niemand
gegengelesen. Und die neuen Fälle E-166a/b machen jeden vollen
Prüfstandslauf rot, sobald `C:\Temp\E166` die beiden Bibliotheken nicht
mehr hat (frisch ausgepackt, anderer Rechner, frischer Klon).

* **Gemessen**: `perl tools/rollen-faellig.pl` *„PRUEFER ist faellig: …
  Eudora71/Eudora/persona.cpp“*. Keine `Befunde/PRUEFER-*.md` nennt
  `persona.cpp:223` (gemessen: `grep -l 'FlushINIFile' Befunde/PRUEFER-6*.md` leer).
* **Belegt**, `tools/messen-e166-konto.ps1:33-37`: fehlt `MFC71.DLL` oder
  `msvcp71.dll`, *„exit 1“*; `tools/pruefstand-lauf.ps1:272-275` zählt das
  als *„[FEHL] … Vorbereiten mit … gescheitert“* und `$fehl++`.
  `tools/pruefstand-faelle.txt` sagt es im Kommentar (*„Braucht MFC71.DLL und
  msvcp71.dll im Pruefstand - nicht im Repo“*), `tools/WERKZEUGE.md:144`
  ebenso — dass der **ganze Lauf** dann rot ist, sagt keine Stelle.
* Nebenbei, kein `.md`: `messen-e166-konto.ps1:47` schreibt die
  Prüfstands-`Eudora.ini` mit `Set-Content … -Encoding ascii` zurück; ein
  Umlaut im Kontonamen würde zu `?`. Am Prüfstand folgenlos, solange das
  Testkonto keinen trägt (**Vermutung**, nicht nachgesehen).

**Was zu tun wäre:** PRÜFER vor dem PR; in `WERKZEUGE.md:144` und in der
Prüfstandsbeschreibung vermerken, dass E-166a/b ohne die beiden Dateien
als Fehler zählen (oder sie dann als *„nicht ausführbar“* ausweisen).

---

## Geprüft ohne Fund

* **[E-166](../Intern/BEFUNDE.md#e-166), Quelltextangaben** (belegt): `persona.cpp:213` `Modify`,
  `:223` `FlushINIFile()` vor `SavePersonaInfo`, `:228` `RemoveAllFromCache`;
  `persona.cpp:194-195`, `WizardPropSheet.cpp:325-326`,
  `settings.cpp:1518-1519` je `FlushINIFile` vor `RemoveAllFromCache`;
  `ModifyAcctSheet.cpp:126`, `WizardPropSheet.cpp:199`,
  `MAPIImport.cpp:1970`/`:2043` rufen `Modify` (unter `VERIFY`, das im
  Release-Bau auswertet). `IDS_ERR_VALIDATE_HOST` in `EudoraRes.rc:9397`
  mit dem zitierten Text, Aufruf `WizardPropSheet.cpp:274`; `YesNoDialog`
  (`guiutils.cpp:1213-1235`) schreibt tatsächlich keine `Dismissed`-Zeile,
  `AlertDialog` schon (`:931-933`).
* **Laufzählung** (gemessen an `tools/TESTLAEUFE.md:546-568`): fünf Starts
  am Vormittag (10:53–11:01) wie im Befund; zehn Läufe 13:30–13:40 am Bau
  `+ea3ebcbd` = *„Lauf 1“* bis *„Lauf 10“*; danach am neuen Bau und ein
  Gegenlauf an `+ea3ebcbd` um 14:18:58. Der Lauf 14:11:52 trägt keine
  Bau-Kennung im Titel — welcher Bau, ist nicht ablesbar.
* **DLLs nicht im Repo** (gemessen): `git ls-files | grep -i 'mfc71\|msvcp71'`
  → nur `Eudora71/VC71Bruecke/Messung/benoetigt-msvcp71.txt`.
* **S-3c** (`BEFUNDE.md:2964-2981`): Tabelle und Schluss stimmen mit README,
  ANWENDER, AUFGABEN, PORTIERUNG überein (bis auf [L-90.6](#l-90.6), das alle
  gleichermaßen betrifft).
* **`tools/ZWEIGE.md:188`**: Zweig mit Gregors Wortlaut eingetragen.
* **`tools/WERKZEUGE.md:142-144`**: Beschreibungen der drei E-166-Skripte
  stimmen mit den Skriptköpfen.
* **ZIEL**: nennt [E-166](../Intern/BEFUNDE.md#e-166) nicht; 27 von 27 unberührt (richtig, solange [E-166](../Intern/BEFUNDE.md#e-166)
  nicht ins Release-Kriterium aufgenommen wird).

## Nicht geprüft

* Gregors beide Protokolle (`test_0.127`, `eudora_20261027.zip`) — nicht in
  meiner Reichweite; daher [L-90.8](#l-90.8) offen.
* Die Behebung selbst gegen die MFC-Quelle — Sache des PRÜFER
  ([L-90.11](#l-90.11)).
* Bestand ohne Bezug zu [E-166](../Intern/BEFUNDE.md#e-166), [E-124](../Intern/BEFUNDE.md#e-124), Junk und Stand-Köpfen: seit
  [LEKTOR-89](LEKTOR-89.md#lektor-89) unverändert (gemessen: `git log --stat
  7148ce09..HEAD`, nur die genannten Dateien) und dort geprüft.

## <a id="gregor"></a>Was nur Gregor entscheiden kann

* **Kommt die Behebung von [E-166](../Intern/BEFUNDE.md#e-166) ins Release 7.2.1?** Der Fehler steckt in
  `v1.0.120` und in 1.0.127 und verliert still Einstellungen
  ([L-90.4](#l-90.4)); die Behebung ist eine Zeile, gebaut und am Prüfstand
  grün, aber noch nicht von dir getestet. Ob 7.2.1 auf deinen Test an einem
  neuen Testpaket wartet oder ohne [E-166](../Intern/BEFUNDE.md#e-166) geht, ist deine Entscheidung.
* **Was vor der Marke `v7.2.1.N` getestet sein muss**
  ([L-74.10](LEKTOR-74.md#l-74.10)) — unverändert offen.
* **Kriterium 0 ohne Visual Studio** ([L-77.3](LEKTOR-77.md#l-77.3)) —
  unverändert; [E-166](../Intern/BEFUNDE.md#e-166) hat gemessen, dass dein Rechner die VC-7.1-Laufzeit in
  `SysWOW64` hat, er ist also kein Rechner „ohne Nachinstallation“.
