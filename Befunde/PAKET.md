## PR-2.0 — Der Paketprüfer prüfte die Maschine statt das Paket (behoben)

**Agent:** PAKET · **Zweig:** `wt/paket-3` · **Datum:** 06.09.2026 ·
**Fassung:** 7.2.0.12 · **Status:** behoben, mit drei Gegenproben belegt

Fortschreibung des Befundes PR-2.0 (`BEFUNDE.md` ab Zeile 4400). Geändert wurde
ausschließlich `tools/paket-pruefen.ps1`. Nichts gebaut, nichts gestartet.

---

### 1. Warum das dran war

Kriterium 0 aus `ZIEL.md` lautet wörtlich:

> „zip runterladen, entpacken, starten - läuft. keine fehlenden DLLs, keine
> fehlermeldungen, daß etwas nicht gefunden werden kann oder nachinstalliert
> werden muß."

Gregor hat 7.2.0.10 heruntergeladen, ausgepackt und gestartet — aber auf einem
Rechner **mit** Visual Studio 2022. Seine Worte: *„aber hier ist auch VS2022
installiert. ich muß es noch woanders prüfen, da hast du recht."* Ein Lauf auf
so einer Maschine beweist nichts, weil die Laufzeiten dort ohnehin herumliegen.

Ein Werkzeug, das das Paket **aus sich heraus** prüft, ersetzt den zweiten
Rechner — und ist der bessere Nachweis, weil er wiederholbar ist.

---

### 2. Was falsch war — beide Mängel frisch nachgemessen

**(a) Es akzeptierte einen Systemtreffer als „vorhanden".**
`Finde-DLL` (alte Fassung, `:260-272`) sah in `SysWOW64` und `System32` nach und
wertete einen Treffer dort kommentarlos als erfüllt.

Gegenprobe, heute selbst gefahren statt übernommen: die alte Fassung aus
`HEAD:tools/paket-pruefen.ps1` gegen eine Kopie von
`Eudora72-1.0.12-release`, aus der `mfc140.dll` gelöscht wurde:

```
ERGEBNIS: keine Fehler.
ALTE FASSUNG EXITCODE=0
```

Genau der Fehler, an dem der Start am 31.08.2026 mit `0xc000007b` scheiterte,
wurde durchgewinkt.

**(b) Die Laufzeitliste war fest verdrahtet und nannte die Debug-Fassungen.**
`:360` suchte nach `mfc140d.dll`, `msvcp140d.dll`, `vcruntime140d.dll`,
`ucrtbased.dll`. Bei einem Release-Paket gab das vier Falschwarnungen, und die
angebotene Abhilfe (`tools/laufzeit-holen.ps1`) holte die **nicht
weiterverteilbaren** Debug-DLLs ins Paket. Auf einem Rechner **ohne** VS2022
wären daraus vier Fehler mit Rückgabewert 1 geworden — ein korrektes Paket
verworfen.

---

### 3. Was die neue Fassung tut

Sie beantwortet nicht mehr „liegt Datei X irgendwo auf dieser Maschine",
sondern: **kann dieses Paket auf einem Windows starten, auf dem nichts
nachinstalliert ist?**

