# PRÜFUNG-PAKET — welche Dateien fehlen im Auslieferungs-ZIP?

Agent PAKET, 05.09.2026. Reine Messung, nichts geändert.
Verfahren: PE-Kopf und Import-/Verzögerungstabelle jeder Binärdatei selbst
ausgelesen (Perl, `peimp.pl` / `pesym.pl` im Kratzverzeichnis), nicht `dumpbin`.
Alle ZIPs nur ins Kratzverzeichnis entpackt. `C:\Users\Gregor\Eudora72-*` nicht
angefasst. Kein Programm gestartet.

---

## 0 — Die kurze Antwort auf Gregors Meldung

Gregor: *„es fehlen ja dateien im zip … ich konnte es also auf einem laptop ohne
VS2022 nicht ausführen."*

**Das trifft zu — aber für Paket 1.0.2, nicht für 1.0.3.** Beide liegen in
`Releases/`, und die Namen laden zur Verwechslung ein
(`Eudora72-1.0.2-lauffaehig.zip` heißt „lauffähig", ist es aber nicht).

| Paket | Bau | fehlende Startdateien | startet auf Maschine ohne VS2022? |
|---|---|---|---|
| `Eudora72-1.0.2-lauffaehig.zip` | **Debug** | `mfc140d.dll`, `msvcp140d.dll`, `vcruntime140d.dll`, `ucrtbased.dll` | **nein** — `0xc000007b` |
| `Eudora72-1.0.3-release.zip` | **Release** | *keine* | **ja** (nach Messung; nicht am fremden Rechner erprobt) |

In 1.0.2 fehlen **vier** Dateien, die der Lader vor dem ersten Befehl braucht —
und ausgerechnet die vier dürfen **nicht** weiterverteilt werden. Das Paket war
in dieser Form nicht reparierbar; es musste neu als Release gebaut werden. Genau
das ist mit 1.0.3 geschehen.

Für 1.0.3 ist die Startkette vollständig. Offen bleiben dort nur zwei Dateien,
die erst **bei Benutzung** einzelner Funktionen gebraucht werden (Abschnitt 2).

---

## 1 — Was im Paket ist (Eudora72-1.0.3-release.zip)

155 Dateien, 21 211 003 Byte entpackt. SHA256 stimmt mit der Beilegedatei
überein: `d4719047 76d5c93a 0d7c5e11 ea90c756 d02fe0c4 22aa82e3 96c1eabd 4e89cfcc`.

**Alle 36 lesbaren PE-Dateien sind x86.** Keine einzige x64-Datei — der
Architekturfehler aus 1.0.2 (von einer DLL-Sammelseite geholte 64-Bit-Dateien)
ist nicht wieder aufgetreten.

### Programm und eigene Bibliotheken

| Datei | Byte | Arch |
|---|---|---|
| `Eudora.exe` | 2 933 760 | x86 |
| `swEudora.exe` | 1 495 112 | x86 |
| `EudoraRes.dll` | 2 447 360 | x86 |
| `QCSSL.dll` | 2 920 960 | x86 |
| `EuLang.dll` | 13 312 | x86 |
| `EuMemMgr.dll` | 64 512 | x86 |
| `Imap.dll` | 101 376 | x86 |
| `QCSocket.dll` | 63 488 | x86 |
| `QCUtils.dll` | 73 216 | x86 |
| `plstclnt.dll` | 65 024 | x86 |
| `Paige32.dll` | 311 296 | x86 |
| `Paige32d.dll` | 311 296 | x86 |
| `DirServ.dll` | 30 208 | x86 |
| `EudoraBk.dll` | 23 040 | x86 |
| `EudoraNS.dll` | 213 062 | x86 |
| `EuMAPI32.dll` | 147 537 | x86 |
| `EuShlExt.dll` | 151 616 | x86 |
| `EuGraph.ocx` | 49 213 | x86 |
| `ISock.dll` | 19 968 | x86 |
| `Ldap.dll` | 143 360 | x86 |
| `Ph.dll` | 57 344 | x86 |
| `SPELL32.DLL` | 112 128 | x86 |
| `x1lib.dll` | 633 856 | x86 |
| `NSImport.eif` / `OEImport.eif` / `OLImport.eif` | 38 912 / 33 792 / 49 664 | x86 |
| `Plugins\SMIME.dll` | 94 208 | x86 |
| `Plugins\SpamHeaders.dll` | 303 104 | x86 |
| `Plugins\SpamWatch.dll` | 81 920 | x86 |
| `libeay32.dll` / `ssleay32.dll` | 659 456 / 155 648 | x86 |
| `libexpat.dll` | 151 552 | x86 |
| `EUMAPI.DLL` | 82 944 | **kein PE** (16-Bit-Altbestand) |
| `ifsmon.vxd` | 4 811 | **kein PE** (VxD, Windows-9x-Altbestand) |

### Mitgelieferte Laufzeiten

| Datei | Byte | Version | Herkunft |
|---|---|---|---|
| `mfc140.dll` | 4 842 112 | 14.38.33142.0 | Microsoft, Release-Redist |
| `msvcp140.dll` | 446 840 | 14.38.33142.0 | Microsoft, Release-Redist |
| `vcruntime140.dll` | 91 296 | 14.38.33142.0 | Microsoft, Release-Redist |
| `msvcr71.dll` | 35 328 | *keine Versionsangabe* | **eigenbau**, siehe unten |

### Daten und Beiwerk

`EUDORA.HLP` (1 165 977), `Eudora.CNT`, `eudora.tip`, `flamelex.dat`,
`EudoraCCProfiles.xml`, `finger.ini`, `ph.ini`, `LDAPinit.ini`,
`rootcerts.p7b` (129 194), `usercerts.p7b`, `Plugins\SpamHeaders.txt`,
`LIESMICH.txt`, `paket-pruefen.ps1`, `Mailverzeichnis\Eudora.ini` (3 222),
sowie die drei Emoticon-Verzeichnisse (`Emoticons`, `Emoticons24`,
`Emoticons32`, zusammen 117 PNG plus zwei `Thumbs.db`).

### `msvcr71.dll` ist nicht die Datei von Microsoft — und das ist Absicht

Gemessen: 35 328 Byte, **keine Versionsressource**, importiert **nur
`kernel32.dll`**, exportiert aber **833 Namen**. Die echte Datei in `Releases/`
(nicht im ZIP) ist 344 064 Byte, Version 7.10.7031.4, „Microsoft® Visual Studio
.NET".

Das ist kein Versehen und kein Stummel: es ist die selbstgebaute Brücke aus
`Eudora71/VC71Bruecke`, die ihre Exporte an die von Windows mitgelieferte
`msvcrt.dll` weiterleitet (Weiterleitungen erzeugen keine Importe — daher nur
`kernel32`). **Gegenprobe bestanden:** die Paketdateien verlangen zusammen 118
Namen aus `msvcr71.dll`; **alle 118 sind in der Brücke vorhanden**, Fehlmenge 0.
Rechtlich sauber, weil keine Microsoft-Binärdatei weitergegeben wird.

---

## 2 — Was fehlt (Gruppe c) — das Herzstück

Vollständige transitive Hülle aller Import- und Verzögerungstabellen, abzüglich
dessen, was im Paket liegt (Gruppe a, 14 Einträge) und was Windows selbst
mitbringt (Gruppe b, 39 Einträge, darunter `ucrtbase.dll` und die
`api-ms-win-crt-*`-Apisets — die sind seit Windows 10 Bestandteil des Systems).

### 2a — Paket 1.0.3: **zwei** Dateien fehlen, beide **nicht** startrelevant

| fehlende Datei | gebraucht von | Herkunft | weiterverteilbar? |
|---|---|---|---|
| **`MFC71.DLL`** | `EudoraBk.dll`, `ISock.dll`, `Ldap.dll`, `Plugins\SMIME.dll`, `Plugins\SpamHeaders.dll`, `Plugins\SpamWatch.dll` | Visual C++ 7.1 / VS.NET 2003 | **nein** — Microsoft hat dafür nie ein eigenständiges Redistributable veröffentlicht |
| **`MSVCP71.dll`** | `Ldap.dll`, `Ph.dll`, `Plugins\SMIME.dll`, `Plugins\SpamHeaders.dll`, `Plugins\SpamWatch.dll` | Visual C++ 7.1 / VS.NET 2003 | **nein** — dito |

Zwei Kandidaten habe ich geprüft und wieder ausgeschlossen, weil Windows sie
selbst mitbringt (auf dieser Maschine in `C:\Windows\SysWOW64` nachgewiesen):

* `mfc42.dll` (1 171 456 Byte, verlangt von `EuGraph.ocx`) — Windows-Altbestand
* `oleacc.dll` (321 024 Byte, nur *verzögert* von `mfc140.dll`) — Windows

**Beide fehlenden Dateien liegen außerhalb der Startkette.** Der Lader braucht
vor dem ersten Befehl genau diese 14 Module, und **alle 14 lösen auf**:

    Eudora.exe  swEudora.exe  EuLang.dll  EuMemMgr.dll  Imap.dll
    libexpat.dll  mfc140.dll  msvcp140.dll  msvcr71.dll  Paige32.dll
    plstclnt.dll  QCSocket.dll  QCUtils.dll  vcruntime140.dll

`EudoraBk`, `ISock`, `Ldap`, `Ph` und die drei Plugins lädt Eudora erst bei
Benutzung nach. Was ausfällt: **Adressbuch, LDAP-/Ph-Verzeichnisdienste, S/MIME,
SpamWatch, SpamHeaders.** Der Start ist davon nicht betroffen.

Dass `MFC71.DLL` nicht zu ersetzen ist, ist bereits belegt und liegt nicht am
Willen: laut `Eudora71/VC71Bruecke/BEFUND.md` laufen **alle 157 MFC71-Importe
über Ordinale, kein einziger über einen Namen** — eine Brücke wie bei `msvcr71`
ist damit aussichtslos, weil die Ordinalzuordnung von 2003 nirgends
veröffentlicht ist. Das ist ein bekannter, dokumentierter Zustand, kein neuer
Befund.

### 2b — Paket 1.0.2: **vier** Dateien fehlen, alle startrelevant

Das ist der Fall, den Gregor erlebt hat.

| fehlende Datei | gebraucht von (Auszug) | Herkunft | weiterverteilbar? |
|---|---|---|---|
| **`mfc140d.dll`** | `Eudora.exe`, `EuLang.dll`, `EudoraRes.dll`, `Imap.dll`, `QCSocket.dll`, `QCUtils.dll`, `plstclnt.dll`, 3 × `.eif` | VS2022 **Debug**-MFC | **NEIN — verboten** |
| **`msvcp140d.dll`** | `Eudora.exe`, `Imap.dll`, `QCSocket.dll`, `plstclnt.dll`, `NSImport.eif`, `OLImport.eif` | VS2022 **Debug**-CRT | **NEIN — verboten** |
| **`vcruntime140d.dll`** | `Eudora.exe` und alle oben genannten | VS2022 **Debug**-CRT | **NEIN — verboten** |
| **`ucrtbased.dll`** | `Eudora.exe` und alle oben genannten | VS2022 **Debug**-UCRT | **NEIN — verboten** |
| `mfc71d.dll` | `Plugins\SMIME.dll`, `SpamHeaders.dll`, `SpamWatch.dll` | VC7.1 Debug | **NEIN — verboten** |

Dazu drei `.pdb`-Dateien (`Plugins\SMIME.pdb`, `SpamHeaders.pdb`,
`SpamWatch.pdb`) — Symboldateien, die in ein Auslieferungspaket nicht gehören.

**Das ist Befund S-8/E-8, und er ist damit belegt:** 1.0.2 war ein Debug-Paket,
dessen Laufzeiten grundsätzlich nicht mitgeliefert werden dürfen. Es lief auf
Gregors Entwicklungsmaschine nur deshalb, weil VS2022 die vier Dateien in
`SysWOW64` abgelegt hat (auf dieser Maschine nachgeprüft: alle vier dort
vorhanden). Auf jeder Maschine ohne VS2022 endet das mit `0xc000007b`.

---

## 3 — Release oder Debug? — Beleg über die Importe, nicht über Dateinamen

**Paket 1.0.3 ist ein reines Release-Paket.** Über alle 36 PE-Dateien hinweg:
**null** Treffer auf `mfc140d` / `msvcp140d` / `vcruntime140d` / `ucrtbased` /
`msvcr71d` / `msvcp71d` / `mfc71d`. Ebenfalls null `.pdb`-Dateien.

**Paket 1.0.2 war ein reines Debug-Paket.** `Eudora.exe` importiert dort
nachweislich `mfc140d.dll`, `msvcp140d.dll`, `ucrtbased.dll`,
`vcruntime140d.dll` — und zwar zusätzlich `paige32d.dll` statt `Paige32.dll`.

Zwei Fallstricke, die die Dateinamen-Prüfung allein falsch beantwortet hätte:

* **`Paige32d.dll` in 1.0.3 ist trotz des `d` KEIN Debug-Bau.** Sie importiert
  `msvcr71.dll` (Release), nicht `msvcr71d.dll`. Das `d` gehört zum
  Produktnamen, nicht zur Bauart. Beide Paige-Dateien tragen Version 7.0.0.8.
* **`msvcr71.dll` in 1.0.3** ist wie beschrieben kein Microsoft-Original,
  sondern die eigene Brücke — nach Dateinamen nicht zu erkennen.

---

## 4 — Wo die weiterverteilbaren Dateien auf diesem Rechner liegen

Visual Studio 2022 **Professional**, Redist-Fassung **14.38.33130**
(Dateiversion 14.38.33142.0):

    C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Redist\MSVC\14.38.33130\x86\Microsoft.VC143.CRT\
        vcruntime140.dll            91 296
        msvcp140.dll               446 840
        concrt140.dll              257 528   (wird NICHT gebraucht, s.u.)
        msvcp140_1.dll / _2.dll / _atomic_wait.dll / _codecvt_ids.dll
        vccorlib140.dll, vcruntime140_threads.dll

    C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Redist\MSVC\14.38.33130\x86\Microsoft.VC143.MFC\
        mfc140.dll               4 842 112
        mfc140u.dll              4 869 768   (Unicode-Fassung, hier nicht nötig)
        mfcm140.dll / mfcm140u.dll

Die drei Dateien im Paket 1.0.3 stimmen **byteweise in der Größe** mit diesen
überein (4 842 112 / 446 840 / 91 296) — sie stammen genau von hier. Es ist
nichts einzusammeln; 1.0.3 ist bereits vollständig bestückt.

**`concrt140.dll` wird nicht gebraucht.** Keine Paketdatei importiert sie,
`msvcp140.dll` auch nicht. Sie gehört nicht ins Paket.
**`vcruntime140_1.dll` gibt es für x86 nicht** (nur x64) — zu Recht nicht dabei.
**`ucrtbase.dll` gehört nicht ins Paket**: sie ist seit Windows 10
Betriebssystembestandteil (hier: `SysWOW64`, 1 182 408 Byte).

Die **Debug**-Gegenstücke liegen unter
`…\14.38.33130\debug_nonredist\x86\Microsoft.VC143.DebugCRT\` bzw.
`…\Microsoft.VC143.DebugMFC\`. Der Verzeichnisname sagt es: **nonredist** —
sie dürfen nicht weitergegeben werden. Sie sind für 1.0.3 auch nicht nötig.

`MFC71.DLL` und `MSVCP71.dll` sind **auf diesem Rechner nirgends** vorhanden
(weder `System32` noch `SysWOW64` noch im Projekt). Nur die verbotenen
Debug-Fassungen `msvcp71d.dll` liegen lose in `Releases/`.

---

## 5 — Trägt PR-2? — **Ja, beide Teile. Und der erste Teil wiegt schwerer als behauptet.**

Behauptet wird: `tools/paket-pruefen.ps1` „prüft die Maschine statt das Paket"
und erzeugt bei einem Release-Paket vier Falschwarnungen.

### Teil 1 — „prüft die Maschine statt das Paket": **belegt**

`Finde-DLL`, **Zeilen 260–272**, akzeptiert `SysWOW64` (Z. 265) und `System32`
(Z. 266) als gültigen Fundort und gibt dann `continue` (Z. 323) — **ohne jede
Meldung**, nicht einmal eine Warnung. Eine Laufzeit-DLL, die im Paket fehlt,
aber auf der Entwicklermaschine im System liegt, gilt damit als in Ordnung.

Prüfung 3 (Z. 357–378) fängt das nur für die **vier Debug**-Laufzeiten ab
(fest verdrahtet in Z. 360). Für die **Release**-Laufzeiten gibt es keinen
solchen Rückhalt.

**Gegenprobe durchgeführt** (auf einer Kopie im Kratzverzeichnis, nichts
gestartet): aus dem entpackten 1.0.3 `mfc140.dll`, `msvcp140.dll` und
`vcruntime140.dll` gelöscht, dann das Werkzeug laufen lassen. Ergebnis:

    Startkette: 11 Modul(e), die der Lader vor dem ersten Befehl braucht.
    In der Startkette loest alles auf.
    ERGEBNIS: keine Fehler.
    EXITCODE=0

**Ein Paket ohne jede VC140-Laufzeit — genau der Fehler, an dem 1.0.2
gescheitert ist — wird als fehlerfrei durchgewinkt.** Das Werkzeug kann den
Fehler, für den es ausdrücklich gebaut wurde (Kopfkommentar Z. 11–19), in seiner
Release-Ausprägung nicht finden.

### Teil 2 — „vier Falschwarnungen": **belegt, und untertrieben**

Zeile 360 verdrahtet `mfc140d.dll`, `msvcp140d.dll`, `vcruntime140d.dll`,
`ucrtbased.dll` und **verlangt** sie („die vier VS2022-Debug-Laufzeiten muessen
dabei sein", Z. 28). Ein korrektes Release-Paket hat keine davon. Lauf gegen das
entpackte 1.0.3 auf dieser Maschine:

    3. VS2022-DEBUG-LAUFZEITEN
       mfc140d.dll        nicht im Paket, aber in SysWOW64 vorhanden
       msvcp140d.dll      nicht im Paket, aber in SysWOW64 vorhanden
       vcruntime140d.dll  nicht im Paket, aber in SysWOW64 vorhanden
       ucrtbased.dll      nicht im Paket, aber in SysWOW64 vorhanden

Genau **vier** Falschwarnungen, wie behauptet — dazu der irreführende Rat,
`laufzeit-holen.ps1` laufen zu lassen (Z. 377), was verbotene Debug-Dateien ins
Paket holen würde.

**Verschärfung:** auf einer Maschine **ohne** VS2022 greift nicht Z. 366
(Warnung), sondern Z. 370–372 — `Melde-Fehler`. Dort meldet dasselbe korrekte
Release-Paket **vier FEHLER** und endet mit **Exit-Code 1**. Das Werkzeug
verwirft also auf einer sauberen Maschine genau das Paket, das dort läuft.

### Was das Werkzeug richtig macht

Die Trennung Startkette (FEHLER) gegen Spätladung (Warnung) in Z. 274–330 ist
sachlich richtig und hat `MFC71.DLL`/`MSVCP71.dll` korrekt als nicht
startrelevant eingeordnet. Der PE-Leser selbst arbeitet korrekt — seine
Ergebnisse decken sich Datei für Datei mit meiner unabhängigen Messung.

---

## 6 — Trägt V-1? — **Ja, und es sind drei ZIPs, nicht zwei**

Unter der Versionsnummer 1.0.3 wurden nacheinander **drei verschiedene** ZIPs
veröffentlicht. Beleg aus dem git-Verlauf von
`Releases/Eudora72-1.0.3-release.zip`:

| Commit | Datum | SHA256 der Beilegedatei | git-Blob des ZIP |
|---|---|---|---|
| `5c49529` | 31.08.2026 | `632c4066…f7a822` | `c06b2e6c…a90dec5` |
| `b090fd8` | 31.08.2026 | `89f9fe0b…ca0853a1` | `7ead246e…2010f8a` |
| `e593c06` | 31.08.2026 | `d4719047…4e89cfcc` | `69e19f41…7db783e` |

Drei verschiedene Blobs, drei verschiedene Prüfsummen, **eine** Versionsnummer.
Die dritte ist die heute in `Releases/` liegende; ihre Prüfsumme habe ich
nachgerechnet und bestätigt. Die Commit-Nachricht von `e593c06` sagt es
ausdrücklich: „Release-ZIP mit der E-11-Behebung ausgetauscht, auch auf GitHub".

**Die Dateilisten aller drei Fassungen sind identisch** (jeweils dieselben 155
Namen) — es wurden also nur Inhalte ausgetauscht, keine Dateien ergänzt oder
entfernt. Von außen ist eine Fassung von der anderen nur an der Prüfsumme zu
unterscheiden.

**Warum das für Gregors Meldung wichtig ist:** wer 1.0.3 heruntergeladen hat,
weiß nicht, welche der drei Fassungen er hat. Die Prüfsummendatei im Verzeichnis
wurde jedes Mal mit überschrieben, sodass auch sie die Frage nicht beantwortet.
Für die Zukunft: eine ausgelieferte Versionsnummer nicht wiederverwenden.

Ergänzend: auch die Namensgebung stiftet Verwirrung. `Eudora72-1.0.2-lauffaehig.zip`
trägt „lauffaehig" im Namen und ist das Debug-Paket, das nirgends außerhalb von
Gregors Entwicklungsmaschine startet.

---

## 7 — Eudora.ini, Mailverzeichnis, Startpfad (Befund E-6)

**Die INI ist da.** `Mailverzeichnis\Eudora.ini`, 3 222 Byte, beginnt mit
`[Settings]` / `NC=1` und enthält die `[Mappings]`-Tabelle. Sie liegt **auch
schon in 1.0.2** — E-6 ist also nicht durch eine fehlende Datei entstanden.

**Der Startpfad ist die eigentliche Hürde.** `LIESMICH.txt` (Z. 50–59) verlangt:

    Eudora.exe "<Pfad zum Mailverzeichnis>"

Eudora braucht das Mailverzeichnis als **Befehlszeilenargument**. Im Paket liegt
**keine `.bat`, `.cmd` oder `.lnk`**, die das täte. Wer das ZIP entpackt und
`Eudora.exe` doppelklickt, startet ohne Argument — im Programmverzeichnis selbst
liegt keine `Eudora.ini` (nur im Unterverzeichnis `Mailverzeichnis`). Das ist
die wahrscheinlichste Erklärung dafür, dass Gregor „das Mailverzeichnis von Hand
dazulegen" musste.

Das ist **kein fehlende-Datei-Problem, sondern ein fehlender Starter.** Für
Kriterium 0 („entpacken, starten – läuft") reicht es nicht, dass die Datei im
Paket liegt; der Doppelklick muss funktionieren.

*(Vermutung, nicht gemessen: ich habe Eudora nicht gestartet und daher nicht
geprüft, was ohne Argument genau passiert — ob Abbruch über den VERIFY in
`eudora.cpp:3542` oder ein Anlegen im Programmverzeichnis. Das ließe sich nur
durch einen Start klären, und Starten war mir untersagt.)*

---

## 8 — Fazit: was ins nächste Paket muss, damit Kriterium 0 erfüllt ist

**Das Laufzeitproblem ist mit 1.0.3 bereits gelöst.** Es ist nichts
einzusammeln: `mfc140.dll`, `msvcp140.dll`, `vcruntime140.dll` liegen in der
richtigen Fassung (14.38.33142.0, x86) im Paket, `msvcr71.dll` ist durch die
eigene Brücke abgedeckt, alles Übrige bringt Windows mit. Die Startkette aus 14
Modulen löst vollständig auf. Gregors Beobachtung stammt mit hoher
Wahrscheinlichkeit von 1.0.2.

Zu tun bleibt:

1. **Gregor 1.0.3 erproben lassen — auf dem Laptop ohne VS2022, mit Angabe der
   Prüfsumme** `d4719047…4e89cfcc`, damit klar ist, welche der drei
   1.0.3-Fassungen er hat. Das ist der einzige noch fehlende Nachweis für
   Kriterium 0. Meine Messung sagt: es müsste laufen.
2. **Einen Starter beilegen** (Abschnitt 7) — eine `Eudora starten.cmd` mit
   `start "" "%~dp0Eudora.exe" "%~dp0Mailverzeichnis"`, oder die `Eudora.ini`
   zusätzlich ins Programmverzeichnis legen. Ohne das ist „entpacken, starten"
   nicht erfüllt, auch wenn keine Datei fehlt.
3. **`paket-pruefen.ps1` berichtigen** (Abschnitt 5) — zwei Eingriffe:
   Prüfung 3 muss die **Release**-Laufzeiten verlangen
   (`mfc140.dll`, `msvcp140.dll`, `vcruntime140.dll`) statt der Debug-Fassungen,
   und `Finde-DLL` darf für Laufzeit-DLLs den Fundort `SysWOW64`/`System32`
   nicht mehr als Freibrief werten, sondern muss ihn melden. Solange das nicht
   geschehen ist, ist ein grünes Ergebnis dieses Werkzeugs kein Beleg.
4. **1.0.2 aus `Releases/` zurückziehen oder eindeutig kennzeichnen.** Es heißt
   „lauffaehig", ist ein nicht auslieferbares Debug-Paket und ist die
   wahrscheinlichste Quelle von Gregors Fehlschlag.
5. **Versionsnummern nicht wiederverwenden** (Abschnitt 6). Die nächste
   Auslieferung heißt 1.0.4, auch wenn sich nur eine Datei ändert.
6. **`MFC71.DLL` / `MSVCP71.dll` bleiben offen** und sind nicht legal zu
   schließen. Das kostet Adressbuch, LDAP, Ph, S/MIME, SpamWatch und
   SpamHeaders — **nicht** den Start. Das gehört ehrlich in die `LIESMICH.txt`,
   die es bislang nicht erwähnt.
