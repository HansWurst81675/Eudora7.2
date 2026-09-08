# Ausgelieferte Pakete

Was in jeder Paketfassung steckte, und ob sie startete. Ergänzt
[AUSLIEFERUNGEN.md](1.0/AUSLIEFERUNGEN.md), das nur die QCSSL.dll verfolgt.

> **Diese Buchführung ist unvollständig — Stand 08.09.2026.** Ausführliche
> Abschnitte gibt es unten für **1.0.23**, **1.0.22**, **1.0.21**, **1.0.18**,
> **1.0.3**, **1.0.2** und **1.0.1**. Die Pakete **1.0.4 bis 1.0.17** sowie
> **1.0.19** und **1.0.20** haben hier keinen eigenen Eintrag, obwohl sie
> gebaut und teilweise veröffentlicht wurden. Der Mangel ist als **M-4** in
> [PRUEFUNG-CODE.md](../PRUEFUNG-CODE.md) festgehalten und weiterhin offen.
>
> **Im Repo liegen als ZIP** (`ls Releases/*.zip`, nachgezählt am 08.09.2026):
> nur noch **1.0.2** (`Eudora72-1.0.2-lauffaehig.zip`, Baugrundlage für
> `tools/paket-bauen.ps1` — **nicht löschen**) und **1.0.21**
> (`Eudora72-1.0.21-release.zip`). Alle übrigen ZIPs sind am 07.09.2026
> entfernt worden, um das Repo von 104 MB auf 16 MB zu bringen; jedes von
> ihnen ist unten mit Prüfsumme und Netzadresse verzeichnet und über seine
> Marke weiter abrufbar.
>
> **Als Marke veröffentlicht** sind `v1.0.1`, `v1.0.2`, `v1.0.3`, `v1.0.10`,
> `v1.0.14`, `v1.0.15`, `v1.0.18` und `v1.0.21`
> (`git ls-remote --tags origin`).
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

## 1.0.21 — veröffentlicht am 07.09.2026

**Die erste Fassung, mit der eine Mail geschrieben, abgeschickt und die Antwort
empfangen wurde.** Von Gregor am 07.09.2026 bestätigt: *„mail können jetzt
abgeschickt werden."* und *„weiterleitung funktioniert übrigens."* Damit sind
die Kriterien 5 und 6 aus [ZIEL.md](../ZIEL.md) belegt.

| | |
|---|---|
| **Paket** | `Releases/Eudora72-1.0.21-release.zip` |
| **SHA256** | `0a699fcb03c3f0b60a0142837fc2128f3baf19884cd6b96a4f388339165b667c` |
| **Größe** | 9 331 078 Byte |
| **Quellstand** | 7.2.0.21 (`Eudora71/Version.h`) |
| **Marke** | [v1.0.21](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.21) |
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
| Veröffentlichung | https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.18 |
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
| ZIP | `Eudora72-1.0.3-release.zip`, 9.209.393 B; darin `Eudora.exe` **2.933.760 B**, `Release\|Win32`. Nachgezählt am 07.09.2026 mit `unzip -l Releases/Eudora72-1.0.3-release.zip` — hier stand bis dahin 2 933 248 B, das sind 512 Byte zu wenig |
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

## Wo die Pakete liegen (Stand 07.09.2026)

Die ZIPs sind am 07.09.2026 aus `Releases/` **entfernt** worden — sie lagen
dort 104 MB und waren doppelt: veroeffentlicht bei GitHub und im git-Verlauf.
Diese Tabelle nennt jede Fassung mit Pruefsumme, damit niemand sie im
Arbeitsbaum sucht.

| Fassung | SHA256 | wo |
|---|---|---|
| `Eudora72-1.0.1-lauffaehig.zip` | `d277cb0b2f3e02e4…` | [GitHub v1.0.1](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.1) |
| `Eudora72-1.0.10-release.zip` | `68c8af8836e30343…` | [GitHub v1.0.10](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.10) |
| `Eudora72-1.0.14-release.zip` | `23cb17e45f85a7a7…` | [GitHub v1.0.14](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.14) |
| `Eudora72-1.0.15-release.zip` | `2a0c49b09f25c1d2…` | [GitHub v1.0.15](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.15) |
| `Eudora72-1.0.18-release.zip` | `809e005f31eb72db…` | [GitHub v1.0.18](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.18) |
| `Eudora72-1.0.19-release.zip` | `27976d451c88a9ed…` | nur im git-Verlauf |
| `Eudora72-1.0.2-lauffaehig.zip` | `5236be5015c0dd01…` | [GitHub v1.0.2](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.2) — **bleibt im Repo**, `paket-bauen.ps1` braucht es als Grundlage |
| `Eudora72-1.0.2-symbole.zip` | `2d98967911b1afd2…` | [GitHub v1.0.2](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.2) |
| `Eudora72-1.0.3-release.zip` | `d471904776d5c93a…` | [GitHub v1.0.3](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.3) |
| `Eudora72-1.0.4-release.zip` | `a3eb72e5f0beccb4…` | nur im git-Verlauf |
| `Eudora72-QCSSL-1.0.1.zip` | `9339fb2edecfbf8b…` | [GitHub v1.0.1](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.1) |

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
