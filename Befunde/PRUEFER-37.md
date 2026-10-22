# PRÜFER-37 — E-101, dritter Teil (`cc64c6db`, PR #103)

Gegenstand: `git show cc64c6db` — `Eudora71/Eudora/msgutils.cpp` (+225) und
`Eudora71/Tests/TestE101.cpp` (+120). Quellstand 7.2.0.107, Zweig `main`.

**Wie geprüft.** Am Quelltext gelesen; dazu drei eigene Messungen, keine davon
mit Oberfläche:

1. **Prüfstand am echten Code.** `Eudora71/Tests/generated/msgutils_e101.inc`
   (von `Extract.ps1` aus `msgutils.cpp` geschnitten) in ein eigenes
   Konsolenprogramm eingebunden und gegen **23 Eingaben** gefahren, die der neue
   Code nicht erwartet — jedes Mal **byteweise** gegen die Eingabe gehalten.
   Dasselbe mit der Fassung aus `cc64c6db^` (alter Stand), also ein echtes
   Vorher/Nachher je Fall.
   Quellen im Kratzverzeichnis: `e101probe.cpp`, `bauen.bat`.
2. **Postfächer gemessen**, nur gelesen: alle 175 `*.mbx` unter `C:\Temp`,
   **374 Nachrichten**.
3. **`Eudora71\Tests\RunTests.cmd`**: 213 Tests, 213 bestanden, 0 fehlgeschlagen.

## Urteil

**Paket 1.0.107 zu Gregor: ja — aber nur mit F2 im Begleittext, und F1 und F3
gehören vorher hinein.** Es sind zwei Bedingungen in einer Zeile und eine
Bedingung in einer zweiten.

**Punkt 3 zuerst, weil er über „zerstört fremde Nachrichten" entscheidet:**

> **Der Code prüft die Grenze nicht.** Liegt eine Nachricht mit **echtem**
> mehrteiligem Rumpf vor, wird ihre `Content-Type`-Zeile trotzdem ersetzt, und
> die gespeicherte Datei ist für jeden Leser kaputt. **Kein Byte geht verloren**
> — der Anhang ist aber aus der Datei nicht mehr herauszuholen.
> **Gemessen** (Fall 1 unten). **Ausgelöst** habe ich es in den 374 echten
> Nachrichten **kein einziges Mal**: 222 davon tragen `multipart` mit Grenze,
> **in keiner** steht die Grenze im Rumpf. Die Annahme des Commits stimmt also
> für den Alltag — nur ist sie nirgends abgesichert, und zwei Wege im
> Quelltext legen einen rohen MIME-Rumpf ab (`mime.cpp:117`).

