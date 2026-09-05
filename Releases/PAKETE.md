# Ausgelieferte Pakete

Was in jeder Paketfassung steckte, und ob sie startete. Ergänzt
[AUSLIEFERUNGEN.md](1.0/AUSLIEFERUNGEN.md), das nur die QCSSL.dll verfolgt.

## Drei Zählungen, und wie sie zusammenhängen

| Zählung | wo sie steht | wo man sie sieht |
|---|---|---|
| **Produktversion** `7.2.0.x` | `Eudora71/Version.h` | Splash und *Hilfe → Über Eudora*, dazu die Dateiversion der `Eudora.exe` |
| **Paketversion** `1.0.x` | Datei `VERSION` | Name des ZIP, Bau-Kennung in der Titelleiste |
| **QCSSL-Version** `1.0.x` | `qcssl.rc` | Versionsressource der `QCSSL.dll` |

**Verabredung: Produkt- und Paketversion haben dieselbe letzte Stelle.**
Paket 1.0.3 trägt Produktversion 7.2.0.3. `tools/kennung-erzeugen.pl` warnt,
wenn die beiden auseinanderlaufen — bei der `QCSSL.dll` sind genau so zwei
verschiedene Binärdateien unter derselben Kennung ausgeliefert worden.

Die QCSSL-Zählung läuft bewusst eigenständig: sie folgt den Quellen der
TLS-Schicht, nicht dem Paket. Paket 1.0.3 enthält QCSSL 1.0.1, weil sich
dort seit 1.0.1 nichts geändert hat.

### Wie man die Version hebt — vollständig, nachgemessen am 31.08.2026

Für Paket **1.0.4** mit Produktversion **7.2.0.4** sind es **fünf Zeilen in zwei
Dateien**:

| Datei | Zeile | von | auf |
|---|---|---|---|
| `VERSION` | 1 | `1.0.3` | `1.0.4` |
| `Eudora71/Version.h` | `EUDORA_VERSION4` | `3` | `4` |
| `Eudora71/Version.h` | `EUDORA_BUILD_NUMBER` | `7,2,0,3` | `7,2,0,4` |
| `Eudora71/Version.h` | `EUDORA_BUILD_DESC` | `"Version 7.2.0.3\0"` | `…7.2.0.4\0` |
| `Eudora71/Version.h` | `EUDORA_BUILD_VERSION` | `"7.2.0.3"` | `"7.2.0.4"` |

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
> Muss etwas hinterher, bekommt es die **nächste Nummer** — Paket 1.0.4 mit
> Produktversion 7.2.0.4. Am 31.08.2026 ist das **verletzt** worden: unter
> `v1.0.3` hängen zwei verschiedene ZIPs, sie unterscheiden sich in der Behebung
> von E-11. Damit identifiziert die Angabe „Version 1.0.3" das Programm nicht
> mehr, und ein Fehlerbericht von außen ist keinem Bau zuzuordnen.
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

## 1.0.3 — veröffentlicht am 31.08.2026, ZIP einmal ausgetauscht

**Release-Bau.** Erste Fassung, die ohne die vier nicht verteilbaren
Debug-Laufzeiten auskommt (Befund F-1). Der Stand der Kriterien steht in
[ZIEL.md](../ZIEL.md) — hier bewusst keine zweite Fassung dieser Tabelle.

> **Achtung, zwei ZIPs unter derselben Kennung.** Das Paket ist am 31.08.2026
> um 09:00 **ausgetauscht** worden. Nur die zweite Fassung enthält die Behebung
> von Befund **E-11** (`eudora.cpp:3372`, `Left(i)` statt `ReleaseBuffer(i)`) —
> mit der ersten stürzte Eudora auf einer frischen Installation beim Klick auf
> *Weiter* im Kontoassistenten ab. Das ist genau der Fall, gegen den diese
> Datei geschrieben wurde: **die Prüfsumme entscheidet, nicht der Name.**

| | |
|---|---|
| Veröffentlichung | https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.3 |
| ZIP | `Eudora72-1.0.3-release.zip`, `Eudora.exe` 2 933 248 B, `Release\|Win32` |
| SHA256 (gültig) | `d471904776d5c93a0d7c5e11ea90c756d02fe0c422aa82e396c1eabd4e89cfcc` |
| SHA256 (erste Fassung, stürzt ab) | `632c4066…` — nicht benutzen |
| Zusammenstellen | `powershell -ExecutionPolicy Bypass -File tools\paket-bauen.ps1 -Ziel "<verz>" -Bauart Release -AusBauverzeichnis` |
| Prüfen | `powershell -ExecutionPolicy Bypass -File tools\paket-pruefen.ps1 -Paket "<verz>"` — **taugt nicht als Freigabekriterium**, siehe PR-2.0 |
| LIESMICH | [`Releases/1.0.3/LIESMICH.txt`](1.0.3/LIESMICH.txt) — beschreibt noch den Debug-Weg, für ein Release-Paket hinfällig (F-1, nächster Schritt 3) |
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
   Hinweis ganz vorn in der LIESMICH.txt. Ohne die vier VS2022-Debug-Laufzeiten
   scheitert der Start mit `0xc000007b` — genau das ist am 31.08.2026
   passiert.

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

**Stand nach ZIEL.md** (31.08.2026, abends). Hier ist genau zu unterscheiden,
welcher Bau gemeint ist — **keine der beiden veröffentlichten Fassungen ist von
jemandem gestartet worden** (Befund V-1):

| Bau | Stand |
|---|---|
| **Debug**-Bau `Eudora72-1.0.3` (nicht veröffentlicht, nicht veröffentlichbar) | darauf sind Kriterium 1 und 3 belegt — 159 Nachrichten, TLSv1.3 (E-1, E-3). Er lief nur, weil die vier **nicht verteilbaren** Laufzeit-DLLs von Hand daneben lagen (E-8) |
| **Release**-ZIP, erste Fassung (`632c4066…`) | von Gregor probiert: **Absturz** beim Klick auf *Weiter* im Kontoassistenten (E-6, Ursache E-11) |
| **Release**-ZIP, zweite Fassung (`d4719047…`) | **von niemandem geprüft** — sie trägt die Behebung von E-11, aber es hat sie noch keiner gestartet |

Kriterium 0 ist damit unbelegt, und die Behebung von E-11 unerprobt — zumal in
derselben Funktion zwei weitere Vorkommen derselben Art stehen (R-1).

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
2. Ohne vorhandene `Eudora.ini` bricht Eudora in `eudora.cpp:3542` ab. Eine
   vorbereitete liegt jetzt im Unterverzeichnis `Mailverzeichnis` (S-1).
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
