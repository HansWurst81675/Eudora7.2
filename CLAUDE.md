# Vor der Arbeit

Diese Datei wird zu Beginn jeder Sitzung gelesen. Sie enthält, was **vor**
dem ersten Handgriff zu tun ist — nicht die Arbeitsweise im Allgemeinen, die
steht in [Arbeitsweise/README.md](Arbeitsweise/README.md).

## 1. Den Bestand an Befunden lesen, bevor irgendetwas neu gesucht wird

```bash
perl tools/offene-befunde.pl
```

Das nennt jeden Befund, der in [BEFUNDE.md](BEFUNDE.md) als offen steht, und
gleicht ihn gegen [WEITERMACHEN.md](WEITERMACHEN.md) ab.

**Warum das an erster Stelle steht.** Gregor am 14.09.2026:

> *„dann schreib dir auf, daß du am anfang immer die befunde.md durchgehst und
> liest und verstanden hast, was da noch offen ist! das nervt mich, wenn wir
> dinge aufschreiben und du sie vergißt und dann neu ausarbeitest, das ist sehr
> schlecht!"*

Der Anlass war **E-85**: Gregor meldete, dass Umlaute über IMAP falsch ankommen.
Ich habe daraus einen neuen Befund gemacht und die Ursache über zwei Tage, zwei
Fehlfassungen und eine ausgelieferte Zwischenfassung hinweg gesucht — während
**NP3-8** in derselben Datei stand, mit dem Vermerk *„Sicherheit: nachgewiesen.
Originalfehler von QUALCOMM"*, einer Tabelle beider Zählweisen, den
Zeilennummern und der fertigen Handlungsanweisung:

> *„in `ImapDownload.cpp:4644` denselben Aufruf verwenden wie
> `mime.cpp:382-390`, am besten durch Aufruf von `FindMIMECharset` selbst, und
> die Abfrage in Zeile 4657 auf `> 2` ziehen."*

Genau so wurde es am Ende behoben. Die Antwort lag fertig im Repo. Gefunden hat
das Gregor, nicht ich.

## 2. Vor jedem neuen Befund: erst suchen

```bash
perl tools/befund-suchen.pl <Datei oder Funktion>
```

Gesucht wird nach dem **Ort im Quelltext**, nicht nach der Beschreibung.
`BEFUNDE.md` hat über 7800 Zeilen und mehrere Nummernkreise (`E-`, `NP-`, `PR-`,
`P-`, `X-`, `Z-`, `R-`, `V-`). Wer einen Fehler mit **seinen** Worten sucht —
„Umlaute kommen falsch an" — findet keinen Eintrag, der „übersetzt keinen
Zeichensatz" heißt. Nur der Ort ist in beiden Formulierungen derselbe.

Erst wenn das Werkzeug **nichts** meldet, ist ein neuer Eintrag berechtigt.
Sonst wird der bestehende fortgeschrieben.

## 3. Der Stand in einem Blick

```bash
perl tools/paket-bereit.pl     # alle Schranken vor einem Paket, in einem Lauf
perl tools/rollen-faellig.pl   # laufen Lektor, Prüfer und Chronist im Takt?
perl tools/gesichert.pl        # ist alles committet und gepusht?
```

`tools/WERKZEUGE.md` führt den vollständigen Bestand — **dort nachsehen, bevor
etwas Neues gebaut wird.** Es gibt über 80 Werkzeuge, und mehr als eines davon
wurde schon ein zweites Mal erfunden.

## 4. Was ohne Rückfrage nicht geschieht

* **Kein Zweig ohne Gregors Ja zum Namen.**
* **Kein direkter Push auf `main`** — er merged.
* **Kein Release ohne seinen lokalen Test und seine Zustimmung.**
* **Nichts auf seinem Bildschirm starten**; Prozesse immer nach Pfad filtern.
* `C:\Users\Gregor\Eudora72-*` sind **seine** Testverzeichnisse. Lesen der
  `eudora.log` ist abgesprochen, alles andere nicht — es sei denn, er bittet
  ausdrücklich darum, ein Paket dorthin zu legen.

## 5. Bytes

Quelldateien unter `Eudora71/` sind **Latin-1 mit gemischten Zeilenenden**, die
`.md` im Wurzelverzeichnis **UTF-8 ohne BOM mit reinen LF**. Nach **jedem**
Schreibzugriff messen:

```bash
perl -0777 -ne '$c=()=/\r\n/g;$l=()=/\n/g;printf "CRLF %d nur-LF %d >127 %d\n",$c,$l-$c,scalar(()=/[\x80-\xff]/g)' <datei>
```

Das Edit-Werkzeug hat `utils.cpp` schon einmal zerstört — alle CR entfernt und
Latin-1 nach UTF-8 umkodiert. Für diese Dateien: Perl über Zeilenanker, Ersatztext
aus einer Datei, Trefferzahl prüfen.
