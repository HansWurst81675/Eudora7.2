# <a id="pruefer-48"></a>PRUEFER-48 — E-116, E-130, E-142 und E-144 gegen Quelle, Bau und Gregors Lauf nachgerechnet, 23.10.2026

**Auftrag.** `git log afafdcfa..edb66e02`: die Behebung von
[E-116](../Intern/BEFUNDE.md#e-116) (Bildbreite aus `<img width>`), die
Behebung von [E-130](../Intern/BEFUNDE.md#e-130) (`BindExe.bat` stempelt
Fremd-DLLs), und Gregors Messungen zu [E-142](../Intern/BEFUNDE.md#e-142)
(leere Kopie in `Out`) und [E-144](../Intern/BEFUNDE.md#e-144)
(Antwortbezüge gehen verloren).

**Ergebnis vorweg.** Die Behebung von [E-116](../Intern/BEFUNDE.md#e-116) ist für jede Eingabe richtig, die
der HTML-Leser überhaupt liefern kann. Die Testsuite schneidet die echte
Funktion heraus, und der Gegentest wird rot. Die Behebung von [E-130](../Intern/BEFUNDE.md#e-130) stimmt
für die fünf genannten DLLs, **aber der Befund ist nur zu fünf Siebteln
richtig erzählt.** Sieben weitere Fremd-DLLs liegen im Repo in gebundenem
Zustand, eine davon (`Paige32.dll`) geht so in jedes Release-Paket
([K1](#k1)). Gregors Messungen zu [E-142](../Intern/BEFUNDE.md#e-142) und [E-144](../Intern/BEFUNDE.md#e-144) stimmen. Bei [E-142](../Intern/BEFUNDE.md#e-142) liegt
die Ursache der **Leere** aber nicht dort, wo der Eintrag sie sucht. Im selben
Lauf hat dieselbe Funktion einen lokalen Entwurf vollständig kopiert
([K7](#k7)). Für [E-144](../Intern/BEFUNDE.md#e-144) gibt es eine Behebung in zwei Zeilen, in
`summary.cpp`, nicht in `compmsgd.cpp` ([K8](#k8)).

**Kein Fund hält ein Release auf.** Neue E-Kennungen: **keine.** E-145 und
E-146 sind nicht vergeben. Alle Funde gehören zu bestehenden Befunden
(`perl tools/befund-suchen.pl` zu `Paige32.dll`, `EuMemMgr.dll`, `BindExe`,
`decimal_value_percent`, `numeric_value` und `SendAgain` vorher gelaufen).

Gekennzeichnet ist jede Aussage: **gemessen** (an Dateien, am Testlauf oder an
`dumpbin` von heute), **am Quelltext belegt** (Datei:Zeile), **Vermutung**.

---

## 1. E-116 — `decimal_value_percent`

### 1a. Was der Leser liefern kann

**Am Quelltext belegt.** Ein Attributwert kommt so an:

* `ProcessAttributes` (`PGHTMIMP.CPP:3615-3647`) kopiert höchstens
  `kMaxAttributeSize - 1` = 1023 Zeichen in `params->param`. Das ist ein Feld,
  kein Zeiger (`PGTXR.H:317`, `pg_char param[1024]`), angelegt mit
  `AppendMemory(param_ref, 1, TRUE)`, also **mit Nullen gefüllt.** Der Wert ist
  damit immer abgeschlossen und **nie NULL.** `<img width>` ohne `=` ergibt
  eine leere Zeichenkette.
* Innerhalb von Anführungszeichen geht jedes Zeichen unverändert durch,
  Leerzeichen und Tab eingeschlossen (`PGHTMIMP.CPP:942-958`,
  `InsertTokenChar(next_char, FALSE)`). `GetNextToken` (`:1097-1150`) schneidet
  nur die Anführungszeichen ab. `" 35"` und `"\t35"` kommen also wirklich so
  an. Der Testfall mit Tab ist nicht ausgedacht.
* Ohne Anführungszeichen trennt jedes Zeichen `<= ' '` das Token
  (`:933-934`). Ein führender Leerraum kann dort nicht ankommen.
* Einziger Aufrufer ist `PGHTMIMP.CPP:2364` (Breite von `<img>`). Die zweite
  Kopie `PaigeDLL/PGTXR/PGHTMIMP.CPP` baut kein Projekt (`tools/wer-baut.pl`:
  „steht in KEINEM Projekt").

### 1b. Jede gefragte Eingabe, alt gegen neu

**Gemessen.** Beide Fassungen der Funktion (alt aus `afafdcfa`, neu aus der
geschnittenen `generated/pghtmimp_e116.inc`) habe ich in ein eigenes Messprogramm im
Scratch-Verzeichnis übersetzt (`cl /O2`, `pg_char = unsigned char` wie
`CPUDEFS.H:501`). `max_for_percent = 600`, rechte Spalte ist der Wert nach dem
`(short)` in Zeile 2364:

| Eingabe | alt | neu | neu nach `(short)` |
|---|---|---|---|
| `35` | 35 | 35 | 35 |
| `35px` | 3508 | **35** | 35 |
| `35%` | 210 | 210 | 210 |
| `35 %` | 2100 | **35** | 35 |
| `" 35"` | 35 | 35 | 35 |
| `" \t 35"` | 9035 | **35** | 35 |
| `+35` | 1135 | **0** | 0 |
| `0` | 0 | 0 | 0 |
| leer | 0 | 0 | 0 |
| `-35` | −35 | −35 | −35 |
| `- 5` | −5 | **0** | 0 |
| `35.9` | 3649 | **35** | 35 |
| `32767` | 32767 | 32767 | 32767 |
| `32768` | 32768 | 32768 | **−32768** |
| `40000` | 40000 | 40000 | **−25536** |
| `70000` | 70000 | 70000 | **4464** |
| `99999999999` | 1215752191 | 1215752191 | **−6145** |
| `3000000%` | 18000000 | 18000000 | **−22400** |

Was „neu" fett zeigt, sind die gewollten und die mitgenommenen Änderungen.
Was die rechte Spalte fett zeigt, ist **alt und neu gleich**, also keine Folge
von [E-116](../Intern/BEFUNDE.md#e-116), siehe [K4](#k4).

**Was eine 0 oder ein negativer Wert im Zeichenweg bewirkt.** Am Quelltext
belegt. `E112Zielrechteck` (`PgEmbeddedImage.cpp:371-415`) nimmt eine Angabe
nur, wenn sie `> 0` ist. 0 und negativ zählen beide als *keine Angabe*, und
das Bild kommt in Dateigröße bzw. im Seitenverhältnis der anderen Angabe.
Danach setzt `PgLoadUrlImage` `source_*` auf das Zielrechteck
(`:575-578`). Das neue `+35 → 0` ist also harmlos: statt 1135 Pixel Breite
gilt die Dateigröße. `35 %` wird jetzt als 35 Pixel gelesen statt als 350 %.
So lesen es nach meiner Kenntnis auch Browser, denn der HTML-Leser für
Längenangaben bricht an der ersten Nicht-Ziffer ab und nimmt `%` nur direkt
dahinter. Das ist **Vermutung** aus der Kenntnis der Norm, hier nicht
nachgeschlagen.

### 1c. `param += index` — braucht der Aufrufer den Zeiger noch?

**Nein, am Quelltext belegt.** `param` ist ein Wertparameter
(`static long decimal_value_percent (pg_char_ptr param, …)`). Verschoben wird
die lokale Kopie, `param_ptr->param` beim Aufrufer bleibt unberührt. Die
Vorzeichenprüfung am Ende (`if (*param == '-')`) liest den verschobenen Zeiger,
und genau das ist gewollt. `index` ist `short`, der Wert hat höchstens 1023
Zeichen, ein Überlauf von `index` ist ausgeschlossen.

### 1d. Schneidet `Extract.ps1` die echte Funktion?

**Ja, gemessen.** `generated/pghtmimp_e116.inc` ohne die drei Kopfzeilen,
gegen `PGHTMIMP.CPP:3999-4044` verglichen (CR entfernt, `diff`): **identisch.**
Das Muster `^static long decimal_value_percent\s*\([^;]*$` schließt den
Prototyp in Zeile 63 aus, weil der auf `;` endet. Die Region endet an der
ersten `}` in Spalte 1, und das ist das Ende der Funktion. `#line 3999` steht
darin, Fehlermeldungen zeigen also auf die echte Datei.

### 1e. Gegentest selbst gefahren

**Gemessen, Testsuite im eigenen Arbeitsbaum (MSBuild Debug Win32).**

| Stand | Ergebnis |
|---|---|
| mit Behebung | **280 Tests, 280 bestanden** |
| `PGHTMIMP.CPP` aus `afafdcfa` zurückgeholt | **278 von 280**, rot: `35px→3508`, `35.5→3645`, `120 px→120008`, `px→8`, `\t35→935`, ` -5→135` |
| wiederhergestellt (`git checkout HEAD --`), neu gebaut | **280 von 280** |

Danach `git status` leer. Die Datei hat dieselben Zeilenenden wie `HEAD`
(4131 reine LF, 0 CRLF, 0 Byte über 127, beide Male).

Die halbe Behebung (Abbruch ohne das Überspringen) habe ich nicht im
Arbeitsbaum gefahren, sondern im Messprogramm: `" 35"` ergibt dann 0. Fall
(3) von `TestE116.cpp` fängt das also. Die Angabe „279/280" in [E-116](../Intern/BEFUNDE.md#e-116) ist
damit am Inhalt bestätigt, an der Zahl nicht nachgezählt.

### 1f. Nebenbefund Höhe: `numeric_value(" 35")` ergibt 0

**Harmlos, am Quelltext belegt.** Die Höhe geht durch `numeric_value`
(`PGHTMIMP.CPP:2366`), das kein Leerzeichen überspringt. Mit Höhe 0:

* Mit einer Breite > 0 nimmt `E112Zielrechteck` den zweiten Zweig
  (`PgEmbeddedImage.cpp:387-394`): die Höhe folgt dem Seitenverhältnis der
  Datei, mindestens 1. **Kein Strich**, das Bild hat seine richtige Form.
* Ohne Breite: beide Angaben fehlen, also gilt die Dateigröße (`:408-414`).
* Nur wenn das Bild gar nicht lädt, bleibt `embed->height` 0 und das Bild
  unsichtbar. So war es vor [E-116](../Intern/BEFUNDE.md#e-116) auch, denn `numeric_value` ist unverändert.
* Nebenwirkung: `EMBED_PREPARE_IMAGE` lädt das Bild sofort, sobald eine der
  beiden Angaben 0 ist (`PgEmbeddedImage.cpp:265`). Das kostet Zeit, sonst
  nichts.

**Vorschlag:** `numeric_value` nicht anfassen. Es liest auch Schriftgrößen,
Tabellenmaße und `colspan` (`PGHTMIMP.CPP:1313-1910`, `:3024-3084`). Eine
Änderung dort hat einen anderen Umfang als [E-116](../Intern/BEFUNDE.md#e-116) und gehört in einen eigenen
Schritt.

## 2. E-130 — `BindExe.bat`

### 2a. Die Liste der eigenen Bauergebnisse

**Gemessen an den 19 Projekten in `Eudora.sln`** (`ConfigurationType`,
`OutDir`, `TargetName`, `OutputFile` aus jeder `.vcxproj`). Nach
`Bin\Release` bauen:

| Projekt | Ergebnis | in der neuen Liste |
|---|---|---|
| Eudora | `Eudora.exe` | ja |
| EudoraRes | `EudoraRes.dll` | ja |
| EuLang | `EuLang.dll` | ja |
| imap | `imap.dll` | ja |
| QCSocket | `QCSocket.dll` | ja |
| QCUtils | `QCUtils.dll` | ja |
| QCSSL | `QCSSL.dll` | ja |
| plstclnt | `plstclnt.dll` | ja |
| VC71Bruecke | `msvcr71.dll` | **nein** |
| NSImport, OEImport, OLImport | `*.eif` | **nein** |

Fremd ist keine der acht. Die vier fehlenden standen auch in der alten Liste
nicht, sie wurden nie gebunden. Siehe [K3](#k3).

### 2b. Gibt es einen zweiten Stempler?

**Nein, gemessen.** `PostBuildEvent` hat in der ganzen Mappe nur
`Eudora.vcxproj`, und nur in der Release-Konfiguration (`:161-164`). Debug hat
nur das `PreBuildEvent` mit der Bau-Kennung (`:63-71`). Die anderen
`PostProcessRel.bat` (`PaigeDLL/PAIGE32`, `PlaylistClient/plstclnt_dll`,
`Sandbox/…`) ruft kein Projekt auf. Sie würden ohnehin `tcsh` brauchen, und
das liegt nicht in `BinTools`. In `tools/` ruft kein Skript `bind`.

### 2c. Braucht etwas das Binden der fremden DLLs?

**Nein.** `bind` trägt nur vorausberechnete Einsprungadressen ein. Passt der
Zeitstempel der Ziel-DLL nicht mehr, löst der Lader wie bei einer ungebundenen
DLL auf. Das ist Windows-Verhalten aus der Dokumentation und hier nicht
gemessen. **Gemessen** ist dagegen: Die Grundlage
`Releases/Eudora72-1.0.2-lauffaehig.zip` enthält `DirServ`, `EuMemMgr`,
`libeay32`, `libexpat`, `SPELL32` und `ssleay32` **ungebunden**, byte-gleich
mit dem Erstcommit `567a5d87`. Damit laufen alle Pakete seit 1.0.2.

### 2d. Warum in `wt-bildbreite` auch `EuMemMgr.dll` und `Paige32.dll`?

**Gemessen mit `dumpbin /headers /imports`. Die Erklärung passt, ist aber
unvollständig erzählt.** Beide DLLs importieren `MSVCR71.dll`, und das ist ein
**eigenes** Bauergebnis (VC71Bruecke):

| Datei | gebunden an `MSVCR71.dll` |
|---|---|
| `Paige32.dll` und `EuMemMgr.dll` in `HEAD` | `6ACDFA25` = 13.10.2026 11:30:13 |
| dieselben in `wt-bildbreite` nach dem Bau | `6ADBC515` = 23.10.2026 22:35:33 |
| `msvcr71.dll` im Hauptbaum | Zeitstempel `6ACDFA25`, Datei 13.10.2026 11:30:13 |
| `msvcr71.dll` in `wt-bildbreite` | Zeitstempel `6ADBC515`, Datei 23.10.2026 22:35:33 |

Ein frischer Arbeitsbaum baut `msvcr71.dll` neu. Dadurch hatten `Paige32` und
`EuMemMgr` ein geändertes Ziel, und `bind` schrieb sie neu. Im Hauptbaum ist
`msvcr71.dll` seit dem 13.10. nicht neu gebaut, deshalb blieben sie dort
gleich. Dass `bind` eine DLL nur dann anfasst, wenn sich ein Ziel geändert hat,
und dass die fünf bei jedem Bau wechselten, weil sie `QCUtils.dll` importieren,
ist **Vermutung**. Alle fünf importieren `QCUtils.dll`, das ist gemessen. Dass
die fünf in `HEAD` **kein** Bound-Import-Verzeichnis haben, ist ebenfalls
gemessen, und das bleibt ein Rest, den die Vermutung nicht erklärt.

## 3. E-142 — die leere Kopie

### 3a. Nachgerechnet an Gregors Dateien

**Gemessen.** Gelesen habe ich `eudora.log` und `Out.mbx` in
`C:\Users\Gregor\Eudora72-1.0.116-release\Mailverzeichnis`, sonst nichts.

Lauf ab 23:20:21 (Protokollzeile 7963):

* 0.11 `OnMessageNewMessage`: neue Nachricht. 0.27
  `E-88 vor dem Absenden: … EditorBytes=26 … getippt=1`: **der Entwurf hatte
  26 Byte getippten Text.**
* 0.38–0.39 nach `Trash (<Dominant>)` (IMAP): `E-118 Hochladen: gespoolt=1`,
  `E-121 Hochgeladen: ergebnis=1 neue-uid=1`, `Ziel nach dem Hochladen: summen=1`.
* 1.03: `NewCompDocument` **ohne** `OnMessageNewMessage` davor, das ist
  `Sum->SendAgain`. Gleich danach `Dialog: "No messages were transferred!"`.
  **Keine** [`E-125`](../Intern/BEFUNDE.md#e-125)-Zeile, die Nachricht galt also als verfasst
  (`IsComp()`), und die Sperre griff zu Recht nicht.
* In `Out.mbx` die Nachricht `From ???@??? Fri Oct 23 23:21:24 2026`:
  `To:` leer, `Subject:` leer, `In-Reply-To:`/`References:` leer, neue
  `Message-Id`, `From:` aus der Persönlichkeit, und **kein Rumpf** (zwei
  Leerzeilen bis zur nächsten `From `-Zeile).
* Beim nächsten Start (Zeile 8486): `Trash (<Dominant>) .mbx size: MBX 406`.
  Im IMAP-Zwischenspeicher liegt also eine Nachricht. Ob es diese ist, kann ich
  nicht sehen, denn die Datei darf ich nicht lesen.

**Die Deutung in [E-142](../Intern/BEFUNDE.md#e-142) stimmt**: Es ist eine leere Kopie in `Out`, und dazu
kommt die falsche Meldung.

### 3b. Woher die leere Kopie kommt

**Die Meldung kommt von der leeren Liste, am Quelltext belegt.** Im Zweig
`ToOut` von `CTocDoc::Xfer` wird `sumlist.AddTail(Sum)` nicht erreicht
(`tocdoc.cpp:3001` steht im Zweig `!ToOut`). `SubtractSum` ist für IMAP
ausgenommen (`:3023-3027`). `ImapXferFromImapToLocal` findet deshalb eine
leere Liste und meldet `IDS_ERR_IMAP_NO_MSGS_XFERRED`
(`EuImap/src/ImapToc.cpp:855-858`). `CanCloseSummaryFrame` (`:836`) spielt
dabei keine Rolle, denn die Schleife darüber läuft gar nicht.

**Die Leere entsteht anderswo, und zwar IMAP-spezifisch. Gemessen, im selben
Lauf.** Derselbe Weg hat um 4.08 einen **lokalen** Entwurf nach `Out`
zurückgeholt (3.30 neue Nachricht, 3.55 gespeichert mit `EditorBytes=38`,
4.08 `NewCompDocument` ohne Dialog). Die Kopie von 23:24:29 in `Out.mbx` hat
`To: hans wurst <…>`, `Subject: test E-144 - ii` und den Rumpf
*„verschieben, nicht senden. die zweite."* (38 Zeichen). **Dieselbe Funktion
`CSummary::SendAgain`, Zweig `IsComp()` (ab `summary.cpp:1901`), kopiert
lokal alles und aus dem IMAP-Ordner nichts.** Die Leere liegt also nicht im
Kopieren der Kopfzeilen, sondern im **Lesen der Quelle.**
`CompDoc->GetHeaderLine(…)` und `CompDoc->GetText()` lieferten leer. Das
passiert genau dann, wenn `CMessageDoc::Read` (`msgdoc.cpp:394-406`) scheitert.
Für einen IMAP-Ordner geht das über `GetFullMessage` → `DownloadImapMessage`
(`msgdoc.cpp:224-230`, `summary.cpp:3566-3605`), und das liefert `E_FAIL`, wenn
`m_Offset < 0` oder `m_Length <= 0` ist oder das Nachladen vom Server
scheitert.

**Welcher dieser Fälle eintrat, ist nicht gemessen.** Die zwei, die ich für
möglich halte (beides **Vermutung**):

1. Gezogen wurde nicht die lokal angelegte Zusammenfassung (aus
   `RewriteMbxStub`, `ImapToc.cpp:1413-1445`, mit Offset und Länge), sondern
   die, die der Abgleich um 0.40 (`Resyncing`, uid=9) vom Server geholt hat.
   Die ist als nicht heruntergeladen markiert und wird stumm nicht
   nachgeladen.
2. Die lokale Zusammenfassung hat Offset und Länge aus der Vorab-Kopie
   (`tocdoc.cpp:2962-2985`), und die passen nicht zum Text, den
   `RewriteMbxStub` später angehängt hat.

**Ist das dieselbe Ursache wie das `<br>` aus [E-125](../Intern/BEFUNDE.md#e-125)? Nein, am Quelltext
belegt.** [E-125](../Intern/BEFUNDE.md#e-125) betraf eine **empfangene** Nachricht, also den anderen Zweig
von `SendAgain` (`summary.cpp:1920-2010`, `HeaderContents` über den Text). Der
Schaden dort war ein **Zuviel** (`<br>` in den Kopfzeilen), hier ist es ein
**Nichts**. Den Zweig für empfangene Nachrichten sperrt seit 7.2.0.122 die
Ablehnung. [E-142](../Intern/BEFUNDE.md#e-142) läuft durch den Zweig für verfasste Nachrichten, der erlaubt
bleibt.

Siehe [K7](#k7) für den Vorschlag.

## 4. E-144 — Antwortbezüge

### 4a. Nachgerechnet

**Gemessen, soweit die freigegebenen Dateien reichen.** Lauf ab 23:27:54
(Zeile 8438): 0.14 `NewCompDocument` ohne `OnMessageNewMessage`, das ist
*Antworten*. 0.29 gespeichert (`E-88 … Typ=2`), das ergibt 23:28:23. 0.52 zweites
`NewCompDocument` ohne Dialog, das ergibt 23:28:46. In `Out.mbx` liegt
`From ???@??? Fri Oct 23 23:28:46 2026`, `Subject: E-144 (iii) Re: Fwd: …`,
`In-Reply-To:` **leer**, `References:` **leer**, neue `Message-Id`. Der Rumpf
beginnt mit `At 11:37 23.10.2026, you wrote:`, es ist also eine Antwort.

**Nicht nachprüfbar für mich:** die Fassung von 23:28:23 *mit*
`In-Reply-To: <1xKBiJ-…>`. Sie steht nicht mehr in `Out.mbx`, sondern liegt im
lokalen `Trash.mbx`, und das ist nicht freigegeben. **Am Quelltext belegt**
ist, dass *Antworten* die beiden Zeilen immer setzt (`summary.cpp:1677-1678`)
und dass der Weg nach `Trash` sie byteweise mitnimmt (`tocdoc.cpp:2962-2965`,
`JJBlockMove`). Die Deutung in [E-144](../Intern/BEFUNDE.md#e-144) ist damit gedeckt.

### 4b. Die Behebung in zwei Zeilen

**Am Quelltext belegt, nicht übersetzt.** `CCompMessageDoc::Read` liest
`In-Reply-To` und `References` schon in `m_Headers` (`compmsgd.cpp:1456`, die
Spanne `IDS_HEADER_TO … IDS_HEADER_REFERENCES`). `SendAgain` gibt sie nur
nicht weiter, weil `NewCompDocument` (`compmsgd.cpp:2167-2180`) dafür keinen
Parameter hat. **Der Ort der Behebung ist deshalb `summary.cpp`, nicht
`compmsgd.cpp:2167`.** Eine neue Signatur von `NewCompDocument` träfe jeden
Aufrufer. In `summary.cpp`, im Block `if (NewDoc)` (`summary.cpp:1916`, nach `SetPriority` in Zeile 1918):

```cpp
NewDoc->SetHeaderLine(HEADER_IN_REPLY_TO, CompDoc->GetHeaderLine(HEADER_IN_REPLY_TO));
NewDoc->SetHeaderLine(HEADER_REFERENCES,  CompDoc->GetHeaderLine(HEADER_REFERENCES));
```

Dasselbe Muster benutzt *Antworten* (`summary.cpp:1677-1678`). `SetHeaderLine`
und `GetHeaderLine` stehen in `compmsgd.h:98-99`, `HEADER_IN_REPLY_TO = 6` und
`HEADER_REFERENCES = 7` in `headertype.h:23-24`.

**Was sich mitändert:** *Message → Send Again* auf eine **gesendete** Antwort
läuft durch denselben Zweig (`IsComp()` umfasst `MS_SENT`) und behält die
Bezüge künftig auch. Das halte ich für richtig, denn es ist dieselbe Antwort
noch einmal. Es ist aber eine Verhaltensänderung gegenüber QUALCOMM und gehört
in den Eintrag. Die Zeilen stehen unverändert seit `567a5d87`
(`summary.cpp:1795-1798` dort).

---

## Funde

### <a id="k1"></a>K1 — sieben weitere Fremd-DLLs liegen gebunden im Repo, `Paige32.dll` so in jedem Paket

**Sicherheit: gemessen.** Gehört zu [E-130](../Intern/BEFUNDE.md#e-130).

[E-130](../Intern/BEFUNDE.md#e-130) sagt: *„die fünf DLLs im Repo sind wieder byte-gleich mit dem Erstcommit
… Damit gibt es nur noch einen Bestand."* Für die fünf stimmt das. Die alte
Liste band aber dreizehn Fremd-DLLs. SHA-1 in `HEAD` gegen den Erstcommit
`567a5d87` gegen die Grundlage `Eudora72-1.0.2-lauffaehig.zip`:

| DLL | `HEAD` | Erstcommit | Grundlage | Abweichung HEAD↔Grundlage |
|---|---|---|---|---|
| `EuMemMgr.dll` | `f2d65ea4` | `7768af7e` | `7768af7e` | 626 Byte |
| `libeay32.dll` | `128b412c` | `fbf5865d` | `fbf5865d` | 557 Byte |
| `libexpat.dll` | `82f25d60` | `1bfbd10d` | `1bfbd10d` | 244 Byte |
| `SPELL32.DLL` | `ce37b5f5` | `ac77dd14` | `ac77dd14` | 486 Byte |
| `ssleay32.dll` | `f1c12030` | `7dce30d1` | `7dce30d1` | 839 Byte |
| `LDAP32.DLL` | `befea20a` | `2284f9f8` | nicht im Paket | — |
| `Paige32.dll` | `bd66a1b7` | `4adf499c` | (nur `Paige32d.dll`, andere Datei) | 666 Byte zum Erstcommit |
| `x1lib.dll` | `57b79276` | `57b79276` | `57b79276` | 0 |

`dumpbin` zeigt in `HEAD` bei allen sieben ein **Bound Import Directory**,
beim Erstcommit keins. Der PE-Zeitstempel ist unverändert (`Paige32`
`434FEE98` = 14.10.2005, `EuMemMgr` `435688CA` = 19.10.2005). Es sind also
QUALCOMMs Dateien, nur gebunden. Committet wurden sie mit „Bauausgaben …
nachgezogen" (`578db37b`, 05.09.2026; `Paige32` und `EuMemMgr` zuletzt
`b1ed24f7`, 13.10.2026).

**Die Folge für die Pakete:** `paket-bauen.ps1:501-502` nimmt `Paige32.dll`
aus `Eudora71\Bin\Release`, also aus dem Repo. **Gemessen am Paket 1.0.120:**
`Paige32.dll` **und** `Paige32d.dll` sind beide `bd66a1b7`, die gebundene
Fassung vom 13.10.2026. `EuMemMgr.dll` im Paket ist `7768af7e`, das
Original aus der Grundlage. Für `EuMemMgr` gibt es damit dieselben zwei
Bestände, die [E-130](../Intern/BEFUNDE.md#e-130) für die fünf beschreibt.

**Schwere:** funktional harmlos (siehe Abschnitt 2c). Das Gewicht liegt beim
Grund, aus dem [E-130](../Intern/BEFUNDE.md#e-130) überhaupt geführt wird: ausgeliefert werden soll, was im
Repo steht, und unerklärte Änderungen an Binärdateien sollen auffallen
([E-124](../Intern/BEFUNDE.md#e-124)). **Hält kein Release auf.**

**Vorschlag:** in einem eigenen Zweig (Name nach Gregors Ja) die sieben aus
`567a5d87` zurückholen. Danach `Paige32` im nächsten Paket gegen `4adf499c`
messen und in [E-130](../Intern/BEFUNDE.md#e-130) „fünf" durch „zwölf" ersetzen. Als Schranke
in `paket-pruefen.ps1`: keine Fremd-DLL im Paket mit Bound Import Directory.
Gegenprobe dazu: die heutige `Paige32.dll` muss dort rot werden.

### <a id="k2"></a>K2 — die Erklärung für `wt-bildbreite` steht nicht im Befund

**Sicherheit: gemessen** (Abschnitt 2d). Gehört zu [E-130](../Intern/BEFUNDE.md#e-130). Im Eintrag steht
nur, dass fünf DLLs bei jedem Bau wechseln. Dass zwei weitere wechseln,
sobald `msvcr71.dll` neu gebaut wird, also in jedem frischen Arbeitsbaum,
steht dort nicht. Mit der neuen Liste ist das erledigt. Der Satz gehört aber
in den Eintrag, sonst sucht der Nächste, der einen alten Arbeitsbaum baut,
von vorn. **Doku. Hält kein Release auf.**

### <a id="k3"></a>K3 — „die acht eigenen Bauergebnisse" sind acht von zwölf

**Sicherheit: gemessen** (Abschnitt 2a). Nicht gebunden werden auch
`msvcr71.dll` und die drei Importer-`.eif`. Das ist kein Mangel, denn `bind`
ist nur eine Beschleunigung, und die vier waren auch vorher nicht in der
Liste. **Vorschlag:** in `BindExe.bat` und [E-130](../Intern/BEFUNDE.md#e-130) *„die acht, die schon die
alte Liste band"*. Gering. **Hält kein Release auf.**

### <a id="k4"></a>K4 — sehr große Breiten laufen beim `(short)` über

**Sicherheit: gemessen** (Tabelle 1b). Gehört zu [E-116](../Intern/BEFUNDE.md#e-116). Unverändert seit dem
Original. `width="70000"` wird 4464 Pixel breit gezeichnet. `40000` und `99999`
werden negativ und zählen damit als keine Angabe. `long` läuft ab etwa
2,1 Milliarden über. Bei Prozent läuft `max_for_percent * value` schon ab
etwa 3,5 Millionen über. Die Breite kommt aus fremdem HTML, ein Absender kann
das also gezielt setzen. Das Ergebnis ist ein sehr breites Bild, nichts
Schlimmeres. Das Rechteck geht als `short` weiter. **Vorschlag:** in
`decimal_value_percent` die Schleife bei `value > 32767` beenden und 0 liefern
(gilt dann als keine Angabe), dazu zwei Fälle in `TestE116.cpp` (`"70000"`
→ 0, `"40000"` → 0). Gering. **Hält kein Release auf.**

### <a id="k5"></a>K5 — drei Änderungen, die kein Testfall festhält

**Sicherheit: gemessen.** Gehört zu [E-116](../Intern/BEFUNDE.md#e-116). `+35` (1135 → 0), `35 %` (2100 →
35) und `- 5` (−5 → 0) haben sich mitgeändert. Alle drei Änderungen sind
richtig oder harmlos (Abschnitt 1b). `TestE116.cpp` prüft keine davon. Wer
später das Vorzeichen oder den Leerraum anders behandelt, ändert sie lautlos
zurück. **Vorschlag:** die drei als Fälle aufnehmen, und in [E-116](../Intern/BEFUNDE.md#e-116) einen Satz
dazu, dass `35 %` jetzt Pixel heißt. Gering. **Hält kein Release auf.**

### <a id="k6"></a>K6 — Höhe 0 aus `" 35"`: kein Handlungsbedarf

**Sicherheit: am Quelltext belegt** (Abschnitt 1f). Es wird kein Strich
gezeichnet. Bei bekannter Breite folgt die Höhe dem Seitenverhältnis, sonst
gilt die Dateigröße. Kein Fund im engeren Sinn, nur die Antwort auf die Frage.

### <a id="k7"></a>K7 — E-142: die Leere hat eine eigene Ursache, und „Was noch fehlt" nennt sie nicht

**Sicherheit: gemessen** (dass die Leere IMAP-spezifisch ist), **Vermutung**
(welcher Lesefehler es ist). Gehört zu [E-142](../Intern/BEFUNDE.md#e-142).

Im Eintrag stehen drei Sätze, die nicht mehr zur gemessenen Lage passen:

* *„Kein Datenverlust: es entsteht eine Kopie zuviel"* und
  *„Stufe: … Duplikat"*: gemessen ist eine **leere** Kopie, kein Duplikat.
* *„Was noch fehlt: … die Fehlmeldung … fällt mit [E-141](../Intern/BEFUNDE.md#e-141) weg"* und die
  Entscheidung zum Verbleib im IMAP-Ordner: Die **Leere** selbst kommt darin
  nicht vor. Mit der Berichtigung aus [E-141](../Intern/BEFUNDE.md#e-141) verschwindet nur die Meldung. Die
  leere Nachricht in `Out` bliebe.

Datenverlust gibt es weiterhin nicht, sofern das Original im IMAP-Ordner bleibt.
Das sagt [E-142](../Intern/BEFUNDE.md#e-142), und gesehen habe ich es nicht. Wer aber die leere Kopie in
`Out` für seinen Entwurf hält und den „alten" im Papierkorb löscht, verliert
26 Byte Text. **Vorschlag:** In [E-142](../Intern/BEFUNDE.md#e-142) die drei Sätze berichtigen. Vor jeder
Behebung eine Spurmarke in `CSummary::SendAgain`, Zweig `IsComp()`, **in einer
Zeile**: `imap=%d nicht-geladen=%d offset=%ld laenge=%ld text=%d kopf-to=%d`.
Dann ist beim nächsten Lauf entschieden, welcher der beiden Fälle aus
Abschnitt 3b eintritt. **Wichtig (Funktion). Hält kein Release auf**, denn es
ist keine Verschlechterung. Vor 1.0.122 lief derselbe Weg, nur mit einem
Ja/Nein-Dialog davor.

### <a id="k8"></a>K8 — E-144: der Ort der Behebung ist `summary.cpp`, nicht `compmsgd.cpp:2167`

**Sicherheit: am Quelltext belegt** (Abschnitt 4b). Gehört zu
[E-144](../Intern/BEFUNDE.md#e-144). *„die beiden Kopfzeilen beim Neuanlegen
übernehmen (`compmsgd.cpp:2167`)"* zeigt auf `NewCompDocument`, und dort
fehlt nur der Parameter. Die Behebung sind zwei Zeilen im Aufrufer
`summary.cpp:1916`. **Vorschlag für den Regressionstest:** am Quelltext
(`QT_…` wie in `TestE125.cpp`) prüfen, dass der Zweig `IsComp()` von
`SendAgain` beide Kopfzeilen setzt. Die Gegenprobe ist dieselbe Datei ohne die
zwei Zeilen, und die muss rot werden. Am Prüfstand geht es ohne IMAP: eine
Nachricht aus `In` beantworten, speichern, `Out → Trash → Out` (wie
`messen-e125.ps1`), danach `In-Reply-To:` in `Out.mbx` gegen die `Message-Id`
der beantworteten Nachricht vergleichen. **Wichtig (Funktion). Hält kein
Release auf**, denn das Verhalten ist so seit dem ersten Stand.

---

## Gegenvermutungen, die ich aufgestellt habe

| Gegenvermutung | Ergebnis |
|---|---|
| Der Testfall `"\t35"` ist ausgedacht, ein Tab kommt nie an | **widerlegt**: in Anführungszeichen geht er unverändert durch (`PGHTMIMP.CPP:955`) |
| `param_ptr->param` kann NULL oder offen sein | **widerlegt**: festes Feld, mit Nullen gefüllt (`PGTXR.H:317`, `AppendMemory(…, TRUE)`) |
| `param += index` verschiebt den Zeiger des Aufrufers | **widerlegt**: Wertparameter |
| `Extract.ps1` schneidet den Prototyp oder eine Kopie | **widerlegt**: `diff` gegen `PGHTMIMP.CPP:3999-4044` identisch |
| Der Test ist grün, egal was in der Funktion steht | **widerlegt**: Original 278/280, halbe Behebung im Messprogramm rot |
| `+35 → 0` zeichnet ein Bild der Breite 0 | **widerlegt**: 0 zählt als keine Angabe (`PgEmbeddedImage.cpp:371-415`) |
| Höhe 0 zeichnet einen Strich | **widerlegt**: Seitenverhältnis oder Dateigröße (Abschnitt 1f) |
| Der Überlauf beim `(short)` ist neu durch [E-116](../Intern/BEFUNDE.md#e-116) | **widerlegt**: alt und neu gleich (Tabelle 1b) |
| Es gibt einen zweiten Stempler (Debug-PostBuild, anderes Projekt) | **widerlegt**: nur `Eudora.vcxproj`, nur Release |
| Eine der acht gebundenen Dateien ist fremd | **widerlegt**: alle acht baut die Mappe |
| Nach der Behebung liegen nur Originale im Repo | **widerlegt**: sieben gebundene ([K1](#k1)) |
| Ins Paket geht nur, was aus der Grundlage kommt | **widerlegt** für `Paige32.dll` (Paket 1.0.120) |
| `Paige32`/`EuMemMgr` in `wt-bildbreite` sind ein dritter Stempler | **widerlegt**: gebunden an die dort neu gebaute `msvcr71.dll` |
| Der Entwurf von [E-142](../Intern/BEFUNDE.md#e-142) war schon leer | **widerlegt**: `EditorBytes=26 getippt=1` beim Speichern |
| Die Leere entsteht in `SendAgain` beim Übernehmen der Kopfzeilen | **widerlegt**: derselbe Zweig kopiert den lokalen Entwurf vollständig, im selben Lauf |
| [E-142](../Intern/BEFUNDE.md#e-142) hat dieselbe Ursache wie das `<br>` aus [E-125](../Intern/BEFUNDE.md#e-125) | **widerlegt**: anderer Zweig von `SendAgain`, anderes Schadensbild |
| Die Antwortbezüge gehen schon beim Weg nach `Trash` verloren | **widerlegt am Quelltext**: `JJBlockMove` kopiert byteweise |
| Die Behebung von [E-144](../Intern/BEFUNDE.md#e-144) gehört in `NewCompDocument` | **widerlegt**: dort fehlt nur der Parameter, der Aufrufer reicht |

## Was gelaufen ist

* `Eudora71/Tests/Tests.vcxproj`, MSBuild Debug Win32, im Arbeitsbaum
  `Eudora7.2-wt-pruefer`: **280 Tests, 280 bestanden.** Gegen den alten
  `PGHTMIMP.CPP` 278 von 280, danach wiederhergestellt und erneut 280 von
  280. `git status` danach leer.
* Messprogramme im Scratch-Verzeichnis (`cl`, `dumpbin`), nichts im Repo.
* Gelesen, nichts verändert: Gregors `eudora.log` und `Out.mbx` (Freigabe vom
  23.10.2026). Dazu `Bin\Release` im Hauptbaum und in `wt-bildbreite`
  (`dumpbin`, Datei-Zeitstempel, `git status`), das Grundlagen-ZIP und das
  Paket `Releases/Eudora72-1.0.120-release.zip` (ausgepackt in das
  Scratch-Verzeichnis).
* Kein Eudora gestartet, kein Fenster, Eudora nicht gebaut.

## Übersicht

| Fund | Was passiert | Schwere | Hält ein Release auf? |
|---|---|---|---|
| [K1](#k1) | sieben Fremd-DLLs liegen gebunden im Repo, `Paige32.dll` geht gebunden in jedes Paket | wichtig (Bestand, nicht Funktion) | nein |
| [K7](#k7) | [E-142](../Intern/BEFUNDE.md#e-142): Leere hat eigene Ursache beim Lesen der IMAP-Quelle; „Was noch fehlt" nennt sie nicht | wichtig (Funktion) | nein, keine Verschlechterung |
| [K8](#k8) | [E-144](../Intern/BEFUNDE.md#e-144): Behebung in zwei Zeilen in `summary.cpp:1916`, nicht in `compmsgd.cpp:2167` | wichtig (Funktion) | nein, Stand seit Erstcommit |
| [K4](#k4) | Breiten ab 32768 laufen beim `(short)` über (4464 Pixel aus `70000`) | gering, Originalverhalten | nein |
| [K5](#k5) | `+35`, `35 %`, `- 5` geändert, aber in keinem Testfall | gering | nein |
| [K2](#k2) | Erklärung für `Paige32`/`EuMemMgr` in frischen Arbeitsbäumen fehlt in [E-130](../Intern/BEFUNDE.md#e-130) | Doku | nein |
| [K3](#k3) | „acht eigene" sind acht von zwölf | Doku | nein |
| [K6](#k6) | Höhe 0 aus `" 35"` zeichnet keinen Strich | keine | nein |

**Keine neue E-Kennung vergeben**, E-145 und E-146 bleiben frei. Alle Funde
gehören zu [E-116](../Intern/BEFUNDE.md#e-116), [E-130](../Intern/BEFUNDE.md#e-130), [E-142](../Intern/BEFUNDE.md#e-142) oder [E-144](../Intern/BEFUNDE.md#e-144). Eingetragen in `Intern/BEFUNDE.md`
ist nichts, das gehört nicht zu meinem Auftrag.
