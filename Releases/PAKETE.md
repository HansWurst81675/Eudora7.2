# Ausgelieferte Pakete

Was in jeder Paketfassung steckte, und ob sie startete. Ergänzt
[AUSLIEFERUNGEN.md](1.0/AUSLIEFERUNGEN.md), das nur die QCSSL.dll verfolgt.

Die Paketversion und die QCSSL-Version sind **verschiedene Zählungen**. Paket
1.0.2 enthält QCSSL 1.0.1, weil sich die QCSSL-Quellen seit 1.0.1 nicht geändert
haben.

> **Zur Benennung.** Beide ZIP-Dateien tragen im Namen das Wort `lauffaehig`.
> Nach [ZIEL.md](../ZIEL.md) ist das für keine der beiden zutreffend: 1.0.1 startet
> gar nicht, 1.0.2 erfüllt nur Kriterium 1 von dreien. Die Namen bleiben stehen,
> weil beide Pakete unter diesem Namen veröffentlicht sind und die Prüfsummen sonst
> nicht mehr zuzuordnen wären. **Künftige Pakete heißen nach ihrem tatsächlichen
> Stand.**

## 1.0.3 — vorbereitet am 31.08.2026, NICHT veröffentlicht

**Vorabfassung.** Der Name trägt bewusst nicht das Wort `lauffaehig`: nach
[ZIEL.md](../ZIEL.md) ist derzeit **keines der drei Kriterien** erfüllt.
Vorgeschlagener Dateiname `Eudora72-1.0.3-vorabfassung.zip`.

Ob und wann das Paket veröffentlicht wird, entscheidet Gregor. Deshalb steht
hier weder eine Prüfsumme noch eine Größe — beides entsteht erst beim
Veröffentlichen.

| | |
|---|---|
| Zusammenstellen | `powershell -ExecutionPolicy Bypass -File tools\paket-bauen.ps1 -Ziel "<verz>" -Zip "<verz>\..\Eudora72-1.0.3-vorabfassung.zip"` |
| Prüfen | `powershell -ExecutionPolicy Bypass -File tools\paket-pruefen.ps1 -Paket "<verz>"` |
| LIESMICH | [`Releases/1.0.3/LIESMICH.txt`](1.0.3/LIESMICH.txt) |
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

**Stand nach ZIEL.md.** Kriterium 1 nicht erfüllt (Fenster erscheint, Menüs
seit M-1 behoben, **Wirkung ungeprüft**), Kriterium 2 nicht erfüllt
(Darstellung in Arbeit, A-1), Kriterium 3 nicht geprüft (kein Mailabruf).

## 1.0.2 — 30.08.2026

**Startet.** Erste Fassung, bei der das Hauptfenster erscheint. Erfüllt damit
**Kriterium 1 von dreien** ([ZIEL.md](../ZIEL.md)) — nicht mehr. Die Darstellung
ist fehlerhaft (S-6), Menüs lassen sich nicht öffnen (S-5), ein Mailabruf ist
nicht geprüft.

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
