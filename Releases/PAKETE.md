# Ausgelieferte Pakete

Was in jeder Paketfassung steckte, und ob sie startete. Ergänzt
[AUSLIEFERUNGEN.md](1.0/AUSLIEFERUNGEN.md), das nur die QCSSL.dll verfolgt.

> **Diese Buchführung ist unvollständig — Stand 22.10.2026 (Nummern bis 1.0.121 verzeichnet, geschnürt ist bis 1.0.120; 1.0.114 wurde geschnürt und bei Gregor getestet, aber **nicht veröffentlicht** — sein Lauf fand den Kurzform-Fehler aus [E-132](../Intern/BEFUNDE.md#e-132), behoben in 1.0.115; 1.0.107, 1.0.108 und 1.0.109 wurden übersetzt, aber nie geschnürt; zuletzt veröffentlicht **1.0.120** als `v1.0.120` am 21.10.2026 um 19:07:37 UTC (Marke `30feeae2`, auf GitHub *Latest*) — es trägt 1.0.118, 1.0.119 und 1.0.120 —, davor **1.0.117** als `v1.0.117` am selben Tag um 07:56:56 UTC (Marke `f546b004`), davor **1.0.113** als `v1.0.113` am 20.10.2026 um 13:01:36 UTC, davor **1.0.112** als `v1.0.112` am selben Tag um 11:55:10 UTC, davor **1.0.101** als `v1.0.101` am 17.10.2026 und **1.0.87** als `v1.0.87` am 14.10.2026; 1.0.85 und 1.0.86 nur als Testverzeichnisse bei Gregor, nicht einzeln veröffentlicht, ihr Stand steckt in 1.0.87; davor veröffentlicht 1.0.84); die Zahlen zu 1.0.66 und jünger sind am 17.09.2026 abends gemessen.** Seit dem 09.09.2026 sind **1.0.30 bis 1.0.72** dazugekommen; eigene Abschnitte stehen unten für **1.0.66 bis 1.0.72** sowie — seit dem 11.10.2026 nachgetragen — für **1.0.43**, **1.0.47** und **1.0.64**. Für die übrigen aus **1.0.30 bis 1.0.65** fehlen sie weiterhin. **Warum das zählt:** wer die nächste Fassungsnummer aus dieser Liste ableitet, greift daneben. Am 17.09.2026 haben **zwei Sitzungen gleichzeitig** die **68** vergeben, weil hier nur bis **1.0.65** verzeichnet war; die zweite musste auf **1.0.69** ausweichen. Die Liste ist keine Nebensache, sondern die Quelle, aus der die Nummer kommt. **Und sie war auch rückwärts lückenhaft:** von 14 Veröffentlichungen auf GitHub fehlten am 11.10.2026 drei hier ganz — gemeldet hat das kein Werkzeug, `tools/pruefe-release-buchfuehrung.pl` prüft nur die neueste Marke. Was in den Fassungen steckt, steht vollständig in [CHANGELOG.md](../CHANGELOG.md)
> Abschnitte gibt es unten für **1.0.27**, **1.0.23**, **1.0.22**, **1.0.21**,
> **1.0.18**, **1.0.3**, **1.0.2** und **1.0.1**. Die Pakete **1.0.4 bis
> 1.0.17**, **1.0.19**, **1.0.20** sowie **1.0.24**, **1.0.25** und **1.0.26**
> haben hier keinen eigenen Eintrag, obwohl sie gebaut und teilweise
> veröffentlicht wurden. Der Mangel ist als **M-4** in
> [PRUEFUNG-CODE.md](../Intern/PRUEFUNG-CODE.md) festgehalten und weiterhin offen.
>
> **Versioniert im Repo sind nur noch zwei ZIPs** — **am 14.09.2026 neu
> gemessen mit `git ls-files Releases/`, und die frühere Angabe stimmte
> nicht mehr**: **1.0.2** (`Eudora72-1.0.2-lauffaehig.zip`, Baugrundlage für
> `tools/paket-bauen.ps1` — **nicht löschen**) und **1.0.30**
> (`Eudora72-1.0.30-release.zip`). Bis hierher stand **1.0.27** *„die
> veröffentlichte Fassung"* — dieses ZIP ist **nicht mehr versioniert**, und
> veröffentlicht ist inzwischen **`v1.0.117`** (21.10.2026, 07:56:56 UTC, Marke `f546b004`, ZIP `Eudora72-1.0.117-release.zip`, SHA-256 `335751a9` am Anfang, auf GitHub als *Latest*; davor `v1.0.113` vom 20.10.2026, 13:01:36 UTC, Marke `ac094f15`, SHA-256 `0d1d4bf4` am Anfang; davor am selben Tag
> `v1.0.112` um 11:55 UTC; davor `v1.0.101` vom 17.10.2026, 19:12 UTC, `v1.0.87` vom 14.10.2026, 05:46 UTC, `v1.0.84` vom 12.10.2026, 12:59 UTC, `v1.0.83` vom selben Tag und `v1.0.72` vom 17.09.2026 — **berichtigt am 17.09.2026 vom LEKTOR,
> hier stand `v1.0.50`**, und am 12.10.2026 von `v1.0.72` auf `v1.0.83`,
> gemessen mit `gh release list`). Die ZIPs zu **1.0.21**, **1.0.23**
> und **1.0.24** sind ebenfalls entfernt; ihre `.sha256`-Dateien für 1.0.21
> und 1.0.22 liegen weiter im Repo, das ZIP daneben nicht. **Kein Verweis in
> dieser Datei darf auf eine dieser Dateien zeigen, als läge sie im
> Arbeitsbaum.**
>
> **Zu 1.0.30 fehlt die `.sha256`-Datei** — `git ls-files Releases/` führt
> `Eudora72-1.0.30-release.zip` ohne Begleitdatei (gemessen am 14.09.2026).
> Dasselbe galt zuvor für 1.0.27, dessen ZIP es nicht mehr gibt.
>
> **Als Marke veröffentlicht** sind `v1.0.1`, `v1.0.2`, `v1.0.3`, `v1.0.10`,
> `v1.0.14`, `v1.0.15`, `v1.0.18`, `v1.0.21`, `v1.0.23`, `v1.0.24` und
> `v1.0.27` (`git ls-remote --tags origin`, gemessen am 09.09.2026).
> **`v1.0.22`, `v1.0.25` und `v1.0.26` gibt es nicht.** Und: die
> **Veröffentlichungen** (Releases mit Dateien) zu `v1.0.18`, `v1.0.21`,
> `v1.0.23` und `v1.0.24` hat Gregor am 09.09.2026 **gelöscht** — die
> **Marken** bestehen weiter, die ZIPs hängen aber nicht mehr daran. Wer einem
> Verweis auf eine dieser Marken folgt, findet den Quellstand, **nicht** das
> Paket. Abrufbar ist als Paket nur noch **v1.0.27**.
>
> Wer wissen will, was in einem der nicht verzeichneten Pakete steckt, liest
> `CHANGELOG.md`, `git log` und `BEFUNDE.md`, nicht diese Datei.

## Drei Zählungen, und wie sie zusammenhängen

| Zählung | wo sie steht | wo man sie sieht |
|---|---|---|
| **Produktversion** `7.2.0.x` | `Eudora71/Version.h` (`EUDORA_BUILD_DESC` → String `IDS_VERSION`) | *Hilfe → Über Eudora*, Startbildschirm, und der `X-Mailer`-Kopf jeder gesendeten Mail. **Nicht** in den Dateieigenschaften: `Eudora.exe` hat gar keinen `VS_VERSION_INFO`-Block (nachgesehen am 07.09.2026 in `Eudora71/Eudora/*.rc`) |
| **Paketversion** `1.0.x` | Datei `VERSION` | Name des ZIP, Bau-Kennung in der Titelleiste |
| **QCSSL-Version** `1.0.x` | `qcssl.rc` | Versionsressource der `QCSSL.dll` |

**Verabredung: Produkt- und Paketversion haben dieselbe letzte Stelle.**
Paket 1.0.3 trägt Produktversion 7.2.0.3. `tools/kennung-erzeugen.pl` warnt,
wenn die beiden auseinanderlaufen — bei der `QCSSL.dll` sind genau so zwei
verschiedene Binärdateien unter derselben Kennung ausgeliefert worden.

Die QCSSL-Zählung läuft bewusst eigenständig: sie folgt den Quellen der
TLS-Schicht, nicht dem Paket. Paket 1.0.3 enthält QCSSL 1.0.1, weil sich
dort seit 1.0.1 nichts geändert hat.

### Wie man die Version hebt — nachgemessen am 07.09.2026

Für die nächste Nummer sind es **fünf Zeilen in zwei Dateien**. Beispiel: von
**1.0.18 / 7.2.0.18** auf **1.0.19 / 7.2.0.19**.

| Datei | Zeile | von | auf |
|---|---|---|---|
| `VERSION` | 1 | `1.0.18` | `1.0.19` |
| `Eudora71/Version.h` | `EUDORA_VERSION4` | `18` | `19` |
| `Eudora71/Version.h` | `EUDORA_BUILD_NUMBER` | `7,2,0,18` | `7,2,0,19` |
| `Eudora71/Version.h` | `EUDORA_BUILD_DESC` | `"Version 7.2.0.18\0"` | `…7.2.0.19\0` |
| `Eudora71/Version.h` | `EUDORA_BUILD_VERSION` | `"7.2.0.18"` | `"7.2.0.19"` |

> **`EUDORA_BUILD_NUMBER` ist seit 7.2.0.13 nicht mitgezogen worden** und steht
> am 07.09.2026 auf `7,2,0,12`, während die drei anderen Angaben auf `18`
> stehen. Kein Werkzeug hat das gemeldet: `tools/ausliefern.pl --pruefen` und
> `tools/kennung-erzeugen.pl` vergleichen nur `EUDORA_BUILD_VERSION` gegen
> `VERSION`. Folgenlos ist es nur, weil das Makro derzeit **nirgends benutzt**
> wird (`grep -rn EUDORA_BUILD_NUMBER Eudora71/` — ein Treffer, die Definition
> selbst); wer es je in eine `VERSIONINFO`-Ressource einsetzt, bekommt eine
> `Eudora.exe`, deren Dateiversion nicht zu ihrer Produktversion passt.
> **`tools/doku-pruefen.pl` meldet den Fall seit dem 07.09.2026.**
>
> **Und er ist am 08.09.2026 gleich wieder aufgetreten:** beim Heben auf
> 7.2.0.23 blieb `EUDORA_BUILD_NUMBER` auf `7,2,0,22` stehen, während die
> anderen vier Angaben auf `23` gingen — vier von fünf Zeilen. Gemeldet hat es
> `tools/doku-pruefen.pl` unter *Zu tun am Quellstand*, berichtigt am
> 08.09.2026. **Wer die Version hebt, geht die Tabelle oben Zeile für Zeile
> durch; „ich weiß, welche es sind" hat jetzt zweimal nicht gereicht.**

Den aktuellen Ausgangswert liest man nicht ab, sondern misst ihn:

```sh
cat VERSION                                          # Paketnummer
grep EUDORA_BUILD_VERSION Eudora71/Version.h         # Produktversion
perl tools/ausliefern.pl --pruefen                   # beides gegeneinander
```

**Die vier Angaben in `Version.h` sind NICHT voneinander abgeleitet** — jede
steht für sich. Wer nur `EUDORA_VERSION4` ändert, hebt die Version an keiner
sichtbaren Stelle; wer nur die Zeichenketten ändert, bekommt eine EXE, deren
Dateiversion nicht zu ihrem Über-Dialog passt. Das ist die Falle.

**`EUDORA_BUILD_MONTH` bleibt unangetastet.** Es steht auf Juni 2006
(`REG_EUD_CLIENT_7_1_MONTH`) und ist keine Versionsangabe, sondern der Monat,
gegen den Registrierungscodes ablaufen. Ein Hochsetzen entwertet **jeden**
existierenden Eudora-Code und startet die Testfrist neu — Befund PR-2.8.

**Wo die Zahl danach sichtbar wird** (gemessen, nicht vermutet):

| Stelle | woraus |
|---|---|
| Dateiversion und Produktversion im Explorer, Reiter *Details* | `EUDORA_BUILD_NUMBER` über `Eudora71/VersionBeg.inc` (`FILEVERSION`, `PRODUCTVERSION`) |
| Versionsressource `FileVersion` / `ProductVersion` | `EUDORA_BUILD_VERSION`, dieselbe `.inc` |
| *Hilfe → Über Eudora* und der Startbildschirm | `EUDORA_BUILD_DESC` über `IDS_VERSION` in `EudoraExeVer.rc:13` und `EudoraResVer.rc:17` |
| `guiutils.cpp:2362`, `msgdoc.cpp:1341` | `EUDORA_BUILD_VERSION` |
| Absturzbericht | `ExceptionHandler.cpp:344` und `:497` |
| `User-Agent` des PlaylistClient (`Eudora/7.2.0.3`) | drei Stellen unter `PlaylistClient/plstclnt_dll` |
| Vergleich mit `RetailVersion` in der `Eudora.ini` | `QCSharewareManager.cpp:1323`, zurückgeschrieben in `:1326` |
| als Zahl | `eudora.cpp:551`, `:1069`, `QComApplication.cpp:610` (`EUDORA_VERSION4`) |

Die Bau-Kennung in der Titelleiste ist davon unabhängig: sie kommt aus
`tools/kennung-erzeugen.pl` und enthält **Produktversion, Paketversion und
Commit**. Sie ist damit die einzige Angabe, die zwei Bauten derselben Version
unterscheidet — **und genau sie fehlt, solange kein Postfach offen ist**
(Befund E-7). In dem Zustand, in dem der Absturz auftrat, sagt der Titel nur
„Eudora".

Die Paketversion und die QCSSL-Version sind **verschiedene Zählungen**. Paket
1.0.2 enthält QCSSL 1.0.1, weil sich die QCSSL-Quellen seit 1.0.1 nicht geändert
haben.

> ### Ein veröffentlichtes Paket wird nicht ersetzt (Befund V-1)
>
> Muss etwas hinterher, bekommt es die **nächste Nummer**. Am 31.08.2026 ist das
> **verletzt** worden: unter `v1.0.3` hängen zwei verschiedene ZIPs. Damit
> identifiziert die Angabe „Version 1.0.3" das Programm nicht mehr, und ein
> Fehlerbericht von außen ist keinem Bau zuzuordnen. (Womit sich die beiden
> unterscheiden, stand hier als *„die Behebung von E-11"* — E-11 ist
> zurückgenommen, siehe den Kasten weiter unten.)
>
> **Das ist derselbe Fehler, den diese Datei bei der `QCSSL.dll` schon
> dokumentiert** (zwei Binärdateien unter „QCSSL 1.0.0", siehe
> [AUSLIEFERUNGEN.md](1.0/AUSLIEFERUNGEN.md), erster Absatz). Die Lehre stand in
> der Datei über die DLL, nicht in der über die Pakete — jetzt steht sie hier.
>
> Zurückziehen ja, überschreiben nein. Das gilt besonders, wenn die alte Fassung
> fehlerhaft ist: gerade dann muss man sie später noch benennen können.

> **Zur Benennung.** Beide ZIP-Dateien tragen im Namen das Wort `lauffaehig`.
> Nach [ZIEL.md](../ZIEL.md) ist das für keine der beiden zutreffend: 1.0.1 startet
> gar nicht, 1.0.2 erfüllte damals nur eines der Kriterien. Die Namen bleiben stehen,
> weil beide Pakete unter diesem Namen veröffentlicht sind und die Prüfsummen sonst
> nicht mehr zuzuordnen wären. **Künftige Pakete heißen nach ihrem tatsächlichen
> Stand.**

## 1.0.121

**Nur übersetzt am 22.10.2026, nicht geschnürt.** Die Nummer ist vergeben, weil der
Quellstand auf **7.2.0.121** gehoben wurde ([E-111](../Intern/BEFUNDE.md#e-111):
`resolve_URL` schreibt nicht mehr über das Zielfeld hinaus, 246 Tests, 246
bestanden, mit Gegenprobe). Es gibt kein ZIP und kein Testverzeichnis bei
Gregor; der Eintrag steht hier, damit die Nummer nicht ein zweites Mal
vergeben wird.

## 1.0.120 — geschnürt am 21.10.2026 um 14:14 nach `C:\Users\Gregor\Eudora72-1.0.120-release`, Quellstand 7.2.0.120, Zweig `e-135-vervollstaendigungsbox`

| | |
|---|---|
| Testverzeichnis | bereitgestellt am 21.10.2026 um 14:14, `C:\Users\Gregor\Eudora72-1.0.120-release`. ZIP `Releases/Eudora72-1.0.120-release.zip`, **9 381 870 Byte**, SHA-256 `26fde41437ae159659675f73cef9037a87aff755e3f71ca5a4bc084a3af6a6a1` — mit `Get-FileHash` an der Datei selbst gemessen, nicht aus dem Bauprotokoll übernommen. Die `Eudora.exe` im Paket ist byte-gleich mit der im Bauverzeichnis (MD5 `C93AEE9B`, Fassung 7.2.0.120, 21.10.2026 14:14:01). `paket-pruefen.ps1`: **keine Fehler**, Kriterium 0 *JA*, 0 Defender-Funde, 4 bekannte Warnungen wie in 1.0.119 |
| Inhalt | wie 1.0.119, dazu [E-135](../Intern/BEFUNDE.md#e-135): **die Vervollständigungsbox im `To:`-Feld schrumpft nicht mehr bei jedem Cursor-Schritt.** `ReCalcACListBoxPos` (`AutoCompleteSearcher.cpp:530`) las mit `GetClientRect` das Innenmaß und setzte daraus über `MoveWindow` das Außenmaß, plus sechs Pixel; gemessen ist der nichtklientische Rand **14** Pixel, und gerufen wird **zweimal** je Cursor-Schritt. Jetzt Außenmaß gegen Außenmaß, wie es `InitList` von Anfang an machte. Dazu [PRÜFER-43 K9](../Befunde/PRUEFER-43.md#k9) als **Sicherung** in `nicktree.cpp:2941` |
| Gemessen | **Am eigenen Prüfstand nachgestellt, vorher rot.** `tools/messen-e135.ps1` unter `tools/testlauf.ps1`, Prüfstand `C:\Temp\E135-box` mit fünf Kurznamen gleichen Anfangs, je sechs Cursor-Schritte, zwei nachweislich verschiedene EXE (MD5 `b50d9136` gegen `1158d27c`). Vorher: 100×62, 84×46, 68×30, 52×14, 36×14, 20×14. Nachher: **sechsmal 108×70**. Bau Release 0 Fehler, **243 Tests, 243 bestanden** |
| Offen | Die Testsuite deckt diesen Weg **nicht** ab. **K9 ist nicht gemessen:** die von [PRÜFER-43](../Befunde/PRUEFER-43.md#k9) vorhergesagte Wirkung — Rechtsklick wählt nicht aus, Kontextmenü ausgegraut — war an fünf Klickhöhen in **beiden** Fassungen nicht nachstellbar (`tools/messen-k9.ps1`); die Zeile bleibt als Sicherung drin. Ebenfalls offen: `InitList` rechnet ohne `ScreenToClient`, `ReCalcACListBoxPos` mit — ob das ein zweiter Fehler ist, ist nicht gemessen |
| Veröffentlicht | als **`v1.0.120`** am 21.10.2026 um **19:07:37 UTC** (= 21:07:37 Ortszeit), Marke auf **`30feeae2`**, auf GitHub *Latest*: https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.120 — Anhang `Eudora72-1.0.120-release.zip`, **9 381 870 Byte**, SHA-256 `26fde41437ae159659675f73cef9037a87aff755e3f71ca5a4bc084a3af6a6a1`, am Anhang gemessen mit `gh release view v1.0.120 --json assets` und byte-gleich mit dem ZIP im Arbeitsbaum. **Es trägt drei Fassungen:** 7.2.0.118, 7.2.0.119 und 7.2.0.120 — 1.0.118 und 1.0.119 haben kein eigenes Release bekommen. Freigabe von Gregor: *„ich habe ja schon alles getestet."* **Nachgetragen am 21.10.2026 abends vom LEKTOR** ([L-49.5](../Befunde/LEKTOR-49.md#l-49.5)): die Zeile fehlte hier, obwohl die Abschnitte 1.0.112 und 1.0.113 sie führen |

## 1.0.119 — geschnürt am 21.10.2026 nach `C:\Users\Gregor\Eudora72-1.0.119-release`, Quellstand 7.2.0.119, Zweig `e-134-adressbuch-auswahl`

| | |
|---|---|
| Testverzeichnis | bereitgestellt am 21.10.2026 um 13:07, `C:\Users\Gregor\Eudora72-1.0.119-release`. ZIP `Releases/Eudora72-1.0.119-release.zip`, **9 382 180 Byte**, SHA-256 `c39e475d16fc11cb8b503aff2fe410472eadb22cdabda3d50e5375f0404bfd2b` — an der Datei selbst gemessen, nicht aus dem Bauprotokoll übernommen. Die `Eudora.exe` im Paket ist byte-gleich mit der im Bauverzeichnis (MD5 `B50D9136`, 3 020 800 Byte, 21.10.2026 13:07:21, Fassung 7.2.0.119). `paket-pruefen.ps1`: **keine Fehler**, Kriterium 0 *JA*, 34 Dateien, 0 Defender-Funde, 4 bekannte Warnungen wie in 1.0.118 |
| Inhalt | wie 1.0.118, dazu [E-134](../Intern/BEFUNDE.md#e-134): **ein neuer Adressbucheintrag nimmt den eingetippten Kurznamen an.** `CTreeCtrl::SelectItem()` tut **nichts**, wenn das Element schon die Karette trägt — auch dann nicht, wenn ein `DoDeselectAll()` davor `TVIS_SELECTED` gelöscht hat. `AddNewNickname` und `NicknameWasChanged` verlassen sich darauf, dass `SelectItem()` auswählt; letztere läuft bei **jedem** Tastendruck im Namensfeld und hat die Karette also immer schon dort. Beide ziehen den Zustand jetzt mit `DoSelectItem(…, TRUE)` nach. Dazu ein zweites, unabhängiges Stück: das `return` in `NicknameEditChanged` griff **immer**, wenn sich der Name geändert hatte, und `ASSERT(0)` daneben ist im Freigabebau nichts |
| Gemessen | **Am eigenen Prüfstand nachgestellt, vorher rot.** Je drei Läufe mit frischem Prüfstand, Prüfgröße `Mailverzeichnis\NNdbase.txt` nach *New* → `hans` eintippen → Fokus weg → beenden. Das ausgelieferte **1.0.118** schreibt dreimal `alias Untitled` — der Fehler, wie Gregor ihn gemeldet hat. **Diese Fassung** schreibt dreimal `alias hans`. Im Code abgelesen: *„nach SelectItem allein: NICHT ausgewaehlt"*, *„nach DoSelectItem: ausgewaehlt"*, `Auswahl im Baum` von `(0)` auf `(1)`. Bau Release 0 Fehler, **243 Tests, 243 bestanden** |
| Offen | Die Testsuite deckt diesen Weg **nicht** ab; der Beleg ist die Messung am laufenden Programm. **Neu offen seit [PRÜFER-43](../Befunde/PRUEFER-43.md):** *warum* die Karette in diesem Bau schon auf dem neuen Eintrag steht, wo sie es in Hermes nicht tat. Die zuerst hier genannte Vermutung *„Fassung der Common Controls oder der MFC"* ist **widerlegt** — PRÜFER hat `TVM_SELECTITEM`/`TVGN_CARET` an einem eigenen Baumsteuerelement mit denselben Stilbits gemessen, dasselbe Programm zweimal gebunden (comctl32 **5.82** ohne Manifest und **6.16** mit), **beide Fassungen verhalten sich gleich**. Weiter offen: [K9](../Befunde/PRUEFER-43.md#k9) — `OnRightButtonDown` (`nicktree.cpp:2941`) trägt denselben Fehlerfall wortwörtlich, Rechtsklick wählt nicht aus und das Kontextmenü bleibt ausgegraut; **nicht gemessen**, deshalb nicht vor diesem Paket eingebaut. Der Quelltext von `nickview.cpp/.h`, `nicktree.cpp/.h` und `Eudora.manifest` ist seit dem initial commit **von uns nie angefasst** worden — eine Portierungsfolge ohne eigene Zeile, passend zu Gregors Hinweis, dass es in Hermes ging |

## 1.0.118 — geschnürt am 21.10.2026 nach `C:\Users\Gregor\Eudora72-1.0.118-release`, Quellstand 7.2.0.118, Zweig `e-132-rueckfrage-fehlschlag`

| | |
|---|---|
| Testverzeichnis | bereitgestellt am 21.10.2026, `C:\Users\Gregor\Eudora72-1.0.118-release`, mit `TESTEN.txt` |
| Inhalt | wie 1.0.117, dazu vier Behebungen aus [PRÜFER-42](../Befunde/PRUEFER-42.md), von ihm selbst eingebaut: **eine fehlgeschlagene Rückfrage** gab 0 zurück und fiel damit in den *Ja*-Zweig — Eudora übernahm das fremde Verzeichnis und schrieb *„fremdes bewusst uebernommen"* ins Protokoll; **ein gemerktes *Ja*** sperrte unsichtbar ein, der Über-Dialog nennt den Merker jetzt samt der Zeile, die ihn löscht; ab ~243 Zeichen Programmpfad wurde das **schließende** Anführungszeichen abgeschnitten (halb geklammert ist schlechter als gar nicht); zwei Grenzfälle in `TestE132.cpp` nachgetragen |
| Gemessen, **am laufenden Programm** | Prüfstand `C:\Temp\Eudora Pruefstand 116` (Kurzform `C:\Temp\EUDORA~1`, mit Leerzeichen) gegen `C:\Temp\Fremd mit INI`. **Erster Start, Antwort *Ja*:** Rückfrage, `fremdes bewusst uebernommen`, Merker `E132Angenommen=C:\Temp\Fremd mit INI` in der `DEudora.ini`, das Protokoll landet im fremden Verzeichnis und dessen `Eudora.ini` ändert sich — so gewollt, der Anwender hat *Ja* gesagt. **Zweiter Start:** **keine Rückfrage**, und im Protokoll steht jetzt, warum — `gemerkte Antwort Ja fuer "C:\Temp\Fremd mit INI"` und `fremdes uebernommen, gemerkte Antwort Ja`. Vorher stand dort nichts; genau das war der Fund. Bau Release 0 Fehler, **243 Tests, 243 bestanden**; Gegenprobe von PRÜFER: die neue Prüfung umgedreht → 242 von 243, zurück → 243 von 243 |
| Verhältnis zu v1.0.117 | **`v1.0.117` ist das veröffentlichte Release** (21.10.2026, 07:56:56 UTC). Diese vier Behebungen hängen nicht an seinem Urteil — PRÜFER-42 sagte *„JA, v1.0.117 geht so raus"* — aber zwei davon sollten nicht offen bleiben, und der Melder aus [Issue #102](https://github.com/HansWurst81675/Eudora7.2/issues/102) ist genau der Mensch, den der unsichtbare Merker träfe |

## 1.0.117 — geschnürt am 21.10.2026 nach `C:\Users\Gregor\Eudora72-1.0.117-release`, Quellstand 7.2.0.117, Zweig `e-132-startwege-und-merker`

| | |
|---|---|
| Testverzeichnis | bereitgestellt am 21.10.2026, `C:\Users\Gregor\Eudora72-1.0.117-release`, mit `TESTEN.txt` |
| ZIP und Prüfsumme | `Eudora72-1.0.117-release.zip`, 9.382.044 Byte, geschnürt am 21.10.2026 um 09:14. SHA-256 `335751a91ca67b7996c4076f077deb49a0f4ce4ac1de74c8a079cc2cb7eeb1a1` — am 21.10.2026 mit `sha256sum` an der Datei selbst nachgemessen ([LEKTOR-46](../Befunde/LEKTOR-46.md#l-46.3)). Release-Notizen: [1.0.117/RELEASE-NOTIZEN.md](1.0.117/RELEASE-NOTIZEN.md). **Noch nicht veröffentlicht** — veröffentlicht war damals `v1.0.113`; draußen ist seit dem 21.10.2026 `v1.0.117` |
| Inhalt | wie 1.0.116, dazu zwei Funde aus [PRÜFER-41](../Befunde/PRUEFER-41.md): **eine kopierte Sicherung ohne `Eudora.ini`** wurde ungefragt übernommen — gefragt wurde nur, wenn dort eine INI lag, obwohl Eudora danach Postfächer, `Attach\` und `Embedded\` hineinschreibt; jetzt genügt irgendeine Spur einer Einrichtung. Und die Zeile *„Mail folder from"* im Über-Dialog **log auf vier Wegen**, darunter der häufigste überhaupt (`Eudora.ini` neben der EXE → *„(unbekannt)"* statt *Programmverzeichnis*) |
| Warum nicht 1.0.116 | **1.0.116 liegt bereits bei Gregor** und enthält diese beiden Behebungen nicht. Zwei Stände unter demselben Namen machen jede spätere Messung wertlos ([version-eindeutig-machen](../Arbeitsweise/version-eindeutig-machen.md)) |
| Veröffentlicht | als **`v1.0.117`** am 21.10.2026 um **07:56:56 UTC**, Marke auf **`f546b004`** (Merge von PR #123): https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.117 — Anhang `Eudora72-1.0.117-release.zip`, **9 382 044 Byte**, SHA-256 `335751a91ca67b7996c4076f077deb49a0f4ce4ac1de74c8a079cc2cb7eeb1a1`, am Anhang gemessen mit `gh release view v1.0.117 --json assets`. **Nicht mehr *Latest*** — am selben Tag von `v1.0.120` abgelöst. Freigabe von Gregor: *„ja, release 1.0.117 auf github"* |
| Gemessen, **rot und grün am laufenden Programm** | Prüfstand `C:\Temp\Eudora Pruefstand 116` (Kurzform `C:\Temp\EUDORA~1`, **mit Leerzeichen im Pfad**) gegen ein fremdes Verzeichnis **ohne `Eudora.ini`**: `C:\Temp\Sicherung ohne INI` mit `In.mbx` und `Attach\` — der Fall einer kopierten Sicherung. **an 1.0.116 rot:** keine Rückfrage, und Eudora schreibt in 90 Sekunden **29 Einträge** in die fremde Sicherung, darunter eine **neue `Eudora.ini`**, `Out.mbx`, `Trash.mbx`, `Junk.mbx`, `descmap.pce`, `OWNER.LOK` und die Verzeichnisse `Attach\`, `Embedded\`, `Filters\`, `Nickname\`, `Sigs\`, `Stationery\`. **an 1.0.117 grün:** `gefunden="C:\Temp\Sicherung ohne INI" … da=1 … fremd=1`, Rückfrage, nach *Nein* `eigenes gewaehlt="…\Mailverzeichnis"`. Damit ist belegt, was Gregors Anforderung vom 20.10.2026 verlangt: *„die alte version von eudora sollte weiterhin funktionieren und keinen schaden bekommen"* — eine Sicherung ist eine vorhandene Installation. Bau Release 0 Fehler, **243 Tests, 243 bestanden**, `Eudora.exe` im Paket byteidentisch mit `Bin\Release`, keine Debug-Laufzeit, Defender 0 Funde |

## 1.0.116 — geschnürt am 21.10.2026 nach `C:\Users\Gregor\Eudora72-1.0.116-release`, Quellstand 7.2.0.116, Zweig `e-132-startwege-und-merker`

| | |
|---|---|
| Testverzeichnis | bereitgestellt am 21.10.2026, `C:\Users\Gregor\Eudora72-1.0.116-release`, mit `TESTEN.txt` |
| Inhalt | wie 1.0.115, dazu [E-132](../Intern/BEFUNDE.md#e-132) dritter Teil aus [PRÜFER-41](../Befunde/PRUEFER-41.md): **K1** — die Rückfrage kam nur auf **einem von drei** Startwegen, weil `ExecutableDir` sonst leer ist (betroffen `mailto:`, Postfachdateien, Briefpapier, gezogene Anhänge; im Protokoll stand dann `eigenes="" fremd=0`, was wie eine Entwarnung aussieht); **K2** — mit einem Leerzeichen im Programmpfad startete Eudora nach *Nein* gar nicht mehr, und *Nein* ist die Vorgabe; **K7** — *Copy info* meldete „Copied" auch dann, wenn nichts in der Zwischenablage stand. Dazu auf Gregors Ansage *„ja, merken"*: die Antwort wird je fremdem Verzeichnis in der `DEudora.ini` gemerkt (`E132Abgelehnt` / `E132Angenommen`), *Abbrechen* nicht |
| Gemessen, **rot und grün** | Derselbe Prüfstand `C:\Temp\Eudora Pruefstand 116` — Kurzform `C:\Temp\EUDORA~1`, **mit Leerzeichen im Pfad**, Aufbau wie in unseren Paketen —, derselbe Handgriff: starten, *Nein* drücken, dreißig Sekunden **zusehen ohne einzugreifen**. **an 1.0.115 rot:** es erscheint ein Fenster *Eudora* mit der Fehlermeldung, und im `Mailverzeichnis` entsteht **kein Protokoll** — Eudora kommt gar nicht hoch. **an 1.0.116 grün:** die Rückfrage, dann das Programmfenster, und das **Protokoll ist da**. Dazu: der Pfad steht ausgeschrieben im Protokoll, der zweite Start fragt nicht mehr (`gemerkte Antwort Nein fuer …`), die fremde `Eudora.ini` bleibt SHA-256-gleich. **243 Tests, 243 bestanden**, Bau Release 0 Fehler. **Der erste Versuch war kein Beweis:** das Messskript beendete den Prozess am Ende selbst, und dann ist nicht mehr zu unterscheiden, ob Eudora von allein gestorben ist oder ob ich es umgebracht habe — deshalb greift der zweite Lauf nicht ein |
| Nach dem Paket eingebaut | [PRÜFER-41](../Befunde/PRUEFER-41.md) **K5** — gefragt wurde nur, wenn im fremden Verzeichnis eine `Eudora.ini` liegt. Nach *Ja* legt Eudora dort aber `Attach\`, `Embedded\`, Postfächer und beim Beenden eine frische `Eudora.ini` an; eine kopierte **Sicherung ohne INI** wurde also ungefragt in Besitz genommen. Jetzt genügt irgendeine Spur einer Einrichtung (`Eudora.ini`, `In.mbx`, `Attach\`, `Embedded\`), und nachgesehen wird in dem Verzeichnis, über das auch entschieden wird — vorher wurde `szIni` geprüft und `szVerzeichnis` benutzt. **K6** — die Zeile *„Mail folder from"* im Über-Dialog log auf vier Wegen, darunter der häufigste überhaupt: liegt eine `Eudora.ini` neben der EXE, sagte sie *„(unbekannt)"*, obwohl die Antwort *Programmverzeichnis* feststeht. **Beides ist im Quelltext, aber NICHT im Paket 1.0.116** |
| Warum es diesen Prüfstand braucht | `C:\Temp\E132` hat **keine** 8.3-Kurzform und **kein** Leerzeichen und fährt nur den Startweg mit leerer Befehlszeile. Drei grüne Messungen dort, und der Fehler war trotzdem da — gefunden hat ihn Gregor am laufenden 1.0.114. Seit dem 21.10.2026 prüft `tools/pruefe-pruefstand-pfad.pl` einen Prüfpfad auf genau diese drei Lagen |

## 1.0.115 — geschnürt am 21.10.2026 nach `C:\Users\Gregor\Eudora72-1.0.115-release`, Quellstand 7.2.0.115, Zweig `release_1.0.115`

| | |
|---|---|
| Testverzeichnis | bereitgestellt am 21.10.2026, `C:\Users\Gregor\Eudora72-1.0.115-release`, mit `TESTEN.txt` |
| Inhalt | wie 1.0.114, dazu die **zweite** Behebung zu [E-132](../Intern/BEFUNDE.md#e-132): Eudora hielt sein **eigenes** Mailverzeichnis für fremd und fragte bei jedem Start. Die Registry trägt die 8.3-Kurzform (`EUDORA~1.114`), `ExecutableDir` die Langform; `E132LangerPfad` löst jetzt beide Seiten auf, und der Dialog zeigt den ganzen Pfad. Dazu der Präfix ohne Grenze (`C:\Eudora` schluckte `C:\Eudora2`) |
| Gemessen | **Von Gregor am 21.10.2026 an 1.0.115 bestätigt:** *„2x nacheinander starten verhält sich jetzt korrekt"*, und im Dialog steht der ausgeschriebene Pfad statt `EUDORA~1.113`. Er hat ausserdem nachgewiesen, dass die Rückfrage **wiederkommt**, wenn dazwischen 1.0.114 läuft — das ist richtig so, 1.0.114 ist aus Sicht von 1.0.115 eine fremde Installation. **243 Tests, 243 bestanden**, Bau Release 0 Fehler, `Eudora.exe` im Paket byteidentisch mit `Bin\Release`, keine Debug-Laufzeit, Defender 0 Funde |
| Gefunden hat beides Gregor | 1.0.114 lag zwei Minuten bei ihm. Mein Prüfstand lag in `C:\Temp\E132` — **zu kurz für einen 8.3-Alias**, und hat den Fehler dadurch weggemessen. Alle drei Messungen am laufenden Programm waren grün, und der Fehler war trotzdem da |
| Nach dem Paket eingebaut | [PRÜFER-41](../Befunde/PRUEFER-41.md) K1 (die Rückfrage gab es nur auf **einem von drei** Startwegen, weil `ExecutableDir` sonst leer ist) und K2 (mit einem Leerzeichen im Programmpfad startete Eudora nach *Nein* **gar nicht mehr** — und *Nein* ist die Vorgabe). **Beide sind im Quelltext, aber NICHT im Paket 1.0.115** |

## 1.0.114 — geschnürt am 21.10.2026, Quellstand 7.2.0.114, Zweig `e-132-fremdes-mailverzeichnis` — **an Gregors Lauf gescheitert, nicht veröffentlicht**

> **Berichtigt am 21.10.2026 ([LEKTOR-46](../Befunde/LEKTOR-46.md#l-46.4)).**
> Hier stand *„Diese Nummer ist vergeben, das Paket gibt es noch nicht"* mit
> einer Messung vom selben Tag. Die ist überholt, und zwar in jedem Punkt:
> `Eudora72-1.0.114-release.zip` liegt seit dem 21.10.2026 um 07:07 in
> `Releases/` (9.380.859 Byte), bei Gregor standen an diesem Tag außerdem
> 1.0.115, 1.0.116 und 1.0.117 — die Aufzählung *„dort stehen 1.0.110 bis
> 1.0.113"* war falsch —, und die SHA-256 in den
> [Release-Notizen](1.0.114/RELEASE-NOTIZEN.md) war kein Platzhalter mehr,
> sondern die Prüfsumme **eines fremden Pakets**
> ([L-46.3](../Befunde/LEKTOR-46.md#l-46.3)).
>
> **Was gilt:** 1.0.114 ist geschnürt und lag zwei Minuten bei Gregor. Sein
> Lauf hat es zu Fall gebracht — Eudora hielt sein **eigenes** Mailverzeichnis
> für fremd (8.3-Kurzform gegen Langform), behoben in 7.2.0.115. **Es gibt
> kein Tag `v1.0.114` und keine Veröffentlichung, und es wird keine geben;**
> veröffentlicht wird 1.0.117. Die Zeile *Gemessen* unten gehört zum
> Quellstand 7.2.0.114. Bis zum 20.10.2026 stand in der Überschrift
> *geschnürt am 20.10.2026* mit einem Testverzeichnis, das es nicht gab — eine
> Anleitung, der niemand folgen kann
> ([LEKTOR-44](../Befunde/LEKTOR-44.md#l-44.5),
> [LEKTOR-45](../Befunde/LEKTOR-45.md#l-45.2)).

| | |
|---|---|
| Testverzeichnis | `C:\Users\Gregor\Eudora72-1.0.114-release`, am 21.10.2026 bereitgestellt. **Steht heute nicht mehr bei ihm** (gemessen am 21.10.2026: dort liegen 1.0.110 bis 1.0.113 und 1.0.115 bis 1.0.117); wer es entfernt hat, ist nicht gemessen |
| Inhalt | wie 1.0.113, dazu: [E-132](../Intern/BEFUNDE.md#e-132) behoben — Eudora fragt, bevor es das Mailverzeichnis einer **fremden** Installation übernimmt, die es über die Registry gefunden hat. Vorgabe ist *Nein* (eigenes Verzeichnis anlegen), damit ein unbedachtes Enter nichts beschädigt. Dazu zwei Dinge, die erst die Messung gezeigt hat: `E132AufrufZerlegen` trennt die **zwei** Pfade, die in der Registry in **einer** Zeichenkette stehen, und die Spurmarken werden gemerkt, bis das Protokoll offen ist — vorher konnten sie gar nicht geschrieben werden |
| Gemessen | **am laufenden Programm, auf allen drei Wegen** (20.10.2026, `C:\Temp\E132` gegen die fremde Installation `C:\Temp\E131`; die Antwort kam als `WM_COMMAND` an ein gemessenes Fensterhandle). *Nein:* `fremd=1`, danach `eigenes gewaehlt="C:\Temp\E132\Mailverzeichnis"`, fremde `Eudora.ini` SHA-256 unverändert. *Ja:* `fremdes bewusst uebernommen`, das Protokoll landet im **fremden** Verzeichnis und dessen `Eudora.ini` ändert sich nach fünfzehn Sekunden (`LastKnownCrashInfo=0` → `=1`) — genau der Schaden aus [Issue #102](https://github.com/HansWurst81675/Eudora7.2/issues/102). *Abbrechen:* das Programm endet, nichts wird angefasst. **Gegenprobe:** zeigt die Registry auf das eigene Paket, steht `fremd=0` und es wird nicht gefragt. **241 Tests, 241 bestanden**, Bau Release 0 Fehler |
| Defender | **1.0.113 wurde am 20.10.2026 um 20:33:12 beim Starten eingezogen** (`Trojan:Win32/Bearfoos.A!ml`, Signaturstand 1.461.115.0) — dritter betroffener Bau nach 1.0.98 (16.10.) und 1.0.111 (20.10., 13:17:28, acht Minuten nach einer Prüfung mit 0 Funden; gemessen und in der Commit-Nachricht von `0f4b2b1a` festgehalten). Nach **Erkennungen** gezählt ist es der vierte Fall, und um 20:45:19 kam ein fuenfter dazu. Ein gezielter Scan derselben Datei meldet **nichts**; der Fund kommt beim **Ausführen**. Die Meldung an Microsoft liegt fertig ausgefüllt in [DEFENDER-FEHLALARM.md](DEFENDER-FEHLALARM.md); absenden muss sie ein Mensch, das Formular verlangt ein CAPTCHA ([E-124](../Intern/BEFUNDE.md#e-124)) |

## 1.0.113 — geschnürt am 20.10.2026 nach `C:\Users\Gregor\Eudora72-1.0.113-release`, Quellstand 7.2.0.113, Zweig `e-131-leistenposition`

| | |
|---|---|
| Testverzeichnis | bereitgestellt am 20.10.2026, `C:\Users\Gregor\Eudora72-1.0.113-release`, mit `TESTEN.txt` |
| Inhalt | wie 1.0.112, dazu: [E-131](../Intern/BEFUNDE.md#e-131) behoben — keine ungültige Fensterposition mehr in der `Eudora.ini`, die eine daneben installierte Eudora/Hermes 7.1 beim Start abstürzen ließ |
| Gemessen | **rot:** ein einziges Starten und Beenden von 7.2.0.112 im Prüfverzeichnis schrieb `MRUFloatXPos=-2147483648` **dreimal** in die INI, die von 3249 auf 6480 Byte wuchs. **grün:** nach der Behebung `E-131 Leistenposition: abschnitte-mit-eintrag=5 berichtigt=5`, danach `MRUFloatXPos=40` und **null** Treffer für `INT_MIN`; beim zweiten Lauf dasselbe. **234 Tests, 234 bestanden** (fünf neue, darunter die Gegenprobe, dass gewöhnliche Positionen unangetastet bleiben). Bau Release 0 Fehler. **Offen bleibt der Leseweg** — eine bereits kaputte INI wird erst beim nächsten Sichern berichtigt |
| Veröffentlicht | als **`v1.0.113`** am 20.10.2026 um **13:01:36 UTC**, Marke auf **`ac094f15`** (Merge von PR **#117**), Anhang **`Eudora72-1.0.113-release.zip`**, SHA-256 `0d1d4bf43eab8323f2ce3ad2ff1c78f44af5c7adf7a84e979334aab5687f4772`. **Am 20.10.2026 vom CHRONIST nachgetragen und gegen `gh release view v1.0.113` sowie `git rev-parse v1.0.113^{commit}` gemessen** — die Zeile fehlte, und `WEITERMACHEN.md:45` schrieb dieser Fassung stattdessen die Angaben von 1.0.112 zu (11:55:10 UTC, `f87a4a74`, PR #113, SHA `0406c108…`). Dadurch wies `doku-pruefen.pl` auf `origin/main` jeden Commit und jeden Push ab. **Noch offen:** der Abschnitt zu 1.0.112 unten beansprucht dieselbe Marke; gemessen ist, dass der veröffentlichte Anhang und seine Prüfsumme zu **1.0.113** gehören ([CHRONIST-2026-10-20b](../Befunde/CHRONIST-2026-10-20b.md), Punkt 6b) |
| Defender | vor dem Hochladen geprüft: **34 Dateien, 0 Funde**. **Das war kein Freispruch:** am 20.10.2026 um **20:33:12** zog Defender `C:\Users\Gregor\Eudora72-1.0.113-release\Eudora.exe` **beim Starten** ein (`Trojan:Win32/Bearfoos.A!ml`, Signaturstand 1.461.115.0), Gregor hat sie aus der Quarantäne geholt; um **20:45:19** traf es dieselbe EXE noch einmal, ausgepackt von unserer eigenen Schranke. Eingereicht bei Microsoft am 20.10.2026 um 20:57:52, Vorgang `a567fe2a-9f58-47e1-a675-a62733ec538f` ([E-124](../Intern/BEFUNDE.md#e-124), [DEFENDER-FEHLALARM.md](DEFENDER-FEHLALARM.md)) |

## 1.0.112 — geschnürt am 20.10.2026 nach `C:\Users\Gregor\Eudora72-1.0.112-release`, Quellstand 7.2.0.112, Zweig `e-123-transfersame`, **als `v1.0.112` veröffentlicht**

| | |
|---|---|
| Testverzeichnis | bereitgestellt am 20.10.2026, `C:\Users\Gregor\Eudora72-1.0.112-release`, mit `TESTEN.txt` |
| Veröffentlicht | **`v1.0.112`** am 20.10.2026 um 11:55:10 UTC auf GitHub, Marke auf `f87a4a74` = Merge von PR #113; ZIP `Eudora72-1.0.112-release.zip`, SHA-256 `0406c1084640a766c2bd4d9eed5681974f5d2f0280f707de545c72ced28765fd`. Die Release-Notizen standen beim Veröffentlichen verstümmelt da – siehe [LEKTOR-43](../Befunde/LEKTOR-43.md#l-43.1) |
| Inhalt | wie 1.0.111, **ohne** den Hochladezähler in `CImapSameServerTransferMsgAction::DoWork` ([PRÜFER-39](../Befunde/PRUEFER-39.md) N1); dazu beide neuen Schranken im **versionierten** Haken |
| Gemessen | **ohne Nachstellung** — Gregor am 20.10.2026: *„wie auch immer: release eine neue version, alles in release notes und changelog, auch der neue befund“* und *„ja, mach das!“*. Diese Fassung behebt **keinen** Fehler Gregors, sie **nimmt eine Gefahr zurück**, die [PRÜFER-39](../Befunde/PRUEFER-39.md) N1 gefunden hat; ein rot-grüner Lauf am Prüfstand ist dafür nicht zu führen, weil der entfernte Zweig nur bei einer im Netz hängenden Verbindung sichtbar würde. **Belegt am Quelltext:** `DoWork` läuft im Nebenfaden (`QCTaskManager.cpp:1095`, `AfxBeginThread` in `:549`), `RequestThreadStop()` ist ein leerer Rumpf (`ImapActionQueue.cpp:709`) — der Zähler hätte `bLaeuft` dauerhaft wahr halten und Eudora unbeendbar machen können. **Gemessen an Gregors eigenen Protokollen, dass das Entfernen nichts ändert:** bei Weg 2b blieb `laeuft=0`, bei Weg 2a kam `laeuft=1` aus `m_bE123UebertragungLaeuft` (`:3768`). Bau Release 0 Fehler, **229 Tests, 229 bestanden**. **Warnung in den Release-Notizen:** [E-131](../Intern/BEFUNDE.md#e-131), von außen gemeldet, von uns nicht nachgestellt |

## 1.0.111 — geschnürt am 20.10.2026 nach `C:\Users\Gregor\Eudora72-1.0.111-release`, Quellstand 7.2.0.111, Zweig `e-123-transfersame`

| | |
|---|---|
| Testverzeichnis | bereitgestellt am 20.10.2026, `C:\Users\Gregor\Eudora72-1.0.111-release`, mit `TESTEN.txt` |
| Inhalt | wie 1.0.110, dazu: die Wache beim Beenden zählt **jede** Übertragungsart, nicht nur die aus einem lokalen Postfach ([E-123](../Intern/BEFUNDE.md#e-123)) |
| Gemessen | Gregors Lauf an 1.0.110 vom 20.10.2026 ist der Fehlerstand: `E-123 Warteschlange: konto=1 eintraege=1 … laeuft=0 uebertragungen=0` bei einem `transfersame`-Eintrag in `actionqueue.dat`, Fenster sofort weg. Nach der Behebung zählt `E123OffeneUebertragungen` die Basisklasse `CImapTransferMsgAction`. Schranke `tools/pruefe-e123-zaehlung.pl` gegengetestet: am Fehlerstand **2 von 2 rot**, nach der Behebung grün; `--selbsttest` 2 Fälle, 0 Fehler. Bau Release 0 Fehler. **Von Gregor am 20.10.2026 an 1.0.111 am laufenden Programm bestätigt (Wege 2a und 2b):** `uebertragungen=1` statt vorher `0`, `E-123 Beenden wartet auf 1 Uebertragung(en)`, `Warten zu Ende nach 4015 ms`; Weg 2a ebenso mit `laeuft=1` und 6015 ms |

## 1.0.110 — geschnürt am 19.10.2026 nach `C:\Users\Gregor\Eudora72-1.0.110-release`, Quellstand 7.2.0.110, Zweig `e-69-meldungsflut`

**Das erste Paket, das E-69 und E-123 zusammen trägt** — und das erste, in dem
die Behebung zu E-69 wirklich greift.

**E-69 (P3 aus PRÜFER-36, dazu R1–R3 aus PRÜFER-38).** Statt eines Eintrags je
übersprungener Nachricht: einer für den ersten Fall, einer als Sammeleintrag
am Ende des Laufs. Piepen und Nach-vorn-Holen höchstens einmal je zwei
Sekunden. **PRÜFER-38 hat dabei zwei Löcher in der ersten Fassung gefunden:**
nach dem ersten Lauf wäre E-69 **stumm** gewesen (R1), und die Klammer fehlte
ausgerechnet am **IMAP-Weg** — also an Gregors Anlassfall (R2). Beides behoben,
dazu eine eigene Sammlung je Faden (R3).

**E-123 (P1, P2 aus PRÜFER-36, R4 aus PRÜFER-38).** Die Notbremse nach fünf
Minuten schließt nicht mehr über ein laufendes Hochladen oder einen offenen
Dialog hinweg, sondern gibt das Beenden auf und sagt es in der Statuszeile.
Der Hochladezähler deckt jetzt auch den Verbindungsaufbau. Der **zweite**
*File → Exit* wartet wieder, statt verschachtelt abzubauen (R4).

**E-123 selbst bleibt offen.** P1, P2 und R4 sind Prüfpunkte **am
Beenden-Weg**, nicht der Befund: nach einem Absturz, einem Eingriff von
Defender, einem Stromausfall oder einem erzwungenen Herunterfahren können
eingebettete Bilder weiter fehlen.

**229 Tests, 229 bestanden.** Gegenproben gefahren — für E-69 fallen drei der
alten und einer der neuen Tests gegen die jeweils alte Fassung um.

**Was Gregor prüft:**

1. **E-69, der Anlassfall:** ein **IMAP**-Postfach filtern, während der Server
   nicht erreichbar ist (*Special → Filter Messages*). Es darf nicht mehr
   ununterbrochen piepen, und *Task Errors* darf sich nicht bei jeder
   Nachricht nach vorn drängen. In der Liste: **zwei** Einträge.
2. **E-69, die Gegenprobe zu R1:** **direkt danach** eine einzelne Nachricht
   filtern, die nicht lesbar ist. Kommt **kein** Eintrag, ist R1 nicht behoben.
3. **E-123:** mehrere Nachrichten in einen IMAP-Ordner verschieben und sofort
   *File → Exit*. Das Fenster darf nicht verschwinden, solange die Übertragung
   läuft; nach fünf Minuten steht *„Quit cancelled: …"* in der Statuszeile.
   Ein zweites *File → Exit* darf nicht in einen unsichtbaren Hänger führen.

4. **E-101, der dritte Prüfpunkt:** eine empfangene HTML-Nachricht mit
   Umlauten und `€` über *File → Save As* sichern und in Thunderbird oder im
   Browser öffnen. Die Zeichen müssen stimmen. Hat die Nachricht einen
   **Anhang**, muss der in der gespeicherten Datei noch als Anhang erkennbar
   sein — nicht als Textblock.

**Nachtrag vom 19.10.2026: F1, F3 und F4 sind ebenfalls drin.** Gregor:
*„f1 und f3/f4 erst beheben, dann 0.111 releasen"* und *„ich teste alles in
0.111, nicht zwei verschiedene"*. Da 7.2.0.110 bis dahin **nie übersetzt**
worden war, ist alles in **1.0.110** gelandet — eine vierte nie geschnürte
Nummer entsteht nicht.

**Die bekannte Regression gegenüber 1.0.106 ist damit weg.** `windows-1251`,
`koi8-r` und `iso-8859-2` behalten beim Speichern ihre richtige Angabe, und
eine echte mehrteilige Nachricht wird nicht mehr zu `text/plain` gemacht —
vorher wurde dabei der Anhang aus der gespeicherten Datei unbrauchbar (F1).
Einzelheiten im CHANGELOG, Abschnitt 7.2.0.110.

## 1.0.109 — **nie geschnürt**, Quellstand 7.2.0.109 (nur übersetzt am 19.10.2026; PRÜFER-38 fand danach R1 bis R4, der Inhalt steckt in 1.0.110), Zweig `e-69-meldungsflut` (E-69: P3 aus PRÜFER-36)

**Aus 500 Pieptönen werden 25, aus 500 Einträgen zwei.** `E69UebersprungenMelden`
legte bei **jedem** Abbruch einen eigenen Eintrag in *Task Errors* an. Jeder
Eintrag piept und holt das Fenster nach vorn (`TaskErrorBringToFront`,
Vorgabe 1). Beim Filtern eines IMAP-Postfachs mit 500 nur angerissenen
Nachrichten und nicht erreichbarem Server: 500 Einträge, 500 Pieptöne, 500
Fenstersprünge — und nichts davon lässt sich wegklicken.

**A — an der Quelle zusammenfassen.** Der **erste** übersprungene Fall eines
Laufs bekommt einen eigenen Eintrag, damit der Anwender überhaupt erfährt,
dass etwas übersprungen wurde; alles Weitere wird gezählt und am Ende des
Laufs zu **einem** Eintrag zusammengefasst.

**B — den Schwall abfangen.** Piepen und Nach-vorn-Holen höchstens einmal je
zwei Sekunden, **unabhängig von der Quelle**. Der Eintrag entsteht weiterhin
in jedem Fall — gedämpft wird nur das Laute.

**222 Tests, 222 bestanden** (neun neue). Gegenprobe gefahren: mit dem alten
Verhalten fallen drei davon um.

**Enthält außerdem 7.2.0.108** (E-123, P1 und P2): die Notbremse nach fünf
Minuten schließt nicht mehr über ein laufendes Hochladen oder einen offenen
Dialog hinweg, und der Hochladezähler deckt jetzt auch den Verbindungsaufbau.

**Was Gregor prüft:**

1. **E-69:** ein IMAP-Postfach filtern, während der Server nicht erreichbar
   ist (*Special → Filter Messages*). Es darf nicht mehr ununterbrochen
   piepen, und *Task Errors* darf sich nicht bei jeder Nachricht nach vorn
   drängen. In der Liste stehen **zwei** Einträge: der erste Fall und ein
   Sammeleintrag *„N further message(s) …"*.
2. **E-123:** mehrere Nachrichten in einen IMAP-Ordner verschieben und sofort
   *File → Exit*. Das Fenster darf nicht verschwinden, solange die
   Übertragung läuft; nach fünf Minuten steht *„Quit cancelled: …"* in der
   Statuszeile.

**Nicht enthalten:** die E-101-Nachbesserungen F1 und F3/F4 aus
[PRÜFER-37](../Befunde/PRUEFER-37.md). **F4 ist eine Regression gegenüber
1.0.106** — eine Nachricht mit einem Zeichensatz, den Eudora nicht übersetzt
(`windows-1251`, `koi8-r`, `iso-8859-2`), bekommt beim Speichern eine falsche
`<meta>`-Angabe. Wer solche Post bekommt, sollte mit dem Speichern warten.

## 1.0.108 — **nie geschnürt**, Quellstand 7.2.0.108 (nur übersetzt am 19.10.2026; der Inhalt steckt in 1.0.109), Zweig `e-123-notbremse-und-zaehler` (E-123: P1 und P2 aus PRÜFER-36)

**Beenden beschädigt keine laufende Übertragung mehr.** Zwei Funde aus
[PRÜFER-36](../Befunde/PRUEFER-36.md), beide an **E-123**:

**P1 — die Notbremse übergeht die Sperren nicht mehr.** `mainfrm.cpp` beendete
nach fünf Minuten *in jedem Fall*, auch wenn ein Hochladen auf dem Stapel lag
oder ein modaler Dialog offen war. Im ersten Fall lief `CloseDown`
verschachtelt im Hochladen — das Fenster verschwand, der Prozess hing
unsichtbar weiter; im zweiten liefen `CloseDown` und `DestroyWindow` unter der
Kennwortabfrage. Jetzt wird das **Beenden aufgegeben** statt erzwungen: das
Fenster bleibt offen, in der Statuszeile steht der Grund, und ein zweiter
Versuch steht jederzeit frei.

**P2 — der Zähler zählt dort, wo das Hochladen beginnt.** Er stand in
`CImapAction::DoPreThreadAction` hinter einem `dynamic_cast`, den ausgerechnet
die einzige Unterklasse nie erreicht, die ihn auslösen würde — sie ruft die
Basisfunktion nicht auf (QUALCOMM-Kommentar an Ort und Stelle). Der eigentliche
Transfer war über einen zweiten Zähler in `DoPostProcessing` gedeckt;
ungedeckt war der **Verbindungsaufbau** (`OpenMailbox`, Anmeldung, `SELECT`).

**Was Gregor prüft:** mehrere Nachrichten in einen IMAP-Ordner verschieben und
sofort *File → Exit*. Das Fenster darf nicht verschwinden, solange die
Übertragung läuft; nach fünf Minuten muss in der Statuszeile *„Quit
cancelled…"* stehen statt eines geschlossenen Fensters.

**Nicht ins Release**, solange **P3** aus PRÜFER-36 offen ist (E-69,
Meldungsflut in *Task Errors*) — dafür ist der Zweig `e-69-meldungsflut`
vereinbart.

## 1.0.107 — **nie geschnürt**, Quellstand 7.2.0.107 (nur übersetzt am 17.10.2026), Zweig `E-101_korrektur_datei_speichern` (E-101, dritter Teil)

**Die gespeicherte Datei bekommt jetzt die Kopfzeile, die zum Rumpf passt.**
Bis hierher liess der Speicherweg eine vorhandene `Content-Type`-Zeile
unangetastet — mit der Begründung, eine empfangene Nachricht bringe ihre echten
Kopfzeilen mit. **Das stimmt nicht:** der **Rumpf** ist immer Eudoras interne
Fassung (beim Empfang zerlegt, entschlüsselt, nach Windows-1252 übersetzt), die
**Kopfzeilen** stehen dagegen so da, wie sie ankamen.

**Gemessen** an sechs empfangenen HTML-Nachrichten im Postfach des Prüfstands:
alle sechs tragen `Content-Type: multipart/…; boundary=…`, und **keine einzige**
der Grenzen steht im Rumpf — ein anderes Programm sucht die Teile und findet
keinen. Vier davon sagen im HTML `charset=UTF-8`, die Bytes sind aber
Windows-1252.

Dazu der Zeichensatz: `0x80` (€), `0x92` (’) und `0x96` (–) gibt es in
ISO-8859-1 nicht. Gespeichert wird jetzt `windows-1252`, wie es der Anzeigeweg
schon tut (`TridentView.cpp`).

**213 Tests, 213 bestanden** (vier neue). Gegenprobe gefahren: mit dem alten
`msgutils.cpp` fallen **genau diese vier** um, die übrigen 209 bleiben grün —
darunter die Gegenprobe *„passender Kopf und passendes `<meta>` bleiben
unberührt"*, ohne die aus der Behebung *„jede Kopfzeile wird überschrieben"*
geworden wäre.

**Nicht ins Release, solange P1–P3 aus [PRÜFER-36](../Befunde/PRUEFER-36.md)
offen sind** — P1/P2 zu **E-123** (Beenden wartet), P3 zu **E-69**
(Meldungsflut in *Task Errors*).

## 1.0.106 — **nicht ausgeliefert**, Quellstand 7.2.0.106, Zweig `e-123-beenden-warten` (E-69 Task Errors; E-123 Beenden wartet)

| | |
|---|---|
| Testverzeichnis | bereitgestellt am 17.10.2026, `C:\Users\Gregor\Eudora72-1.0.106-release` |
| Inhalt | wie 1.0.104, dazu: übersprungene Nachricht beim Filtern erscheint in *Task Errors* ([E-69](../Intern/BEFUNDE.md#e-69)) |
| Gemessen | nachgestellt am Prüfstand: an 7.2.0.104 nur Protokollzeile ohne Meldung (Fehler: lautlos), an 7.2.0.106 Eintrag in Task Errors, Nachricht bleibt in `In`; E-123 wie 1.0.104; Testsuite 209/209 |

## 1.0.105 — **nie gebaut als Paket**, Zwischenbau 7.2.0.105 (Meldungstext *„message text is empty“*), nur am Prüfstand

## 1.0.104 — **ersetzt durch 1.0.106, Testverzeichnis entfernt, nie getestet**, Quellstand 7.2.0.104, Zweig `e-123-beenden-warten` (E-123 Beenden wartet, nach PRÜFER-35 abgesichert)

| | |
|---|---|
| Testverzeichnis | bereitgestellt am 17.10.2026, `C:\Users\Gregor\Eudora72-1.0.104-release` |
| Inhalt | wie 1.0.103, dazu die Korrekturen aus [PRÜFER-35](../Befunde/PRUEFER-35.md) – kein Warten für immer mehr |
| Gemessen | nachgestellt am Prüfstand: an 7.2.0.101 kein Warten, Hochladen nie bestätigt (Fehler); an 7.2.0.104 einfaches und doppeltes Schließen grün; Testsuite 209/209 |

## 1.0.103 — **ersetzt durch 1.0.104, Testverzeichnis entfernt, nie getestet**, Quellstand 7.2.0.103, Zweig `e-123-beenden-warten` (E-123 Beenden wartet, nach PRÜFER-34 abgesichert)

| | |
|---|---|
| Testverzeichnis | bereitgestellt am 17.10.2026, `C:\Users\Gregor\Eudora72-1.0.103-release` |
| Inhalt | wie 1.0.102, dazu die Korrekturen aus [PRÜFER-34](../Befunde/PRUEFER-34.md) |
| Gemessen | nachgestellt am Prüfstand: an 7.2.0.101 kein Warten, Hochladen nie bestätigt (Fehler); an 7.2.0.103 gewartet, zweites Schließen ignoriert, hochgeladen, sauber beendet; Testsuite 209/209 |

## 1.0.102 — **ersetzt durch 1.0.103, Testverzeichnis entfernt, nie getestet**, Quellstand 7.2.0.102, Zweig `e-123-beenden-warten` (E-123 Beenden wartet)

| | |
|---|---|
| Testverzeichnis | bereitgestellt am 17.10.2026, `C:\Users\Gregor\Eudora72-1.0.102-release` |
| Inhalt | wie 1.0.101, dazu: Beenden wartet auf IMAP-Übertragungen, belegte Verbindung blockiert die Warteschlange nicht mehr ([E-123](../Intern/BEFUNDE.md#e-123)) |
| Gemessen | nachgestellt am Prüfstand: an 7.2.0.101 kein Warten, Hochladen nie bestätigt (Fehler), an 7.2.0.102 Warten 10 s bis zum bestätigten Hochladen, sauber beendet; Testsuite 209/209 |

## 1.0.101 — **veröffentlicht als `v1.0.101`** (17.10.2026), Quellstand 7.2.0.101, Zweig `e-121-mehrere-gesendete` (eigene Kennung für gesendete Post, E-67 gemessen)

| | |
|---|---|
| Testverzeichnis | bereitgestellt am 17.10.2026, `C:\Users\Gregor\Eudora72-1.0.101-release` |
| Inhalt | wie 1.0.100, dazu: gesendete Post bekommt beim Verschieben nach IMAP eine eigene Kennung, eine gescheiterte Vorab-Kopie wird sofort entfernt ([E-121](../Intern/BEFUNDE.md#e-121)); Spurmarken zu [E-67](../Intern/BEFUNDE.md#e-67) |
| Gemessen | Prüfstand an 7.2.0.101: Normalfall, abgelehntes Hochladen (Kopie entfernt, Mail bleibt in `In`), Kollisionsfall; Filterfenster nachgestellt – an 7.2.0.101 grün, Gegenprobe mit dem alten Vergleich zeigt den Fehler (`verb-auswahl=14 eintraege=2`); Testsuite 209/209. Die Kennung für gesendete Post ist am Prüfstand nicht nachstellbar – Prüfung bei Gregor, auf seine Anweisung (*„nur was nicht geht, werde ich testen.“*). |
| Defender | sauber (Paketprüfung, 34 Dateien, 0 Funde) |
| Release-ZIP | gebaut am 17.10.2026, `Releases/Eudora72-1.0.101-release.zip`, 9 066 464 Byte, SHA-256 `79a40bc00e2ca4d929e23f4ad5d043a8cbdab27ce9a7ab66eb58a77764e8694a`; die 34 EXE/DLL/OCX byteidentisch mit Gregors getestetem `Eudora72-1.0.101-release`; Paketprüfung mit Defender am entpackten ZIP: 0 Funde. **Veröffentlicht als `v1.0.101`** – am 17.10.2026 um 19:12:08 UTC auf GitHub veröffentlicht (*Latest*, Marke auf `eec4e4e5` = Merge von PR #99, ZIP 9 066 464 Byte, SHA-256 `79a40bc00e2ca4d929e23f4ad5d043a8cbdab27ce9a7ab66eb58a77764e8694a`, nachgerechnet an der von GitHub zurückgeladenen Datei; die 34 EXE/DLL/OCX byteidentisch mit Gregors getestetem `Eudora72-1.0.101-release`; Defender: 0 Funde). |
| URL | https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.101 |
| Freigabe | Gregor am 17.10.2026: *„ja, veröffentlichen“* (nach seinem Test von 1.0.101 in vier Runden und dem Merge von PR #99) |
| Bei Gregor | bestätigt am 17.10.2026: zwei gesendete Mails mit zwei verschiedenen eigenen Kennungen hochgeladen; in der Liste erst nach Neuöffnen des Ordners sichtbar ([E-121](../Intern/BEFUNDE.md#e-121)) |

## 1.0.100 — **nicht ausgeliefert**, Quellstand 7.2.0.100, Zweig `e-121-mehrere-gesendete` ([PRÜFER-31](../Befunde/PRUEFER-31.md) F1, F3, F4)

| | |
|---|---|
| Testverzeichnis | bereitgestellt am 16.10.2026, `C:\Users\Gregor\Eudora72-1.0.100-release` |
| Inhalt | wie 1.0.99, dazu: mehrere gesendete Mails in einer Übertragung nach IMAP ([E-121](../Intern/BEFUNDE.md#e-121)), leere Kennungsliste, Sperre in `SetDisplayWindow` ([E-83](../Intern/BEFUNDE.md#e-83)) |
| Stand | Testsuite 209/209; sechs Prüfstandläufe an 7.2.0.100 grün (Normalfall, Server ohne neue UID, Kollisionsfall); F1 selbst **ohne Nachstellung** – am Prüfstand nicht nachstellbar (Kennung 0 nur aus `Out`), bei Gregor (GMX mit UIDPLUS) tritt es nicht auf. Gregor hat entschieden, ohne Nachstellung zu testen: *„ja, leg 1.0.100 hin, ich teste es“* (Chat, 16.10.2026). Sein Test: zwei gesendete Mails auf einmal verschieben. |
| Bei Gregor | 16.10.2026 (nachgetragen von [LEKTOR-39](../Befunde/LEKTOR-39.md), Quelle `WEITERMACHEN.md`): eine gesendete Mail `test 20261016c` hochgeladen (`id=0 … hochgeladen=1`, einmal in der `OUTBOX`), zwei Mails aus `In` mit `markiert=1`, sauber beendet. Der Fall *mehrere gesendete Mails auf einmal* ist damit nicht gemessen ([PRÜFER-32](../Befunde/PRUEFER-32.md)). Dabei gefunden: [E-125](../Intern/BEFUNDE.md#e-125). Kein Release wegen [PRÜFER-32](../Befunde/PRUEFER-32.md) (zwei Wege zum Datenverlust, behoben in 7.2.0.101) |

## 1.0.99 — **nicht ausgeliefert**, Quellstand 7.2.0.99, Zweig `e-118_HTML_header` (Neubau von 1.0.98, E-124)

| | |
|---|---|
| Testverzeichnis | bereitgestellt am 16.10.2026, `C:\Users\Gregor\Eudora72-1.0.99-release` |
| Inhalt | derselbe Quelltext wie 1.0.98, neu gebaut ([E-124](../Intern/BEFUNDE.md#e-124): Defender stufte 1.0.98 als Trojaner ein) |
| Gemessen | wie 1.0.98 nachgestellt (Start-Abgleich: an 7.2.0.96/97 12 von 12 hängend, Fehler `liegengeblieben`; Kollisionsfall an 1.0.95 mit Fehler); an 7.2.0.99 drei Läufe hochgeladen; Defender sauber vor und nach den Läufen; Testsuite 209/209 |
| Defender | 1.0.98: `Trojan:Win32/Bearfoos.A!ml` (nicht ausliefern); 1.0.99: sauber |
| Bei Gregor | bestätigt am 16.10.2026: gesendete Mail und zwei Mails aus `In` hochgeladen, sauber beendet |

## 1.0.98 — **nicht ausgeliefert**, Quellstand 7.2.0.98, Zweig `e-118_HTML_header` (E-83 zweite Ursache; E-121 gesendete Post, N1)

| | |
|---|---|
| Testverzeichnis | bereitgestellt am 16.10.2026, `C:\Users\Gregor\Eudora72-1.0.98-release` |
| Inhalt | wie 1.0.97, dazu: eine beim Start schon erledigte Aufgabe bleibt nicht mehr stehen ([E-83](../Intern/BEFUNDE.md#e-83)) |
| Gemessen | Nachgestellt: an 7.2.0.96 und 7.2.0.97 hingen 12 von 12 Läufen am Start-Abgleich (Fehler `liegengeblieben`), an 7.2.0.98 10 von 10 hochgeladen; Kollisionsfall an 1.0.95 mit Fehler nachgestellt, an 7.2.0.98 grün; Testsuite 209/209. Gesendete Post (Kennung 0) am Prüfstand nicht nachstellbar – Prüfung bei Gregor. |
| Bei Gregor | 16.10.2026: Microsoft Defender beendete das laufende Programm (`Trojan:Win32/Bearfoos.A!ml`, [E-124](../Intern/BEFUNDE.md#e-124)) – kein Absturz; die gesendete Mail war schon hochgeladen (`id=0 … hochgeladen=1`). **Nicht testen, nicht ausliefern**, ersetzt durch 1.0.99 |

## 1.0.97 — **nicht ausgeliefert, nicht freigegeben**, Quellstand 7.2.0.97, Zweig `e-118_HTML_header` (E-121: gesendete Post wieder hochgeladen, N1)

| | |
|---|---|
| Testverzeichnis | am 15.10.2026 bei Gregor abgelegt, `C:\Users\Gregor\Eudora72-1.0.97-release`; **nicht testen** (`f6d98141`: *„Gregor testet 1.0.97 nicht“*), ersetzt durch 1.0.99 |
| Inhalt | wie 1.0.96, dazu: gesendete Post (Kennung 0) wird wieder hochgeladen ([PRÜFER-30](../Befunde/PRUEFER-30.md) F1, Rückfall in 1.0.96), nur die markierte Quelle wird entfernt (N1, [E-121](../Intern/BEFUNDE.md#e-121)) |
| Stand | Testsuite 209/209, Paketprüfung grün. **Keine Nachstellung am Prüfstand** – F1 ist dort nicht nachstellbar, für N1/Kollision fehlte die Zustimmung zu Fenstern. Ob ohne Nachstellung getestet wird, entscheidet Gregor (siehe WEITERMACHEN.md). **Nachtrag 16.10.2026 ([LEKTOR-37](../Befunde/LEKTOR-37.md#l-37.5)):** am Prüfstand hingen an 7.2.0.96 und 7.2.0.97 zusammen 12 von 12 Läufen am Start-Abgleich – Ursache [E-83](../Intern/BEFUNDE.md#e-83), behoben in 7.2.0.98; der Verdacht eines Rückfalls in 7.2.0.97 ist widerlegt. |

## 1.0.96 — **nicht ausgeliefert**, Quellstand 7.2.0.96, Zweig `e-118_HTML_header` (E-121 Kollision Kennung/Server-UID)

| | |
|---|---|
| Testverzeichnis | bereitgestellt am 15.10.2026, `C:\Users\Gregor\Eudora72-1.0.96-release` |
| Inhalt | wie 1.0.95, dazu: die Vorab-Kopie trägt ein Merkzeichen, eine fremde Mail mit gleicher UID wird nicht mehr angefasst ([E-121](../Intern/BEFUNDE.md#e-121)) |
| Gemessen | Testsuite 209/209; Prüfstand mit `--fremde-uid`: an 1.0.95 Gregors Fehler nachgestellt, an 1.0.96 grün |
| Bei Gregor | bestätigt am 15.10.2026: kein Fehlerdialog, vier Übertragungen alle hochgeladen |
| Freigabe | **nicht veröffentlichen** ([PRÜFER-30](../Befunde/PRUEFER-30.md) F1: gesendete Post mit Kennung 0 wird nicht hochgeladen, behoben in 1.0.97) |

## 1.0.95 — **nicht ausgeliefert**, Quellstand 7.2.0.95, Zweig `e-118_HTML_header` (E-121 Doppelanzeige, fünfter Teil)

| | |
|---|---|
| Testverzeichnis | bereitgestellt am 15.10.2026, `C:\Users\Gregor\Eudora72-1.0.95-release` |
| Inhalt | wie 1.0.94, dazu: die Vorab-Kopie wird an Ort und Stelle aktualisiert ([E-121](../Intern/BEFUNDE.md#e-121)) |
| Gemessen | Testsuite 209/209; am Prüfstand nicht gemessen |
| Gregors Test, 15.10.2026 | Doppelanzeige weg; neuer Fehler *„Attempt to add the message to mailbox Inbox failed“* – lokale Kennung 13 gleich Server-UID 13, die fremde Mail wurde für die Vorab-Kopie gehalten. Kein Verlust, die Mail blieb in In ([E-121](../Intern/BEFUNDE.md#e-121), behoben in 1.0.96) |

## 1.0.94 — **nicht ausgeliefert**, Quellstand 7.2.0.94, Zweig `e-118_HTML_header` (E-121 Doppelanzeige, vierter Teil)

| | |
|---|---|
| Testverzeichnis | bereitgestellt am 15.10.2026, `C:\Users\Gregor\Eudora72-1.0.94-release` |
| Inhalt | wie 1.0.93, dazu: der Abgleich ersetzt einen Eintrag mit derselben UID, statt ihn zu verdoppeln ([E-121](../Intern/BEFUNDE.md#e-121)) |
| Gemessen | Testsuite 209/209; am Prüfstand nicht gemessen |
| Gregors Test, 15.10.2026 | **nicht bestanden:** weiter doppelt in der Fensterliste, nach dem Neuöffnen einmal; `summen` unverändert, der Abgleich-Weg aus 7.2.0.94 lief gar nicht ([E-121](../Intern/BEFUNDE.md#e-121)) |

## 1.0.93 — **nicht ausgeliefert**, Quellstand 7.2.0.93, Zweig `e-118_HTML_header` (E-121 Doppelanzeige ohne UIDPLUS)

| | |
|---|---|
| Testverzeichnis | bereitgestellt am 15.10.2026, `C:\Users\Gregor\Eudora72-1.0.93-release` |
| Inhalt | wie 1.0.92, dazu: meldet der Server keine UID, wird die Vorab-Kopie nach dem Hochladen entfernt ([E-121](../Intern/BEFUNDE.md#e-121)) |
| Gemessen | Testsuite 209/209; Am Prüfstand NICHT gemessen (vier Läufe mit `--ohne-appenduid` hingen alle am Start-Abgleich des Prüfservers); Prüfung bei Gregor mit offenem IMAP-Ordner. |
| Gregors Test, 15.10.2026 | **nicht bestanden** (*„FAILED“*): weiter doppelt in Inbox und OUTBOX bis zum Neuöffnen; GMX meldet die UID, die UIDPLUS-Vermutung ist widerlegt ([E-121](../Intern/BEFUNDE.md#e-121)) |

## 1.0.92 — **nicht ausgeliefert**, Quellstand 7.2.0.92, Zweig `e-118_HTML_header` (E-121 Doppelanzeige, zweiter Teil)

| | |
|---|---|
| Testverzeichnis | bereitgestellt am 15.10.2026, `C:\Users\Gregor\Eudora72-1.0.92-release` |
| Inhalt | wie 1.0.91, dazu: die ersetzte Vorab-Kopie trägt die Server-UID, damit der Abgleich keine zweite Zeile einfügt ([E-121](../Intern/BEFUNDE.md#e-121)) |
| Gemessen | Testsuite 209/209; am Prüfstand nicht im Doppelfall gemessen |
| Gregors Test, 15.10.2026 | **nicht bestanden:** drei Mails, jede doppelt bei offenem Ordner ([E-121](../Intern/BEFUNDE.md#e-121)) |

## 1.0.91 — **nicht ausgeliefert**, Quellstand 7.2.0.91, Zweig `e-118_HTML_header` (E-121 Doppelanzeige)

| | |
|---|---|
| Testverzeichnis | bereitgestellt am 15.10.2026, `C:\Users\Gregor\Eudora72-1.0.91-release` |
| Inhalt | wie 1.0.90, dazu: nach dem Verschieben in einen IMAP-Ordner steht die Mail nicht mehr doppelt da ([E-121](../Intern/BEFUNDE.md#e-121)) |
| Gemessen | Testsuite 209/209; Prüfstand: `summen=1` im Fall mit Vorab-Kopie |
| Gregors Test, 15.10.2026 | **nicht bestanden:** die Mail steht nach dem Verschieben weiter doppelt da, bis der Ordner neu geöffnet wird ([E-121](../Intern/BEFUNDE.md#e-121)) |

## 1.0.90 — **nicht ausgeliefert**, Quellstand 7.2.0.90, Zweig `e-118_HTML_header` (E-118 Teil 2, E-121)

| | |
|---|---|
| Testverzeichnis | **bereitgestellt am 14.10.2026**, `C:\Users\Gregor\Eudora72-1.0.90-release`, Grundlage 1.0.84-ZIP, 33 EXE/DLL/OCX aus dem Bau (`SPELL32.DLL` aus dem ZIP), `Eudora.exe` byte-gleich mit dem Prüfstand `C:\Temp\E118`, `paket-pruefen.ps1`: keine Fehler, `TESTEN.txt` (Kopie `Releases/1.0.90/TESTEN.txt`); PRÜFER-29: auslieferbar |
| Inhalt | wie 1.0.89, dazu [E-118](../Intern/BEFUNDE.md#e-118) Teil 2 (eingebettete Bilder werden mit hochgeladen) und [E-121](../Intern/BEFUNDE.md#e-121) (kein Verlust beim Verschieben in einen IMAP-Ordner) |
| Gemessen | Testsuite 209/209; IMAP-Prüfserver: Bild als `multipart/related` mit `Content-ID`, Fußzeile erhalten; fehlende Kopie und abgelehntes `APPEND` ohne Verlust |
| Gregors Test, 14.10.2026 | **bestätigt:** [E-118](../Intern/BEFUNDE.md#e-118) Teil 2 an der SoftMaker-Mail (*„ja, bilder sind drin.“*). **Gemeldet:** nach dem Verschieben erscheint die Mail doppelt, auf dem Server einmal ([E-121](../Intern/BEFUNDE.md#e-121), behoben in 1.0.91 bis 1.0.96) |

## 1.0.89 — **nicht ausgeliefert**, Quellstand 7.2.0.89, Zweig `e-118_HTML_header` (E-118)

| | |
|---|---|
| Testverzeichnis | **bereitgestellt am 14.10.2026**, `C:\Users\Gregor\Eudora72-1.0.89-release`. Grundlage `Releases/Eudora72-1.0.84-release.zip`, darüber 33 EXE/DLL/OCX aus `Eudora71/Bin/Release` (`SPELL32.DLL` bleibt die aus dem ZIP); `Eudora.exe` byte-gleich mit dem Prüfstand `C:\Temp\E118`; `paket-pruefen.ps1`: keine Fehler; beide melden 7.2.0.89. Im Paket `TESTEN.txt` (Kopie `Releases/1.0.89/TESTEN.txt`); Prüfschritte in [TESTPLAN.md](../Intern/TESTPLAN.md#c5) |
| Inhalt | wie 1.0.88, dazu [E-118](../Intern/BEFUNDE.md#e-118): HTML-Mail behält beim Hochladen in einen IMAP-Ordner `Content-Type: text/html` |
| Gemessen | Testsuite 207/207 (`TestE118.cpp`); IMAP-Prüfserver: `text/html` mit Zeichensatz, ohne Hülle; Gegenprobe 1.0.88 ohne `Content-Type` |
| Gregors Test, 14.10.2026 | **bestätigt:** [E-118](../Intern/BEFUNDE.md#e-118) an der waipu.tv-Mail (in den IMAP-Ordner verschoben, erscheint als HTML). **Nicht bestanden:** bei der SoftMaker-Mail fehlten danach die eingebetteten Bilder (*„hier fehlt der inhalt“*) – [E-118](../Intern/BEFUNDE.md#e-118) Teil 2, eingebaut in 1.0.90. [E-105](../Intern/BEFUNDE.md#e-105) an 1.0.89 noch nicht geprüft |

## 1.0.88 — **nicht ausgeliefert**, Quellstand 7.2.0.88, gemergt mit PR #97 (E-105); Gregor verzichtete auf einen eigenen Test

| | |
|---|---|
| Testverzeichnis | noch keines bei Gregor; gemessen in `C:\Temp\E105` (Programmdateien aus `Eudora71/Bin/Release`, 14.10.2026) |
| Inhalt | wie 1.0.87, dazu [E-105](../Intern/BEFUNDE.md#e-105): Abschnitte mit `style="display:none"` werden samt Inhalt nicht angezeigt |
| Gemessen | Testsuite 202/202 (`TestE105.cpp`); Prüfnachricht `Testdaten/e105-handyfassung-versteckt.eml`: Öffnen und Weiterleiten ohne versteckte Teile, Gegenprobe 1.0.87 zeigt sie |

## 1.0.87 — **veröffentlicht als `v1.0.87`** am 14.10.2026, Quellstand 7.2.0.87 (E-117, mit E-112, E-103, E-115)

| | |
|---|---|
| Testverzeichnis | **bereitgestellt am 13.10.2026** nach LEKTOR-31, PRÜFER-25 (auslieferbar) und CHRONIST, `C:\Users\Gregor\Eudora72-1.0.87-release`. Grundlage `Releases/Eudora72-1.0.84-release.zip` (157 Dateien), darüber 29 EXE/DLL/OCX aus `Eudora71/Bin/Release`; `Eudora.exe`, `EudoraRes.dll`, `Paige32.dll` byte-gleich mit dem gemessenen Prüfstand `C:\Temp\E112-1085`; `paket-pruefen.ps1`: startet ohne Nachinstallation; beide melden 7.2.0.87. Im Paket `TESTEN.txt` mit den Testschritten (Kopie `Releases/1.0.87/TESTEN.txt`). Von Gregor getestet, siehe unten |
| Inhalt | wie 1.0.86, dazu [E-117](../Intern/BEFUNDE.md#e-117): `&amp;` in Bildadressen |
| Gemessen | Testsuite 196/196 (`TestResolveURL.cpp` (8), vorher rot); am laufenden Programm (`C:\Temp\E112-1085`, Prüfnachricht `Testdaten/e117-amp-in-bildadresse.eml`, Bildserver `tools/bildserver-e117.pl`): 7.2.0.85 holt `&amp;` und malt ein Pixel, 7.2.0.87 holt `&` und das Bild (`Datei=330x327 gemalt=165x164`), siehe [E-117](../Intern/BEFUNDE.md#e-117); das ZIP entstand erst zum Release (siehe unten) |
| Gregors Test, 14.10.2026 | **bestätigt:** [E-117](../Intern/BEFUNDE.md#e-117) (Bildschirmfoto: eBay-Synology-Weiterleitung, das Produktfoto steht unter „Der Countdown läuft!“; *„so?“*) |
| ZIP (Release) | `Releases/Eudora72-1.0.87-release.zip`, 9 060 108 Byte (nicht versioniert), 158 Dateien, flach ohne Wurzelordner. Gebaut am 14.10.2026 **nicht** aus Gregors Testverzeichnis (darin liegt inzwischen sein Mailverzeichnis), sondern frisch: 1.0.84-ZIP (157 Dateien) entpackt, darüber die EXE/DLL/OCX aus `Eudora71/Bin/Release` außer `SPELL32.DLL` (siehe Nebenbefund), dazu `TESTEN.txt`. Die 34 EXE/DLL/OCX byteidentisch (`cmp`) mit Gregors getestetem `Eudora72-1.0.87-release`; `Eudora.exe` und `EudoraRes.dll` melden 7.2.0.87; `paket-pruefen.ps1`: startet ohne Nachinstallation. `Mailverzeichnis` enthält nur die Vorgabe-`Eudora.ini` (3249 Byte) |
| SHA256 | `a4f1c28ddfa22dbd1c16bd71705157134fca431dbc161d1554f78da42864904c` — gemessen am lokalen und am von GitHub heruntergeladenen ZIP, gleich |
| URL | https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.87 — 14.10.2026, 05:46:20 UTC, *Latest*, Marke auf `41c6752` (Merge von PR #96) |
| Freigabe | Gregor am 14.10.2026: *„ja, wir releasen ein 0.87 in github“*, nach seinem Test von 1.0.87 |
| Nebenbefund | `Eudora71/Bin/Release/SPELL32.DLL` (05.09.2026 19:18, SHA-256 `c085571c…48ac9`) ist **nicht** die getestete und ausgelieferte Datei: ausgeliefert ist die aus dem 1.0.84-ZIP (30.08.2026 17:57, `2d5d3d78…7f45`), gleich groß (112 128 Byte). Der erste Packlauf hatte die aus `Bin/Release` genommen; erst der Byte-Vergleich gegen Gregors Verzeichnis hat es gezeigt, `paket-pruefen.ps1` sieht es nicht. Nicht behoben, siehe [PR-2](../Intern/BEFUNDE.md#pr-2), Abschnitt PR-2.2 |

## 1.0.86 — **als Testverzeichnis an Gregor, nicht einzeln veröffentlicht** (enthalten in `v1.0.87`), Quellstand 7.2.0.86 (E-115)

| | |
|---|---|
| Testverzeichnis | **bereitgestellt am 13.10.2026** auf Gregors Anweisung (*„bau mir dann auch ein 0.86 zum testen.“*), `C:\Users\Gregor\Eudora72-1.0.86-release`. Grundlage `Releases/Eudora72-1.0.84-release.zip` (157 Dateien), darüber 29 EXE/DLL/OCX aus `Eudora71/Bin/Release`; `Eudora.exe`, `EudoraRes.dll`, `Paige32.dll` byte-gleich mit dem gemessenen Prüfstand `C:\Temp\E115-gregor`; `paket-pruefen.ps1`: startet ohne Nachinstallation; beide melden 7.2.0.86. Rollen nach der E-115-Behebung nicht gelaufen |
| Inhalt | wie 1.0.85, dazu [E-115](../Intern/BEFUNDE.md#e-115): `FindCheck` überspringt Recent nicht mehr ins Leere |
| Gemessen | am laufenden Programm: mit 7.2.0.84 Meldung, mit 7.2.0.86 keine (siehe [E-115](../Intern/BEFUNDE.md#e-115)) |
| Gregors Test, 13.10.2026 | **bestätigt:** [E-112](../Intern/BEFUNDE.md#e-112) (*„paßt dagegen“*, Bildschirmfoto), mit ihm [E-103](../Intern/BEFUNDE.md#e-103), und [E-115](../Intern/BEFUNDE.md#e-115) (*„tritt bisher nicht mehr auf“*, vorläufig). **Neu gemeldet:** [E-117](../Intern/BEFUNDE.md#e-117) (seither in 1.0.87 behoben), [E-118](../Intern/BEFUNDE.md#e-118), [E-119](../Intern/BEFUNDE.md#e-119), [E-105](../Intern/BEFUNDE.md#e-105) zweiter Fall, [E-120](../Intern/BEFUNDE.md#e-120) (kein eigener Fehler). Urteile mit Zitat in [BEFUNDE.md](../Intern/BEFUNDE.md) |

## 1.0.85 — **als Testverzeichnis an Gregor, nicht einzeln veröffentlicht** (enthalten in `v1.0.87`), Quellstand 7.2.0.85 (E-112)

| | |
|---|---|
| Testverzeichnis | **als Verzeichnis bereitgestellt am 13.10.2026**, `C:\Users\Gregor\Eudora72-1.0.85-release`, auf Gregors Anweisung (*„stell mir ein 0.85 zu den anderen dazu. nicht bei dir“*). Grundlage: `Releases/Eudora72-1.0.84-release.zip` (157 Dateien), darüber 29 EXE/DLL/OCX aus `Eudora71/Bin/Release`; `Eudora.exe`, `EudoraRes.dll`, `Paige32.dll` byte-gleich mit dem Prüfstand `C:\Temp\E112-1085`; `paket-pruefen.ps1`: startet ohne Nachinstallation; beide Dateien melden 7.2.0.85. Ein erster Versuch mit `paket-bauen.ps1 -AusBauverzeichnis` nahm `Bin\Debug` (7.2.0.12) – umbenannt in `Eudora72-1.0.85-FALSCH-debug-7.2.0.12-nicht-benutzen`, Löschen lag nicht in meiner Freigabe. Gregors Urteil zu [E-112](../Intern/BEFUNDE.md#e-112) und [E-103](../Intern/BEFUNDE.md#e-103) kam an 1.0.86, das diesen Stand enthält (siehe dort) |
| Inhalt | [E-112](../Intern/BEFUNDE.md#e-112): die Metadatei eines Bildes wird in der angegebenen Größe geschrieben (`E112MetadateiAusDIB`, `QCGraphics.cpp`), mit ihm [E-103](../Intern/BEFUNDE.md#e-103); danach PRÜFER-22 **F1** (gleiche URL nicht mehr teilen: zuerst `dae6727` an `PGEMBED.C`, wirkungslos, weil `Paige32.dll` nicht aus dem Quelltext gebaut wird; jetzt `ac8f030` in `PGHTMIMP.CPP`, `check_to` 0) und **F2** (halbe Angabe ergänzt die fehlende Seite aus dem Seitenverhältnis: zuerst `c294594`, am Ladeweg wirkungslos; jetzt `11b6a3a`); danach PRÜFER-23 **N1** (`9f5142b`, `msgutils.cpp`: der [E-89](../Intern/BEFUNDE.md#e-89)-Deckel erfindet beim Antworten kein `height="1"` mehr) und ihre Gegenrichtung (`bf96856`, kein `width="1"`, [LEKTOR-29](../Befunde/LEKTOR-29.md#l-29.3)) |
| Gemessen | Testsuite 195/195 (seit der Gegenrichtung; nach N1 194/194, davor 193/193), darunter `TestE112Metadatei.cpp` (vor der Behebung rot: 330×327 statt 35×35 gemalt), `TestE112.cpp` (3), (6) zu F2, `TestE89.cpp` (4b) zu N1 und (4c) zur Gegenrichtung. **Am laufenden Programm an `a36c47f`** (Prüfstand `C:\Temp\E112-1085`, Titelzeile `1.0.85+a36c47f*`): `gemalt=35x35`, `250x96`, `79x64`, kein Bild auf dem Text. **Am Bau `11b6a3a`**, derselbe Prüfstand: dazu `70x70` (F1) und `150x58` (F2), Fensterfoto ohne überdeckten Text. **Am Bau `bf96856`** (13.10.2026): N1 `angegeben=600x0 gemalt=600x230`, Gegenrichtung `angegeben=0x600 gemalt=606x600` |
| Nicht gemessen | kein Paket. Bekannt offen: PRÜFER-23 N2 bis N5 und, erst ab dieser Fassung sichtbar, [E-116](../Intern/BEFUNDE.md#e-116) |

## 1.0.84 — **veröffentlicht als `v1.0.84`** am 12.10.2026, Quellstand 7.2.0.84 (E-94)

| | |
|---|---|
| Testverzeichnis | als Verzeichnis bereitgestellt, `C:\Users\Gregor\Eudora72-1.0.84-release` (Prüfstand: `C:\Temp\E94-nachher`, die 8 Kerndateien byteidentisch) |
| ZIP (Release) | `Releases/Eudora72-1.0.84-release.zip`, 9 361 952 Byte (nicht versioniert); die 34 EXE/DLL/OCX darin byteidentisch mit Gregors getestetem Verzeichnis |
| SHA256 | `4b25a26ff55d5759153228b2bf17e3091a4fdc5cd59a2a5e083f32bd18731741` — gemessen am von GitHub heruntergeladenen ZIP |
| URL | https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.84 — 12.10.2026, 12:59:15 UTC, damals *Latest*, abgelöst durch `v1.0.87` (heute ist `v1.0.120` *Latest*); Marke auf `eb54752` |
| Quellstand | 7.2.0.84 (`Eudora71/Version.h`), gemergt als PR #86 |
| Gregors Test, 13.10.2026 | **bestätigt:** Testplan Teil A (E-49, E-50, E-52 bis E-63), E-85, E-93, AN-2; E-83 auf seinen Auftrag nachgemessen. **Durchgefallen:** E-101 (gespeicherte HTML-Datei: `<meta>` UTF-8, Inhalt Windows-1252), E-112 unverändert. **Neu gemeldet:** E-114, E-115. Urteile mit Zitat in [BEFUNDE.md](../Intern/BEFUNDE.md) |

Vergeben am 12.10.2026, weil sich die `Eudora.exe` gegenüber dem veröffentlichten
7.2.0.83 ändert (**V-1**). Inhalt: [CHANGELOG.md](../CHANGELOG.md), Abschnitt 7.2.0.84.

## 1.0.83 — **veröffentlicht als `v1.0.83`** am 12.10.2026, Quellstand 7.2.0.83 (AN-1 elfter Teil, mit AN-2)

| | |
|---|---|
| ZIP | `Releases/Eudora72-1.0.83-release.zip`, 9 361 416 Byte (nicht versioniert); dazu als Verzeichnis bei Gregor, `C:\Users\Gregor\Eudora72-1.0.83-release` (Prüfstand: `C:\Temp\AN5`) |
| SHA256 | `7cef4852645d053ca6e4fde3855e9294e3cbb22698e30687eed176be3c88f3eb` — gemessen am von GitHub heruntergeladenen ZIP |
| URL | https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.83 — 12.10.2026, 11:18:20 UTC, damals *Latest*, abgelöst durch `v1.0.84` (heute ist `v1.0.120` *Latest*); Marke auf `ec9f11d` |
| Quellstand | 7.2.0.83 (`Eudora71/Version.h`), Zweig `an1-endungen` |

Vergeben am 12.10.2026, weil 7.2.0.82 gebaut und gemessen war und 7.2.0.83 davon
abweicht (**V-1**). Inhalt: [CHANGELOG.md](../CHANGELOG.md), Abschnitt 7.2.0.83.

Von Gregor über IMAP an seinem Postfach getestet und am 12.10.2026 bestätigt
(*„gekürzt mit endung reicht"*) und danach angewiesen: *„erstelle ein release
auf github"*. Die 34 EXE-, DLL- und OCX-Dateien im ZIP sind byteidentisch mit
seinem getesteten Verzeichnis; kein Mailverzeichnis-Inhalt im ZIP.

## 1.0.82 — **gebaut und gemessen, nicht geschnürt**, Quellstand 7.2.0.82 (AN-1 und AN-2 zusammengeführt)

| | |
|---|---|
| ZIP | **existiert nicht** — nur das Prüfverzeichnis `C:\Temp\AN4` |
| SHA256 | **nicht belegt** |
| URL | **nicht belegt** — nicht veröffentlicht |
| Quellstand | 7.2.0.82 (`Eudora71/Version.h`), Zweig `an1-endungen` nach Merge von `main` (PR #83) |

Vergeben am 12.10.2026. Was drinsteckt, steht in
[CHANGELOG.md](../CHANGELOG.md), Abschnitte 7.2.0.82, 7.2.0.81, 7.2.0.80-an1 und
7.2.0.80.

## 1.0.81 — **gebaut und gemessen, nicht geschnürt**, Quellstand 7.2.0.81 (AN-1, neunter und zehnter Teil)

| | |
|---|---|
| ZIP | **existiert nicht** — nur das Prüfverzeichnis `C:\Temp\AN3` |
| SHA256 | **nicht belegt** |
| URL | **nicht belegt** — nicht veröffentlicht |
| Quellstand | 7.2.0.81 (`Eudora71/Version.h`), Zweig `an1-endungen` (bis 12.10.2026 `patch_20261012`) |

Vergeben am 12.10.2026, weil 7.2.0.80-an1 an diesem Tag gebaut und gemessen wurde
und 7.2.0.81 davon abweicht (**V-1**). Was drinsteckt, steht in
[CHANGELOG.md](../CHANGELOG.md), Abschnitt 7.2.0.81.

## Messfassung 1.0.80-an1 — **gebaut und gemessen, nicht geschnürt**, Quellstand 7.2.0.80 (AN-1, achter Teil) — **Nummer doppelt vergeben**

> Dieselbe Nummer trägt auch 1.0.80 (AN-2) weiter unten. Beide entstanden am
> 12.10.2026 auf getrennten Zweigen; diese hier gab es nur als Prüfbau.

| | |
|---|---|
| ZIP | **existiert nicht** — nur das Prüfverzeichnis `C:\Temp\AN2` |
| SHA256 | **nicht belegt** |
| URL | **nicht belegt** — nicht veröffentlicht |
| Quellstand | 7.2.0.80 (`Eudora71/Version.h`), Commit `ca8da5a` auf `an1-endungen` |

Gebaut am 12.10.2026 (Rebuild, 0 Fehler) und am laufenden Programm gemessen:
Fall 03 heil, Fall 05 ohne Endung. Einzelheiten in
[CHANGELOG.md](../CHANGELOG.md), Abschnitt Messfassung 7.2.0.80-an1.

## 1.0.80 — **nicht gebaut, nicht geschnürt**, Quellstand 7.2.0.80 (AN-2)

| | |
|---|---|
| ZIP | **existiert nicht** |
| SHA256 | **nicht belegt** — es gibt keine Datei |
| URL | **nicht belegt** — nicht veröffentlicht |
| Quellstand | 7.2.0.80 (`Eudora71/Version.h`), am 12.10.2026 |

Nummer vergeben, damit sie nicht zweimal vergeben wird. **Inhalt:** Befund
**AN-2** — Paige zeigte den Inhalt von `<script>` und `<style>` als Text, was
beim Start im Werbefenster den Quelltext einer Webseite sichtbar machte.
Gemessen mit `tools/html-tags-pruefen.pl` (30 Fälle, 0 Abweichungen, Gegenprobe
gefahren); **übersetzt ist nichts**. *Stand 12.10.2026: übersetzt erst als Teil
von 7.2.0.82 (siehe 1.0.82), am laufenden Programm nicht gemessen.*

Durchlauf: [AUFGABEN.md](../Intern/AUFGABEN.md), **B6**.

## 1.0.79 — **nicht gebaut, nicht geschnürt**, Quellstand 7.2.0.79 (AN-1)

> *Stand 12.10.2026: 7.2.0.79 ist am selben Tag doch gebaut und gemessen worden
> (Rebuild 0 Fehler, Prüfverzeichnis `C:\Temp\AN1`, 4 von 6 Prüffällen heil); **geschnürt
> wurde es nicht**. Der Abschnitt unten beschreibt den Stand beim Vergeben der
> Nummer. Aus den sieben Teilen wurden elf, aus den zehn Marken elf.*

| | |
|---|---|
| ZIP | **existiert nicht** |
| SHA256 | **nicht belegt** — es gibt keine Datei |
| URL | **nicht belegt** — nicht veröffentlicht |
| Quellstand | 7.2.0.79 (`Eudora71/Version.h`), am 12.10.2026 auf `main` |

Die Nummer ist am 12.10.2026 **vergeben**, damit sie nicht zweimal vergeben
wird — nicht, weil ein Paket existiert. **77** und **78** sind übersprungen,
weil Gregor sie am selben Tag auf seinem Rechner lokal gebaut hat; zwei
verschiedene `Eudora.exe` dürfen nicht dieselbe Nummer tragen (**V-1**). Was in
den beiden steckte, steht in [CHANGELOG.md](../CHANGELOG.md).

**Inhalt des Quellstands:** sechs der sieben Ursachen von **AN-1** sind geändert
— abgeschnittene Anhangnamen und fehlende Endungen —, dazu zehn Debug-Marken auf
dem Weg des Namens. **Übersetzt ist nichts**, und von Gregor ist nichts geprüft.
Gemessen ohne MSVC: `tools/kopfzeile-pruefen.pl` (10 Fälle, 0 Abweichungen) und
`tools/rfc2231-pruefen.pl` (20 Fälle, 0 Abweichungen). Offen bleibt **B5.7**.

Durchlauf zum Bauen und Prüfen: [AUFGABEN.md](../Intern/AUFGABEN.md), **B5**.

## 1.0.76 — gebaut am 18.09.2026, **E-112 behoben**

**Bilder erscheinen wieder in der Größe, die im HTML steht.** `pict_frame` — das
Zielrechteck, in das Paige eine Metadatei streckt — bekam bis dahin die **echte
Dateigröße**. Damit wurde das WhatsApp-Symbol mit 330×327 gezeichnet, obwohl es
als 35×35 ausgezeichnet ist.

Das war eine Regression der **E-106**-Behebung: sie vergrößerte die **Zeile**,
statt das **Bild** zu verkleinern. Solange **E-110** offen war, lud kaum ein
Bild und es fiel nicht auf; kaum luden sie, füllte eines das halbe Fenster.

Die Entscheidung sitzt jetzt in einer eigenen Funktion `E112Zielrechteck`, die
ohne Paige, ohne Fenster und ohne ein einziges Bild prüfbar ist — genau das
fehlte bei E-106. Die Regel: **vollständige Angabe gewinnt; ohne Angabe gilt
die Datei** (das ist E-103); ist nichts bekannt, wird nichts geändert.

**185 Tests, 185 bestanden** (sieben neue). Die Gegenprobe ist gefahren: mit der
alten Regel fallen **drei** davon um, während die E-103-Fälle und die Ränder in
beiden Richtungen grün bleiben.

**Was Gregor prüft:** dieselbe Nachricht öffnen und **antworten**. Die Bilder
müssen so groß sein wie im Lesefenster — kein Symbol, das das halbe Fenster
füllt, und kein Text, der von einem Bild zugedeckt wird.

**Nicht behoben, als E-113 aufgeschrieben:** ein Bild, dessen **angegebene**
Breite größer ist als das Fenster, läuft weiterhin rechts hinaus. Das ist die
Regel, die Newsletter mit `max-width:100%` meinen — auf Gregors Anordnung
*„erst A, dann B"* nicht mitbehoben.

## 1.0.75 — gebaut am 18.09.2026, **E-110 behoben**

**Bilder mit Leerzeichen im Namen kommen wieder an.** `resolve_URL`
(`HTMLUtils.cpp`) warf jede Prozent-Sequenz weg, statt sie zu entschlüsseln:
im `%`-Zweig wurde das entschlüsselte Zeichen nach `*output` geschrieben, der
Zeiger aber nicht weitergerückt — das nächste Zeichen überschrieb es. Aus
`en%20aktuellen%20Verlust.png` wurde `enaktuellenVerlust.png`, der Server
antwortete mit **404**, Eudora legte die Fehlerseite ab und zeichnete einen
grauen Kasten. Zehn von zwanzig Bildern in Gregors Nachricht.

Die Behebung ist ein `++output;`. Betroffen war **jede** Prozent-Sequenz, also
auch Umlaute in Dateinamen (`%C3%BC`), Klammern (`%28`) und Schrägstriche
(`%2F`) — der Fehler steckt im Originalcode von QUALCOMM, nicht in der
Portierung.

**178 Tests, 178 bestanden** (sieben neue). Die Gegenprobe ist gefahren: ohne
die Behebung fallen **vier** der sieben um, und zwar mit genau den
Zeichenketten aus Gregors Protokoll; die drei anderen prüfen den *erlaubten*
Fall (Adresse ohne Prozentzeichen, die Ränder, die Längenschranke) und bleiben
in beiden Richtungen grün.

**Was Gregor prüft:** dieselbe Nachricht öffnen und **antworten**. Die grauen
Kästen müssen verschwunden sein. Im Protokoll steht dann bei diesen Bildern
`datei=1 intern=1` und ein `daten=` ungleich 0.

**Nicht behoben, weiter offen:** `loader_result` bleibt auch jetzt `0` —
schlägt ein Bildabruf aus einem anderen Grund fehl, meldet Eudora es weiterhin
nirgends (in **E-110** vermerkt). Und **E-111**: `resolve_URL` kann bei einer
Adresse von genau 512 Zeichen ein Byte hinter das Zielfeld schreiben.

## 1.0.74 — gebaut am 18.09.2026, **Messfassung, kein Release**

**Behebt nichts, trennt aber die letzte offene Alternative zu E-110.** Die
Messfassung 1.0.73 hat gezeigt: von zehn Bildern werden fünf geladen
(`daten` gesetzt, `art=9`, jeweils beim **zweiten** Ruf) und fünf geben auf
(`ok=0 daten=0`). Damit ist belegt, dass der Wiederholungsmechanismus
funktioniert und der Abruf nicht gesperrt ist (`faden=1`, `fehler=0`).

**Was 1.0.73 nicht trennen konnte:** `ok=0` zusammen mit `daten=0` hat im
Quelltext **zwei** mögliche Ursachen —

1. `fetch_url_schmookie` liefert `-1`, der Abruf kommt gar nicht zustande;
2. die Datei **ist da**, aber weder `MetafileFromImage` noch QuickTime können
   sie umwandeln.

Das sind zwei ganz verschiedene Behebungen. Im ersten Fall liegt der Fehler im
Abrufweg, im zweiten im Bilddecoder — und das Bild läge längst auf der Platte.

**Neu in der Zeile:** `datei=` (0 = keine Datei, 1 = Datei vorhanden, −1 = der
Block wurde nie betreten) und `intern=` (hat `CanHandleImageInternally`
zugestimmt?). `filePath` liegt in einem inneren Block und ist an der Messstelle
nicht mehr sichtbar; beide Werte werden deshalb dort gemerkt, wo sie entstehen.

**Wozu Gregor es braucht:** dieselbe Nachricht, antworten, `eudora.log`
sichern. `datei=1 intern=0` heißt: geholt, aber nicht als Bild erkannt.
`datei=1 intern=1 daten=0` heißt: erkannt und trotzdem nicht umgewandelt.
`datei=0` heißt: nie angekommen.

**Nicht als Release herausgeben.**

## 1.0.73 — gebaut am 18.09.2026, **Messfassung, kein Release**

**Dieses Paket behebt nichts.** Es enthält gegenüber 1.0.72 genau eine
Änderung: die E-95-Spurmarke sagt jetzt, ob hinter einem Bild überhaupt Daten
liegen. Gebaut, weil Gregors Protokoll vom 18.09.2026 die Frage zu **E-110**
nicht beantworten konnte — 128 Zeilen `E-95 Bild`, und keine unterscheidet ein
geladenes Bild von einem grauen Platzhalter. Ausgegeben wurden zweimal **Maße**
(`source_width/height` aus dem HTML gegen `mess_ptr->width/height` aus dem
Embed), nie der Datenbestand.

Neu in der Zeile: **`daten=`** aus `image_data` — den Metadatei-Griff setzt
`PgLoadUrlImage`, sobald die Datei wirklich da ist; bleibt er `0`, hat Paige
nichts zu zeichnen. Dazu **`art=`** aus `type_and_flags` und die **ungekürzte
Adresse**: die war zweifach beschnitten (Kopierschleife auf 32 Zeichen *und*
`%.32s` im Format), weshalb alle 128 Bilder im Protokoll gleich aussahen. Bei
zu langer Adresse fällt jetzt die **Mitte** weg, nicht das Ende — bei **E-106**
hing alles am Dateinamen, `_3x` heißt dreifache Auflösung.

**Wozu Gregor es braucht:** auf dieselbe Nachricht antworten, in der Bilder grau
bleiben, und die `eudora.log` sichern. `daten=0` bei einem Bild, das im
Lesefenster sichtbar ist, heißt: Eudora **holt es auf dem Antwortweg nicht**.
`daten` gesetzt und trotzdem grau heißt: es **holt es und zeichnet es nicht**.
Zwei verschiedene Ursachen, zwei verschiedene Behebungen.

**Nicht als Release herausgeben.** Eine Messfassung ist kein Fortschritt für
den Anwender; E-110 ist damit nicht behoben, sondern erst messbar.

## 1.0.72 — gebaut am 17.09.2026, **von Gregor bestätigt**

**Die erste Fassung ohne den Absturz beim Antworten.** Gregor an diesem Abend:
*„kein crash"* — und sein Protokoll belegt es dreifach: der E-106-Block läuft
**18 mal**, er läuft **über die bisher tödliche Stelle hinaus** (`pos=770`
hinter dem `pos=765`, an dem in allen drei Absturzprotokollen Schluss war), und
die letzte Zeile lautet `Logging shutdown`. Keine `Exception.log`, nicht einmal
eine leere.

Inhaltlich **E-108**: der direkte Zugriff auf den Textstil, den **E-106**
eingeschleppt hatte, ist entfernt; stattdessen derselbe Weg wie im Originalcode
von 1996 (Maße ins Embed, `pgInvalEmbedRef` rechnen lassen). Dazu bringt das
Paket erstmals **`LogLevel=58527` in `[Debug]`** mit — Gregors erstes
Absturzprotokoll zu 1.0.71 war leer, weil der Schalter fehlte.

| | |
|---|---|
| **Paket** | `Releases/Eudora72-1.0.72-release.zip` (**nicht im Repo versioniert**) |
| **SHA256** | `b65a3d235d7cfb7967d78723ff4fc5b249534dd097a860028e1ff13ead3c480f` |
| **Größe** | 9 356 860 Byte, 157 Dateien |
| **Quellstand** | 7.2.0.72 (`Eudora71/Version.h`) |
| **`Eudora.exe` im Paket** | 2 987 008 Byte, 17.09.2026 21:56 |
| **`EudoraRes.dll` im Paket** | 2 448 384 Byte |
| **Paketprüfung** | keine Fehler |
| **Tests** | 171 von 171 |

## 1.0.71 — gebaut am 17.09.2026, **stürzt ab**

**Nicht benutzen.** Enthielt **E-107**, das sich als die **falsche Erklärung**
für den Absturz erwies: der E-106-Block wurde auf den Ladeweg beschränkt, lief
dort aber weiter — Gregors Protokoll zeigt ihn fünfmal, und der Abbruch kam an
derselben Stelle wie an 1.0.69.

Diese Fassung ist der Beleg dafür, dass die Ursache **im Block** saß und nicht
darin, wer ihn aufruft. Ohne sie wäre E-108 nicht gefunden worden.

| | |
|---|---|
| **Paket** | `Releases/Eudora72-1.0.71-release` (Verzeichnis, **kein ZIP**) |
| **Quellstand** | 7.2.0.71 |
| **`Eudora.exe` im Paket** | 2 987 520 Byte, 17.09.2026 21:32 |
| **Dateien** | 157 |
| **Achtung** | ohne `LogLevel` in der INI — Gregors erstes Absturzprotokoll blieb deshalb leer |

## 1.0.70 — gebaut am 17.09.2026, kein Release

**Die erste Fassung, die alles enthält.** Die vier davor enthielten jeweils nur
einen Teil — siehe die Tabelle im [CHANGELOG](../CHANGELOG.md), Abschnitt
7.2.0.70. Inhaltlich kein neuer Code gegenüber `ceab98f`; diese Fassung bündelt
**E-101** (beide Teile samt Datenverlust **P-28**), **E-103**, **E-104**,
**E-106** und **P-38**.

**Zu prüfen ist genau ein Punkt:** ob **E-106** trägt. Die Behebung ist am
Prüfstand **nicht** nachweisbar, weil er die Bilder nicht lädt; nur Gregors Lauf
kann sie belegen. Was im Protokoll stehen muss, steht im CHANGELOG.

| | |
|---|---|
| **Paket** | `Releases/Eudora72-1.0.70-release.zip` (**nicht im Repo versioniert**) |
| **SHA256** | `6c36638665161f80b72b69cba66e11851b64252379ddc9029eb097e5bbde4605` |
| **Größe** | 9 356 792 Byte, 157 Dateien |
| **Quellstand** | 7.2.0.70 (`Eudora71/Version.h`), Grundlage `ceab98f` |
| **Marke** | keine — kein Release |
| **`Eudora.exe` im Paket** | 2 987 520 Byte, 17.09.2026 21:18 |
| **`EudoraRes.dll` im Paket** | 2 448 384 Byte |
| **Paketprüfung** | `paket-pruefen.ps1`: keine Fehler |
| **Tests** | 171 von 171 |

## 1.0.69 — gebaut am 17.09.2026, kein Release

Aus der **zweiten Sitzung**, die parallel an **E-101** arbeitete. Enthält den
zweiten Teil von E-101 (*„ohne Kopfzeilen fehlte der Content-Type ganz"*) und
**P-38** (die Spurmarke misst den Rumpf), **aber nicht E-106**.

Die Nummer entstand als **Ausweichnummer**: beide Sitzungen hatten
unabhängig die **68** vergeben. Der Commit heißt wörtlich *„7.2.0.69 / 1.0.69 —
die Nummernkollision mit E-106 aufgelöst"*.

| | |
|---|---|
| **Paket** | nur ausgepackt bei Gregor unter `%USERPROFILE%\Eudora72-1.0.69-release`, **kein Verzeichnis unter `Releases/`, kein ZIP** |
| **Quellstand** | 7.2.0.69 |
| **Marke** | keine — kein Release |
| **`Eudora.exe`** | 2 987 008 Byte, 17.09.2026 20:24 |
| **Achtung** | 235 Dateien statt 157 — das Mailverzeichnis liegt darin, es ist Gregors Testverzeichnis, kein reines Paket |

## 1.0.68 — gebaut am 17.09.2026, kein Release

Enthält **E-106** (Bilder, die größer sind als angegeben) und **E-104**, **nicht**
aber den zweiten Teil von E-101. **Dieselbe Nummer wurde von der zweiten Sitzung
ein zweites Mal vergeben** — daher die Kollision.

Ein erster Anlauf trug in der `Eudora.exe` noch **7.2.0.67**: die Fassung war
hochgezogen, aber nicht neu gebaut worden. Aufgefallen beim Abfragen der
Versionsnummer aus der ausgelieferten Datei; neu gebaut und neu geschnürt.

| | |
|---|---|
| **Paket** | `Releases/Eudora72-1.0.68-release` (Verzeichnis, **kein ZIP**) |
| **Quellstand** | 7.2.0.68 |
| **Marke** | keine — kein Release |
| **`Eudora.exe` im Paket** | 2 987 008 Byte, 17.09.2026 20:18 |
| **Dateien** | 157 |
| **Paketprüfung** | keine Fehler |

## 1.0.67 — gebaut am 17.09.2026, kein Release

Enthält **E-101** (erster Teil) und **E-103** (Mindestzeilenhöhe für Bilder ohne
Größenangabe). An dieser Fassung hat Gregor belegt, dass **E-103 seinen Fall
nicht traf** — sein Logo trägt `width=200 height=52`, also eine Angabe. Daraus
entstand **E-106**.

| | |
|---|---|
| **Paket** | `Releases/Eudora72-1.0.67-release` (Verzeichnis, **kein ZIP**) |
| **Quellstand** | 7.2.0.67 |
| **Marke** | keine — kein Release |
| **`Eudora.exe` im Paket** | 2 985 984 Byte, 17.09.2026 18:58 |
| **Dateien** | 157 |
| **Paketprüfung** | keine Fehler |

## 1.0.66 — **nie geschnürt**

Der Quellstand 7.2.0.66 hat es gegeben — er trug die erste Fassung von
**E-101** —, aber **es wurde nie ein Paket daraus gebaut**. Weder unter
`Releases/` noch bei Gregor liegt etwas. Der Eintrag steht hier, damit die Lücke
in der Zählung nicht wieder für eine freie Nummer gehalten wird.

## 1.0.64 — veröffentlicht am 17.09.2026

**Speichern stürzt nicht mehr ab** (**E-97**). Titel der Veröffentlichung:
*„7.2.0.64 / Paket 1.0.64 - Speichern stuerzt nicht mehr ab"*.

**Am 11.10.2026 nachgetragen.** Dieser Abschnitt hat gefehlt: `v1.0.64` liegt
seit 17.09.2026 auf GitHub, in dieser Buchführung stand es nicht. Aufgefallen ist
es, weil `tools/doku-pruefen.pl` die Zeile `CHANGELOG.md:888` abwies — sie nennt
`Eudora72-1.0.64-release.zip`, und die Schranke verlangt dann, dass das ZIP
entweder in `Releases/` liegt oder **hier** geführt wird. Solange das fehlte,
wies der Haken **jeden** Push auf `main` ab.

Die Angaben unten stammen aus der GitHub-API (`gh api
repos/HansWurst81675/Eudora7.2/releases/tags/v1.0.64`), **nicht** aus einem
eigenen Lauf. Was dort nicht steht, steht hier auch nicht — Dateizahl im ZIP,
Größe der `Eudora.exe`, Paketprüfung und Testzahlen sind für diese Fassung
**nicht belegt** und werden hier nicht erfunden.

| | |
|---|---|
| **Paket** | `Releases/Eudora72-1.0.64-release.zip` (**nicht im Repo versioniert**) |
| **SHA256** | `7d8982432cecc5ce298bec1763143c86597c529558e1bee09fa0c25e564d4bf0` |
| **Größe** | 9 354 875 Byte |
| **Quellstand** | 7.2.0.64 |
| **Netzadresse** | https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.64 |
| **Dateizahl, `Eudora.exe`, Paketprüfung, Tests** | nicht belegt |

## 1.0.47 — veröffentlicht am 11.09.2026

**Der Blah-Blah-Blah-Knopf blendet Kopfzeilen wieder aus** (**E-80**).
Titel der Veröffentlichung: *„7.2.0.47 / Paket 1.0.47 — der Blah-Blah-Blah-Knopf
blendet Kopfzeilen wieder aus"*.

**Am 11.10.2026 nachgetragen.** Dieser Abschnitt hat gefehlt: `v1.0.47` liegt
seit 11.09.2026 auf GitHub, in dieser Buchführung stand es nicht. Aufgefallen ist
es, weil `tools/doku-pruefen.pl` beim Nachrechnen am 11.10.2026 auffiel: von **14**
Veröffentlichungen auf GitHub fehlten **drei** in dieser Datei. Gemeldet hat
das kein Werkzeug — `pruefe-release-buchfuehrung.pl` prüft nur die **neueste**
Marke, nicht die Vollständigkeit.

Die Angaben unten stammen aus der GitHub-API (`gh api
repos/HansWurst81675/Eudora7.2/releases/tags/v1.0.47`), **nicht** aus einem
eigenen Lauf. Was dort nicht steht, steht hier auch nicht — Dateizahl im ZIP,
Größe der `Eudora.exe`, Paketprüfung und Testzahlen sind für diese Fassung
**nicht belegt** und werden hier nicht erfunden.

| | |
|---|---|
| **Paket** | `Releases/Eudora72-1.0.47-release.zip` (**nicht im Repo versioniert**) |
| **SHA256** | `df299585655080ad6d533409a1d8f03ba6d51dd1fed74c98afde8b45dd22fd97` |
| **Größe** | 9 355 896 Byte |
| **Quellstand** | 7.2.0.47 |
| **Netzadresse** | https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.47 |
| **Dateizahl, `Eudora.exe`, Paketprüfung, Tests** | nicht belegt |

## 1.0.43 — veröffentlicht am 10.09.2026

**Filter löschen nichts mehr auf dem Server, Fenstergrößen bleiben.**
Titel der Veröffentlichung: *„7.2.0.43 / Paket 1.0.43 — Filter loeschen nichts
mehr auf dem Server, Fenstergroessen bleiben"*.

**Am 11.10.2026 nachgetragen.** Dieser Abschnitt hat gefehlt: `v1.0.43` liegt
seit 10.09.2026 auf GitHub, in dieser Buchführung stand es nicht. Aufgefallen ist
es, weil `tools/doku-pruefen.pl` beim Nachrechnen am 11.10.2026 auffiel — siehe 1.0.47.

Die Angaben unten stammen aus der GitHub-API (`gh api
repos/HansWurst81675/Eudora7.2/releases/tags/v1.0.43`), **nicht** aus einem
eigenen Lauf. Was dort nicht steht, steht hier auch nicht — Dateizahl im ZIP,
Größe der `Eudora.exe`, Paketprüfung und Testzahlen sind für diese Fassung
**nicht belegt** und werden hier nicht erfunden.

| | |
|---|---|
| **Paket** | `Releases/Eudora72-1.0.43-release.zip` (**nicht im Repo versioniert**) |
| **SHA256** | `e68d8a8a579c6644a99043d915eae3d001f607dc1021a5dbb15c3fde476d669d` |
| **Größe** | 9 347 153 Byte |
| **Quellstand** | 7.2.0.43 |
| **Netzadresse** | https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.43 |
| **Dateizahl, `Eudora.exe`, Paketprüfung, Tests** | nicht belegt |

## 1.0.41 — gebaut am 10.09.2026, kein Release

**Nicht veröffentlicht.** Gregor hat die Fassung noch nicht beurteilt; ein
Release entsteht erst danach (Lehre `release-erst-nach-gregors-test`). Das ZIP
liegt **nicht** im Repo, sondern nur im Arbeitsbaum unter
`Releases/Eudora72-1.0.41-release.zip` und ausgepackt bei Gregor unter
`%USERPROFILE%\Eudora72-1.0.41-release`.

Inhaltlich bringt sie **E-70** (die Andockgrößen überleben einen Neustart —
der Aufruf saß in `SECToolBarManager::LoadState`, die Eudora nie aufruft) und
die Bestätigung von **E-64** als Fehlalarm. Neu eingebaut ist die Spurmarke zu
**E-76**.

| | |
|---|---|
| **Paket** | `Releases/Eudora72-1.0.41-release.zip` (**nicht im Repo versioniert**) |
| **SHA256** | `22949297c77c6f55c6f1e27d5a03646ccecb2fd3b538f7ecdf9909d8014d15ce` |
| **Größe** | 9 346 106 Byte, 157 Einträge |
| **Quellstand** | 7.2.0.41 (`Eudora71/Version.h`) |
| **Marke** | keine — kein Release |
| **`Eudora.exe` im ZIP** | 2 966 016 Byte, 10.09.2026 13:12 |
| **`EudoraRes.dll` im ZIP** | 2 447 360 Byte, 10.09.2026 13:10 |
| **`.sha256` daneben** | fehlt |

Alle Zahlen am 10.09.2026 nachgemessen: `Get-FileHash`, `Length` und die
Einträge im ZIP über `System.IO.Compression.ZipFile`. `paket-pruefen.ps1`
meldete beim Bau keine Fehler, Kriterium 0 **JA**.

> **Das ZIP hat keine eigene Wurzelebene.** Alle 157 Einträge liegen auf der
> obersten Ebene. Es darf deshalb nur in ein **eigenes, leeres** Verzeichnis
> ausgepackt werden — am 10.09.2026 ist es einmal direkt nach
> `C:\Users\Gregor` gegangen und hat dort eine `Eudora.ini` des Anwenders
> überschrieben (Lehre `anwenderdatei-nicht-erschlagen`,
> `tools/home-aufraeumen.ps1`).

## 1.0.29 — veröffentlicht am 09.09.2026

**Stand 09.09.2026 die jüngste Fassung, und die einzige, die damals als Paket
im Repo lag.** Sie
bringt gegenüber 1.0.28 fünfzehn Behebungen: acht aus **PRÜFERs** sechstem
Durchgang (**E-54** bis **E-61**) und sieben aus dem ersten Lauf der Schranke
`tools/pruefe-nachrichtenschleife.pl`, die daraus entstanden ist (**E-62**).
**Von Gregor am 09.09.2026 beurteilt:** *„1-6, ok"* — mit einem Restfehler,
den er selbst zurückgestellt hat (**E-63**, die letzte Registerkarte zeigt
keinen Kurzhinweis).

| | |
|---|---|
| **Paket** | `Releases/Eudora72-1.0.29-release.zip` (**im Repo versioniert**) |
| **SHA256** | `cf60bb3a806204ea4ae85af5cbaccc46f432f22f699b5063ae1d36a2a998158c` |
| **Größe** | 9 342 274 Byte |
| **Quellstand** | 7.2.0.29 — alle drei Makros in `Eudora71/Version.h` stimmen überein (`EUDORA_VERSION4 29`, `EUDORA_BUILD_NUMBER 7,2,0,29`, `EUDORA_BUILD_VERSION "7.2.0.29"`) |
| **Marke** | [v1.0.29](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.29) — zeigt auf Commit `15a7cb8`, den Stand, aus dem dieses Paket gebaut ist |
| **`Eudora.exe` im ZIP** | 2 961 408 Byte, 09.09.2026 12:37 |
| **`EudoraRes.dll` im ZIP** | 2 447 360 Byte, 09.09.2026 12:17 |
| **`.sha256` daneben** | **fehlt** (siehe Kopfkasten) |

Alle Zahlen am 09.09.2026 nachgemessen: `Get-FileHash`, `Length`, und die
Einträge im ZIP über `System.IO.Compression.ZipFile`.

> **Paket gegen den Bau gemessen** (Lehre `paket-gegen-den-bau-messen`).
> `Eudora.exe` und `EudoraRes.dll` im ZIP sind byte- und zeitgleich mit
> `Eudora71/Bin/Release/` im Hauptbaum, und **beide tragen dieselbe
> Produktversion 7.2.0.29**. Das ist nicht selbstverständlich: an 1.0.22/1.0.23
> hat genau dieser Unterschied den Dialog *„Eudora has loaded a Resource DLL
> that does not match this version of Eudora"* erzeugt. `tools/testlauf.ps1`
> prüft es seitdem vor jedem Start, `tools/paket-pruefen.ps1` nach jedem
> Packen.

`tools/paket-pruefen.ps1`: **keine Fehler**, Kriterium 0 erfüllt. 35
Binärdateien, 13 in der Startkette, in der Startkette fehlt nichts, keine
Debug-Laufzeit, keine `.pdb`. Vier Warnungen, alle bekannt und hingenommen:
`EUMAPI.DLL` und `ifsmon.vxd` sind 16-Bit-Altlast, die niemand importiert,
`MFC71.DLL` und `MSVCP71.dll` fehlen (**E-47**).

| Befund | was | Stand |
|---|---|---|
| **E-54** | der Ziehrahmen war beim Ziehen nach **rechts** unsichtbar — gezeichnet wurde auf die 188 Pixel breite Andockleiste. Jetzt auf den **Bildschirm**, mit Fenstersperre, wie `CDockContext::InitLoop` es macht | **behoben, von Gregor bestätigt** |
| **E-55** | ein acht Pixel hoher leerer Streifen unter der Werkzeugleiste — der Zuschlag für den Greifstreifen galt für alle vier Andockleisten | **behoben, von Gregor bestätigt** |
| **E-56** | *Show MDI task bar* abschalten ließ den Kartenstreifen stehen — `RecalcLayout` und `ResetTaskBar` stehen im Original innerhalb von `if (m_bWorkbookMode)` | **behoben, von Gregor bestätigt** |
| **E-57** | `IsTabLabelTruncated` legte bei jeder Mausbewegung eine `CPaintDC` außerhalb von `WM_PAINT` an und verwarf damit den Malbereich | **behoben, von Gregor bestätigt** |
| **E-58** | ein Klick in den rechten Rand des Streifens öffnete den **Browser** — `CalcLogoTopLeft` prüft nur x, und das Logo wird gar nicht gezeichnet. Rückentwicklung aus 1.0.25 bis 1.0.28 | **behoben, von Gregor bestätigt** |
| **E-59** | `m_cxTab` wurde nur in `OnPaint` gesetzt; Treffprüfungen rechneten mit dem alten Wert | **behoben** |
| **E-60** | ein Trennbalken konnte **während des Ziehens** gelöscht werden — `Track` verteilt Nachrichten, eine davon löst einen Anordnungsdurchlauf aus | **behoben** |
| **E-61** | `Track` verschluckte `WM_QUIT` — Kriterium 7 wäre lautlos wieder offen gewesen | **behoben, von Gregor bestätigt** (*File → Exit* geprüft) |
| **E-62** | **sieben** eigene Nachrichtenschleifen in Eudoras Quellen verschluckten `WM_QUIT`; zwei davon (`LeftClickAttachment`, `CTocView::SizeColumn`) **hängen** danach für immer, mit gehaltenem Mausfang — bei `SizeColumn` genügt das Ziehen einer Spaltenbreite | **behoben** |
| **E-63** | die **letzte** Registerkarte zeigt keinen Kurzhinweis | **offen, von Gregor zurückgestellt** — behoben in 7.2.0.30, von Gregor an 1.0.84 bestätigt am 13.10.2026 |
| **E-49**, **E-52** | linken Bereich breiter ziehen und Balken danach greifbar (**A-4**) — aus 1.0.26/1.0.27 übernommen | **behoben, das seitliche Ziehen damals noch nicht beurteilt** — von Gregor an 1.0.84 bestätigt am 13.10.2026 |

## 1.0.27 — veröffentlicht am 09.09.2026

**Von 1.0.29 abgeloest; das ZIP ist aus dem Repo genommen, die Marke und die
Veroeffentlichung bestehen.** Sie bringt
gegenüber 1.0.26 zwei Nachbesserungen am Trennbalken links (**E-52**): der
Balken bleibt nach dem Verbreitern greifbar, und die Registerkarten stehen
danach nicht doppelt. **Von Gregor noch nicht beurteilt** — bestätigt ist nur
der Gegenfall, die Höhe: *„verschieben rauf / runter — bug gefixt, die anzeige
ist korrekt."*

| | |
|---|---|
| **Paket** | `Eudora72-1.0.27-release.zip` — **nicht mehr im Repo**, haengt an der Marke v1.0.27 |
| **SHA256** | `69595d4b380204eb5ac6d327ce8ded65080b356594090a2465394ced07f81b3a` |
| **Größe** | 9 342 224 Byte |
| **Quellstand** | 7.2.0.27 — alle drei Makros in `Eudora71/Version.h` stimmen überein (`EUDORA_VERSION4 27`, `EUDORA_BUILD_NUMBER 7,2,0,27`, `EUDORA_BUILD_VERSION "7.2.0.27"`) |
| **Marke** | [v1.0.27](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.27) — **die einzige Veröffentlichung, an der noch Dateien hängen** |
| **`Eudora.exe` im ZIP** | 2 960 896 Byte, 09.09.2026 11:02 (`unzip -l`) |
| **`EudoraRes.dll` im ZIP** | 2 447 360 Byte, 09.09.2026 11:02 |
| **`QCSSL.dll`** | 1.0.1 — dieselbe Datei wie seit 1.0.1 (2 920 960 Byte, 30.08.2026 17:57) |
| **`DEudora.ini`** | 6 960 Byte, 07.09.2026 15:15 — die Vorgaben für ein neu angelegtes Konto (**A-1**) |
| **`.sha256` daneben** | **fehlt** (siehe Kopfkasten) |

Alle Zahlen am 09.09.2026 nachgemessen: `sha256sum`, `stat -c%s`, `unzip -l`.

> **Paket gegen den Bau gemessen.** `Eudora.exe` im ZIP ist 2 960 896 Byte
> groß; `Eudora71/Bin/Release/Eudora.exe` im Hauptbaum hat **dieselbe Größe**,
> trägt aber den Zeitstempel 09.09.2026 11:35 gegen 11:02 im ZIP. Größe und
> Quellstand stimmen also, der Bau im Arbeitsbaum ist nach dem Packen noch
> einmal gelaufen. Das Bauverzeichnis dieses Arbeitsbaums
> (`Eudora7.2-wt-lektor`) enthält **keine** `Eudora.exe` — hier wird nicht
> gebaut.

| Befund | was | Stand |
|---|---|---|
| **E-52** | nach dem Verbreitern war der Trennbalken nicht mehr greifbar, und die Registerkarten standen doppelt — MFC verschiebt die Leisten mit `DeferWindowPos`, in `OnSizeParent` ist die neue Größe noch nicht gesetzt. Der Balken entsteht jetzt in `OnSize`, und `OnSplitterMoved` frischt mit `RDW_INVALIDATE \| RDW_ERASE \| RDW_ALLCHILDREN` auf | **behoben, nicht bestätigt** |
| **E-49** | der linke Bereich lässt sich breiter ziehen (Anforderung **A-4**) — aus 1.0.26 übernommen, Endstand 188 Pixel Andockleiste bei 180 Pixel Leiste, 8 Pixel freier Streifen | **behoben, damals nicht bestätigt** — von Gregor an 1.0.84 bestätigt am 13.10.2026 |
| **E-50** | drei Mängel an der Registerkartenleiste — aus 1.0.26 übernommen | **behoben, damals nicht bestätigt** — von Gregor an 1.0.84 bestätigt am 13.10.2026 |
| **E-51** | die eigene Ziehschleife konnte Eudora einfrieren; jetzt höchstens 100 ms Wartezeit, danach Fenster, Mausfang und **physische** Maustaste erneut geprüft | **behoben, bevor es ausgeliefert wurde** |
| **E-48** | die Registerkartenleiste für die offenen Fenster (Anforderung **A-3**) — aus 1.0.25 übernommen | **behoben, von Gregor am 09.09.2026 bestätigt** |
| **E-43** | `SECControlBar` war zweimal definiert — aus 1.0.24 übernommen; mit ihm fielen **E-37** und **E-38** weg | **behoben, von Gregor am 08.09.2026 bestätigt** |

**Was in dieser Fassung nicht geht:** nach einem Neustart stehen die Fenster
nicht im Vollbild, obwohl sie beim Beenden so waren (Nebenbefund **ohne
Kennung**, von Gregor an 1.0.25 gemeldet); beim Öffnen der
Kurznamen-/Verzeichnisdienst-Leiste kommt der Fehlerdialog **E-47**
(`MFC71.DLL` und `MSVCP71.dll` fehlen, keine Behebung in Sicht); die Meldung
„Encountered an improper argument" beim **Anzeigen** mancher Nachrichten ist
**seit E-43 neu zu messen**; und **E-39** ist offen. Die Prüfanleitung steht
im [CHANGELOG.md](../CHANGELOG.md) unter *Was an 1.0.27 zu prüfen ist*.

## 1.0.23 — gebaut am 08.09.2026, Marke v1.0.23 gesetzt, Paket nicht mehr abrufbar

**Die Fassung, mit der Anforderung A-2 erfüllt ist:** *Task Status* und *Task
Errors* liegen waagrecht am unteren Fensterrand. Von Gregor am 08.09.2026
bestätigt: *„jetzt ist sie unten, ja"*.

| | |
|---|---|
| **Paket** | `Eudora72-1.0.23-release.zip` — **nicht mehr im Repo und nicht mehr abrufbar**; die Veröffentlichung zu `v1.0.23` ist am 09.09.2026 gelöscht worden, die Marke besteht |
| **SHA256** | `3f58a93c85c8fbf9f206ccc319a4798bb40236f3b60821a3de6df17710139045` |
| **Größe** | 9 340 228 Byte |
| **Quellstand** | 7.2.0.23 (`Eudora71/Version.h`) |
| **Marke** | `v1.0.23` — gesetzt, aber ohne Dateien daran |
| **Eudora.exe im ZIP** | 2 957 312 Byte, 08.09.2026 10:51 (`unzip -l`, gemessen am 08.09.2026, solange das ZIP noch da war) |
| **QCSSL** | 1.0.1 — dieselbe Datei wie in 1.0.21 und 1.0.22 (2 920 960 Byte, 30.08.2026 17:57) |

Alle Zahlen am 08.09.2026 nachgemessen: `sha256sum`, `stat -c%s`, `unzip -l`.
**Das ZIP liegt heute nicht mehr im Repo** — es ist am 09.09.2026 durch das zu
1.0.27 ersetzt worden (`git status`: Umbenennung
`Eudora72-1.0.23-release.zip` → `Eudora72-1.0.27-release.zip`). Die Prüfsumme
oben ist alles, was von dieser Fassung bleibt.

| Befund | was | Stand |
|---|---|---|
| **E-44** | *Task Status* und *Task Errors* waagrecht unten statt senkrecht links — zwei Ursachen, beide gemessen (`ID_SEC_HIDE` beim frischen Profil; keine Andockseite in `LoadWazooConfigFromIni` ab dem zweiten Start) | **behoben, von Gregor bestätigt** |
| **E-45** | `QCWorkbook::OnClose` darf **nicht** übersprungen werden, sonst bleibt ein Prozess ohne Fenster übrig; eigener Fangzweig holt `DestroyWindow()` nach | **behoben** (von PRUEFER gefunden, `Befunde/PRUEFER-5.md`) |
| **E-46** | Verdacht, `CMainFrame::OnClose` arbeite auf einem freigegebenen Objekt weiter — Spurmarke im Destruktor | **widerlegt**: die Marke erscheint erst *nach* der Stelle |
| **E-43** | `SaveCustomInfo` wirft weiter; die verfeinerte Marke misst vier Werte in einer Zeile und schließt „flackernder Wert" und „freigegebenes Objekt" aus | **offen, Ursache eingegrenzt** |
| **E-37** | zweiter Anlauf für das Löschen eines Kontos — Suche über `GetItemText` statt `FindItem`, ohne `PopulateView()` | **gebaut, von Gregor nicht bestätigt** |

**Was in dieser Fassung noch nicht geht:** ein gelöschtes Konto verschwindet
möglicherweise weiter erst nach einem Neustart aus der Liste (**E-37**, nicht
bestätigt), die im Kontoassistenten eingegebenen Daten fehlen unter
*Konto → Eigenschaften* (**E-38**, jetzt erstmals messbar), und die Leiste am
unteren Rand zeigt *Task Status* und *Task Errors*, nicht die Reiter für die
offenen Fenster (Kriterium 8, halb). Die Einzelheiten stehen im
[CHANGELOG.md](../CHANGELOG.md) unter 7.2.0.23.

## 1.0.22 — gebaut am 08.09.2026, nicht als Marke veröffentlicht

**Die Fassung, mit der Kriterium 7 erfüllt ist:** Eudora beendet sich über
*File → Exit*, über **Alt-F4** und über das **Kreuz**. Von Gregor am 08.09.2026
bestätigt: *„schließen klappt jetzt."* Ebenfalls von ihm bestätigt ist
Anforderung **A-1**: *„default werte beim neuen persona konto für ‚leave
message on server' greifen."*

| | |
|---|---|
| **Paket** | `Eudora72-1.0.22-release.zip` — **nicht mehr im Repo**; nur die `.sha256`-Datei liegt noch in `Releases/`. Es gibt keine Marke `v1.0.22` und keine Veröffentlichung |
| **SHA256** | `7ddab1a0f0fdf1c4458a7aa2ab00d2f1fbb15561ab576657c73006fcfa95586c` |
| **Größe** | 9 339 516 Byte |
| **Quellstand** | 7.2.0.22 (`Eudora71/Version.h`) |
| **Marke** | **keine** — nicht veröffentlicht |
| **Eudora.exe im ZIP** | 2 956 288 Byte, 08.09.2026 08:58 (`unzip -l`) |
| **QCSSL** | 1.0.1 (unverändert seit 1.0.1) |

Alle Zahlen am 08.09.2026 nachgemessen: `sha256sum`, `stat -c%s`, `unzip -l`.

| Befund | was | wo |
|---|---|---|
| **E-40** | eine Rückfrage, die sich nicht öffnen lässt, galt als „Abbrechen" | `Eudora71/Eudora/doc.cpp`, `msgdoc.cpp` (`SaveModified`) |
| **E-41** | Alt-F4 und das Kreuz laufen durch ein `ENSURE_VALID`, das *File → Exit* nicht hat | `Eudora71/Eudora/mainfrm.cpp` (`OnSysCommand`) |
| **E-42** | zwölf Aufräumschritte konnten das Beenden abbrechen — neues Makro `AUFRAEUMEN` | `Eudora71/Eudora/mainfrm.cpp` (`OnClose`, `CloseDown`) |
| **A-1** | Vorgaben für ein **neu angelegtes** Konto greifen | `tools/DEudora.ini`, Anforderung in [ZIEL.md](../ZIEL.md) |

**Was in dieser Fassung noch nicht geht:** *Task Status* und *Task Errors*
liegen senkrecht links (Anforderung **A-2**, erst in 1.0.23 behoben), der erste
E-37-Anlauf war eine **Regression** und zeigte beim Löschen einer Persönlichkeit
„Encountered an improper argument", und `SaveCustomInfo` wirft beim Beenden
weiter (**E-43**, abgefangen). Die Prüfanleitung steht im
[CHANGELOG.md](../CHANGELOG.md) unter *Was an 1.0.22 zu prüfen ist*.

## 1.0.21 — veröffentlicht am 07.09.2026

**Die erste Fassung, mit der eine Mail geschrieben, abgeschickt und die Antwort
empfangen wurde.** Von Gregor am 07.09.2026 bestätigt: *„mail können jetzt
abgeschickt werden."* und *„weiterleitung funktioniert übrigens."* Damit sind
die Kriterien 5 und 6 aus [ZIEL.md](../ZIEL.md) belegt.

| | |
|---|---|
| **Paket** | `Eudora72-1.0.21-release.zip` — **nicht mehr im Repo**; nur die `.sha256`-Datei liegt noch in `Releases/` |
| **SHA256** | `0a699fcb03c3f0b60a0142837fc2128f3baf19884cd6b96a4f388339165b667c` |
| **Größe** | 9 331 078 Byte |
| **Quellstand** | 7.2.0.21 (`Eudora71/Version.h`) |
| **Marke** | `v1.0.21` — die Marke besteht, die **Veröffentlichung** ist am 09.09.2026 gelöscht; das ZIP hängt nicht mehr daran |
| **Eudora.exe gebaut** | 07.09.2026, 09:48 |
| **QCSSL** | 1.0.1 (unverändert seit 1.0.1) |

**Was in dieser Fassung behoben ist** — die Kette, die das Verfassen-Fenster
freigelegt hat, mit Messwerten im [CHANGELOG.md](../CHANGELOG.md) unter
7.2.0.21:

| Befund | was | wo |
|---|---|---|
| **E-31** | `pg_time_t` war acht Byte breit statt vier — jede Paige-Struktur verschoben | `Eudora71/PaigeDLL/PGHEADER/CPUDEFS.H:695` |
| **E-34** | eine MFC-Ausnahme in `GetButton` wickelte den ganzen Fensterbau ab, ohne Meldung und ohne Absturz | `Eudora71/Eudora/QCChildToolBar.cpp` |
| **E-35** | blinder Zeigerzugriff, den E-34 erst sichtbar machte | `Eudora71/Eudora/CompMessageFrame.cpp` |
| **E-36** | zweimal dasselbe, vom eigenen Absturzbericht gefunden | `Eudora71/Eudora/PgCompMsgView.cpp` |

**Was in dieser Fassung noch nicht geht:** *File → Exit* beendet Eudora nicht
(Kriterium 7, *„beenden geht nicht"*), und die untere Statuszeile mit Reitern
für die offenen Fenster fehlt (Kriterium 8, halb — das Menü *Window* listet
sie). Die Prüfanleitung steht im [CHANGELOG.md](../CHANGELOG.md) unter
*Was an 1.0.21 zu prüfen ist*.

## 1.0.18 — veröffentlicht am 06.09.2026

Die Fassung mit der Behebung von **E-31** (`pg_time_t`) — die erste, in der in
dieser Portierung überhaupt ein Paige-Fenster entsteht. **Aus Anwendersicht
bringt sie nichts:** Gregors Urteil lautet *„es crasht nicht, aber es passiert
auch nichts. beenden kann ich es auch nicht. nichts statt crash ist auch keine
verbesserung!"* Der Grund ist **E-32**, behoben erst am 07.09.2026 und damit
**nicht** in diesem Paket.

| | |
|---|---|
| Veröffentlichung | **am 09.09.2026 gelöscht.** Die Marke `v1.0.18` besteht weiter, das ZIP hängt nicht mehr daran |
| Marke | `v1.0.18` auf Commit `e881164` (`git ls-remote --tags origin`) |
| ZIP | `Eudora72-1.0.18-release.zip`, 9.330.115 B |
| SHA256 | `809e005f31eb72dbe349175b97b6838e7341c25c872fc4625f682657200b7e72` |
| Eudora.exe | 2.943.488 B, `Release\|Win32` |
| Quellstand | 7.2.0.18 (`Eudora71/Version.h`) |

Alle Zahlen am 07.09.2026 nachgemessen: `stat -c%s`, `sha256sum` gegen die
beiliegende `.sha256`, `unzip -l` für die `Eudora.exe`.

> **1.0.4 bis 1.0.17 haben weiter keinen Eintrag** (Mangel **M-4**). Für
> 1.0.14 und 1.0.15 liegen die ZIPs im Repo, für die übrigen nicht — erfunden
> wird hier nichts.

## 1.0.3 — veröffentlicht am 31.08.2026, ZIP einmal ausgetauscht

**Release-Bau.** Erste Fassung, die ohne die vier nicht verteilbaren
Debug-Laufzeiten auskommt (Befund F-1). Der Stand der Kriterien steht in
[ZIEL.md](../ZIEL.md) — hier bewusst keine zweite Fassung dieser Tabelle.

> **Achtung, zwei ZIPs unter derselben Kennung.** Das Paket ist am 31.08.2026
> um 09:00 **ausgetauscht** worden. Die beiden Fassungen unterscheiden sich in
> einer Änderung an `eudora.cpp:3372` (`Left(i)` statt `ReleaseBuffer(i)`). Das
> ist genau der Fall, gegen den diese Datei geschrieben wurde: **die Prüfsumme
> entscheidet, nicht der Name.**
>
> **Berichtigung (06.09.2026).** Hier stand, nur die zweite Fassung enthalte
> „die Behebung von Befund **E-11**". **E-11 ist zurückgenommen** — die
> Änderung behebt den Absturz im Kontoassistenten nicht. Die belegte Ursache
> ist **E-25** (`Befunde/ASSISTENT.md`), und auch die war nicht die einzige:
> 7.2.0.12 stürzt weiter ab. Die Unterscheidung der beiden ZIPs bleibt richtig,
> ihre Begründung trägt nicht mehr.

| | |
|---|---|
| Veröffentlichung | https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.3 |
| ZIP | `Eudora72-1.0.3-release.zip`, 9.209.393 B; darin `Eudora.exe` **2.933.760 B**, `Release\|Win32`. Nachgezählt am 07.09.2026 mit `unzip -l Releases/Eudora72-1.0.3-release.zip` — hier stand bis dahin 2 933 248 B, das sind 512 Byte zu wenig. **Das ZIP liegt heute nicht mehr im Arbeitsbaum**, der Befehl ist die Messung von damals |
| SHA256 (gültig) | `d471904776d5c93a0d7c5e11ea90c756d02fe0c422aa82e396c1eabd4e89cfcc` |
| SHA256 (erste Fassung, stürzt ab) | `632c4066…` — nicht benutzen |
| Zusammenstellen | `powershell -ExecutionPolicy Bypass -File tools\paket-bauen.ps1 -Ziel "<verz>" -Bauart Release -AusBauverzeichnis` |
| Prüfen | `powershell -ExecutionPolicy Bypass -File tools\paket-pruefen.ps1 -Paket "<verz>"` — rechnet die Startkette aus den PE-Importtabellen aus, `SysWOW64` zählt nicht (PR-2.0 behoben am 06.09.2026). Ersetzt keinen Startversuch auf einem fremden Rechner |
| LIESMICH | [`Releases/1.0.3/LIESMICH.txt`](1.0.3/LIESMICH.txt) — am 31.08.2026 abends auf den Release-Weg umgeschrieben; die alte Debug-Fassung ist dort im Kasten benannt |
| QCSSL | 1.0.1 (`ab55281a`), unverändert seit Paket 1.0.1 |

**Was sich gegenüber 1.0.2 ändert.**

1. **Keine Fremdbinärdateien mehr.** `msvcr71.dll`, `msvcr71d.dll` und
   `msvcp71d.dll` von dll-files.com fallen weg. An ihrer Stelle die selbst
   gebaute `msvcr71.dll` aus `Eudora71/VC71Bruecke` — 1429 Weiterleitungen an
   die von Windows mitgelieferte `msvcrt.dll`, eine einzige selbst
   geschriebene Funktion (`__security_error_handler`). Gemessen am fertigen
   PE: x86, einzige Abhängigkeit `KERNEL32.dll`. Befund B-1.
2. **`Paige32d.dll` ist jetzt eine Kopie der Release-`Paige32.dll`.** In 1.0.2
   lag dort die Debug-Fassung; nur ihretwegen brauchte das Paket
   `msvcr71d.dll`. Dass die Umbenennung zulässig ist, ist mit vier
   unabhängigen Messungen belegt (B-1, entscheidend `_pgAllocateNewRef@20` in
   beiden Fassungen).
3. **Die drei Plugins als Release-Fassungen, ohne PDB.** 1.0.2 lieferte die
   Debug-Fassungen samt 12 MB Symboldateien. Ladbar sind beide nicht.
4. **`laufzeit-holen.ps1` und `paket-pruefen.ps1` liegen im Paket**, mit
   Hinweis ganz vorn in der LIESMICH.txt.

   > **Berichtigung (06.09.2026).** Hier stand: *„Ohne die vier
   > VS2022-Debug-Laufzeiten scheitert der Start mit `0xc000007b`."* Das ist im
   > Abschnitt über ein **Release**-Paket falsch und widerspricht der eigenen
   > Überschrift: 1.0.3 ist die erste Fassung, die **ohne** diese vier DLLs
   > auskommt (Befund F-1). Sie dürfen auch gar nicht weitergegeben werden.
   > `laufzeit-holen.ps1` liegt nur für den Fall bei, dass jemand einen
   > **Debug**-Bau daneben ausprobiert.

**Was der Paketprüfer sagt.** Zusammengestellt und geprüft am 31.08.2026:

| | 1.0.2 | 1.0.3 |
|---|---|---|
| Fehler | 3 | **0** |
| Warnungen | 5 | 7 |
| Binärdateien, alle x86 | 31 | 29 |

Die drei Fehler in 1.0.2 waren `MFC71.DLL`, `MFC71D.DLL` und `MSVCP71.dll`.
In 1.0.3 ist `MFC71D.DLL` verschwunden (Release-Plugins), die beiden anderen
sind zu Warnungen geworden — nicht weil sich etwas verschlechtert hätte,
sondern weil der Prüfer inzwischen die **Startkette** ausrechnet und weiß,
dass sie außerhalb liegen.

**Wann Eudora die fehlenden Module lädt — gemessen, nicht vermutet.** Die
Startkette (alles, was der Lader vor der ersten eigenen Codezeile anfassen
muss) besteht aus elf Modulen:

    Eudora.exe  swEudora.exe  EuLang.dll  EuMemMgr.dll  Imap.dll
    libexpat.dll  msvcr71.dll  Paige32d.dll  plstclnt.dll  QCSocket.dll
    QCUtils.dll

`EudoraBk`, `ISock`, `Ldap`, `Ph` und die drei Plugins sind **nicht** darin.
Das fehlende `MFC71.DLL`/`MSVCP71.dll` hält den Start also nicht auf; es fällt
erst bei Benutzung auf (Adressbuch, LDAP, Ph, S/MIME, Spamfilter). Das galt
für 1.0.2 genauso — es war nur nicht gemessen.

**Stand nach ZIEL.md** (31.08.2026, abends — der damalige Stand, hier als
Zeitdokument):

| Bau | Stand |
|---|---|
| **Debug**-Bau `Eudora72-1.0.3` (nicht veröffentlicht, nicht veröffentlichbar) | darauf sind Kriterium 1 und 3 belegt — 159 Nachrichten, TLSv1.3 (E-1, E-3). Er lief nur, weil die vier **nicht verteilbaren** Laufzeit-DLLs von Hand daneben lagen (E-8) |
| **Release**-ZIP, erste Fassung (`632c4066…`) | von Gregor probiert: **Absturz** beim Klick auf *Weiter* im Kontoassistenten (E-6) |
| **Release**-ZIP, zweite Fassung (`d4719047…`) | war am 31.08.2026 von niemandem gestartet |

> **Nachtrag (06.09.2026).** Zwei Dinge daran sind überholt. Erstens ist
> **E-11 zurückgenommen** — die zweite 1.0.3-Fassung trug also nicht „die
> Behebung des Absturzes", sondern eine Änderung an einer Stelle, die den
> Absturz nicht verursacht hat; die richtige Erklärung ist **E-25**
> (Doppelfreigabe in `NSImport.eif`), und selbst die reichte nicht: 7.2.0.12
> stürzt weiter ab. Zweitens ist der Satz *„keine der beiden veröffentlichten
> Fassungen ist von jemandem gestartet worden"* längst überholt — seither sind
> 1.0.4 bis 1.0.10 gebaut und benutzt worden.
>
> **Nachtrag (07.09.2026): Kriterium 0 ist erfüllt.** Der Satz „Kriterium 0
> bleibt trotzdem offen: kein Paket ist auf einem Rechner **ohne** Visual Studio
> ausgepackt und gestartet worden" stand hier bis heute. Er ist seit dem
> 06.09.2026 überholt: Gregor hat `Eudora72-1.0.10-release.zip` genau so
> gestartet — *„test bestanden: eudora läuft ohne VS2022 installiert."*

## 1.0.2 — 30.08.2026

**Startet.** Erste Fassung, bei der das Hauptfenster erscheint — Stand
30.08.2026: die Darstellung war fehlerhaft (S-6), Menüs ließen sich nicht
öffnen (S-5), ein Mailabruf war nicht geprüft. Behoben ist das erst in 1.0.3
(M-1, A-1, E-1).

| | |
|---|---|
| ZIP | `Eudora72-1.0.2-lauffaehig.zip`, 12.808.796 B |
| SHA256 | `5236be5015c0dd01b27f3eeb3c5648aa7ef1100e195c71a6263305aa056c17f1` |
| Eudora.exe | 10.201.088 B, Debug\|Win32, Toolset v143 |
| QCSSL | 1.0.1 (`ab55281a`), unverändert gegenüber Paket 1.0.1 |
| Symbole | `Eudora72-1.0.2-symbole.zip` — nur als Anhang der Veröffentlichung, nicht im Repo |

**Was 1.0.1 am Starten hinderte und hier behoben ist:**

1. Die sieben vorgebauten Fremd-DLLs von 2006 lagen als **Debug**-Fassungen bei
   und verlangten die nicht verteilbare VS2003-Debug-Laufzeit. Jetzt die
   Release-Fassungen (Befund S-1).
2. Ohne vorhandene `Eudora.ini` lief Eudora nicht sinnvoll an. Eine
   vorbereitete liegt jetzt im Unterverzeichnis `Mailverzeichnis` (S-1).
   *(Die frühere Formulierung „bricht in `eudora.cpp:3542` ab" ist falsch —
   siehe README, Abschnitt „Starten".)*
3. Der Stillstand nach dem Startbildschirm war die **Werbefläche**:
   `CAdWazooWnd::OnCreate` legt sie mit 0 × 0 Bildpunkten an, Paige verheddert
   sich in einer Endlosrekursion. Die Leiste wurde bedingungslos angelegt; sie
   hängt jetzt an `IsBoxBuild()`, dazu der Schalter
   `BUILD_BOX_OR_SITE_R_VERSION` (S-2).

**Abnahme.** Aus frisch ausgepacktem Paket in ein unberührtes Verzeichnis
gestartet: läuft, 10 Threads, 75 MB, Hauptfenster mit Menü-, Werkzeug- und
Statusleiste. Vier SUPERASSERT-Dialoge sind wegzuklicken (Debug-Bau, S-3b).

**Nicht geprüft.** Abruf gegen einen echten Mailserver. Adressbuch, LDAP und Ph
fallen mangels `MFC71.DLL` und `MSVCP71.dll` aus (S-3c).

**Enthält Fremdbinärdateien.** `msvcr71.dll`, `msvcr71d.dll`, `msvcp71d.dll`
stammen von dll-files.com, nicht von Microsoft, und sind nicht signiert. Sie
werden gebraucht, weil die vorgebauten DLLs von 2006 daran gebunden sind und
Microsoft für Visual C++ 2003 nie ein eigenständiges Redistributable
veröffentlicht hat. Eine saubere Alternative ist machbar: Windows liefert selbst
eine `msvcrt.dll` derselben Generation mit, die 19 der 20 von Paige benötigten
Funktionen exportiert — eine eigene Weiterleitungs-DLL käme ohne Fremdbinärdatei
aus.

## 1.0.1 — 30.08.2026

**Startet nicht.** Bricht mit „MSVCR71D.dll nicht gefunden" ab. Die beiliegende
`LIESMICH.txt` nennt als Voraussetzung nur die VS2022-Debug-Laufzeiten und
behauptet, die seien auf der Zielmaschine vorhanden — das ist unvollständig und
war der Grund, warum das Paket als lauffähig ausgegeben wurde, ohne es je
gestartet zu haben.

| | |
|---|---|
| ZIP | `Eudora72-1.0.1-lauffaehig.zip`, 9.207.607 B |
| SHA256 | `d277cb0b2f3e02e4e9e0fbe5e0b98298b431314b516a8423b68d91653f095366` |
| QCSSL | 1.0.1 (`ab55281a`) |

Dazu `Eudora72-QCSSL-1.0.1.zip` (1.489.032 B, SHA256
`9339fb2edecfbf8b3631ada00117f72ecd7dddcfe321b5b7edf369aed6ebf4e6`) — nur die
TLS-Bibliothek, zum Einsetzen in eine bestehende Eudora-Installation. Die ist von
den Startproblemen **nicht** betroffen.

## Wie man nachsieht, was man hat

```bash
certutil -hashfile Eudora72-1.0.2-lauffaehig.zip SHA256
```

Die Prüfsumme in der Tabelle oben sagt eindeutig, welche Fassung vorliegt.

## Wo die Pakete liegen (Stand 13.09.2026)

Die ZIPs sind am 07.09.2026 aus `Releases/` **entfernt** worden — sie lagen
dort 104 MB und waren doppelt: veroeffentlicht bei GitHub und im git-Verlauf.
Diese Tabelle nennt jede Fassung mit Pruefsumme, damit niemand sie im
Arbeitsbaum sucht.

**Im Repo liegen genau zwei ZIPs** (`git ls-files Releases/`, gemessen am
13.09.2026): `Eudora72-1.0.2-lauffaehig.zip` (Baugrundlage, mit `.sha256`) und
`Eudora72-1.0.30-release.zip` (**ohne** `.sha256`). Bis zum 13.09.2026 stand
hier `Eudora72-1.0.27-release.zip` und dazu *„die veröffentlichte Fassung"* —
beides falsch: das ZIP im Repo ist 1.0.30, und veröffentlicht ist bei GitHub
`v1.0.48` (`gh release list`).
Die ZIPs zu **1.0.21**, **1.0.23** und **1.0.24** sind wieder entfernt. Die
beiden verwaisten Prüfsummendateien zu **1.0.21** und **1.0.22** — ohne ZIP
daneben, ohne einen einzigen Verweis — sind am **11.10.2026** ebenfalls
entfernt worden, auf Gregors Anweisung (*„waisen entfernen, 1.0.30
behalten"*). **Es geht dabei kein Beleg verloren:** beide Prüfsummen stehen in
dieser Datei, in den Abschnitten 1.0.21 und 1.0.22. Das ZIP zu **1.0.30**
bleibt bewusst liegen — es ist das einzige mitversionierte Release-ZIP und
damit das einzige, an dem `tools/pruefe-behoben-ausgeliefert.pl` in einem
frischen Klon überhaupt etwas **messen** kann.

> **Abrufbar ist als Paket nur noch `v1.0.27`.** Gregor hat am 09.09.2026 die
> **Veröffentlichungen** zu `v1.0.18`, `v1.0.21`, `v1.0.23` und `v1.0.24`
> gelöscht. Die **Marken** bestehen weiter — wer einem Verweis darauf folgt,
> findet den Quellstand, aber **kein ZIP**. Die Prüfsummen unten bleiben
> trotzdem stehen: sie sagen eindeutig, welche Fassung jemand in der Hand hat,
> der eines dieser Pakete früher heruntergeladen hat.

| Fassung | SHA256 | wo |
|---|---|---|
| `Eudora72-1.0.41-release.zip` | `22949297c77c6f55c6f1e27d5a03646ccecb2fd3b538f7ecdf9909d8014d15ce` | **nicht im Repo** — liegt im Hauptarbeitsbaum unter `Releases/`, 9 346 106 B, gebaut am 10.09.2026, `paket-pruefen.ps1` ohne Fehler, Kriterium 0 **JA**. Keine Marke, nie veröffentlicht — Gregor hat es noch nicht beurteilt. Eingetragen von PRÜFER am 10.09.2026, weil `WEITERMACHEN.md:11` es nennt und `doku-pruefen.pl` sonst jeden Commit abweist |
| `Eudora72-1.0.27-release.zip` | `69595d4b380204eb5ac6d327ce8ded65080b356594090a2465394ced07f81b3a` | **im Repo** und [GitHub v1.0.27](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.27) — die einzige Veröffentlichung mit Dateien |
| `Eudora72-1.0.24-release.zip` | siehe [CHANGELOG.md](../CHANGELOG.md) unter 7.2.0.24 | Marke `v1.0.24` gesetzt, **Veröffentlichung am 09.09.2026 gelöscht**; nur im git-Verlauf |
| `Eudora72-1.0.23-release.zip` | `3f58a93c85c8fbf9f206ccc319a4798bb40236f3b60821a3de6df17710139045` | Marke `v1.0.23` gesetzt, **Veröffentlichung gelöscht**; nur im git-Verlauf |
| `Eudora72-1.0.22-release.zip` | `7ddab1a0f0fdf1c4458a7aa2ab00d2f1fbb15561ab576657c73006fcfa95586c` | **keine Marke**, nie veröffentlicht; nur im git-Verlauf, `.sha256` in `Releases/` |
| `Eudora72-1.0.21-release.zip` | `0a699fcb03c3f0b60a0142837fc2128f3baf19884cd6b96a4f388339165b667c` | Marke `v1.0.21` gesetzt, **Veröffentlichung gelöscht**; nur im git-Verlauf, `.sha256` in `Releases/` |
| `Eudora72-1.0.18-release.zip` | `809e005f31eb72db…` | Marke `v1.0.18` gesetzt, **Veröffentlichung gelöscht**; nur im git-Verlauf |
| `Eudora72-1.0.19-release.zip` | `27976d451c88a9ed…` | nur im git-Verlauf |
| `Eudora72-1.0.15-release.zip` | `2a0c49b09f25c1d2…` | [GitHub v1.0.15](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.15) |
| `Eudora72-1.0.14-release.zip` | `23cb17e45f85a7a7…` | [GitHub v1.0.14](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.14) |
| `Eudora72-1.0.10-release.zip` | `68c8af8836e30343…` | [GitHub v1.0.10](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.10) |
| `Eudora72-1.0.4-release.zip` | `a3eb72e5f0beccb4…` | nur im git-Verlauf |
| `Eudora72-1.0.3-release.zip` | `d471904776d5c93a…` | [GitHub v1.0.3](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.3) |
| `Eudora72-1.0.2-lauffaehig.zip` | `5236be5015c0dd01…` | **im Repo** und [GitHub v1.0.2](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.2) — **bleibt im Repo**, `paket-bauen.ps1` braucht es als Grundlage |
| `Eudora72-1.0.2-symbole.zip` | `2d98967911b1afd2…` | [GitHub v1.0.2](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.2) |
| `Eudora72-1.0.1-lauffaehig.zip` | `d277cb0b2f3e02e4…` | [GitHub v1.0.1](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.1) |
| `Eudora72-QCSSL-1.0.1.zip` | `9339fb2edecfbf8b…` | [GitHub v1.0.1](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.1) |

> **Zu 1.0.25 und 1.0.26 ist hier keine Prüfsumme verzeichnet.** Beide Pakete
> hat Gregor geprüft (A-3 an 1.0.25, die Meldung zu E-52 an 1.0.26), aber keine
> Marke dafür gesetzt und kein ZIP im Repo hinterlassen. Was drinsteckte, steht
> im [CHANGELOG.md](../CHANGELOG.md) unter 7.2.0.25 und 7.2.0.26. Das ist Teil
> des Mangels **M-4** aus dem Kopfkasten.

Ebenfalls entfernt: `Releases/1.0.2/` und die drei Fremd-DLLs
`msvcr71.dll`, `msvcr71d.dll`, `msvcp71d.dll` — null Verweise im ganzen Repo.
Die beiden `d`-Fassungen stammten von dll-files.com und durften ohnehin nicht
weitergegeben werden; `msvcr71.dll` wird seit Befund B-1 selbst gebaut
(`Eudora71/VC71Bruecke`).

> **Nicht loeschen:** `Eudora72-1.0.2-lauffaehig.zip` sieht nach dem aeltesten
> und nutzlosesten aus, ist aber die **Grundlage jedes neuen Pakets**
> (`tools/paket-bauen.ps1`, Schalter `-Grundlage`). Dazu `Releases/1.0/`
> (fuenf Werkzeugstellen) und `Releases/1.0.3/LIESMICH.txt` (kommt in jedes
> Paket).
