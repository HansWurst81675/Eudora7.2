# Aufgaben für die nächste Sitzung

Stand **31.08.2026, 09:00**. Branch `darstellung-und-menue`.
Einstieg: [WEITERMACHEN.md](WEITERMACHEN.md) · Maßstab: [ZIEL.md](ZIEL.md) ·
Belege: [BEFUNDE.md](BEFUNDE.md)

Diese Datei ist die Arbeitsliste — was zu tun ist, in welcher Reihenfolge, und
für jeden Punkt die Fundstelle. Sie ist so geschrieben, dass ein Agent damit
sofort anfangen kann, ohne die Vorgeschichte zu kennen.

---

## Wo wir stehen

| # | Kriterium aus ZIEL.md | Stand |
|---|---|---|
| 0 | Paket läuft ohne Nachinstallieren | **nicht belegt** — Release-Paket gebaut, aber `paket-pruefen.ps1` trägt nicht (PR-2) |
| 1 | startet, Hauptfenster bedienbar | **erfüllt** (E-1) |
| 2 | Darstellung korrekt | **fast** — HTML-Umlaute behoben, Wirkung ungeprüft (Z-2) |
| 3 | Mailkonto verbinden und Mail abrufen | **erfüllt** — 159 Nachrichten, TLS 1.3 (E-1, E-3) |

---

## Ganz zuerst: das Release auf dem zweiten PC probieren

**Am 31.08. um 09:00 nicht mehr geschafft — das ist der erste Schritt.**

Auf GitHub hängt seit 09:00 ein **ausgetauschtes** ZIP:

| | |
|---|---|
| Veröffentlichung | https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.3 |
| SHA256 | `d471904776d5c93a0d7c5e11ea90c756d02fe0c422aa82e396c1eabd4e89cfcc` |
| enthält | die **E-11-Behebung** (`eudora.cpp:3372`, `Truncate` statt `ReleaseBuffer`) |
| dazu | Härtung von `InitPluginList`, Zeichensatz-Ansage für HTML (Z-2) |

Die **erste** Fassung (`632c4066…`) hatte die Behebung noch nicht — die hat
Gregor am 31.08. probiert, und sie stürzte beim Klick auf *Weiter* ab.

**Zu tun, in dieser Reihenfolge:**

1. Auf dem Win11-Rechner auspacken, `Eudora.exe` starten, im Assistenten
   auf *Weiter* klicken. **Stürzt es noch ab?**
   - **Nein** → E-11 ist bestätigt. Dann A2: die Fehlerklasse abstellen.
   - **Ja** → `tools/stapel-untersuchen.ps1` mit der `Eudora.pdb` daneben.
     Die `Eudora.pdb` liegt **nicht** im Paket, sie muss aus
     `Eudora71/Bin/Release` dazu.
2. Dabei gleich mitprüfen, was ohnehin ansteht:
   - **Kriterium 0** — startet es dort ohne Nachinstallieren? (C2)
   - **HTML-Umlaute** — eine Mail mit Umlauten öffnen (B1)
   - **Die Kennung im Titel** — steht sie da, sobald ein Postfach offen
     ist? Vorher nicht, das ist E-7.
   - **Beim Beenden** — kommt der Index-Fehler aus E-4?
3. Und die offene Frage aus E-6: **warum musste das Mailverzeichnis von
   Hand dazugelegt werden**, obwohl das Paket eines enthält?

Ein einziger Lauf beantwortet fünf offene Punkte. Deshalb steht er hier oben.

---

## A — Zuerst: der Absturz auf frischen Installationen

**Dringend, weil er jeden neuen Anwender trifft.**

### A1 · Die Behebung prüfen lassen

`eudora.cpp:3372` wurde am 31.08. um 08:55 geändert:

```cpp
RegMailto = RegMailto.Left(i);      // war: RegMailto.ReleaseBuffer(i);
```

Ursache und Beleg stehen in **E-11**. Kurzfassung: `ReleaseBuffer` ohne
vorangehendes `GetBuffer` ist bei MFC 14 unzulässig — `CStringT` zählt
Referenzen. Auf Gregors VM fiel es nie auf, weil der Zweig nur bei einer
**jungfräulichen** Installation betreten wird (Eudora ist dort schon
`mailto`-Handler).

