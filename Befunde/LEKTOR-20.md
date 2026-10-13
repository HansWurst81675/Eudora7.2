# <a id="lektor-20"></a>LEKTOR-20 — offene Funde aus LEKTOR-16 und LEKTOR-17 berichtigt (Basis `18f71e5`)

Lauf am 12.10.2026, **schreibend**, auf `wt/lektor` (Basis `18f71e5` = `release-v1.0.83`).
Anlass: Gregors Regel *„keine lügen auf main!"* nach dem Merge von PR #84.
Nicht angefasst: `tools/offene-befunde.pl` (Hauptagent), Quelltext unter `Eudora71/`, `CLAUDE.md`.
Nichts gebaut, nichts gestartet.

## Der Maßstab, gemessen

| Frage | Messung | Ergebnis |
|---|---|---|
| Quellstand | `Eudora71/Version.h` | **7.2.0.83** |
| Paketnummer | `VERSION` | **1.0.83** |
| Release | CHANGELOG 7.2.0.83, `perl tools/pruefe-release-buchfuehrung.pl` | v1.0.83 **angewiesen, nicht veröffentlicht**; neuestes Tag `v1.0.72` |
| [AN-1](../BEFUNDE.md#an-1) POP | CHANGELOG 7.2.0.81 bis 7.2.0.83 | alle sechs Prüffälle heil an 7.2.0.81 (`C:\Temp\AN3`), 7.2.0.82 (`AN4`), 7.2.0.83 (`AN5`); 185/185 an 7.2.0.82 und 7.2.0.83 |
| [AN-1](../BEFUNDE.md#an-1) IMAP | CHANGELOG 7.2.0.83 | Gregor mit 1.0.83: drei Anhänge, alle mit Endung; *„gekürzt mit endung reicht"* |
| ANHANG-Marken | `grep -rn "ANHANG-Marke" Eudora71` | elf Nummern; POP 1–8, 10, 11; IMAP 1–9 (5 zweimal) |
| Stummer Ausstieg in `MIMEMap::Find` | `MIMEMap.cpp:77-78` | `if (!ms \|\| !ms->m_hd) return (FALSE);` ohne Marke |

**Festgelegte Zählung ([L-17.5](LEKTOR-17.md#l-17.5)):** **elf Teile B5.1 bis B5.11**, davon **zehn behoben**, **[B5.7](../AUFGABEN.md#b5.7) offen**.
[B5.0](../AUFGABEN.md#b5.0) sind die Marken, kein Teil. Grundlage: die Überschriften im CHANGELOG (7.2.0.81 „neunter und zehnter Teil", 7.2.0.83 „elfter Teil").
Gezogen in BEFUNDE.md (Übersicht und Kasten), AUFGABEN.md (Überschrift, Tabelle, Fließtext), CHANGELOG „Noch offen", README.md, ZIEL.md.

---

## Die Funde

### L-16.1 / L-17.8 — `offene-befunde.pl` blind für AN-1, AN-2, E-112

Am Werkzeug **nicht** gearbeitet (ausgenommen laut Auftrag). Auf Zusatzauftrag des Hauptagenten die beiden Übersichtszeilen in BEFUNDE.md so umgestellt, dass das **erste Fett mit dem Urteil beginnt**:

* [AN-1](../BEFUNDE.md#an-1): „**POP-Weg am laufenden Programm heil an 7.2.0.81**" → „**teilweise behoben — über POP am laufenden Programm gemessen, heil seit 7.2.0.81; über IMAP von Gregor mit 1.0.83 getestet und am 12.10.2026 bestätigt; [B5.7](../AUFGABEN.md#b5.7) offen.**"
* [AN-2](../BEFUNDE.md#an-2): „**Ursache am Quelltext belegt, Behebung eingespielt, nicht übersetzt.**" → „**offen — Anzeige geändert in 7.2.0.80, seit 7.2.0.82 übersetzt, am laufenden Programm nicht gemessen.**"

**Abweichung vom Vorschlag:** bei [AN-2](../BEFUNDE.md#an-2) steht „geändert", nicht „behoben". `tools/pruefe-behoben-belegt.pl` (Commit-Haken) weist ein „behoben" ohne Beleg ab, und für [AN-2](../BEFUNDE.md#an-2) gibt es keinen — es ist am Programm nicht gemessen. Die Schranke hat hier recht. Für [AN-1](../BEFUNDE.md#an-1) trägt die Zeile jetzt „am laufenden Programm gemessen" und „von Gregor … bestätigt".

### L-16.2 / L-17.7 — BEFUNDE.md AN-1: Kasten neu, darunter Altstand

* Übersichtszeile [AN-1](../BEFUNDE.md#an-1): „zehn Ursachen … IMAP-Weg ist nicht gemessen … Von Gregor noch nicht geprüft" → elf Ursachen, AN3/AN4/AN5, 185/185, IMAP-Test, Gregors Urteil, Teile 1–6 und 8–11 behoben.
* Kasten: Zeilen 7.2.0.82 (`AN4`) und 7.2.0.83 (`AN5`) ergänzt; „drei weitere Teile, alle im POP-Weg" → vier, mit **Teil 11**; „IMAP-Weg nicht gemessen" → Gregors IMAP-Test, offen [B5.7](../AUFGABEN.md#b5.7).
* „**Stand 12.10.2026.** … Übersetzt ist nichts" → „**Stand vor dem ersten Bau (12.10.2026, morgens).**"
* `Token[0] = 0;` „Nicht angefasst — kein Compiler" und `DeMacifyName32` „Nicht angefasst": stehen gelassen, mit Nachtrag „Stand 12.10.2026: seit 7.2.0.79 drin (B5.2)" bzw. „behoben in 7.2.0.79 (B5.4), dazu `AnhangNameKuerzen` (B5.8)".
* Teil 1, „Stand | im Quelltext seit 7.2.0.79. Nicht übersetzt" → „übersetzt und am laufenden Programm gemessen (Fall 01 und 02 heil)".
* „Was noch offen ist" (Punkte 2–5): Nachtrag oben, alle vier erledigt (B5.3, B5.5, B5.2, B5.4); Liste bleibt als Stand 30.09.
* Entscheidungstabelle „alle sechs heil → B5.1 bis B5.6" → POP-Teile (B5.1, B5.2, B5.3 mit B5.8, B5.5, B5.9), B5.6/[B5.7](../AUFGABEN.md#b5.7) nur IMAP; Zeile „gemischt" ergänzt.
* „Nichts davon ist am laufenden Programm nachgesehen. Es gibt keinen Bau." → Nachtrag „(Stand 30.09.2026; seit 12.10.2026 gebaut und gemessen …)".
* Teil 8: „drei Kappungen" bleibt, mit Zusatz „(POP und IMAP; im POP-Lauf wirkten davon zwei)" — damit stimmt es mit CHANGELOG „zwei Stellen" zusammen ([L-17.5](LEKTOR-17.md#l-17.5), zweiter Absatz).

### L-16.3 — zitierte Zeilennummern

* Markentabelle: Zeilen auf Stand 7.2.0.83 (Kommentarzeile der Marke), Zeilen **9, 10, 11** ergänzt; „Marken 1 bis 3 gibt es doppelt, einmal für IMAP" → „1 bis 9 auch für IMAP, 9 nur dort, 10 und 11 nur POP/`MIMEMap`". Bei 11 vermerkt, dass der erste Ausstieg stumm ist.
* Weg-Tabelle und folgende Abschnitte: **nicht** einzeln nachgemessen. Darüber steht jetzt „Zeilennummern Stand 7.2.0.76, vor der Behebung; der Funktionsname ist der Anker" (der Vorschlag aus [L-16.3](LEKTOR-16.md#l-16.3)).

### L-16.4 / L-17.4 — AUFGABEN.md B5

* Überschrift: „über POP heil seit 7.2.0.81 (… 7.2.0.81 und 7.2.0.82: alle sechs)" → „über POP heil seit 7.2.0.81, über IMAP von Gregor mit 1.0.83 getestet; [B5.7](../AUFGABEN.md#b5.7) offen (… 7.2.0.81 bis 7.2.0.83: alle sechs)".
* Kasten: „behoben in 7.2.0.80", „gemessen an 7.2.0.80" → „-an1"; Verweis „Abschnitt 7.2.0.80" → „Messfassung 7.2.0.80-an1, 7.2.0.81 und 7.2.0.83" ([L-17.2](LEKTOR-17.md#l-17.2)); AN4/AN5, B5.11, IMAP-Test ergänzt.
* „**Es ist nichts mit MSVC gebaut.**" → durchgestrichen, „Erledigt am 12.10.2026: gebaut … 7.2.0.79 bis 7.2.0.83".
* „Sechs getrennte Ursachen" → „Elf getrennte Ursachen (B5.1 bis B5.11)"; „Stand der sieben Teile" → „elf Teile".
* **Tabelle um B5.8, B5.9, B5.10, B5.11 ergänzt** (Quelle: CHANGELOG 7.2.0.80-an1, 7.2.0.81, 7.2.0.83; BEFUNDE-Kasten).
* B5.1: „behoben, POP und IMAP" → „geändert in POP und IMAP; für den Dateinamen wirkt es nur über POP" (L-16 Kleinere).
* B5.3: Zusatz „im Dateinamen wirksam erst mit B5.8".
* [B5.7](../AUFGABEN.md#b5.7): Zusatz, warum es in Gregors IMAP-Test nicht auffiel (alle drei Namen trugen eine Endung).
* „drei Übersetzungsfehler … ungeklärt": Nachtrag — fünf Rebuilds danach mit 0 Fehlern, was die drei waren, ist nirgends aufgeschrieben; die Bindefrage bleibt offen.
* „**Nicht gemessen:** nichts davon ist mit MSVC gebaut" → „Mit den Werkzeugen nicht messbar …", Nachtrag gebaut und gestartet, alter Wortlaut zitiert.
* „Der nächste Schritt": Nachtrag „Schritte 1–4 erledigt; offen Schritt 5 (`TestPopEmpfang.cpp`) und [B5.7](../AUFGABEN.md#b5.7)".
* Spalte `stand` in `kopfzeile-pruefen.pl`: Nachtrag, die Bedingung ist erfüllt, die Spalte trotzdem noch nicht nachgezogen.
* Entscheidungstabelle wie in BEFUNDE.md (POP-Teile, Zeile „gemischt").
* „Alle sechs behobenen Teile … soweit ohne MSVC möglich" → „Alle zehn behobenen Teile … gebaut und gemessen …; B5.4, B5.6, B5.10 und B5.11 mit den Prüfdaten nicht auslösbar".

### L-16.5 / L-17.6 — CHANGELOG.md

* „Noch offen", [AN-1](../BEFUNDE.md#an-1): „Zehn Ursachen behoben, dazu … Pufferschutz. **Offen:** [B5.7](../AUFGABEN.md#b5.7), der IMAP-Weg ist nicht gemessen, und **Gregor hat noch nicht geprüft**" → AN4/AN5, 185/185, Gregors IMAP-Test mit Urteil, „Elf Teile B5.1 bis B5.11, davon zehn behoben; offen ist [B5.7](../AUFGABEN.md#b5.7)".
* Messfassung 7.2.0.80-an1: „**Behoben in 7.2.0.80:**" → „7.2.0.80-an1" ([L-17.2](LEKTOR-17.md#l-17.2)); „Ursache ist nicht geklärt; Marke 11 nennt jetzt jeden Ausstieg" → Nachtrag „geklärt in 7.2.0.81 (`pkcs10`). Marke 11 nennt jeden Ausstieg außer dem ersten … der bleibt stumm".
* 7.2.0.79: Überschrift und „Hier ist nichts gebaut" stehen gelassen (historisch), darunter Nachtrag „Stand 12.10.2026: am selben Tag übersetzt und gemessen, 4 von 6 … aus sieben Teilen wurden elf". „**Zehn Debug-Marken**" mit Zusatz „seit 7.2.0.80-an1 elf".
* **Nicht geändert:** die Kennung mit Stern (`1.0.79+f4d1439*`) — was der Stern bei den Bauten abdeckte, lässt sich heute nicht mehr messen ([L-16.5](LEKTOR-16.md#l-16.5) letzte Zeile, [L-17.9](LEKTOR-17.md#l-17.9) erster Punkt). Offen.

### L-16.6 — Releases/PAKETE.md

* 1.0.79: Überschrift „nicht gebaut, nicht geschnürt" stehen gelassen (Stand beim Vergeben), darunter Nachtrag „7.2.0.79 ist am selben Tag doch gebaut und gemessen worden (`C:\Temp\AN1`, 4 von 6); geschnürt wurde es nicht … aus sieben Teilen elf, aus zehn Marken elf".
* 1.0.83: Gregors Bestätigung und „Release angewiesen, **veröffentlicht ist es noch nicht** — veröffentlicht ist weiterhin `v1.0.72`" ergänzt.

### L-16.7 — LIESMICH.md

War eingearbeitet. Rest aus [L-17.9](LEKTOR-17.md#l-17.9): Spaltenkopf um 7.2.0.82 (`AN4`) und 7.2.0.83 (`AN5`) ergänzt; Fall 04 „voller Name, `.pdf`" → „… gespeichert als `…Musterstadt 20251.pdf`, weil der Name aus Fall 02 schon belegt ist".

### L-16.8 — WEITERMACHEN.md

* „Der nächste Schritt", Punkt 1 („Er will `git apply` fahren … Zwei Patches … **nicht angewandt**") ersetzt durch: Gregors Reihenfolge vom 12.10.2026 (Release, [E-112](../BEFUNDE.md#e-112), [E-113](../BEFUNDE.md#e-113), [E-94](../BEFUNDE.md#e-94), [E-77](../BEFUNDE.md#e-77)), „1. Release v1.0.83 abschließen … **angewiesen, veröffentlicht ist es noch nicht**"; alter Wortlaut als Nachtrag genannt. Punkt 4 um [E-94](../BEFUNDE.md#e-94) und [E-77](../BEFUNDE.md#e-77) ergänzt.
* „Was heute fertig wurde" (18.09.) → „Was am 18.09.2026 fertig wurde", davor „Was am 12.10.2026 fertig wurde".
* **Nicht geändert:** Zeile `:27` „Zuletzt gebaut und veröffentlicht | 7.2.0.72". Versucht, in „Zuletzt gebaut" (7.2.0.83) und „Zuletzt veröffentlicht" (7.2.0.72) zu trennen — **beide Schranken weisen das ab, in entgegengesetzter Richtung**: `doku-pruefen.pl` verlangt hinter „Zuletzt veröffentlicht" die **aktuelle** Paketnummer 1.0.83 („nennt Paketnummer 1.0.72 als Stand"), `pruefe-release-buchfuehrung.pl` meldet die neue Zeile mit 1.0.83 als „gibt 1.0.83 als aktuellen Stand aus, veröffentlicht ist 1.0.72". Zurückgenommen. Das ist dieselbe Klasse wie [L-15.5](LEKTOR-15.md#l-15.5)/[E-109](../BEFUNDE.md#e-109) (Wortauslöser statt Aussage) und gehört an die Werkzeuge. Den aktuellen Stand nennen die Zeilen `:9-10` und der neue Punkt 1 richtig.

### L-16.9 — Zweig `patch_20261012`

War erledigt.

### L-16.10 / L-17.3 — ZIEL.md, README.md, PORTIERUNG.md, tools/ZWEIGE.md

* ZIEL.md:17: „seitdem ist nichts gebaut … Quellstand ist jetzt 7.2.0.80 … aber nicht übersetzt … Der letzte wirklich gebaute Stand ist 7.2.0.76" → „Quellstand ist jetzt 7.2.0.83 / Paket 1.0.83, gebaut … [AN-1](../BEFUNDE.md#an-1) über POP gemessen und heil, über IMAP von Gregor bestätigt, nur [B5.7](../AUFGABEN.md#b5.7) offen; [AN-2](../BEFUNDE.md#an-2) übersetzt, nicht gemessen … Release v1.0.83 angewiesen, veröffentlicht noch nicht. Der davor gebaute inhaltliche Stand ist 7.2.0.76".
* README.md [AN-1](../BEFUNDE.md#an-1): „Sieben getrennte Ursachen … Sechs davon sind in 7.2.0.79 geändert, aber nicht übersetzt" → elf Ursachen, „Behoben bis auf einen Teil", POP-Messung, IMAP-Test, „Offen bleibt [B5.7](../AUFGABEN.md#b5.7)".
* README.md LogLevel-Tabelle: Zeile **65536 | Anhangnamen (ANHANG, [AN-1](../BEFUNDE.md#an-1)) | aus**; Beleg `debug.h:15-32` → `debug.h:14-44` ([L-17.9](LEKTOR-17.md#l-17.9) dritter Punkt).
* PORTIERUNG.md:43: vor dem Absatz „Stand 18.09.2026" ein Absatz „**Stand 12.10.2026:** Quellstand 7.2.0.83 …, [AN-1](../BEFUNDE.md#an-1) …, [AN-2](../BEFUNDE.md#an-2) …, Release angewiesen, veröffentlicht weiterhin `v1.0.72`".
* tools/ZWEIGE.md `an1-endungen`: „7.2.0.80 (`AnhangNameKuerzen` …)" → „7.2.0.80-an1"; ergänzt Merge von `main` (PR #83, 7.2.0.82), 7.2.0.83, Merge als PR #84.

### L-17.1 — AN-2 nur „nicht übersetzt"

Ergänzt um „seit 7.2.0.82 übersetzt, am laufenden Programm nicht gemessen" in: BEFUNDE.md (Übersicht, Status-Satz des Abschnitts, „Was nicht gemessen ist" als Nachtrag), AUFGABEN.md B6 (Überschrift, Tabellenzeile „Nicht gemessen"), README.md, PAKETE 1.0.80 (Nachtrag), CHANGELOG 7.2.0.80 (Nachtrag unter dem Kasten), ZIEL.md, PORTIERUNG.md. CHANGELOG „Noch offen" und WEITERMACHEN:10 trugen es schon.

### L-17.2 — „7.2.0.80" ohne „-an1"

Berichtigt: AUFGABEN-Kasten (zwei Stellen und der **falsche Verweis**), PAKETE 1.0.80-an1 (**falscher Verweis** „Abschnitt 7.2.0.81" → „Messfassung 7.2.0.80-an1"), PAKETE 1.0.81, CHANGELOG „Behoben in 7.2.0.80", ZWEIGE `an1-endungen`. Dazu fehlte vor `## 1.0.80` in PAKETE eine Leerzeile — ergänzt.

### L-17.5 — Zahl der Ursachen

Festgelegt auf **elf** (siehe oben). Übrig mit „sieben" stehen nur historische Stellen: CHANGELOG-Überschrift 7.2.0.79 und PAKETE 1.0.79 „sechs der sieben" — beide mit Nachtrag „aus sieben wurden elf".

### L-17.9 — Kleinere

* Stern in TESTLAEUFE.md: **offen**, nicht messbar (s. [L-16.5](LEKTOR-16.md#l-16.5)).
* LIESMICH Fall 04: erledigt (s. [L-16.7](LEKTOR-16.md#l-16.7)).
* README LogLevel-Tabelle: erledigt (s. [L-16.10](LEKTOR-16.md#l-16.10)).
* LEKTORAT.md:1078 / LEKTOR-16.md:3: Kopf von LEKTOR-16.md und LEKTOR-17.md verweist jetzt auf diesen Bericht; LEKTORAT.md trägt den Durchgang 25.
* „POP-Marken 1 bis 8 … gemessen" (Marke 8, AUFGABEN [B5.0](../AUFGABEN.md#b5.0) und CHANGELOG 7.2.0.79): **nicht geändert.** Ob Marke 8 im Lauf an 7.2.0.77 schrieb, lässt sich ohne dieses Log nicht prüfen. Offen.
* PAKETE 1.0.79: erledigt (s. [L-16.6](LEKTOR-16.md#l-16.6)).

### <a id="l-19.3"></a>L-19.3 (nachgeholt) — Langpfad-Präfix im CHANGELOG 7.2.0.83

[LEKTOR-19](LEKTOR-19.md#lektor-19) meldete es als eingearbeitet, im Bestand stand aber weiter `\?\` (ein Rückstrich vorn). Berichtigt auf `\\?\`, in Bytes geprüft: `5C 5C 3F 5C` („2+1"). Commit `bb01b74`.

---

## Was offen bleibt

1. [L-16.1](LEKTOR-16.md#l-16.1)/[L-17.8](LEKTOR-17.md#l-17.8): das Werkzeug selbst (Hauptagent); [E-112](../BEFUNDE.md#e-112) bleibt bis dahin unsichtbar.
2. WEITERMACHEN.md:27 lässt sich wegen zweier gegenläufiger Schranken nicht trennen (s. [L-16.8](LEKTOR-16.md#l-16.8)).
3. Was der Stern in den Bau-Kennungen abdeckte ([L-16.5](LEKTOR-16.md#l-16.5), [L-17.9](LEKTOR-17.md#l-17.9)).
4. Marke 8 als „gemessen" (L-16 Kleinere, [L-17.9](LEKTOR-17.md#l-17.9)).
5. Weg-Tabelle in BEFUNDE.md [AN-1](../BEFUNDE.md#an-1) nur als „Stand 7.2.0.76" gekennzeichnet, nicht neu ausgemessen ([L-16.3](LEKTOR-16.md#l-16.3)).
6. AUFGABEN B5 Schritt 5 (`TestPopEmpfang.cpp`) und die Spalte `stand` in `kopfzeile-pruefen.pl` — Sachaufgaben, kein Lektorat.

## Meldungen der Werkzeuge

Stehen im Abschnitt „Fünfundzwanzigster Durchgang" in [LEKTORAT.md](../LEKTORAT.md).
