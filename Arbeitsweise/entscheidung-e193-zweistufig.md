---
name: entscheidung-e193-zweistufig
description: "Gregor 04.11.2026: E-193 Suche zweistufig - ohne Umlaut/€ wie bisher nur Index, mit Umlaut/€ Index plus Nachprüfung jedes Treffers im Text"
metadata:
  type: project
---

Schranke: keine - eine Entscheidung über das Verhalten; geprüft wird sie, wenn E-193 behoben und am Prüfstand (tools/messen-e193.ps1) gemessen wird.

Gregor am 04.11.2026 zu [E-193](../Intern/BEFUNDE.md#e-193) (Suche mit Umlauten oder €): *„wenn zweistufig, dann bin ich damit einverstanden: ohne umlaute = wie bisher (=schnell), mit umlauten = zusätzlicher aufwand.“*

- Suchwort nur aus ASCII: wie bisher, nur der X1-Index.
- Suchwort mit Umlaut oder €: erst der Index, dann jeden Treffer mit der genauen Textsuche nachprüfen, falsche Treffer verwerfen. Bei „€“ liefert der Index jede Mail, dann wird alles nachgeprüft (so langsam wie ohne Index, aber richtig).
- Nicht erfasst: Mails, die der Index gar nicht liefert; HTML-Entitäten (`&auml;`) sieht auch die genaue Suche nicht (zweiter Schritt).

**Nachtrag 04.11.2026 nachmittags (geändert):** Am Quelltext zeigte sich, dass die zweite Stufe neuer Code wäre (Indextreffer sind nur Nummern in der X1-Datenbank, die genaue Suche ist eine eigene Maschine, `SearchEngine`). Gregor auf die Frage nach einer einfachen Weiche: *„ja, erst die Weiche bauen und messen“*. **Also zuerst:** enthält ein Suchbegriff Umlaut oder €, nimmt Eudora für diese Suche automatisch die genaue Suche ohne Index (`CSearchView::DoSearch`, `SearchView.cpp:2598`); ohne Umlaut wie bisher der Index. Am Prüfstand Treffer UND Zeit messen; ist es Gregor zu langsam, danach die zweistufige Fassung. Wort „Schalter“ vermeiden - es ist eine automatische Weiche, keine Einstellung (Gregor fragte nach).

**Nachtrag 04.11.2026, nach der Messung der Weiche:** Ergebnis 8/11 mit und ohne Index gleich, keine falschen Treffer mehr; alle drei Fehler sind dieselbe HTML-Mail mit Umlauten als Code (`&auml;`, `&euro;`) - „Spätzle“ fand der Index vorher, jetzt nicht (Rückschritt). Zeit bei neun Mails ~0,4 s, kein Maßstab. Gregor: *„Ja, Codes lesen“* - im selben Zweig die genaue Suche (`SearchEngine`) so erweitern, dass sie HTML-Entitäten liest; Ziel Prüfstand 11/11, erst dann PR.

**Why:** `x1lib.dll` (Fassung `1852bz-bm`) lässt sich nicht ändern; kein Update, kein SDK gefunden, feste COM-Schnittstelle (`x1lib.tlh`).
**How to apply:** Erst messen (alte gegen neue Fassung, Treffer und Zeit, die neun Testmails), dann Gregor das Ergebnis zeigen. Reihenfolge: nach E-188 und E-199 ([[stand-04-11-2026]]).