**Zu tun:** Release bauen, Paket schnüren, Gregor auf dem Win11-Rechner
probieren lassen: Assistent → *Weiter*. Der Bau lief beim Sitzungsende noch.

### A2 · Die Fehlerklasse abstellen — **142 Vorkommen**

`ReleaseBuffer` ist im Baum **142-mal** benutzt. Nicht alle falsch: richtig ist
`p = s.GetBuffer(n); … s.ReleaseBuffer();`. Falsch sind die ohne vorangehendes
`GetBuffer` auf **derselben** Variablen.

Besonders verdächtig, weil sie eine **Länge** übergeben und damit kürzen wollen:

| Stelle | Bemerkung |
|---|---|
| `eudora.cpp:3372` | behoben (A1) |
| `QCSharewareManager.cpp`, in `Load` | `RetailVersion.ReleaseBuffer(LastDot + 1)` — läuft bei **jedem Start** durch den Box-Build-Zweig |
| `ConConProfile.cpp:198` | `m_szElementData.ReleaseBuffer(nNewDataLength)` |

**Aufgabe für einen Agenten:** ein Werkzeug `tools/releasebuffer-pruefen.pl`,
das je Vorkommen prüft, ob auf derselben Variablen vorher ein `GetBuffer` im
selben Block steht. Ausgabe als Liste mit Datei:Zeile und Einstufung. Danach
die echten Fälle einzeln beheben — `s = s.Left(i)` statt `s.ReleaseBuffer(i)`.

Das ist eine **Fehlerklasse**, kein Einzelfall: eine VC6-Altlast, die sich erst
zur Laufzeit meldet, und zwar nur auf bestimmten Wegen.

---

## B — Was Gregor sieht

### B1 · HTML-Umlaute: Wirkung prüfen

Behoben in `TridentView.cpp:1334-1351` und `msgutils.cpp:1625-1639` (**Z-2**),
übersetzt, **aber nie im Programm gesehen**. Eine HTML-Mail mit Umlauten öffnen.

Gegenprobe ohne Eudora-Start: nach dem Anzeigen liegt die Zwischendatei als
`%TEMP%\eud*.htm` (`TridentView.cpp:1469-1484`) — dort muss die
`charset=windows-1252`-Zeile als **erste** stehen und keine fremde
`charset`-Angabe mehr vorkommen.

### B2 · Die Bau-Kennung fehlt im Titel (**E-7**)

Solange kein Postfach offen ist, steht im Titel nur `Eudora`. `OnUpdateFrameTitle`
läuft erst bei einer Auffrischung. **Behebung:** einmal `OnUpdateFrameTitle(TRUE)`
nach `FinishInitAndShowWindow` (`eudora.cpp:1510`) aufrufen. Kleiner Eingriff.

Das ist mehr als Kosmetik: die Kennung fehlt genau in dem Zustand, in dem
Gregor Fehler findet — beim frischen Start.

### B3 · Absturz beim Beenden (**E-4**)

`afxcoll.inl:213` = `CPtrArray::ElementAt`, Index außerhalb des Arrays.
Verdacht: `SECDockBar::MoveControlBarToPosition` (`OTShim.cpp:2718-2795`, am
31.08. neu) baut `m_arrBars` von Hand um, ohne den Zustand mitzuziehen, den
`CDockBar` parallel führt.

**Weg:** `tools/stapel-untersuchen.ps1`, im Zusicherungsdialog *Wiederholen*
drücken — dann wird aus der Meldung ein Haltepunkt, den der Debugger sieht.

### B4 · Gesperrte Werkzeugleisten-Knöpfe

`DrawDisabled` ist behoben (E-2), aber geprüft ist nur der Zustand, in dem die
Knöpfe **freigegeben** sind. Nachsehen, ob gesperrte Knöpfe erkennbar grau
erscheinen statt leer.

---

## C — Das Auslieferungspaket

### C1 · `paket-pruefen.ps1` ist unbrauchbar als Freigabekriterium (**PR-2**)

Zwei belegte Mängel:

