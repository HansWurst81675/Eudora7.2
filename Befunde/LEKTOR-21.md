# <a id="lektor-21"></a>LEKTOR-21 — Kurzlauf über `1f20a04` und `5849a50`

Lauf am 12.10.2026, nur lesend, aus dem Notizordner übernommen. **Mangel 1 und der Nebenbefund 4 sind im selben Commit wie dieser Bericht behoben.**


1. **WEITERMACHEN.md, Liste offene-befunde:** 29 Kennungen. Jede Kurzbeschreibung stimmt mit der zweiten Spalte von BEFUNDE.md überein (Markup entfernt, gekürzt). Alle 29 sind offen, teilweise, WIEDER OFFEN oder zurückgestellt ([E-90](../Intern/BEFUNDE.md#e-90), [E-92](../Intern/BEFUNDE.md#e-92): so gewollt, `offene-befunde.pl:71,102-107`). `perl tools/offene-befunde.pl` meldet „29/29, Die Liste deckt die offenen Befunde.“ — keine Mängel.
2. **tools/WERKZEUGE.md:116:** „16 → 29“ und „13 neue Treffer“ stimmen (1 [E-112](../Intern/BEFUNDE.md#e-112) + 12 Nicht-E im Diff). Auch die Beschreibung stimmt mit dem Code überein (Regex `:82`, wieder offen/teilweise `:119`, erste Zeile gewinnt `:98`) — keine Mängel.
   - Nebenbefund im Code, nicht in einer MD: Der Kommentar in `tools/offene-befunde.pl:94-96` hat oben und unten vertauscht. In BEFUNDE.md steht [A-1](../Intern/BEFUNDE.md#a-1) **oben** (Z. 147) mit „teilweise“ und **unten** (Z. 5020) mit „heute überholt“. Vorschlag: den Kommentar umdrehen.
3. **Arbeitsweise/schranke-gegentesten.md (Nachtrag):** Zeile 120 und Zeile 185 in `tools/pruefe-branch.pl` sind wörtlich so zitiert, die Meldung steht in `:187`. Der pre-push ruft `--streng` ohne stdin auf (`.git/hooks/pre-push:30`) — keine Mängel.
4. **Mangel: Arbeitsweise/text-nicht-durch-schichten-schicken.md:281-284** („Folge, noch offen: CHANGELOG.md:97 hat noch `\?\` … nicht behoben“) ist falsch. `CHANGELOG.md:97` enthält schon im Stand 5849a50 `\\?\`, gemessen mit 3× `\x5c`; berichtigt hat das `bb01b74` ([L-19.3](LEKTOR-20.md#l-19.3)). Vorschlag: den Absatz ändern in „durch bb01b74 behoben, nachgemessen mit 3 Rückstrichen“. Die Lehre wendet hier ihre eigene Zählprobe nicht an.
