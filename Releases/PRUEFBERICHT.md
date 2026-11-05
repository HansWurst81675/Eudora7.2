# Pruefbericht Eudora 7.2

| | |
|---|---|
| **Quellstand** | `7.2.2.136` (Paketnummer `7.2.2.136`) |
| **Commit** | `3b8c17b7` — **Arbeitsbaum nicht sauber** (11 Dateien) |
| **Erstellt** | 2026-11-05 22:05 |
| **Gesamturteil** | **NICHT VOLLSTAENDIG** |

**Dauer** — wer die Tests selbst faehrt, braucht etwa:

| Teil | Dauer | gemessen |
|---|---|---|
| Unit-Tests bauen und fahren | 0 min 00 s | dieser Lauf |
| Schranken mit Rueckfallprobe | 0 min 09 s | dieser Lauf |
| Pruefstand, 103 Faelle, 64 Eudora-Starts | 80 min 52 s | voller Lauf, Ende 2026-11-05 17:52:25 |
| **zusammen** | **81 min 01 s** | |

| Art | Tests | gruen | rot | sonst |
|---|---|---|---|---|
| Unit-Tests (`EudoraTests.exe`) | 0 | 0 | 0 | **nicht gelaufen** |
| Schranken mit Rueckfallprobe | 19 | 19 | 0 | |
| Pruefstand (Oberflaeche) | 109 | 0 | 0 | 103 an anderem Bau, 6 nie gelaufen |

Erzeugt von `tools/pruefbericht.pl`. Jeder Test steht unten einzeln, mit
Zeitpunkt und Bau. Maschinenlesbar steht dasselbe in
[`pruefbericht-tests.tsv`](pruefbericht-tests.tsv) — das ist der Stand *vorher*
fuer den Vergleich.

## Nach einer eigenen Aenderung: vorher und nachher vergleichen

```
perl tools/pruefbericht.pl --vergleich
```

baut und faehrt die Unit-Tests und die Schranken, liest die Pruefstandsfaelle
aus `Intern/pruefstand-buch.tsv` und vergleicht alles mit diesem eingecheckten
Stand: **neu rot**, neu gruen, neu hinzugekommen, weggefallen. Rueckgabe 1,
sobald etwas neu rot ist. Geschrieben wird dabei nichts.

Die Pruefstandsfaelle oeffnen Eudora-Fenster und laufen deshalb nur auf
Anforderung, je Fall an einem eigenen Verzeichnis unter `C:\Temp`:

```
powershell -ExecutionPolicy Bypass -File tools\pruefstand-lauf.ps1 -Freigabe "<wer, wann>"
```

Danach `perl tools/pruefbericht.pl` schreibt Bericht und Testbuch neu.

## 1. Unit-Tests

**Nicht gelaufen** — `EudoraTests.exe` fehlt oder lieferte keine Ergebniszeile.

## 2. Schranken mit Rueckfallprobe

Eine Schranke im `pre-commit` zaehlt nur als Regressionstest, wenn sie ihren
Rueckfall abweist: die Behebung wird voruebergehend zurueckgenommen, die
Schranke muss rot werden, danach wird die Datei byte-genau wiederhergestellt
(`tools/schranken-gegenprobe.pl`, Liste in `tools/regression-schranken.txt`).
Gelaufen am **2026-11-05 22:05** gegen Commit `3b8c17b7*`.

| Befund | Schranke | Ergebnis | gemessen |
|---|---|---|---|
| E-42 | `pruefe-beenden.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-41 | `pruefe-beenden.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-40 | `pruefe-beenden.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-45 | `pruefe-beenden.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-62 | `pruefe-nachrichtenschleife.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-62#2 | `pruefe-nachrichtenschleife.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-61 | `pruefe-nachrichtenschleife.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-34 | `pruefe-fensterbau.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-35 | `pruefe-fensterbau.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-35#2 | `pruefe-fensterbau.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-35#3 | `pruefe-fensterbau.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-35#4 | `pruefe-fensterbau.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-16 | `pruefe-fensterbau.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-36 | `pruefe-fensterbau.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-68 | `pruefe-filter-aktionsgrenze.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-73 | `pruefe-filter-serverloeschung.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-74 | `pruefe-filter-serverloeschung.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-43 | `pruefe-waechter.pl` | ok | vorher=0 rueckfall=1 danach=0 |
| E-51 | `pruefe-nachrichtenschleife.pl` | ok | vorher=0 rueckfall=1 danach=0 |