1. **Es prüft die Maschine, nicht das Paket.** Gegenprobe: `EudoraRes.dll`,
   `QCSSL.dll`, `SPELL32.DLL`, `EuGraph.ocx` und `Plugins\` aus einer Kopie
   gelöscht → *„keine Fehler, EXIT=0"*.
2. **Bei einem Release-Paket erzeugt es vier Falschwarnungen** (feste
   Debug-Laufzeitliste, `:360`). Wer ihnen folgt, holt mit `laufzeit-holen.ps1`
   die **nicht verteilbaren** DLLs ins Paket — es leitet zum Lizenzverstoß an.

**Behebung:** die nötigen Laufzeiten aus den **Importen** der Paketdateien
ableiten, nicht aus einer Liste. Und „vorhanden" nur gelten lassen, wenn die
Datei **im Paket** liegt oder von Windows selbst stammt — nicht, wenn sie in
`SysWOW64` einer Entwicklermaschine steht.

Solange das offen ist, ist **Kriterium 0 nicht nachweisbar**.

### C2 · Kriterium 0 auf einem Rechner ohne Visual Studio nachweisen

Das Release-Paket dort auspacken und starten. Das ist der einzige belastbare
Nachweis. Am 31.08. lief auf dem Win11-Rechner das **Debug**-Paket mit
beigelegten, nicht verteilbaren DLLs (**E-8**) — das zählt nicht.

### C3 · Warum musste das Mailverzeichnis von Hand dazugelegt werden?

Beide Pakete enthalten `Mailverzeichnis\Eudora.ini`. Ungeklärt (**E-6**).

---

## D — Die Werkzeuge

### D1 · Neun Löcher in `pruefe-bytes.pl` (**X-1**)

Die zwei schwersten sind genau die Schäden, gegen die die Schranke gebaut wurde:

- **L1** — eine **Umbenennung** hebelt sie vollständig aus (`:198`,
  `--diff-filter=ACM`; ein `git mv` erscheint als `R088` und landet nie in der
  Prüfliste). `git mv` + Neuschreiben ist der Ablauf einer Portierung.
- **L2** — eine saubere Umkodierung **Latin-1 → UTF-8** bleibt unerkannt.

Dazu L3 bis L9, alle in X-1 mit Gegenprobe belegt.

### D2 · Der pre-commit-Hook wertet seinen ersten Schritt nicht aus (**X-1**)

`tools/hooks-einrichten.sh:20` prüft `$?` von `lehren-spiegeln.pl` nicht. Meldet
das Spiegeln *„Der Commit wurde abgebrochen"*, stimmt das nicht — der Hook gibt
0 zurück. Dieselbe Fehlerklasse wie NP3-4.

### D3 · `suche-zeiger.pl` ist Rauschen (**X-1**)

345 Treffer, Stichprobe von 15: **15 Fehlalarme**. Drei strukturelle Ursachen
erklären 79 %. Entweder die drei Filter einbauen oder das Werkzeug löschen.

### D4 · `zeilenenden-angleichen.pl`: zwei Lücken (**X-1**)

Es lässt **773 eindeutige Textdateien** aus (darunter `.ih` und `.rgs`, die
mitkompiliert werden bzw. als Ressource ins Binary gehen). Und es dreht
absichtliche Arbeit **richtungslos** zurück: wer LF→CRLF korrigiert, verliert
das kommentarlos.

---

## E — Die Ersatzschicht

### E1 · `FloatControlBarInMDIChild` ist ein leerer Rumpf (**A-1**)

`WazooBarMgr.cpp:377-400` dockt danach das Adressbuch an, schickt
`ID_SEC_MDIFLOAT` (wirkungslos) und ruft `GetParentFrame()` — das liefert dann
**das Hauptfenster** statt eines `QCControlBarWorksheet`. Im Debug greift
`ASSERT_KINDOF`, **im Release läuft `MoveWindow` auf das Hauptfenster**.

ANSICHT hält das für den größten verbliebenen Rest.

### E2 · Der größte Eingriff des Tages hat keinen Test (**PR-2**)

`1a4a6d5` ändert `OTShim.cpp` um **334 Zeilen**; `Eudora71/Tests/` blieb
unangetastet. `TestOTShimAndocken.cpp:214` prüft sogar noch das **alte**
Verhalten (`CalcDynamicLayout(0, LM_HORZDOCK) == 32767`). Der neue Zweig wird
von keinem der 105 Tests betreten.

### E3 · `SetControlBarWidthsInRow` ist noch leer

`OTShim.cpp:2244`, und `OnSizeParent` (`:3276`) reicht noch durch.

---

## F — Offene Kleinigkeiten

- **`Out.mbx`-Größe 1.788.158.654 für eine leere Datei** (E-11, Nebenbefund) —
  nicht initialisierter Wert im Protokoll, zwei Zeilen später steht korrekt 0.
- **`EUMAPI.DLL` ist eine 16-Bit-Datei** von 1995 (Signatur `NE`, belegt in
  Z-1). Niemand importiert sie. Kann vermutlich aus dem Paket.
- **`MFC71.DLL` und `MSVCP71.dll`** sind nicht nachbaubar (157 Ordinale, B-1).
  Adressbuch, LDAP und Ph fallen dauerhaft aus, solange die Fremd-DLLs von 2006
  benutzt werden.
- **Der Release-Zweig von `EudoraRes`** hängt noch über einen Projektverweis an
  `OT501` (`EudoraRes.vcxproj:351`).
- **LEKTORAT:** am 31.08.2026 abends sind **alle 45 Markdown-Dateien** gelesen
  und die Widersprüche berichtigt worden (dritter Durchgang in `LEKTORAT.md`).
  Ungeprüft bleiben die beiden `LIESMICH.txt` — insbesondere
  `Releases/1.0.3/LIESMICH.txt`, die noch den Debug-Weg beschreibt und für ein
  Release-Paket irreführend ist (F-1, nächster Schritt 3).
- ~~**Die alte CR-Anzahl-Regel** steht noch in vier `Arbeitsweise/`-Dateien, in
  `PORTIERUNG.md` und in einem Patch-Kommentar.~~ **Nachgemessen am 31.08.2026
  abends: die Behauptung war zu weit gefasst.** Von acht Fundstellen war
  **eine** falsch (`tools/patches/zertifikatspruefung-verschaerfen.md:105`,
  jetzt berichtigt). Die `Arbeitsweise/`-Stellen beschreiben `aendere-zeile.pl`
  — und das bricht wirklich bei geänderter CR-Zahl ab (`:33`) — oder den
  Handgriff von Hand; beides richtig. `PORTIERUNG.md:664` sagt ausdrücklich,
  dass die CR-Anzahl **nicht** mehr verglichen wird.
- ~~**`VC71Bruecke/BEFUND.md:462`** nennt eine **falsche GUID**~~ — **berichtigt
  am 31.08.2026 abends**, mit Kasten und der echten GUID aus
  `VC71Bruecke.vcxproj:32` (gegengeprüft: sie steht fünfmal in
  `Eudora71/Eudora.sln`).

---

## Zurückgestellt — nicht von selbst aufgreifen

`tools/patches/zertifikatspruefung-verschaerfen.patch` (Hostnamensprüfung,
`X509_V_ERR_CERT_UNTRUSTED`). Gregor hat entschieden, das später anzugehen.
**Nicht ohne sein Wort anwenden.**

---

## Auflagen für Agenten

1. **Kein Programm mit Fenstern starten** ohne Absprache. Gregor testet auf
   derselben Windows-Sitzung. Beim Aufräumen von Prozessen **immer nach Pfad
   filtern** — sonst schießt man seine laufende Sitzung mit ab.
2. **Erst prüfen, dann anweisen.** Keine Handlungsanweisung ohne den Weg selbst
   gegangen zu sein. Ein Bauverzeichnis ist kein Startverzeichnis.
3. **Byte-erhaltend ändern:** `tools/aendere-zeile.pl`, `tools/ersetze-bereich.pl`.
   **Niemals `sed`** — das cygwin-`sed` wirft CR weg (X-1). Zum Messen `perl`
   mit `:raw`, **nicht** `grep -c $'\r'`.
4. **Bauen nur in der PowerShell**, nicht in der Git-Bash. Visual Studio liegt
   unter **Professional**. Einzelprojekte brauchen
   `/p:BuildProjectReferences=false`; für den Release-Zweig einmal **mit**
   Verweisen bauen, damit die `.lib` entstehen, dann **ohne**.
5. **Zeilenangaben veralten**, sobald jemand dieselbe Datei anfasst (Z-1: sieben
   von elf Abweichungen waren genau das). Wer eine Fundstelle benutzt, prüft sie
   nach.
6. **In kleinen Schritten committen und pushen.** Was nicht gepusht ist, ist bei
   einem Abschalten verloren.