| Fund | Schwere | Stand |
|---|---|---|
| **F1** `multipart` wird ersetzt, ohne zu prüfen, ob die Grenze im Rumpf steht | **mittel, selten.** Datei semantisch zerstört, kein Byteverlust | Mechanik **gemessen**, Auslösung in 374 Nachrichten **nicht gefunden** |
| **F2** Der ganze neue Block 4a ist auf dem **einzigen** Aufrufweg **tot** — `StripTabooHeaders` entfernt `Content-` vorher | **hoch (Wirkung), kein Schaden.** 225 Zeilen ohne Wirkung; die Commit-Begründung trifft nicht zu | **gemessen**, und seit PRÜFER-13 [P-23](PRUEFER-13.md#p-23) / PRÜFER-14 [P-33](PRUEFER-14.md#p-33) bekannt |
| **F3** Ein **richtiger** Zeichensatz im Kopf wird überschrieben, wenn Eudora ihn beim Empfang nicht übersetzt (`windows-125x≠1252`, `koi8-r`, `iso-8859-2`, …) | **mittel, selten.** Lesbarer Text wird unlesbar | **gemessen** (Fälle 21–23) |
| **F4** Im `<meta>` dasselbe — und das läuft **auf dem Vorgabeweg**, ohne Kopfzeilen | **mittel, selten.** Echte Regression gegenüber 1.0.106 | Mechanik belegt; in 374 Nachrichten **0** Treffer (alle 62 `<meta charset>` sagen `utf-8`) |
| **F5** `multipart` über HTML-Rumpf **ohne** `<x-html>`-Marker wird `text/plain` | gering | gemessen (Fall 5); 0 von 374 |
| **F6** `charset` wird als **Teilzeichenkette** gesucht, nicht als Parameter | gering | gemessen (Fall 6) |
| **F7** `<meta name="x" content="charset=utf-8">` wird mitgeändert | kosmetisch | gemessen (Fall 9) |
| **F8** Der Kopfkommentar und `tocview.cpp:3176-3178` sagen das Gegenteil des Codes | Doku | belegt; [P-33](PRUEFER-14.md#p-33) ist damit **zum zweiten Mal** offen |
| **F9** Der neue Code ist **nie an einem laufenden Eudora gemessen** worden | Prüflücke | belegt |

**Keine Fundstelle für Datenverlust (Punkt 1).** In allen 23 Fällen ist der
Rumpf **Byte für Byte** derselbe geblieben, außer wo der `<x-html>`-Marker
entfernt wurde (das ist alter, geprüfter Code) und wo der Name des Zeichensatzes
im `<meta>` ersetzt wurde. Die Klassen [P-18](PRUEFER-13.md#p-18) und
[P-28](PRUEFER-13.md#p-28) habe ich eigens nachgestellt (Fälle 12 und 13) —
beide verhalten sich richtig.

---

## F1 — `multipart` wird ersetzt, ohne die Grenze zu prüfen

**Ort.** `msgutils.cpp:4282` und `:4305`:

```cpp
const bool	bMultipart = ( szCt.Left( 10 ) == "multipart/" );
…
if ( bMultipart || bTypFalsch || bCharsetFalsch )
```

`bMultipart` hängt **allein am Text der Kopfzeile**. Ob die Grenze, die diese
Zeile ankündigt, im Rumpf steht, wird nirgends nachgesehen.

**Gemessen.** Eingabe (302 Byte): Kopf `multipart/mixed; boundary="GRENZE"`,
Rumpf mit zwei echten Teilen, darunter ein PDF in Base64.

Alter Stand (`cc64c6db^`):

```
geaendert=0 — die Datei geht unverändert hinaus
```

Neuer Stand:

```
E-101 speichern: … content-type-vorhanden=1 typ=text/plain charset=windows-1252
  bytes-vorher=302 nachher=396 rumpf-vorher=206 rumpf-nachher=206
  mime-ergaenzt=0 ct-ersetzt=1 meta-charset=0 geaendert=1

From: a@example.invalid
MIME-Version: 1.0
X-Original-Content-Type: multipart/mixed; boundary="GRENZE"
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit

--GRENZE
Content-Type: text/plain; charset=iso-8859-1

Gr<FC><DF>e und ein Euro <80>
--GRENZE
Content-Type: application/pdf; name="x.pdf"
Content-Transfer-Encoding: base64

JVBERi0xLjQKJeLjz9MK
--GRENZE--
```

**Rumpf ein = 206, Rumpf aus = 206, Byte für Byte gleich.** Es geht nichts
verloren. Aber die Datei sagt jetzt `text/plain`, und jeder Leser zeigt die
Grenzen, die Teilköpfe und den Base64-Block als Text. **Der Anhang ist aus
dieser Datei nicht mehr zu holen** — mit dem alten Stand war er es.

**Wie oft kommt das vor?** In den **374** Nachrichten aus 175 Postfächern unter
`C:\Temp`: **222 tragen `multipart` mit Grenze, in 0 steht die Grenze im
Rumpf.** Die Messung des Commits (sechs Nachrichten) hält also auch über die
60-fache Menge. Die Annahme stimmt, weil Eudora beim Empfang zerlegt
(`mime.cpp`, `MultiReader`).

**Wo sie trotzdem brechen kann** — zwei Wege im Quelltext legen den rohen
MIME-Text ab, statt ihn zu zerlegen (`mime.cpp:117`):

```cpp
if (!m_hd->isMIME || depth>=MAX_MIME_DEPTH)
```

* `isMIME` wird **nur** gesetzt, wenn eine `MIME-Version`-Kopfzeile da ist
  (`header.cpp:308`). Eine Nachricht mit `Content-Type: multipart/…`, **ohne**
  `MIME-Version`, läuft durch den `TextReader` — Grenzen und Base64 landen roh
  im Postfach, und die Kopfzeile bleibt.
* `MAX_MIME_DEPTH` ist 100 (`mime.h:136`).

Ungemessen (ich habe keine solche Nachricht im Bestand), aber am Quelltext
belegt.

**Behebung, kleinstmöglich.** Vor `:4305` die Grenze aus der Kopfzeile ziehen
und im Rumpf suchen; nur ersetzen, wenn sie **nicht** da ist:

```cpp
// Nur ersetzen, wenn der Rumpf die angekuendigten Teile WIRKLICH nicht
// hat - sonst wird aus einer gueltigen mehrteiligen Nachricht eine Datei,
// in der der Anhang als Text steht (PRUEFER-37 F1).
bool	bGrenzeImRumpf = false;
if ( bMultipart )
{
	const int	nB = szCt.Find( "boundary" );
	if ( nB >= 0 )
	{
		int		q = nB + 8;
		while ( q < szCt.GetLength() && ( szCt[q]==' '||szCt[q]=='\t'||szCt[q]=='='||szCt[q]=='"'||szCt[q]=='\'' ) )
			q++;
		CString		szGrenze;
		while ( q < szCt.GetLength() && szCt[q]!='"' && szCt[q]!='\'' && szCt[q]!=';' &&
				szCt[q]!=' ' && szCt[q]!='\t' && szCt[q]!='\r' && szCt[q]!='\n' )
			szGrenze += szCt[q++];
		if ( !szGrenze.IsEmpty() )
		{
			CString		szRKlein( szRumpf );
			szRKlein.MakeLower();
			bGrenzeImRumpf = ( szRKlein.Find( "--" + szGrenze ) >= 0 );
		}
	}
}

if ( ( bMultipart && !bGrenzeImRumpf ) || bTypFalsch || bCharsetFalsch )
```

(`szCt` ist bereits kleingeschrieben, deshalb der Vergleich gegen den
kleingeschriebenen Rumpf.) Steht die Grenze im Rumpf, bleibt alles, wie es war
— genau das Verhalten von 1.0.106.

**Dazu ein Test**, der heute fehlt: *„[E-101](../Intern/BEFUNDE.md#e-101) dritter Teil: ein Kopf, dessen Teile
es wirklich gibt, bleibt stehen"* — Eingabe wie oben, Erwartung
`ct-ersetzt=0`, `geaendert=0`.

---

## F2 — der neue Block läuft auf dem einzigen Aufrufweg nie

**Ort.** `msgutils.cpp:4270-4310` (Abschnitt 4a), Aufrufweg
`tocview.cpp:3130-3190`.

**Es gibt genau einen Aufrufer** von `E101SpeicherfassungAufbereiten`:
`tocview.cpp:3186`. Dort steht acht Zeilen vorher:

```cpp
CReadMessageDoc* pReadMessageDoc = DYNAMIC_DOWNCAST(CReadMessageDoc, pDoc);
if (pReadMessageDoc)
     pReadMessageDoc->StripTabooHeaders(pszFullMessage);
```

`StripTabooHeaders` vergleicht per **Präfix** (`ReadMessageDoc.cpp:504`), und die
Vorgabeliste `IDS_INI_USER_TABOO_HEADERS` (`EudoraRes.rc:9997`) enthält
`Mime-Version` **und** `Content-`.

**Gemessen** mit dem Werkzeug des Projekts, `tools/taboo-rechnen.pl`, an
`C:\Temp\E80b\Mailverzeichnis\In.mbx`:

```
72 Nachrichten mit Kopfteil ausgewertet
VERSTECKT der Knopf (steht auf der Liste):
   …
    72x  Content-Type
    54x  Mime-Version
    18x  MIME-Version
```

**72 von 72.** Jede empfangene Nachricht verliert `Content-Type`, bevor die
Funktion sie sieht — also ist `bHatContentType` **false**, und 4a wird
übersprungen.

Die andere Seite: Dokumente, die **kein** `CReadMessageDoc` sind (selbst
verfasste), werden nicht beschnitten — die haben aber gar keine
`Content-Type`-Zeile. **Gemessen** über alle `Out.mbx` unter `C:\Temp`:
**85 Nachrichten, 0 mit `Content-Type`.**

Damit bleibt für 4a genau ein Fall übrig: **der Anwender hat `TabooHeaders` in
seiner `Eudora.ini` von Hand geändert.** In `C:\Temp\E80b\Eudora.ini` steht der
Schlüssel nicht, es gilt also die Vorgabe.

**Woher der Irrtum kommt.** Die Messung im Commit („sechs empfangene
HTML-Nachrichten … alle sechs tragen `Content-Type: multipart/…`") ist an der
**`In.mbx`** genommen, nicht an dem, was in die Funktion hineingeht. Zwischen
beidem liegt `StripTabooHeaders`.

**Das ist kein neuer Fund.** Er steht seit dem 17.09.2026 zweimal im Repo:
[P-23](PRUEFER-13.md#p-23) und [P-33](PRUEFER-14.md#p-33), beide mit genau
dieser Begründung, beide mit fertigem Ersatztext. Der neue Code und seine
Commit-Nachricht widersprechen ihnen, ohne sie zu nennen.
([Bestand vor neuer Suche](../Arbeitsweise/bestand-vor-neuer-suche.md).)

**Was das für 1.0.107 heißt.** Der **nützliche** Teil der Änderung läuft
trotzdem, denn er hängt nicht an `bHatContentType`:

* `windows-1252` statt `ISO-8859-1` (`:4178-4181`) — wirkt immer;
* das `<meta>` im HTML berichtigen (4b, `:4328`) — braucht nur `bHochbyte` und
  den `<x-html>`-Marker; 55 von 72 Rümpfen in `In.mbx` tragen ihn.

Gregors Symptom vom 13.10. („inhalt ist mit falschen zeichen dargestellt")
wird also von 1.0.107 angegangen. Nur die 225 Zeilen um die `Content-Type`-Zeile
tun im Auslieferungszustand nichts.

**Behebung.** Nichts am Code — die Zeilen sind richtig für den Fall, für den
sie gedacht sind. Zu ändern ist die **Buchführung**:

1. In `Releases/PAKETE.md` und in der Commit-Beschreibung dazuschreiben, dass
   der Block nur greift, wenn `TabooHeaders` ohne `Content-` eingestellt ist.
2. Den Ersatztext aus [P-33](PRUEFER-14.md#p-33) jetzt wirklich an beide Stellen
   setzen (`tocview.cpp:3176-3178`, `msgutils.cpp:3882`) — siehe F8.
3. Wenn der Zweck war, dass **Gregors** gespeicherte Dateien eine passende
   Kopfzeile bekommen: das tut schon der zweite Teil (`:4418-4426`), weil nach
   dem Taboo-Schnitt keine `Content-Type`-Zeile mehr da ist.

---

## F3 — ein richtiger Zeichensatz im Kopf wird überschrieben

**Ort.** `msgutils.cpp:4285-4302`.

**Der Grundsatz des Commits ist richtig, aber nicht für jeden Zeichensatz.**
Übersetzt wird beim Empfang nur ab Index 3 (`TextReader.cpp:271`,
`size = ISOTranslate(buf, size, iCharsetIdx)`), und die Indizes vergibt
`FindMIMECharset` (`mime.cpp:383-403`):

| Angabe im Kopf | Index | übersetzt? | Bytes im Postfach |
|---|---|---|---|
| `windows-…` (jedes!) | 0 | **nein** | wie empfangen |
| `us-ascii` | 1 | nein | CP1252-verträglich |
| `iso-8859-1` | 2 | nein | CP1252-verträglich |
| `iso-8859-15` | 3 | ja | CP1252 |
| `utf-8` | 4 | ja | CP1252 |
| alles andere | **-1** | **nein** (`iCharsetIdx > 2` ist falsch) | wie empfangen |

Für `windows-1251`, `windows-1250`, `koi8-r`, `iso-8859-2`, `gb2312` usw. steht
im Postfach also **der Originalzeichensatz**, und die Kopfzeile nennt ihn
**richtig**. Der neue Code hält sie trotzdem für falsch, weil sie nicht
`windows-1252` oder `ISO-8859-1` heißt.

**Gemessen**, neuer Stand:

```
21  Kopf: Content-Type: text/plain; charset=windows-1251
    Rumpf: C0 E1 E2 20 80 90        (kyrillisch, CP1251)
    -> X-Original-Content-Type: text/plain; charset=windows-1251
       Content-Type: text/plain; charset="windows-1252"        ct-ersetzt=1

22  Kopf: charset=koi8-r,    Rumpf C1 C2 C3  -> charset="ISO-8859-1"   ct-ersetzt=1
23  Kopf: charset=iso-8859-2, Rumpf B1 E6 EA -> charset="ISO-8859-1"   ct-ersetzt=1
```

Alter Stand: alle drei `geaendert=0`.

Aus lesbarem Russisch wird so `Àáâ €`. **Byteverlust: keiner** — nur die Angabe,
mit der man die Bytes deuten muss, ist weg (sie steht noch in
`X-Original-Content-Type:`, aber kein Leser sieht dort nach).

**Behebung, kleinstmöglich.** `:4301` so einschränken, dass nur Angaben als
falsch gelten, bei denen der Rumpf nachweislich CP1252 ist:

```cpp
// Der Rumpf ist nur dann CP1252, wenn Eudora beim Empfang uebersetzt hat
// (iso-8859-15, utf-8 -> ISOTranslate) oder der Zeichensatz schon
// CP1252-vertraeglich war. Jede andere Angabe ist die EINZIGE richtige,
// weil die Bytes unveraendert im Postfach liegen (FindMIMECharset liefert
// fuer windows-* 0 und fuer Unbekanntes -1, TextReader.cpp:271 uebersetzt
// erst ab 3). PRUEFER-37 F3.
const bool	bRumpfIstCp1252 =
		  szCs.IsEmpty()            || szCs == "us-ascii"
		|| szCs == "iso-8859-1"     || szCs == "windows-1252"
		|| szCs == "iso-8859-15"    || szCs == "utf-8"
		|| szCs == "utf8"           || szCs == "latin1";

bCharsetFalsch = bRumpfIstCp1252 &&
				 !( szCs == szUnser ||
					( szCs == "windows-1252" && szUnser == "iso-8859-1" ) );
```

**Und ein Test**, der heute fehlt: *„[E-101](../Intern/BEFUNDE.md#e-101) dritter Teil Gegenprobe: ein
Zeichensatz, den Eudora nicht übersetzt, bleibt stehen"* — Fall 21 oben,
Erwartung `ct-ersetzt=0`.

---

## F4 — dasselbe im `<meta>`, und das läuft auf dem Vorgabeweg

**Ort.** `msgutils.cpp:4328-4393` (Abschnitt 4b).

Die Bedingung ist `bHochbyte && ( bWarHtml || bKopfSagtHtml )`. **Die Kopfzeile
spielt keine Rolle** — 4b läuft auch ohne jede Kopfzeile, also im
Auslieferungszustand (`IncludeHeaders` hat die Vorgabe `0`,
`EudoraRes.rc:8218`) bei **jeder** gespeicherten HTML-Nachricht mit einem Byte
≥ 0x80.

Steht im HTML `<meta charset="windows-1251">` und sind die Bytes CP1251
(Eudora übersetzt sie nicht, siehe F3), wird daraus `windows-1252`. **Vorher
war die Datei richtig, nachher ist sie falsch** — eine echte Regression
gegenüber 1.0.106, auf dem Vorgabeweg.

**Gemessen, wie oft das vorkommt:** von 374 Nachrichten tragen **62** ein
`<meta charset>`, und **alle 79 Fundstellen sagen `utf-8`**. Kein einziger
Treffer. Die Gefahr ist belegt, die Auslösung in diesem Bestand nicht.

**Behebung.** Die Prüfung aus F3 auch hier anwenden: den vorgefundenen
`szWert` nur dann für falsch halten, wenn er in derselben Liste steht
(`bRumpfIstCp1252`). Eine Zeile mehr an `:4382`:

```cpp
const bool	bPasst = ( szWert == szUnser ||
					   ( szWert == "windows-1252" && szUnser == "iso-8859-1" ) ||
					   !WirdUebersetzt( szWert ) );   // PRUEFER-37 F4
```

---

## F5 — `multipart` über HTML ohne Marker wird `text/plain`

**Ort.** `msgutils.cpp:4313`:

```cpp
const char *	pszUntertyp = ( bWarHtml || bKopfSagtHtml ) ? "html" : "plain";
```

Sagt der Kopf `multipart/alternative` und steht im Rumpf HTML **ohne**
`<x-html>`-Marker, dann ist `bWarHtml` falsch und `bKopfSagtHtml` ebenso — die
Datei wird als `text/plain` ausgezeichnet, und der Leser zeigt HTML-Quelltext.
Genau das Bild, mit dem [E-101](../Intern/BEFUNDE.md#e-101) angefangen hat.

**Gemessen** (Fall 5): Eingabe `multipart/alternative` + `<html><body>Grüße</body></html>`,
Ausgabe `typ=text/plain charset=ISO-8859-1 ct-ersetzt=1`.

**Wie oft:** von 374 Nachrichten haben 64 einen `multipart`-Kopf **ohne**
Marker im Rumpf, und **keine davon** enthält `<html`, `<body`, `<div` oder
`<table`. Also 0 Treffer; die Marker-Erkennung reicht im Bestand aus.

**Behebung** (optional, eine Zeile): den Rumpf zusätzlich auf einen
HTML-Anfang prüfen, etwa `szRKlein.Left(400).Find("<html") >= 0`.

---

## F6 — `charset` wird als Teilzeichenkette gesucht

**Ort.** `msgutils.cpp:4288`: `const int nCs = szCt.Find( "charset" );`

Gesucht wird irgendwo im Wert, nicht nach dem **Parameter** `charset=`. Ein
Grenzname oder Dateiname, in dem `charset` vorkommt, wird gelesen.

**Gemessen** (Fall 6): `Content-Type: text/plain; boundary="__charset=windows-1252__"`
mit `0x80` im Rumpf → `szCs` wird `windows-1252__` → gilt als falsch →
`ct-ersetzt=1`. Hier ist die Ersetzung zufällig richtig; der umgekehrte Fall
(ein `charset=iso-8859-1` in einem Dateinamen überdeckt den echten Wert) wäre
es nicht.

**Behebung.** Vor der Suche verlangen, dass links von `charset` ein `;` oder der
Zeilenanfang steht und rechts (nach Leerraum) ein `=`.

Konstruiert; ich habe keine echte Nachricht mit diesem Muster.

---

## F7 — `<meta name="x" content="charset=utf-8">` wird mitgeändert

**Gemessen** (Fall 9): drei `<meta>` im Rumpf, `meta-charset=2`. Geändert wurden
das echte `<meta charset="utf-8">` **und** `<meta name="x" content="charset=utf-8">`,
das keine Zeichensatzangabe ist. Der Code kann beide nicht unterscheiden, weil
`<meta http-equiv="content-type" content="text/html; charset=UTF-8">` — die
normale Form — genau so aussieht.

Richtig behandelt wurden dagegen die **maskierten** Vorkommen
(`&lt;meta charset=utf-8&gt;`): die bleiben stehen. Kosmetisch, kein Verlust.

---

## F8 — Kommentare sagen das Gegenteil des Codes

`msgutils.cpp:3882-3885`, im Kopfkommentar der Funktion:

> *„WAS SIE NICHT TUT: eine vorhandene Content-Type-Zeile anfassen. Eine
> empfangene Nachricht bringt ihre echten Kopfzeilen aus dem Postfach mit; die
> sind richtig und bleiben, wie sie sind."*

`tocview.cpp:3176-3178`, drei Zeilen über dem Aufruf, der sie entfernt:

> *„Eine bereits vorhandene Content-Type-Zeile - also der Normalfall bei einer
> empfangenen Nachricht - bleibt unangetastet."*

Beide stehen jetzt doppelt falsch: der Code tastet sie an (4a), **und** auf
diesem Weg kommt gar keine an (F2). [P-33](PRUEFER-14.md#p-33) hat den
Ersatztext schon fertig geliefert; er ist nie eingesetzt worden.
([Review sieht nur den Diff](../Arbeitsweise/review-sieht-nur-den-diff.md) —
die unveränderte veraltete Stelle steht in keinem Diff.)

---

## F9 — nie an einem laufenden Eudora gemessen

Die Spurmarke `E-101 speichern:` schreibt jetzt `ct-ersetzt=` und
`meta-charset=`. **Gesucht in allen `eudora.log` unter `C:\Temp`: keine einzige
Zeile `E-101 speichern` in irgendeinem Protokoll** — nur in den `Eudora.exe`
selbst (als Formattext). `Releases/PAKETE.md:189` führt 1.0.107 als *„nie
geschnürt"* und hat keine Zeile „Gemessen".

Nach [Erst nachstellen, dann ausliefern](../Arbeitsweise/erst-nachstellen-dann-ausliefern.md)
fehlt damit: Gregors Symptom vom 13.10. am **alten** Stand rot, am **neuen**
grün. Der Prüfstand dafür ist billig — eine Nachricht aus `In.mbx` markieren,
Datei → Speichern unter, `LogLevel` mit `DEBUG_MASK_DIALOG`, und die Zeile
`E-101 speichern:` aus `eudora.log` lesen
([Eingebaute Messung auslesen](../Arbeitsweise/eingebaute-messung-auslesen.md)).

---

## Punkt 5 — reichen die vier neuen Tests?

**Sie prüfen, was sie behaupten.** Ich habe die vier Behauptungen einzeln
nachgerechnet; die Gegenprobe des Commits (vier rot am alten Stand, 209 grün)
habe ich nicht am Testlauf, aber an meinem eigenen Vorher/Nachher-Prüfstand
bestätigt: alle vier geprüften Wirkungen gibt es am alten Stand nicht.

**Der dritte Test — *„passender Kopf und passendes `<meta>` bleiben"* — ist
nicht scharf genug.** Er fährt genau eine Kombination: `windows-1252` im Kopf,
`windows-1252` im `<meta>`, Bytes nur Latin-1. Damit ist nur der
Sonderfall-Zweig `szCs == "windows-1252" && szUnser == "iso-8859-1"` abgedeckt.
Was er **nicht** trifft, habe ich selbst gefahren:

| Fall | neuer Stand | Urteil |
|---|---|---|
| Kopf `iso-8859-1`, Bytes Latin-1 | `ct-ersetzt=0`, `geaendert=0` | gut, ungetestet |
| Kopf `ISO-8859-1; format=flowed` | `ct-ersetzt=0`, `geaendert=0` | gut, ungetestet — der Zusatzparameter überlebt die Zerlegung |
| Kopf `text/plain` ohne `charset`, Rumpf ASCII | `ct-ersetzt=0`, `geaendert=0` | gut, ungetestet |
| **zweites Speichern derselben Datei** | `ct-ersetzt=0`, `geaendert=0` | gut, ungetestet — die Funktion ist idempotent |
| **Kopf `windows-1251`, Bytes CP1251** | `ct-ersetzt=1` | **falsch, F3** |
| **`multipart` mit echten Teilen** | `ct-ersetzt=1` | **falsch, F1** |
| `multipart` über HTML ohne Marker | `typ=text/plain` | falsch, F5 |

**Was fehlt**, nach Dringlichkeit:

1. Ein Kopf, dessen **Teile es wirklich gibt** → muss stehen bleiben (F1).
2. Ein **richtiger Zeichensatz, den Eudora nicht übersetzt** (`windows-1251`)
   → muss stehen bleiben (F3), und dasselbe für das `<meta>` (F4).
3. Der **echte Weg**: eine empfangene Nachricht **nach** dem Taboo-Schnitt, also
   ganz ohne `Content-Type`. Das ist [P-23](PRUEFER-13.md#p-23), seit einem
   Monat offen, und genau der Fall, den der Anwender bekommt (F2).
4. Zweites Speichern (idempotent) — gemessen gut, aber nicht festgeschrieben.

Gut gewählt ist der Test *„ohne Kopfzeilen wird das `<meta>` trotzdem
berichtigt"*: er trifft als einziger den Vorgabeweg (`IncludeHeaders=0`).

---

## Was vor dem Release zu ändern ist

1. **F1** — die Grenze im Rumpf prüfen, bevor `multipart` ersetzt wird
   (`msgutils.cpp:4305`), plus Test.
2. **F3/F4** — nur Zeichensätze für falsch halten, die Eudora beim Empfang nach
   CP1252 übersetzt (`:4301` und `:4382`), plus Test.
3. **F2/F8** — in `PAKETE.md`, im Kopfkommentar und in `tocview.cpp` benennen,
   dass 4a nur bei geänderten `TabooHeaders` greift; den Ersatztext aus
   [P-33](PRUEFER-14.md#p-33) endlich setzen.
4. **F9** — einmal am laufenden Eudora speichern und die Zeile
   `E-101 speichern:` aus `eudora.log` in `PAKETE.md` eintragen.
5. F5, F6, F7 können warten; alle drei haben 0 Treffer im Bestand.

## Gregors Test an 1.0.107

> **Nachtrag LEKTOR, 19.10.2026 ([LEKTOR-42](LEKTOR-42.md#lektor-42)):** **1.0.107 ist nie geschnürt worden** (`Releases/PAKETE.md`, Abschnitt 1.0.107). Gregor hat dieses Paket nicht. Der Inhalt steckt in **1.0.110**; die Prüfschritte dazu stehen in `TESTPLAN.md`, Abschnitt [C6](../Intern/TESTPLAN.md#c6). Der Abschnitt hier bleibt als Prüfidee stehen, nicht als Auftrag.

Eine empfangene HTML-Nachricht mit Umlauten und einem Euro-Zeichen in der
Übersichtsliste markieren, **Datei → Speichern unter**, und die Datei in
Thunderbird oder im Browser öffnen. Erwartung: Umlaute und `€` stehen richtig
da. Im Protokoll (`LogLevel` mit `DEBUG_MASK_DIALOG`, 0x08) steht eine Zeile

```
E-101 speichern: … typ=text/html charset=windows-1252 … ct-ersetzt=0 meta-charset=1 geaendert=1
```

`ct-ersetzt=0` ist dabei **erwartet** und kein Mangel — siehe F2.

**Nicht testen:** eine Nachricht mit Anhang speichern, bei der die
`Content-Type`-Zeile erhalten geblieben ist. Das ist F1, und die Datei wird
dabei unbrauchbar. Mit der Vorgabe-`Eudora.ini` kann das nicht passieren.