## 3. Regressionstests ueber die Oberflaeche (Pruefstand)

Je Fall der **letzte** Lauf. *Bau* ist die Kennung aus der `Eudora.exe` des
Pruefstands (Fassung, Paket, Commit; ein `*` heisst: mit uncommitteten
Aenderungen gebaut). Ein Fall, der an einer anderen Fassung als `7.2.2.136`
lief, zaehlt fuer diesen Stand nicht als gruen.

| Fall | Ergebnis | gelaufen am | Pruefstand | Bau | erwartet |
|---|---|---|---|---|---|
| E-131a | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E131L` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `ohne MRUFloatXPos=-2147483648` |
| E-131b | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E131L` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `ohne MRUFloatYPos=-2147483648` |
| E-131c | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E131L` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E-131 Leistenposition:` |
| E-121 | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E118` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `ablage-dateien=1` |
| E-118 | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E118` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E-118 Bild:` |
| E-125a | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E125` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E125 ERGEBNIS out=1 trash=0 (vorher 1) dialoge-gegenprobe=0` |
| E-125b | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E125` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E125 UMKEHR in=1 (vorher 1) out=1 (vorher 1) dialoge=1` |
| E-125c | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E125` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E-125 Xfer nach Out abgelehnt: quelle=In ziel=Out` |
| E-103p | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\EBILD` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E-112 Metadatei: angegeben=0x0 Datei=79x64 gemalt=79x64` |
| E-112p | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\EBILD` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E-112 Metadatei: angegeben=35x35 Datei=330x327 gemalt=35x35` |
| E-112f2 | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\EBILD` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E-112 Metadatei: angegeben=150x0 Datei=985x378 gemalt=150x58` |
| E-112n1 | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\EBILD` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E-112 Metadatei: angegeben=600x0 Datei=985x378 gemalt=600x230` |
| E-112h | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\EBILD` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E-112 Metadatei: angegeben=0x600 Datei=330x327 gemalt=606x600` |
| E-106p | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\EBILD` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E-106 groesser als angegeben: attr=35x35 quelle=330x327` |
| E-110p | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\EBILD` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E-110 Laden: src=cid:punkt-rot@e118.invalid faden=1 ok=1` |
| E-105p | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\EBILD` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E-105 versteckter Bereich <p> ohne eigenes Ende-Tag beendet` |
| E-108p | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\EBILD` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `Logging shutdown` |
| BILD-lauf | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\EBILD` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `BILD ERGEBNIS abgeholt=8 geoeffnet=8 weitergeleitet=8` |
| E-113p | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\EBILD` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `Datei=985x378 gemalt=718x276` |
| E-113b | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\EBILD` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `BILD E113B` |
| E-113b2 | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\EBILD` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `neu=0 lebt=1 probe=ok` |
| E-119d | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E119K` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `vollstaendig=1 probe=ok` |
| E-119a | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\EBILD` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `data-db1b9f48.png faden=1 ok=1` |
| E-119b | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\EBILD` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E-119 data-Bild als Datei:` |
| E-119c | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\EBILD` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `data-2eaa4a58.png laenge=1574` |
| E-119e | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\EBILD` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `laenge=78519` |
| E-77a | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E77` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E77 ERGEBNIS roh=0 dekodiert=2` |
| E-77b | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E77` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E-77 Ordnername: server="Entw&APw-rfe"` |
| E-77c | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E77` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E-77 Ordnername: server="Gel&APY-scht"` |
| E-77d | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E77U` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E77U ERGEBNIS rename=ok liste=Ablage-&AOQ- unbekannt=0` |
| E-146 | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E146` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E146 ERGEBNIS rename=abgelehnt baum-neu=weg baum-alt=da liste=(kein Eintrag)` |
| E-184 | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E184` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E184 ERGEBNIS fremd=1 kopie=1 eintraege=2` |
| E-189 | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E184` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E189 ERGEBNIS fremd=1 kopie-neu=1 kopie-mit-alter-uid=0 eintraege=2` |
| E-184m | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E184` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E184M ERGEBNIS richtig=3 falsch=0 eintraege=3 anfrage=3,2,1 copyuid=1:3/1:3` |
| E-188k | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E188` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E188 ERGEBNIS weg=konten anzeige=richtig` |
| E-188a | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E188` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E188 ERGEBNIS weg=append` |
| E-188u | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E188` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E188 ERGEBNIS weg=ohneuid anzeige=richtig` |
| E-188t | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E188` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E188 ERGEBNIS weg=kontentext anzeige=richtig` |
| E-188l | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E188` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E188 ERGEBNIS weg=lokal anzeige=richtig` |
| E-188f | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E188` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E188 ERGEBNIS weg=fetch` |
| E-188tm | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E188` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E188 ERGEBNIS weg=kontenmehr` |
| E-188fm | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E188` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E188 ERGEBNIS weg=fetchmehr` |
| E-188e | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E188` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E188 ERGEBNIS weg=lokaleins anzeige=richtig` |
| E-188d | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E188` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E188 LOESCHEN GEMESSEN fremd-lebt=1` |
| E-193p | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E193` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E193 ERGEBNIS index-falsch=0/11 ohne-falsch=0/11 fenster-falsch=0/24 x1=1 mails=9 lebt=1` |
| E-193w | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E193` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E193 WEICHE gleich=11/11 index-zu-viel=0` |
| E-193fs | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E193f` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E193F ERGEBNIS suchweg-ohne f1=1 f2=1 f3=1 f4=1 f5=1 f6=1 f7=1 f8=1 f9=1 f10=1 f11=1 f12=1 f14=1` |
| E-193f | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E193f` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E193F ERGEBNIS direkt f1=1 f2=1 f3=1 f4=1 f5=1 f6=1 f7=1 f8=1 f9=1 f10=1 f11=1 f12=1 f13=1 f14=1` |
| E-193fd | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E193f` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E193F ERGEBNIS dialog f1=1 f2=1 f3=1 f4=1 f5=1 f6=1 f7=1 f8=1 f9=1 f10=1 f11=1 f12=1 f13=1 f14=1` |
| E-169p | **NIE GELAUFEN** |  | `` |  | `E169 ERGEBNIS p1 lesen=ABCDEFGh vorschau=ABcdefgh` |
| E-169r | **NIE GELAUFEN** |  | `` |  | `E169 REGISTRY unveraendert=1` |
| E-169b | **NIE GELAUFEN** |  | `` |  | `E169 ERGEBNIS p1 lesen=ABCDEFGh vorschau=ABCDEFGh` |
| E-169h | **NIE GELAUFEN** |  | `` |  | `E169 ERGEBNIS p3 lesen=abcdefgH vorschau=abcdefgH` |
| E-169s | **NIE GELAUFEN** |  | `` |  | `E169 REGISTRY unveraendert=1` |
| E-192 | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E192` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E192 ERGEBNIS richtig=3 falsch=0 eintraege=3 anfrage=3,2,1 copyuid=1:3/1:3` |
| E-97 | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E97` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E97 ERGEBNIS dialog=1 lebt=1 datei=1` |
| E-100 | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E97` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E100 ERGEBNIS dialog=1 lebt=1 ini=ok` |
| E-67 | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E67` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `verb-gespeichert=14 verb-auswahl=0` |
| ZIEL24 | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\EBILD` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `Logging shutdown` |
| ZIEL24b | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\EBILD` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `Logging shutdown` |
| E-137a | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E137` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E137 ERGEBNIS titel: mail-offen=1 leiste-versteckt=1` |
| E-137b | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E137` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E137 ERGEBNIS rand: mail-offen=1 leiste-versteckt=1` |
| E-137c | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E137` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E-137 Strg-W angekommen: leiste-mit-fokus=nein zuletzt-angeklickte-leiste=ja` |
| E-166a | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E166` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `reihenfolge=junk-no,konto-ok` |
| E-166b | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E166` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `AskedAboutJunk=6` |
| E-13p | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E13` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E13 FORTSCHRITT sichtbar=1` |
| E-144p | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E144` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E144 ERGEBNIS probe=ok gleich=1 references=1` |
| E-140p | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E140` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E140 ERGEBNIS liste=1 lesen=1 verfassen=1 lebt=1 zeichensatz=3` |
| E-139p | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E139` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E139 ERGEBNIS lauf=1 erschienen=1 kaestchen=1 angekreuzt=1 lebt=1` |
| E-171p | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E171` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E171 ERGEBNIS fehlermeldung=0 suchfenster=1 lebt=1` |
| E-177p | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E177` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E177 ERGEBNIS dateien=3 pop=passt e118=passt roh=falsch falsche-angabe=0 fehlende-angabe=0 lebt=1` |
| E-122p | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E122` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E122 ERGEBNIS nachrichten=2 passt=2 verschoben=0 lebt=1` |
| E-143s | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E143S` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E143S ERGEBNIS treffer=3 hinweise=1 abgelehnt-log=3 e125-zeilen=0 out-neu=0 lebt=1` |
| E-178p | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E178` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E178 ERGEBNIS fett=passt kursiv=passt tt=passt link=passt gespeichert=passt antwort=passt lebt=1` |
| E-194p | **ok, ANDERER BAU** | 2026-11-05 17:54:11 | `C:\Temp\E194` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E194 ERGEBNIS kopf=0 mbx=1 dateien=4 filter=4 liste-xflowed=0 liste-flowed=1 liste-umbruch=weich liste-euro=cp1252 liste-umlaute=10 lesen-xflowed=0 htm-meta=2 rtf=0 lebt=1` |
| E-205p | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E205` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E205 ERGEBNIS neu1=0h neu2=0h q1=0h q2=0h liste1=0h liste2=0h zone=passt lebt=1` |
| E-194k | **ok, ANDERER BAU** | 2026-11-05 17:54:11 | `C:\Temp\E194K` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E194 ERGEBNIS kopf=1 mbx=1 dateien=4 filter=4 liste-xflowed=0 liste-flowed=1 liste-umbruch=weich liste-euro=cp1252 liste-umlaute=10 lesen-xflowed=0 htm-meta=2 rtf=0 lebt=1` |
| E-207p | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E207` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E207 ERGEBNIS fenster=1 geaendert=1 txt=passt htm=passt frage=0 sig=unveraendert lebt=1` |
| E-203p | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E203` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E39 ERGEBNIS abschnitt-wieder=0 schluessel=- war-aktuell=0 aktuell-danach=<Dominant> lebt=1` |
| E-203v | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E203` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E39 Vorlauf: kennwort-meldung,vergessen` |
| E-203w | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E203` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E39 PROBE ok` |
| E-204p | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E204` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E204 ERGEBNIS rueckfrage=1 user=e204neu pass=neu lebt=1` |
| E-204w | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E204` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E204 PROBE ok` |
| E-223p | **ok, ANDERER BAU** | 2026-11-05 17:52:50 | `C:\Temp\E223` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E223 ERGEBNIS savepassword=1 ini-kennwort=1 beendet=1` |
| E-223w | **ok, ANDERER BAU** | 2026-11-05 17:52:50 | `C:\Temp\E223` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E223 PROBE ok` |
| E-239p | **NIE GELAUFEN** |  | `` |  | `absturz=0 beendet=1` |
| E-222p | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E222` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E222 ERGEBNIS kennung=` |
| E-222w | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E222` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E222 PROBE ok` |
| A-5p | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\EHILFE` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `HILFE ERGEBNIS menue=1 kuerzel=ausgelassen einstellungen=ausgelassen fehlt-meldung=1 lebt=1` |
| A-5p-log | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\EHILFE` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `Hilfe: Tastenkuerzel.html fehlt` |
| E-216p | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\EABOUT` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `ABOUT ERGEBNIS knoepfe=5 ueberlappt=0 github=1 herkunft-zeilen=2 log-zeilen=2 passt=1 rand=0 lebt=1` |
| E-216l | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\EABOUT-langer-pfad-fuer-die-log-zeile` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `ABOUT ERGEBNIS knoepfe=5 ueberlappt=0 github=1 herkunft-zeilen=2 log-zeilen=2 passt=1 rand=0 lebt=1` |
| E-133p | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E133` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E133 ERGEBNIS meldung=rueckfrage gestartet=1 registry-danach=C:\Temp\E133\Eudora.exe C:\Temp\E133\MAILVE~1` |
| E-133q | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E133` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E-133 Registry berichtigt: Mailverzeichnis="C:\Temp\E133\Mailverzeichnis\"` |
| E-170p | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E170` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `kopie-mit-label=1 log-grund=ok lebt=1` |
| E-170o | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E170` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E170 ERGEBNIS copyuid=nein label-quelle=1 uid-alt=3 uid-kopiert=3 quelle-passt=1 uid-ziel=1 kopie-mit-label=1 log-grund=zugeordnet lebt=1` |
| E-170m | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E170` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E170M ERGEBNIS labels-quelle=3 richtig=3 falsch=0 ohne=0 eintraege=3 log-grund=zugeordnet lebt=1` |
| E-170f | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E170` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E170F ERGEBNIS art=anders fremde-gelegt=1 kopie-betreff-passt=1 fremd-label=0 kopie-label=6 eintraege=2 log-grund=zugeordnet lebt=1` |
| E-170g | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E170` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E170F ERGEBNIS art=gleich fremde-gelegt=1 kopie-betreff-passt=1 fremd-label=0 kopie-label=0 eintraege=2 log-grund=mehrdeutig lebt=1` |
| E-170c | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E170` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E170C ERGEBNIS abgelehnt=1 fremde-gelegt=1 fremd-label=0 eintraege=1 vorgemerkt=0 log-grund=fehlgeschlagen lebt=1` |
| E-170s | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E170` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E170S ERGEBNIS vorhanden=1 kopie=1 vorhanden-label=0 kopie-label=0 schon-da=1 vorgemerkt=0 log-grund=keine-neuen-uids lebt=1` |
| E-141p | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\EM141` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E141 ERGEBNIS hochgeladen=1 rueckfrage=1 nicht-uebertragen=0 expunge=0 lokal=1` |
| E-141g | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\EM141` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `geloescht=1 lebt=1` |
| E-179p | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\EM179` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E179 ERGEBNIS gesendet=1 form=plain emoji=entitaet kyr=entitaet hex=entitaet euro=zeichen umlaut=zeichen lebt=1` |
| E-128p | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E128` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E128 ERGEBNIS kopf=0 mail=html mbx=1 liste=eml lesen=htm verfassen=htm spur=6 rtf=0 lebt=1` |
| E-128k | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E128K` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E128 ERGEBNIS kopf=1 mail=html mbx=1 liste=eml lesen=htm verfassen=htm spur=6 rtf=0 lebt=1` |
| E-128t | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E128T` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E128 ERGEBNIS kopf=0 mail=text mbx=1 liste=txt lesen=txt verfassen=htm spur=6 rtf=0 lebt=1` |
| E-220p | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E220` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E220 ERGEBNIS mbx=1 probe=1 liste-pfad=0 liste-umlaute=1 liste-doppelleer=0 liste-ende=1 liste-gespeichert=1 liste-voll=1 liste-punkte=1 liste-endung=eml lesen-pfad=0 lesen-umlaute=1 lesen-doppelleer=0 lesen-ende=1 lesen-gespeichert=1 lesen-voll=1 lesen-punkte=1 lesen-endung=htm liste2-pfad=0 liste2-umlaute=1 liste2-doppelleer=0 liste2-ende=1 liste2-gespeichert=1 liste2-voll=1 liste2-punkte=1 liste2-endung=eml lebt=1` |
| E-221p | **ok, ANDERER BAU** | 2026-11-05 17:52:24 | `C:\Temp\E221` | Eudora 7.2.2.135+1cf4a59f 2026-11-05 16:30 | `E221 ERGEBNIS gesendet=1 faltung=wort kurz=heil gefaltet=heil gesendet-betreff=heil lebt=1` |

## 4. Deckung der kritischen Befunde

Von **70** kritischen Befunden haben **68** einen Test, **0** keinen (gezaehlt von `tools/pruefe-regressionstest.pl`). Ohne Test: -.

Solange diese Zahl nicht null ist, sagt ein gruener Bericht nicht, dass
nichts kaputt ist — er sagt, dass nichts von dem kaputt ist, was geprueft
wird.

## 5. Was dieser Bericht nicht abdeckt

* Die manuellen Faelle in [TESTPLAN.md](../Intern/TESTPLAN.md), Teil M.
* Gregors eigene Ergebnisse am Paket: die Ergebnistabelle im Kopf von
  [TESTPLAN.md](../Intern/TESTPLAN.md) (je Kriterium und Pruefschritt, mit Paketnummer),
  aeltere in der Buchfuehrung darunter.
* Alles, was keinen Test hat (Abschnitt 4).
* Ein Release gilt erst nach **Gregors eigenem Lauf** und seiner Zustimmung
  (CLAUDE.md, Abschnitt 4) — dieser Bericht ersetzt das nicht.