| Schritt | wie |
|---|---|
| Architektur | PE-Kopf jeder `.exe`, `.dll`, `.ocx`, `.drv`, `.vxd` — muss x86 sein |
| Abhängigkeiten | Import- **und** Verzögerungstabelle aus dem PE-Kopf, transitiv weiterverfolgt: eine importierte DLL, die im Paket liegt, hat selbst wieder Importe |
| Einsortierung | jeder Name in genau einen von drei Töpfen: **(a)** liegt im Paket, **(b)** bringt Windows mit, **(c)** fehlt. Topf (c) ist die Antwort |
| Systemverzeichnisse | ein Treffer in `SysWOW64`/`System32` zählt **nicht** als vorhanden. Er wird nur als erklärender Nebensatz ausgegeben („liegt zwar in SysWOW64 dieser Maschine — zählt nicht") |
| Debug-Laufzeiten | ein Import auf `mfc140d`, `msvcp140d`, `vcruntime140d`, `vcruntime140_1d`, `ucrtbased`, `concrt140d` ist ein **Fehler** (Befund S-8/E-8). Abhilfe ist ein Release-Bau, nicht das Mitliefern |
| Pakethygiene | keine `.pdb` im Release-Paket, `Mailverzeichnis\Eudora.ini` (Befund S-1), `Eudora starten.cmd` (Befund E-6) |

Gelesen wird der **PE-Kopf**, nicht der Dateiinhalt. Ein `grep` über die Datei
liefert Bruchstücke wie `s.dll` und `ts.dll`, weil in der Zeichenkettentabelle
Namen ohne Trennung aneinanderstoßen; `dumpbin /imports` scheidet aus, weil die
Git-Bash das Argument zu einem Pfad verhunzt. Der bewährte PE-Leser aus der
alten Fassung wurde übernommen und nur um die Erkennung von 16-Bit-Dateien
erweitert.

**Startkette gegen Bedarf.** Wurzel ist `Eudora.exe` — die EXE, die
`Eudora starten.cmd` aufruft. Von dort wird jedem *gewöhnlichen* Import gefolgt,
der auf eine Paketdatei zeigt. Was außerhalb dieser Hülle liegt, lädt Eudora
erst bei Benutzung über `LoadLibrary` oder COM. Das ist der Unterschied
zwischen **„startet nicht"** (Fehler) und **„eine Zusatzfunktion fehlt"**
(Warnung), und er entscheidet über den Rückgabewert.

---

### 4. Was Windows mitbringt — nachgewiesen, nicht angenommen

Der erste Lauf gegen 1.0.12 warf drei Namen aus, die auf der vorgegebenen Liste
fehlten. Statt sie zu vermuten, wurde jeder einzeln belegt:

| Name | Beleg |
|---|---|
| `gdiplus.dll` | WinSxS-Paket `amd64_microsoft.windows.gdiplus.systemcopy_...10.0.19041.6456` — Windows-Bestandteil |
| `oledlg.dll` | `ProductName` = „Microsoft Windows Operating System", Fassung `10.0.19041.5794` — mit dem Windows-Bau versioniert |
| `mfc42.dll` | WinSxS-Paket `microsoft-windows-mfc42x_31bf3856ad364e35_10.0.19041.3636`, dazu `wow64_microsoft-windows-mfc42x` für die 32-Bit-Fassung. Der Schlüssel `31bf3856ad364e35` ist der Windows-Herausgeber. Windows liefert MFC 4.2 aus Rücksicht auf alte Programme weiter mit — **anders als MFC 7.1** |

Damit die Liste nachprüfbar bleibt, gibt `-Ausfuehrlich` sie vollständig aus
(*„Als ‚bringt Windows mit' eingestuft"*). Jeder Name darin ist eine Behauptung;
steht etwas Falsches darin, fällt das Urteil zu günstig aus. Bei 1.0.12 sind es
41 verschiedene Namen, alle nachgesehen.

---

### 5. Die drei Gegenproben

| Paket | erwartet | gemessen |
|---|---|---|
| `C:\Users\Gregor\Eudora72-1.0.12-release` | grün | **`ERGEBNIS: keine Fehler` · EXITCODE=0** · 3 Warnungen |
| Kopie davon im Scratchpad, `mfc140.dll` gelöscht | rot | **`FEHLT BEIM START: mfc140.dll` · EXITCODE=1** |
| `C:\Users\Gregor\Eudora72-1.0.12-debug` | rot | **`Debug-Bau: 4 Debug-Laufzeit(en)` · EXITCODE=1** |

Gregors Verzeichnisse wurden nur gelesen; die Kopie liegt im Scratchpad.

Bei der zweiten Probe steht in der Meldung ausdrücklich dabei, warum der
Systemtreffer nicht hilft:

```
FEHLT BEIM START: mfc140.dll   gebraucht von Eudora.exe, EuLang.dll, Imap.dll,
                               plstclnt.dll, QCSocket.dll, QCUtils.dll
                  liegt zwar in SysWOW64 dieser Maschine - zaehlt nicht.
```

Bei der dritten meldet das Werkzeug ausdrücklich, dass `laufzeit-holen.ps1`
hier **nicht** die Lösung ist — der frühere Weg in den Lizenzverstoß ist damit
zugemauert.

---

### 6. Die Antwort auf Kriterium 0

**Ja — Paket 1.0.12-release ist aus sich heraus startfähig.**

35 Binärdateien, davon 33 x86 (zu den zwei anderen siehe X-8.1). 13 Module in
der Startkette: `Eudora.exe`, `EuLang.dll`, `EuMemMgr.dll`, `Imap.dll`,
`libexpat.dll`, `mfc140.dll`, `msvcp140.dll`, `msvcr71.dll`, `Paige32.dll`,
`plstclnt.dll`, `QCSocket.dll`, `QCUtils.dll`, `vcruntime140.dll`. Alle liegen
im Paket. 251 Importe lösen gegen Windows-eigene Bibliotheken auf, 53 gegen
Paketdateien. In der Startkette fehlt **nichts**.

Das ist ein Nachweis über den PE-Kopf, kein Startversuch. Er sagt: der Lader
findet alles, was er vor dem ersten Befehl braucht. Er sagt nicht, dass das
Fenster danach bedienbar ist — dafür stehen S-5, S-6 und M-1 weiter offen.

**Bekannte, erwartete Lücken** — kein Fehlschlag von Kriterium 0:

| fehlt | gebraucht von | Folge |
|---|---|---|
| `MFC71.DLL` | `EudoraBk.dll`, `ISock.dll`, `Ldap.dll`, `Plugins\SMIME.dll`, `Plugins\SpamHeaders.dll`, `Plugins\SpamWatch.dll` | Adressbuch, LDAP, S/MIME, Spam-Erweiterungen |
| `MSVCP71.dll` | `Ldap.dll`, `Ph.dll`, `Plugins\SMIME.dll`, `Plugins\SpamHeaders.dll`, `Plugins\SpamWatch.dll` | LDAP, Ph, S/MIME |

Beide stammen von Visual Studio .NET 2003 und wurden von Microsoft nie als
Redistributable veröffentlicht. Keine der sechs Dateien liegt in der
Startkette — das Werkzeug prüft das eigens und würde die Lücke sonst zum Fehler
hochstufen.

---

## X-8.1 — Zwei 16-Bit-Altlasten im Paket (niedrig, offen)

`EUMAPI.DLL` (82 944 Byte) trägt an `e_lfanew` die Signatur **`NE`** — ein
16-Bit-New-Executable aus der Zeit vor Win32. `ifsmon.vxd` (4 811 Byte) trägt
**`LE`** — ein Win9x-Gerätetreiber. Beide lassen sich auf einem 64-Bit-Windows
überhaupt nicht laden; NTVDM gibt es dort nicht.

Nachgemessen: **keine** Paketdatei importiert eine der beiden. Sie schaden also
nichts, sie sind totes Gewicht aus dem Eudora-7.1-Original. Das 32-Bit-Gegen-
stück `EuMAPI32.dll` (147 537 Byte) liegt daneben und ist ein gültiges PE32.

Das Werkzeug meldet beide jetzt als Warnung und würde sie zum **Fehler**
hochstufen, sobald sie doch jemand importiert.

---

## X-8.2 — Das Debug-Paket 1.0.12 mischt einen Release-Bau hinein (mittel, offen)

Beim Lauf gegen `Eudora72-1.0.12-debug` fiel auf: `QCSSL.dll` importiert
`mfc140.dll` und `VCRUNTIME140.dll` — die **Release**-Laufzeiten — während jede
andere Binärdatei desselben Pakets `mfc140d.dll`, `MSVCP140D.dll`,
`ucrtbased.dll` und `VCRUNTIME140D.dll` importiert.

`QCSSL.dll` ist in diesem Paket also kein Debug-Bau. Da die Release-Laufzeiten
im Debug-Paket nicht beiliegen, meldet das Werkzeug sie folgerichtig als
Bedarfslücke: SSL fällt aus, sobald es gebraucht wird. Zwei CRT-Instanzen im
selben Prozess sind darüber hinaus die klassische Quelle für Abstürze beim
Freigeben von Speicher über die Modulgrenze.

Nicht verfolgt — hier wurde nur ein PowerShell-Werkzeug geändert, nicht gebaut.

---

## X-8.3 — Aussagen über den Prüfer sind jetzt überholt (niedrig, offen)

Mehrere Dateien sagen, `paket-pruefen.ps1` tauge nicht als Freigabekriterium.
Das galt für die alte Fassung und stimmt nicht mehr:

| Datei | Zeile |
|---|---|
| `ZIEL.md` | 19, 113, 127, 137 |
| `AUFGABEN.md` | 26, 103, 254 |
| `WEITERMACHEN.md` | 226, 470, 602, 628 |
| `Releases/PAKETE.md` | 113 |
| `Releases/1.0.3/LIESMICH.txt` | 54, 104, 178-195 |

Nicht angefasst: `BEFUNDE.md`, `README.md` und `AUFGABEN.md` gehören derzeit
LEKTOR, und die übrigen Stellen im selben Zug zu ändern hätte den Zweig
unnötig mit fremder Arbeit verzahnt. Die Aufstellung steht hier, damit sie
niemand suchen muss.

Die Schnittstelle des Werkzeugs ist unverändert (`-Paket`, `-Ausfuehrlich`,
Rückgabe 0/1/2), `tools/paket-bauen.ps1:154` und `:206` brauchen nichts.
