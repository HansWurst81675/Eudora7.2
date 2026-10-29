# <a id="lektor-91"></a>LEKTOR-91 — Bestand nach dem Einarbeiten von LEKTOR-90, E-168 und Gregors Entscheidung 15, 29.10.2026

**Auftrag.** Lauf über `116095f5..3b8ae53a` (sieben Commits: [PRÜFER-64](PRUEFER-64.md),
dessen Einarbeitung, der Merge von [LEKTOR-90](LEKTOR-90.md#lektor-90), der Stand vom
28.10. abends, der CHRONIST, *„[E-168](../Intern/BEFUNDE.md#e-168) eingetragen, [LEKTOR-90](LEKTOR-90.md#lektor-90) eingearbeitet“* und
*„[E-166](../Intern/BEFUNDE.md#e-166) kommt mit dem Release 7.2.1“*) und Bestand der 61 `.md` ohne
`Arbeitsweise/` und `Befunde/`. Besonders: jeder der 18 Funde aus [LEKTOR-90](LEKTOR-90.md#lektor-90)
einzeln; [E-168](../Intern/BEFUNDE.md#e-168) (Absturz im Konto-Assistenten, vom
Messskript ausgelöst); Gregors Entscheidung 15 (die Behebung von
[E-166](../Intern/BEFUNDE.md#e-166) — Einstellungen gingen beim Schließen der
Konto-Eigenschaften verloren — geht mit 7.2.1 hinaus, Gregor prüft sie an der
Release-Fassung); die neue Aussage, dass Junk-Filter und S/MIME laden, wenn
`MFC71.DLL`/`MSVCP71.dll` schon auf dem Rechner liegen; `pruefe-startwege.pl`
mit `Audit.log`. Gemessen im Arbeitsbaum `Eudora7.2-wt-lektor` auf
`wt/lektor-20261029` (= `3b8ae53a`).

**Ergebnis vorweg.** **11 Funde: 2 falsch, 1 veraltet, 4 unvollständig,
2 ungenau, 2 Hinweise.** Von den 18 Funden aus [LEKTOR-90](LEKTOR-90.md#lektor-90) sind 14 erledigt,
2 teilweise, einer im Repo erledigt und selbst falsch, **einer nur
scheinbar**: die Startwege-Schranke soll seit heute
auch `Audit.log` zählen und so die zwanzig Starts vom 28.10. sehen — sie sieht
für den 28.10. weiter **einen** ([L-91.1](#l-91.1), gemessen). **Ein Fund aus
[LEKTOR-90](LEKTOR-90.md#lektor-90) war selbst falsch:** die veröffentlichte Notiz zu `v1.0.120` zählt
gar nicht auf, was ausfällt; der Absatz, den ich für veröffentlicht hielt,
ist unsere eigene Anmerkung im Repo. Die Frage an Gregor, ob der Text auf
GitHub um den Junk-Filter ergänzt wird, ist damit gegenstandslos
([L-91.2](#l-91.2)). Beim Nachmessen gefunden: **die drei veröffentlichten
Release-Texte `v1.0.113`, `v1.0.117` und `v1.0.120` verweisen siebenmal auf
`blob/main/BEFUNDE.md` — die Datei liegt seit dem 22.10. unter `Intern/`,
alle sieben Links führen ins Leere** ([L-91.3](#l-91.3)). Gregors
Entscheidung 15 steht in README, TESTPLAN, BEFUNDE und CHANGELOG stimmig,
**fehlt aber in ZIEL**, das laut README als einzige Stelle sagt, was zu 7.2.1
noch fehlt ([L-91.5](#l-91.5)); und der neue Prüfschritt im TESTPLAN wird
auf einem Rechner ohne die beiden Bibliotheken „bestanden“, ohne etwas zu
prüfen ([L-91.4](#l-91.4)). Die Junk-Ausnahme steht an genau einer Stelle
(`FILTER.md:501-509`), README, ANWENDER und PORTIERUNG verlinken dorthin —
PORTIERUNG aber dehnt sie ungemessen auf die Verzeichnisdienste aus
([L-91.6](#l-91.6)), und vier Stellen sagen weiter ohne Bedingung, die
Punktzahl bleibe 0 ([L-91.7](#l-91.7)).

Kennzeichnung je Aussage: **gemessen** (Befehl mit Ausgabe), **belegt**
(Zitat mit Datei:Zeile), **Vermutung**. Nichts berichtigt — der Auftrag
erlaubt nur diesen Bericht und `Intern/LEKTORAT.md`.

---

## Funde aus LEKTOR-90

| Fund | worum es ging | Stand | Beleg |
|---|---|---|---|
| [L-90.1](LEKTOR-90.md#l-90.1) | Einstieg sagte, [E-166](../Intern/BEFUNDE.md#e-166) sei nicht nachstellbar und warte auf Gregor | **erledigt** | `Intern/WEITERMACHEN.md:138` *„\*\*Stand 29.10.2026 — hier weiter:\*\* Zweig `e166-junk_message_fix`“*; `:140` und `:142` als *„überholt durch den Block darüber“* gekennzeichnet; Quellstand-Zeile `:11` nennt Zweig und Bau (belegt). Der Dateikopf `:3` blieb stehen → [L-91.9](#l-91.9) |
| [L-90.2](LEKTOR-90.md#l-90.2) | AUFGABEN: „Quellstand seit 27.10. unverändert“ | **erledigt** | `Intern/AUFGABEN.md:3` *„Quellstand \*\*7.2.0.127\*\* plus Behebung [[E-166](../Intern/BEFUNDE.md#e-166)] (`persona.cpp`, nur übersetzt, kein Paket)“* (belegt) |
| [L-90.3](LEKTOR-90.md#l-90.3) | [E-166](../Intern/BEFUNDE.md#e-166) in keinem CHANGELOG-Abschnitt | **erledigt** | `CHANGELOG.md:100` *„## Im Quellstand, noch in keinem Paket“*, `:104` [E-166](../Intern/BEFUNDE.md#e-166) (belegt). Dass er mit 7.2.1 hinausgeht, sagt der Abschnitt nicht → [L-91.5](#l-91.5) |
| [L-90.4](LEKTOR-90.md#l-90.4) | README „Bekannte Fehler“ ohne [E-166](../Intern/BEFUNDE.md#e-166) | **erledigt** | `README.md:161` *„\*\*Bis Paket 1.0.127:\*\* wer \*Konto → Eigenschaften\* mit OK schließt, verliert Einstellungen … \*\*Behoben ab dem Release 7.2.1\*\*“* (belegt). Zur Menübezeichnung → [L-91.11](#l-91.11) |
| [L-90.5](LEKTOR-90.md#l-90.5) | [E-166](../Intern/BEFUNDE.md#e-166) „wichtig“, Begründung „kritisch“ | **erledigt** | `Intern/BEFUNDE.md:384` *„\*\*Stufe: kritisch\*\* (… am 29.10.2026 von \*wichtig\* hochgestuft“* (belegt) |
| [L-90.6](LEKTOR-90.md#l-90.6) | „Junk-Punktzahl bleibt immer 0“ ohne Einschränkung | **teilweise** | erledigt in `Intern/FILTER.md:501-509`, `README.md:166`, `Doku/ANWENDER.md:21-23`, `:128-130` (belegt). Offen: `FILTER.md:511`, `:737`, `Intern/EINSTELLUNGEN.md:184`, `Intern/STARTUMGEBUNG.md:119-123`; dazu die Folge für [E-74](../Intern/BEFUNDE.md#e-74) (`DeleteFetchedJunk`) in `FILTER.md:530-533` ohne Bedingung → [L-91.7](#l-91.7) |
| [L-90.7](LEKTOR-90.md#l-90.7) | „Microsoft hat sie nie veröffentlicht“ | **teilweise** | [S-3](../Intern/BEFUNDE.md#s-3) (`BEFUNDE.md:212`) und [E-47](../Intern/BEFUNDE.md#e-47) (`:294`) sagen jetzt *„nicht zur Weitergabe freigegeben“* (gemessen: `git grep 'nie veröffentlicht'` ohne Treffer in BEFUNDE). **Offen:** `Intern/AUFGABEN.md:293-294` *„die hat Microsoft nie als Redistributable veröffentlicht“* (belegt). Eine Quelle für die Lizenzaussage nennt weiter keine Stelle |
| [L-90.8](LEKTOR-90.md#l-90.8) | „dort luden die Junk-Zusätze“ hätte die Frage erzwungen | **erledigt** | `BEFUNDE.md:384` *„ob die Junk-Zusätze dort luden, zeigt das Protokoll nicht (Protokollstufe `0xE49F`, ohne den Schalter `0x100` für Zusatzmodule; nachgesehen am 29.10.2026“* (belegt) |
| [L-90.9](LEKTOR-90.md#l-90.9) | DEFENDER-FEHLALARM ohne 28.10., [E-124](../Intern/BEFUNDE.md#e-124) ohne 27.10. | **erledigt** | `Releases/DEFENDER-FEHLALARM.md:3` *„am 28.10.2026 traf er erstmals die \*\*`EudoraRes.dll`\*\*“*; `BEFUNDE.md:370` *„\*\*27.10.2026, bei Gregor an Paket 1.0.127:\*\* Defender nahm die `Eudora.exe` um 16:47“*, Erkennungsname zur Kennung *„`Trojan:Win32/Bearfoos.A!ml` (Kennung 2147731250 laut `Get-MpThreat`“* (belegt) |
| [L-90.10](LEKTOR-90.md#l-90.10) | vier Messangaben in [E-166](../Intern/BEFUNDE.md#e-166) und STARTUMGEBUNG | **erledigt** | `BEFUNDE.md:384` *„`:800-801`“*, *„auf Commit `249e4f95`, im Fenstertitel `+772ed08d`“*, *„Zuletzt gemessen: 28.10.2026 an 7.2.0.127 (`+772ed08d`, mit Behebung)“*; `STARTUMGEBUNG.md:121-122` *„(für die drei Zusätze gemessen 28.10.2026, [E-166](../Intern/BEFUNDE.md#e-166))“* (belegt) |
| [L-90.11](LEKTOR-90.md#l-90.11) | „behoben“ ohne PRÜFER; E-166a/b ohne fremde DLLs immer rot | **erledigt** | [PRÜFER-64](PRUEFER-64.md) liegt vor; `tools/WERKZEUGE.md:144` *„\*\*Fehlen die beiden Dateien, zählt `pruefstand-lauf.ps1` E-166a/b als `[FEHL]`, und der ganze volle Lauf ist rot\*\*“* (belegt) |
| [L-90.12](LEKTOR-90.md#l-90.12) | Absturz am Prüfstand um 13:35 in keinem Dokument | **erledigt** | [E-168](../Intern/BEFUNDE.md#e-168) `BEFUNDE.md:383`; `tools/TESTLAEUFE.md:556` *„\*\*Absturz\*\* um 13:35:16 im Konto-Assistenten, vom Messskript ausgelöst — [[E-168](../Intern/BEFUNDE.md#e-168)]“* (belegt). Dass [E-157](../Intern/BEFUNDE.md#e-157) ihn kennt, fehlt → [L-91.8](#l-91.8) |
| [L-90.13](LEKTOR-90.md#l-90.13) | TESTPLAN verspricht das Release, [E-166](../Intern/BEFUNDE.md#e-166) verlangt ein Testpaket | **erledigt** | `Intern/TESTPLAN.md:9-11` *„an ihm prüfst du zusätzlich [[E-166](../Intern/BEFUNDE.md#e-166)] — erst danach wird es veröffentlicht“*, `:13-29` Prüfschritt (belegt). Zum Prüfschritt selbst → [L-91.4](#l-91.4) |
| [L-90.14](LEKTOR-90.md#l-90.14) | PAKETE 1.0.127 ohne Defender-Zeile | **erledigt** | `Releases/PAKETE.md:173` *„\| Defender \| \*\*27.10.2026 16:47\*\* bei Gregor … \*\*28.10.2026\*\* am Prüfstand: `EudoraRes.dll` viermal beim Lesen“* (belegt) |
| [L-90.15](LEKTOR-90.md#l-90.15) | PAKETE 1.0.127 zweierlei zum Testverzeichnis | **erledigt** | `Releases/PAKETE.md:168` *„Getestet hat Gregor außerhalb der VM mit leerem Stand“* (belegt) |
| [L-90.16](LEKTOR-90.md#l-90.16) | Release-Notiz `v1.0.120` ohne Junk-Filter | **im Repo erledigt — der Fund selbst war falsch** | `Releases/1.0.120/RELEASE-NOTIZEN.md:83-85`; der Absatz ist keine veröffentlichte Aussage → [L-91.2](#l-91.2) |
| [L-90.17](LEKTOR-90.md#l-90.17) | `pruefstand-ergebnis.txt` als Teillauf nicht gekennzeichnet, kein Leser | **erledigt (wirkt ab dem nächsten Lauf)** | `tools/pruefstand-lauf.ps1:400-404` Kommentar berichtigt, `:410` *„nur=“* (belegt). Die eingecheckte Datei `Intern/pruefstand-ergebnis.txt:2-5` ist noch die alte ohne `nur=` (gemessen) — sie wird beim nächsten Lauf ersetzt |
| [L-90.18](LEKTOR-90.md#l-90.18) | Startwege-Schranke sah am 28.10. einen von zwanzig Starts | **als erledigt gemeldet, nicht wirksam** | gemessen: `pruefe-startwege.pl --nurmelden --tag 2026-10-28` → *„Starts  1“* → [L-91.1](#l-91.1) |
| [L-89.4](LEKTOR-89.md#l-89.4) | Verweise auf `#s-3` statt auf S-3c | **teilweise** | `Intern/WEITERMACHEN.md:142` verlinkt jetzt den Anker `s-3c`; **offen** `tools/WERKZEUGE.md:142` *„([S-3c](../Intern/BEFUNDE.md#s-3), Abschnitt S-3c)“* und `BEFUNDE.md:384` *„eingetragen in [S-3](#s-3), Abschnitt S-3c“*, obwohl der Anker `s-3c` (`BEFUNDE.md:2965`) existiert (belegt) |
| [L-88.9](LEKTOR-88.md#l-88.9) | [E-124](../Intern/BEFUNDE.md#e-124) ohne den Fall vom 27.10. | **erledigt** | siehe [L-90.9](LEKTOR-90.md#l-90.9) |
| [L-88.10](LEKTOR-88.md#l-88.10) | PRÜFER-63 nennt [E-165](../Intern/BEFUNDE.md#e-165)/[E-166](../Intern/BEFUNDE.md#e-166) „nicht vergeben“ | **offen** | `Befunde/PRUEFER-63.md:186` unverändert; derselbe Fall neu in PRÜFER-64 → [L-91.10](#l-91.10) |

## Mechanisch zuerst (gemessen, nicht als Urteil übernommen)

| Werkzeug | Ausgabe |
|---|---|
| `perl tools/doku-pruefen.pl` | rc=0, *„Kein Widerspruch gefunden.“*; 47 Dateien; zur Kenntnis dieselben 15 Dateien ohne 7.2.0.127 wie in [LEKTOR-90](LEKTOR-90.md#lektor-90) |
| `perl tools/offene-befunde.pl` | rc=0, *„41 offene Befunde, in beiden Listen gleich.“*; 5 aktuell, 25 veraltet, 11 nie gemessen — [E-168](../Intern/BEFUNDE.md#e-168) zählt als *erledigt* und ändert die Zahl nicht |
| `perl tools/pruefe-regressionstest.pl` | rc=0, *„Kein neues "behoben" ohne Regressionstest.“*; 71 kritisch, 22 davon ohne jede Prüfung ([E-166](../Intern/BEFUNDE.md#e-166) nicht darunter: Fälle E-166a/b) |
| `perl tools/ziel-stand.pl` | rc=0, *„27 von 27 erfüllt, 0 offen - ZIEL.md ist auf dem Stand.“* |
| `perl tools/pruefe-befundurteile.pl` | rc=0, *„Kein Dokument erklaert einen offenen Befund fuer erledigt“* |
| `perl tools/rollen-faellig.pl` | rc=1: LEKTOR fällig (14 Dateien), CHRONIST fällig (`tools/pruefe-startwege.pl` u. a.); PRÜFER aktuell |
| `perl tools/pruefe-startwege.pl --nurmelden --tag 2026-10-28` | *„2026-10-28   Starts  1   Protokollzeilen 23   ohne Zeile  0“* → [L-91.1](#l-91.1) |

Alle Doku-Schranken grün. `ziel-stand.pl` meldet „auf dem Stand“, weil es
nur die Urteile in BEFUNDE liest; ein Prüfschritt, der nur im TESTPLAN steht,
liegt außerhalb seiner Reichweite ([L-91.5](#l-91.5)). Keine Schranke liest
die veröffentlichten Release-Texte ([L-91.3](#l-91.3)).

## Gregors Entscheidung 15 — überall stimmig?

| Stelle | Aussage | Urteil |
|---|---|---|
| `Intern/WEITERMACHEN.md:136` | *„geht \*\*mit dem Release 7.2.1\*\* hinaus … \*\*Kein Testpaket 7.2.0.128 dafür\*\* — Gregor prüft es an der Release-Fassung“* | Quelle |
| `README.md:161` | *„\*\*Behoben ab dem Release 7.2.1\*\*“* unter „Bekannte Fehler“ | stimmt (belegt) |
| `Intern/TESTPLAN.md:9-11`, `:13-29` | Prüfschritt am Release, Anker `e-166-am-release` | stimmt; Prüfschritt lückenhaft → [L-91.4](#l-91.4) |
| `Intern/BEFUNDE.md:384` | *„\*\*Was noch fehlt:\*\* Gregors Test \*\*an der Release-Fassung 7.2.1\*\*“* | stimmt (belegt) |
| `CHANGELOG.md:100-104` | *„Gregors Test steht aus.“* | stimmt, sagt aber nicht „mit 7.2.1“ → [L-91.5](#l-91.5) |
| `ZIEL.md` | nennt [E-166](../Intern/BEFUNDE.md#e-166) nicht (gemessen: `grep -c 'E-166' ZIEL.md` → 0) | **fehlt** → [L-91.5](#l-91.5) |
| `Releases/PAKETE.md` | kein Paket 1.0.128 angekündigt (gemessen: `git grep '1\.0\.128\|7\.2\.0\.128'` nur in WEITERMACHEN `:136` als *„Kein Testpaket“*) | stimmt |

---

## <a id="l-91.1"></a>L-91.1 — falsch: die Startwege-Schranke sieht den 28.10. weiterhin nicht — die Behebung zu L-90.18 wirkt nicht

**Was passiert:** die Schranke im Commit-Haken soll melden, wenn Eudora am
Prüfstand lief, ohne dass das Laufprotokoll es weiß. Seit heute zählt sie
dazu auch `Audit.log`, ausdrücklich, um die zwanzig Starts vom 28.10. zu
sehen. Für den 28.10. meldet sie trotzdem **einen** Start. Ein Start ohne
Protokollzeile, der vor dem Austausch der `Eudora.exe` liegt, bleibt ihr
weiter verborgen — genau die Lücke, die geschlossen sein soll.

* **Gemessen**, `perl tools/pruefe-startwege.pl --nurmelden --tag
  2026-10-28`: *„2026-10-28   Starts  1   Protokollzeilen 23   ohne Zeile
  0“*. Dagegen `C:\Temp\E166\Mailverzeichnis\Audit.log` (nur gelesen): 20
  Zeilen `… 32 15` mit `261028…` (`2610281059` bis `2610281420`).
* **Gemessen**, Ursache: `C:\Temp\E166\Eudora.exe` trägt die Änderungszeit
  *„2026-10-28 14:19:06“*. `tools/pruefe-startwege.pl:163` wirft jeden
  Audit-Start weg, der davor liegt (*„next if defined($exezeit) && $ep <
  $exezeit - 65;“*), `:153-154` übernimmt dafür ausdrücklich *„Dieselbe Regel
  wie oben: nur was nach der Eudora.exe liegt“*. Am 28.10. wurde die
  `Eudora.exe` im Prüfstand zwischen den Läufen getauscht (Paket-Bau
  `+ea3ebcbd`, neuer Bau `+772ed08d`, Gegenlauf 14:18:58,
  `tools/TESTLAEUFE.md:546-568`); übrig bleibt nur `2610281420`.
* **Belegt**, die Behauptung: `tools/WERKZEUGE.md:30` *„\*\*Seit dem
  29.10.2026 zählt sie auch `Audit.log`\*\* … am 28.10.2026 sah die Schranke
  deshalb einen Start, wo `Audit.log` zwanzig hatte ([[L-90.18](LEKTOR-90.md#l-90.18)])“*;
  `tools/pruefe-startwege.pl:146-148` derselbe Satz als Begründung;
  `Intern/WEITERMACHEN.md:138` *„[L-90.18](LEKTOR-90.md#l-90.18) (`pruefe-startwege.pl` zählt
  `Audit.log`)“* unter *„[LEKTOR-90](LEKTOR-90.md#lektor-90) eingearbeitet“*. Gegengeprüft wurde laut
  `:150-151` nur am 29.10. (*„vier testlauf.ps1-Starts, vier solche
  Zeilen“*) — am Tag ohne Austausch, nicht am Fall, der den Fund auslöste
  ([schranke-gegentesten](../Arbeitsweise/schranke-gegentesten.md)).
* **Gemessen**, Nebenbefund: `--tag 2026-10-20` meldet *„ohne Zeile  3“* —
  `C:/Temp/E131` 20:13:54, `C:/Temp/E132` 21:24:00 und 21:25:00.
  `WERKZEUGE.md:30` nennt *„zwei bisher unsichtbare Starts vom 20.10.2026 in
  `C:\Temp\E132`“*; der dritte (`E131`) fehlt, und in `tools/TESTLAEUFE.md`
  ist keiner der drei nachgetragen (gemessen: `grep '2026-10-20 2[01]:'` ohne
  Treffer). Der Haken prüft nur den heutigen Tag, deshalb weist er nicht ab.

**Was zu tun wäre:** für `Audit.log` die exe-Zeit nicht als Untergrenze
nehmen — `Audit.log` wird beim Kopieren eines Prüfstands nicht mitgenommen
wie die `eudora.log`, oder, falls doch, die Untergrenze aus der ersten
Audit-Zeile nach dem Anlegen des Mailverzeichnisses ziehen (**Vermutung**,
nicht geprüft, ob `pruefstand-lauf.ps1` `Audit.log` mitkopiert). Gegentest
gegen `--tag 2026-10-28`: 20 Starts erwartet. Die drei Starts vom 20.10. in
`TESTLAEUFE.md` nachtragen oder als nicht abgesprochen vermerken. Werkzeug,
kein `.md` — aber `WERKZEUGE.md:30` und der Einstieg `WEITERMACHEN.md:138`
behaupten das Gegenteil.

## <a id="l-91.2"></a>L-91.2 — falsch (mein Fund L-90.16): die veröffentlichte Notiz zu `v1.0.120` zählt gar nicht auf, was ausfällt

**Was passiert:** [LEKTOR-90](LEKTOR-90.md#lektor-90) schrieb, die veröffentlichte Notiz nenne
Verzeichnisdienste und S/MIME, aber nicht den Junk-Filter, und fragte Gregor,
ob der Text auf GitHub ergänzt wird. Der veröffentlichte Text enthält diesen
Absatz nicht. Er steht nur in unserer Datei im Repo, unter der Überschrift
*„Was in diesen Notizen bewusst nicht steht“* — einer Anmerkung des LEKTOR
vom 21.10. Die Frage an Gregor war damit falsch gestellt, und der Nachtrag
vom 29.10. bestätigt die falsche Annahme.

* **Gemessen**, `gh release view v1.0.120 --json body`: 2590 Byte; die
  Wörter *Junk*, *Verzeichnisdienste* und *S/MIME* kommen nicht vor. Der
  Text endet mit *„## Hinweis zu Windows Defender“*.
* **Belegt**, `Releases/1.0.120/RELEASE-NOTIZEN.md:23` *„## Der
  veröffentlichte Text, wörtlich“* reicht bis `:74`; `:76` *„## Was in diesen
  Notizen bewusst nicht steht“* ist eigener Text. Darin `:83-85` neu:
  *„dazu der \*\*Junk-Filter\*\* (nachgetragen am 29.10.2026 im Repo …; der
  Text auf GitHub ist unverändert)“* — der Halbsatz legt nahe, auf GitHub
  stehe dieser Absatz ohne Junk-Filter.
* **Belegt**, die Frage: `Intern/WEITERMACHEN.md:138` *„\*\*Offen bei
  Gregor:\*\* … (b) wird die veröffentlichte Notiz zu `v1.0.120` auf GitHub um
  den Junk-Filter ergänzt ([L-90.16](LEKTOR-90.md#l-90.16))?“*.
* Dazu, **gemessen**: der Kopf `:6` sagt *„Der \*\*Text unten ist der Rumpf
  des veröffentlichten Releases, wörtlich\*\*“*; die Links darin lauten aber
  `blob/main/Intern/BEFUNDE.md#e-135` (`:28`), veröffentlicht ist
  `blob/main/BEFUNDE.md#e-135`. Die Abschrift ist nachträglich angepasst
  worden → [L-91.3](#l-91.3).

**Was zu tun wäre:** in `:84-85` statt *„der Text auf GitHub ist
unverändert“* sagen, dass der veröffentlichte Text keine solche Aufzählung hat;
Frage (b) in `WEITERMACHEN.md:138` streichen. Ich nehme sie aus Gregors
Liste.

## <a id="l-91.3"></a>L-91.3 — unvollständig: sieben Links in drei veröffentlichten Release-Texten führen ins Leere

**Was passiert:** wer auf GitHub in den Notizen zu `v1.0.113`, `v1.0.117`
oder `v1.0.120` auf einen Befund klickt, landet auf einer Fehlerseite.
`BEFUNDE.md` wurde am 22.10. nach `Intern/` verschoben, die Release-Texte
verweisen weiter auf die Wurzel. Das ist die Außenseite des Projekts, und
`v1.0.120` ist das aktuelle Release.

* **Gemessen**: `git cat-file -e origin/main:BEFUNDE.md` → *„fatal: path
  'BEFUNDE.md' does not exist in 'origin/main'“*; `Intern/BEFUNDE.md`
  besteht. Verschoben mit `c28cde84` (22.10.2026, *„Der Stand steht an einer
  Stelle“*).
* **Gemessen**, `gh release view <marke> --json body`, Zahl der Links
  `blob/main/BEFUNDE.md`: `v1.0.120` 3 ([E-135](../Intern/BEFUNDE.md#e-135), [E-134](../Intern/BEFUNDE.md#e-134), [E-132](../Intern/BEFUNDE.md#e-132)), `v1.0.117` 2,
  `v1.0.113` 2; `v1.0.112` und `v1.0.101` keine. Issue #102 verweist nur auf
  `MELDUNGEN-VON-AUSSEN.md`, die an der Wurzel liegt.
* **Gemessen**, kein Dokument kennt das: `git grep 'blob/main/BEFUNDE'` ohne
  Treffer außerhalb der Abschriften, die schon auf `Intern/` umgeschrieben
  sind (siehe [L-91.2](#l-91.2)).

**Was zu tun wäre:** die veröffentlichten Texte berichtigen — das ist eine
Änderung nach außen, also Gregors Entscheidung (unten). Unabhängig davon
gehört in die Abschriften im Repo ein Vermerk, dass ihre Links vom
veröffentlichten Text abweichen. **Vermutung:** eine Weiterleitung von
`BEFUNDE.md` an der Wurzel (eine Datei mit einem Satz und dem Link auf
`Intern/BEFUNDE.md`) würde die Seite erreichbar machen, nicht aber die Anker.

## <a id="l-91.4"></a>L-91.4 — ungenau: der Prüfschritt zu E-166 am Release gilt auch dann als bestanden, wenn die Frage nie kam

**Was passiert:** Gregor soll an der Release-Fassung prüfen, dass die
Junk-Frage nach *Properties → OK* nicht wiederkommt. „Bestanden“ heißt im
Plan nur: beim zweiten Start keine Frage. Die Frage kommt aber nur, wenn
`MFC71.DLL` und `MSVCP71.dll` auf dem Rechner liegen. Auf einem Rechner ohne
die beiden kommt sie beim ersten Start schon nicht — und der Test ist grün,
ohne etwas geprüft zu haben ([ausbleiben-ist-kein-befund](../Arbeitsweise/ausbleiben-ist-kein-befund.md)).

* **Belegt**, `Intern/TESTPLAN.md:20-22` *„Es kommen der Konto-Assistent und
  die Frage \*„Automatically put junk mail in the Junk mailbox?“\*“*; `:28`
  *„\*\*Bestanden:\*\* beim zweiten Start kommt die Junk-Frage \*\*nicht\*\*
  wieder.“* Was zu tun ist, wenn die Frage in Schritt 1 ausbleibt, steht
  nicht da; als Voraussetzung nennt `:17-19` nur das leere Mailverzeichnis.
* **Belegt**, die Bedingung: `Intern/FILTER.md:506-508` *„auf Gregors Rechner
  kam die Junk-Frage, die nur mit geladenem Zusatz erscheint
  (`eudora.cpp:1792`)“*; `BEFUNDE.md:384` *„\*\*Ohne
  `MFC71.DLL`/`MSVCP71.dll` laden die Junk-Zusätze nicht\*\* und die Frage
  kommt nie (fünf Starts am Vormittag, `AskedAboutJunk=4`“*.
* **Belegt**, auf welchem Rechner Gregor testet, steht nicht im Plan; die
  beiden Dateien stammen *„aus seinem `SysWOW64`“* (`BEFUNDE.md:384`). Auf
  diesem Rechner wird der Schritt also aussagekräftig sein (**Vermutung**,
  dass es derselbe ist).
* **Vermutung**, nicht geprüft: ZIEL `:87` verlangt am Release *„Gregors Test
  aller neun Kriterien an einem frischen Paket“*; ob dafür Gregors Daten
  hineinkopiert werden (wie im Kurztest 7.2.0.127, `TESTPLAN.md:37-39`), sagt
  der Plan nicht. Dann muss der E-166-Schritt **vorher** laufen, sonst ist
  die Frage schon beantwortet (`:17-19`).

**Was zu tun wäre:** in Schritt 1 *„Kommt die Frage nicht, ist der Test hier
nicht durchführbar — bitte melden, nicht ‚bestanden‘“*; die Reihenfolge zum
übrigen Release-Test festlegen. Was ein *nein* für das Release bedeutet,
lässt sich aus Gregors Wortlaut ableiten (*„ist nicht dringend. reicht unter
'bekannte fehler'“*, `WEITERMACHEN.md:136`): die README-Zeile `:161` verlöre
dann ihr *„Behoben ab dem Release 7.2.1“*. Das gehört als ein Satz in den
Plan; Form der Doku, keine Frage an Gregor.

## <a id="l-91.5"></a>L-91.5 — unvollständig: ZIEL kennt den E-166-Prüfschritt am Release nicht, obwohl die README sagt, nur dort stehe, was zu 7.2.1 fehlt

**Was passiert:** wer wissen will, was vor dem Release 7.2.1 noch zu tun ist,
wird von der README nach ZIEL geschickt — *„dort und nur dort“*. ZIEL sagt:
alles erfüllt. Der Prüfschritt, nach dem das Release laut TESTPLAN erst
veröffentlicht wird, steht dort nicht.

* **Belegt**, `README.md:143-144` *„\*\*Was zur Fassung 7.2.1 noch fehlt,
  steht erzeugt ganz oben in [ZIEL.md](../ZIEL.md)\*\* — dort und nur dort,
  mit der Angabe, wer es prüft.“*
* **Belegt**, `ZIEL.md:44-50` *„\*\*Stand: 27 von 27 erfüllt, 0 offen.\*\* …
  \*\*Alle Zeilen des Maßstabs sind erfüllt.\*\*“*; `:87-89` *„\*\*Vor dem
  Release:\*\* … dann Gregors Test aller neun Kriterien an einem frischen
  Paket, erst danach die Marke“* — ohne [E-166](../Intern/BEFUNDE.md#e-166) (gemessen: `grep -c '[E-166](../Intern/BEFUNDE.md#e-166)'
  ZIEL.md` → 0). `ZIEL.md:174` *„\*\*Stand 27.10.2026.\*\* Quellstand
  \*\*7.2.0.127\*\*“* — die Behebung auf dem Zweig fehlt.
* **Belegt**, Gegenstück: `Intern/TESTPLAN.md:10-11` *„an ihm prüfst du
  zusätzlich [[E-166](../Intern/BEFUNDE.md#e-166)] — erst danach wird es veröffentlicht.“*
* **Belegt**, ebenso: `README.md:138` *„\*\*Neu in den Testpaketen 7.2.0.123
  bis 7.2.0.127\*\* (… kommt mit dem Release 7.2.1)“* zählt auf, was mit
  7.2.1 kommt — [E-166](../Intern/BEFUNDE.md#e-166) kommt mit, steht aber in keinem Testpaket und nicht in
  der Aufzählung `:139-142`. `CHANGELOG.md:102-104` sagt *„die Nummer kommt
  beim Schnüren“* und *„Gregors Test steht aus“*, nicht, dass es das Release
  wird.
* `ziel-stand.pl` meldet *„ZIEL.md ist auf dem Stand“* — es liest nur
  Urteile in BEFUNDE, und [E-166](../Intern/BEFUNDE.md#e-166) ist dort *behoben* (gemessen, siehe oben).
  Die Lehre [anforderung-gehoert-in-den-massstab](../Arbeitsweise/anforderung-gehoert-in-den-massstab.md)
  trifft genau das.

**Was zu tun wäre:** in ZIEL `:87` den Prüfschritt mit Verweis auf
`TESTPLAN.md#e-166-am-release` nennen; in README `:138ff` und im
CHANGELOG-Abschnitt `:102` je einen Halbsatz *„kommt mit dem Release
7.2.1“*. Form der Doku — Sache des Hauptagenten.

## <a id="l-91.6"></a>L-91.6 — ungenau: PORTIERUNG dehnt die Junk-Ausnahme ungemessen auf die Verzeichnisdienste aus

**Was passiert:** die neue Aussage lautet an der maßgeblichen Stelle: liegen
die beiden Bibliotheken schon auf dem Rechner, laden **Junk-Filter und
S/MIME**. PORTIERUNG macht daraus: auch die Verzeichnisdienste fallen dann
nicht aus. Das ist nicht gemessen, und die README sagt im selben Atemzug das
Gegenteil.

* **Belegt**, `Intern/PORTIERUNG.md:739` *„die Verzeichnisdienste (LDAP, Ph,
  `EudoraBk`) und S/MIME fallen deshalb aus, sofern die beiden nicht schon auf
  dem Rechner liegen ([FILTER.md](../Intern/FILTER.md#warum-die-junk-bewertung-hier-nicht-arbeitet))“*.
* **Belegt**, die Quelle, auf die PORTIERUNG verweist, spricht nur von den
  Zusätzen: `Intern/FILTER.md:503-504` *„die Zusätze laden wie im Original,
  und die Junk-Bewertung arbeitet“*; `README.md:166` *„laden Junk-Filter und
  S/MIME doch“*; `Doku/ANWENDER.md:21-22` ebenso.
* **Belegt**, gemessen ist nur das Laden der drei Zusätze:
  `BEFUNDE.md:384` *„Lauf 1 — alle drei Junk-/S/MIME-Zusätze laden“*. Für
  die Verzeichnisdienste hat [LEKTOR-90](LEKTOR-90.md#lektor-90) ([L-90.6](LEKTOR-90.md#l-90.6))
  ausdrücklich *„\*\*Vermutung\*\* (nicht gemessen, ob [[E-47](../Intern/BEFUNDE.md#e-47)] bei Gregor
  ausbleibt)“* geschrieben.

**Was zu tun wäre:** in PORTIERUNG die Bedingung auf S/MIME beschränken
(*„die Verzeichnisdienste fallen aus; S/MIME auch, sofern …“*) oder die
Verzeichnisdienste mit den beiden Dateien am Prüfstand messen. Hindert nichts.

## <a id="l-91.7"></a>L-91.7 — unvollständig: die Junk-Ausnahme steht an einer Stelle, aber vier Stellen sagen weiter ohne Bedingung „Punktzahl 0“

**Was passiert:** die Aussage *„lädt, wenn `MFC71`/`MSVCP71` schon da
sind“* steht wie verlangt an genau einer Stelle (`FILTER.md:501-509`), und
README, ANWENDER, PORTIERUNG und [S-3](../Intern/BEFUNDE.md#s-3) verlinken dorthin. In FILTER selbst und
in drei anderen Dateien stehen aber Sätze, die das Gegenteil ohne Bedingung
behaupten — einer davon widerspricht zusätzlich der eigenen Liste darüber.

* **Belegt**, `Intern/FILTER.md:511` *„`LoadLibrary` schlägt in diesem Fall
  fehl“* — seit dem Einschub `:501-509` bezieht sich *„in diesem Fall“* auf
  die Ausnahme, in der `LoadLibrary` gerade **gelingt**.
* **Belegt**, `Intern/FILTER.md:737` (Tabelle der Befunde): *„`SpamWatch`
  und `SpamHeaders` laden nicht — siehe oben. \*\*Praktische Folge für die
  Filter:\*\* jede eingehende Nachricht behält die Junk-Punktzahl 0, eine
  Regel auf \*Junk Score\* trifft also nie“* — ohne Bedingung, und *„trifft
  also nie“* widerspricht `:526-527` derselben Datei (*„`«Junk Score» is less
  than N` für jedes N ≥ 1 \*\*jede\*\* Nachricht“*).
* **Belegt**, `Intern/FILTER.md:530-533` *„Aus demselben Grund steht
  `DeleteFetchedJunk` in dieser Portierung auf \*\*0\*\* … Einer Einstufung,
  die auf einem nicht geladenen Modul beruht, darf man keine Post zum Löschen
  anvertrauen.“* — die Folge für Rechner mit geladenem Modul
  ([L-90.6](LEKTOR-90.md#l-90.6), dritter Punkt) steht nirgends.
* **Belegt**, `Intern/EINSTELLUNGEN.md:184` *„\*\*4.1 Die Junk-Punktzahl
  bleibt bei jeder eingehenden Nachricht `0`.\*\*“* — der Rumpf erklärt den
  Mechanismus (*„ist keines geladen“*), die Überschrift ist absolut, kein
  Verweis auf die Ausnahme.
* **Belegt**, `Intern/STARTUMGEBUNG.md:119-123` *„`MFC71.DLL` und
  `MSVCP71.dll` fehlen weiterhin … Dadurch fallen \*\*die Verzeichnisdienste
  …, Junk-Filter und S/MIME\*\* aus“* — kein Verweis auf FILTER.
* **Belegt**, Rest von [L-90.7](LEKTOR-90.md#l-90.7): `Intern/AUFGABEN.md:293-294`
  *„die hat Microsoft nie als Redistributable veröffentlicht“*.
* Doppelt, nicht falsch: `README.md:166` wiederholt den Ort
  *„`C:\Windows\SysWOW64`“* aus `FILTER.md:503` statt nur zu verlinken.

**Was zu tun wäre:** `FILTER.md:511` auf *„Fehlen die beiden, schlägt
`LoadLibrary` fehl“*; `:737` auf *„ohne `MFC71`/`MSVCP71` … — siehe oben“* und
*„trifft also nie“* durch *„greift nicht wie gedacht“* ersetzen; in
EINSTELLUNGEN 4.1 und STARTUMGEBUNG je einen Halbsatz mit Link auf
FILTER; `AUFGABEN.md:293` auf *„nicht zur Weitergabe freigegeben“*. Hindert
nichts.

## <a id="l-91.8"></a>L-91.8 — unvollständig: E-168 sagt „gehört zu E-157“, E-157 weiß nichts davon

**Was passiert:** [E-157](../Intern/BEFUNDE.md#e-157) beschreibt, dass die
Prüfstandsläufe keine Abstürze sehen. Am 28.10. ist genau das geschehen:
Eudora stürzte im Prüfstand ab, der Lauf wurde ohne Vermerk verbucht, erst
der LEKTOR fand das `Exception.log`. [E-168](../Intern/BEFUNDE.md#e-168)
verweist dafür auf [E-157](../Intern/BEFUNDE.md#e-157) — [E-157](../Intern/BEFUNDE.md#e-157) selbst ist nicht fortgeschrieben, und sein
*„Zuletzt gemessen“* steht auf dem 26.10.

* **Belegt**, `BEFUNDE.md:383` ([E-168](../Intern/BEFUNDE.md#e-168)): *„Dass der Prüfstand den Absturz
  nicht meldete, gehört zu [[E-157](../Intern/BEFUNDE.md#e-157)].“*
* **Gemessen**, E-157-Zeile: kein [`E-168`](../Intern/BEFUNDE.md#e-168), kein `28.10.2026`; *„Zuletzt
  gemessen: 26.10.2026 an 7.2.0.124“*. Im erzeugten CHANGELOG-Block
  `CHANGELOG.md:29` ([E-157](../Intern/BEFUNDE.md#e-157)) *„nach jedem Testpaket dieselbe Zählung … ein Fall
  im Prüfstand, der einen echten Abs…“* — der 28.10. wäre der erste echte
  Fall dafür.

**Was zu tun wäre:** [E-157](../Intern/BEFUNDE.md#e-157) um den 28.10. ergänzen (Bau `+ea3ebcbd`,
`Exception.log` 13:35:16, im `Audit.log` der einzige Start ohne Beenden-Zeile,
`testlauf.ps1` meldete *„Schliesszeit 5.1 s“*), Datum nachziehen
([bestand-vor-neuer-suche](../Arbeitsweise/bestand-vor-neuer-suche.md)).

## <a id="l-91.9"></a>L-91.9 — veraltet: Kopfzeilen nennen den 28.10. und zwei offene Fragen

**Was passiert:** der Einstieg zeigt oben *„Stand 28.10.2026“*, zwei Zeilen
darunter *„Stand 29.10.2026“*, und dieser Block sagt, zwei Fragen an Gregor
seien offen — eine ist seit Entscheidung 15 beantwortet, die andere ist
gegenstandslos ([L-91.2](#l-91.2)).

* **Belegt**, `Intern/WEITERMACHEN.md:3` *„\*\*Stand 28.10.2026.\*\*“*; `:7`
  *„\*\*ALS ERSTES (Stand 29.10.2026):\*\* … [[LEKTOR-90](LEKTOR-90.md#lektor-90)] ist eingearbeitet bis
  auf zwei Fragen an Gregor“*; `:138` *„(a) ~~kommt [E-166](../Intern/BEFUNDE.md#e-166) ins Release
  7.2.1?~~ beantwortet“*.
* **Belegt**, `ZIEL.md:174` *„\*\*Stand 27.10.2026.\*\* Quellstand
  \*\*7.2.0.127\*\*“* (siehe [L-91.5](#l-91.5)).

**Was zu tun wäre:** `:3` auf den 29.10.; `:7` *„eingearbeitet; offen bei
Gregor nichts“* (nach [L-91.2](#l-91.2)). Hindert nichts.

## <a id="l-91.10"></a>L-91.10 — Hinweis: PRÜFER-64 sagt „E-168 nicht vergeben“ und verlinkt auf E-168; E-167 ist eine stille Lücke

**Was passiert:** im Bericht des PRÜFER steht *„[E-168](../Intern/BEFUNDE.md#e-168) nicht vergeben“* — seit
heute als Link auf den Absturz im Konto-Assistenten, der mit dem Bericht
nichts zu tun hat. Die Kennung E-167 hat der PRÜFER für einen Vorschlag
vorgemerkt; sie fehlt in `BEFUNDE.md`, und nirgends sonst steht, warum.

* **Belegt**, `Befunde/PRUEFER-64.md:332-333` *„E-167 als Vorschlag für
  [K5](#k5), aufzunehmen erst nach einer Messung. [E-168](../Intern/BEFUNDE.md#e-168)
  nicht vergeben.“* — der Link kam mit `1e54773d` (gemessen: `git show
  1e54773d -- Befunde/PRUEFER-64.md`, `-[E-168](../Intern/BEFUNDE.md#e-168) nicht vergeben` / `+[E-168](…)
  nicht vergeben`).
* **Gemessen**: `grep -n 'E-167' Intern/BEFUNDE.md` ohne Treffer; `git grep
  'E-167' -- '*.md' ':!Befunde'` ohne Treffer.
* Derselbe Fall älter: `Befunde/PRUEFER-63.md:186` *„[[E-165](../Intern/BEFUNDE.md#e-165)] und [[E-166](../Intern/BEFUNDE.md#e-166)]
  sind nicht vergeben.“* ([L-88.10](LEKTOR-88.md#l-88.10), offen).

**Was zu tun wäre:** `befunde-verlinken.pl` sollte Sätze *„… nicht
vergeben“* nicht verlinken (Werkzeug); in BEFUNDE einen Satz, dass E-167 für
PRÜFER-64 K5 vorgemerkt ist, sonst vergibt `befunde-einsammeln.pl --naechste
E` die Lücke nie oder doppelt (**Vermutung**, nicht nachgesehen, wie das
Werkzeug Lücken behandelt).

## <a id="l-91.11"></a>L-91.11 — Hinweis: die README nennt ein Menü, das es in Eudora nicht gibt

**Was passiert:** die neue Zeile unter „Bekannte Fehler“ sagt *„Konto →
Eigenschaften“*. Eudora ist englisch; dieses Menü findet ein Anwender nicht.
Der TESTPLAN nennt für denselben Weg den richtigen Pfad.

* **Belegt**, `README.md:161` *„wer \*Konto → Eigenschaften\* mit OK
  schließt“* und *„vor dem Öffnen der Konto-Eigenschaften“*.
* **Belegt**, `Intern/TESTPLAN.md:24-25` *„\*Tools → Personalities\*, in der
  Liste Rechtsklick auf \*\*`<Dominant>`\*\* → \*Properties\*“*; am Quelltext
  `EudoraRes.rc:6268` *„MENUITEM "&Properties\tAlt+Enter",
  IDM_MODIFY_PERSONALITY“*, geöffnet über `PersonalityView.cpp:857`/`:906`
  (`CModifyAcctSheet`).

**Was zu tun wäre:** in der README *„\*Tools → Personalities\*, Rechtsklick
→ \*Properties\*“*. Hindert nichts.

---

## Geprüft ohne Fund

* **[E-168](../Intern/BEFUNDE.md#e-168)** (`BEFUNDE.md:383`) gegen
  `tools/TESTLAEUFE.md`: vier Läufe am 29.10. (07:04:46, 07:05:17, 07:06:13,
  07:06:58), passend zu vier `Audit.log`-Starts `2610290704`–`2610290706`
  (gemessen). Die Zeile 07:05:17 trägt keine Bau-Kennung im Fenstertitel —
  welcher der beiden Bauten dort lief, ist nicht ablesbar; die Aussage
  *„weder am Bau `+772ed08d` noch an … `+ea3ebcbd`“* stützt sich auf die
  übrigen drei. Die Herleitung *„vom Messskript ausgelöst“* ist am Stapel
  belegt (zweiter Eintritt in `OnWizardNext` über `WM_COMMAND` aus der
  modalen Schleife der Meldung) und am Programm gemessen
  (`IsWindowEnabled` 0); was genau den Absturz auslöste, nennt der Eintrag
  selbst *„nicht bekannt“*. Stufe *werkzeug* mit Gregors *„ja, so
  eintragen“*.
* **[E-124](../Intern/BEFUNDE.md#e-124) und PAKETE** (`BEFUNDE.md:370`, `Releases/PAKETE.md:173`): beide
  *„viermal“* mit denselben Zeiten, ZIP 14:11:33, Erkennungsname gleich.
  `WEITERMACHEN.md:138` sagt im Präsens *„enthält keine `EudoraRes.dll`
  mehr“*, PAKETE ergänzt *„das ZIP hat Gregor am selben Tag gelöscht“* —
  Zeitstufen verschieden, kein Widerspruch.
* **TESTPLAN, Schritt 2** (`:24-25`): *Properties* im Kontextmenü besteht
  (`EudoraRes.rc:6268`), öffnet `CModifyAcctSheet` und damit
  `CPersonality::Modify` (`ModifyAcctSheet.cpp:126`, [LEKTOR-90](LEKTOR-90.md#lektor-90) belegt).
* **README `:161`, Abhilfe** *„vor dem Öffnen … einmal beenden und neu
  starten“*: passt zum Mechanismus in [E-166](../Intern/BEFUNDE.md#e-166) (beim Beenden wird geschrieben).
* **CHANGELOG `:100-104`**, **AUFGABEN `:3`**, **TESTPLAN `:1`**: Datum und
  Quellstand stimmen mit `git log` (letzte Quelländerung `249e4f95`, 28.10.).
* **DEFENDER-FEHLALARM `:3`**: *„Stand 28.10.2026“* — die dort genannten
  Ereignisse sind vom 28.10.; dass das ZIP am 29.10. nachgezählt wurde, steht
  in [E-124](../Intern/BEFUNDE.md#e-124). Kein Fund.
* **`tools/WERKZEUGE.md:145`** (`messen-assistent-wiedereintritt.ps1`)
  stimmt mit [E-168](../Intern/BEFUNDE.md#e-168) und den vier Läufen.
* **Links auf die neue Stelle**: `README.md:166`, `Doku/ANWENDER.md:23`,
  `Intern/PORTIERUNG.md:739`, `BEFUNDE.md:212` zeigen auf
  `FILTER.md#warum-die-junk-bewertung-hier-nicht-arbeitet`; die Überschrift
  `FILTER.md:489` *„### Warum die Junk-Bewertung hier nicht arbeitet“* ergibt
  genau diesen Anker (belegt).
* **README.en.md** verweist für bekannte Fehler auf die deutsche Liste
  (`:36-38`) — keine eigene Junk-Aussage.

## Nicht geprüft

* Ob die drei Starts vom 20.10. ohne Protokollzeile echte eigene Starts waren
  oder mitkopierte Zeilen — nur die Ausgabe der Schranke gelesen
  ([L-91.1](#l-91.1)).
* Die Lizenzlage von `MFC71.DLL`/`MSVCP71.dll` — weiter ungeprüft übernommen
  ([L-90.7](LEKTOR-90.md#l-90.7)).
* Bestand ohne Bezug zu [E-166](../Intern/BEFUNDE.md#e-166), [E-168](../Intern/BEFUNDE.md#e-168), [E-124](../Intern/BEFUNDE.md#e-124), Junk, Startwege und Stand-Köpfen:
  seit [LEKTOR-90](LEKTOR-90.md#lektor-90) unverändert (gemessen: `git log --stat 116095f5..HEAD`, nur
  die oben genannten `.md`) und dort geprüft.

## <a id="gregor"></a>Was nur Gregor entscheiden kann

* **Die veröffentlichten Release-Texte `v1.0.113`, `v1.0.117` und
  `v1.0.120` auf GitHub** enthalten zusammen sieben Links auf
  `BEFUNDE.md`, die seit dem 22.10. ins Leere führen, weil die Datei nach
  `Intern/` verschoben wurde ([L-91.3](#l-91.3)). Sollen die Texte auf GitHub
  berichtigt werden? Die Abschriften im Repo kann der Hauptagent ergänzen.
* Die Frage aus [LEKTOR-90](LEKTOR-90.md#lektor-90), ob die Notiz zu `v1.0.120` um den Junk-Filter
  ergänzt wird, **entfällt** — der veröffentlichte Text zählt gar nicht auf,
  was ausfällt ([L-91.2](#l-91.2)).
* **Was vor der Marke `v7.2.1.N` getestet sein muss**
  ([L-74.10](LEKTOR-74.md#l-74.10)) und **Kriterium 0 ohne Visual Studio**
  ([L-77.3](LEKTOR-77.md#l-77.3)) — unverändert offen.
